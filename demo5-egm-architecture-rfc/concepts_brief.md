# Asynchronous Merchant ERP Settlement Outbox with Deterministic FX Conversion

* **Author:** @architecture-team
* **Date:** 2026-10-27

## Overview

This feature provides reliable, currency-aware order settlement notifications to merchant ERP systems following a successful checkout. Foreign exchange (FX) calculations are delegated directly to the existing `CurrencyService` via typed gRPC calls rather than external LLM services, maintaining financial determinism and sub-millisecond execution. Merchant ERP notifications are decoupled from the synchronous checkout path using a transactional outbox table, allowing checkout to reliably complete within its 150ms p99 SLA while guaranteeing at-least-once delivery to external merchant endpoints via an asynchronous worker.

## Analysis

Review across six Goldfish lenses identified the following architectural findings:

### 1. Architectural Boundaries and Separation of Concerns (`egm-design`, `egm-structural`)
* **Boundary Enforcement**: Under repository rules in `AGENTS.md`, `currencyservice` canonically owns currency conversion math (`CurrencyService.Convert` in `protos/demo.proto`), while `paymentservice` strictly manages card charges and ledger settlement. Delegating FX to `currencyservice` maintains these boundaries.
* **Failure Isolation**: External merchant ERP endpoints exhibit high latency variability and intermittent unavailability. Decoupling ERP notification from the synchronous `PaymentService.Charge` path isolates checkout availability from third-party outages.

### 2. SLA Protection and Infrastructure Economics (`egm-zoom-out`)
* **Checkout Latency**: Synchronous checkout has a 150ms p99 budget (`AGENTS.md §2`). Eliminating synchronous external HTTP calls preserves checkout latency budgets.
* **Deterministic Arithmetic**: Replacing an external LLM endpoint with `currencyservice` eliminates token spend, rate-limit failures, non-deterministic rounding, and hallucinated decimal amounts.

### 3. Transactional Outbox and Delivery Guarantees (`egm-implementation-readiness`)
* **Atomic Outbox Writes**: When `PaymentService.Charge` authorizes a card, it writes the charge record and an outbox event (`PAYMENT_SETTLED`) in the same database transaction, eliminating dual-write inconsistency.
* **Retry Dynamics**: The asynchronous outbox dispatcher must implement exponential backoff with full randomized jitter (`AGENTS.md §3.2`):
  $$\text{sleep} = \text{random}(0,\, \min(T_{\max},\, T_{\text{base}} \times 2^{\text{attempt}}))$$
  Fixed or linear delays (such as `time.sleep(1.0)`) are forbidden.
* **Dead-Letter Handling (DLQ)**: Records exceeding max retry attempts (default: 5) transition to a `DEAD_LETTER` state for operator alerting and manual triage.
* **Idempotency**: All webhook dispatches must transmit a canonical `Idempotency-Key` / `tx_id` header to ensure merchant ERPs can safely handle duplicate deliveries.

### 4. Codebase Alignment and Defect Warnings (`egm-codebase-details`)
* **Existing Anti-Pattern**: Review of `src/paymentservice/reconciler.py` uncovered existing anti-patterns:
  * A `KeyError` vulnerability on legacy records (`tx_id` vs `transaction_id`).
  * A hardcoded linear sleep (`time.sleep(1.0)`), which violates repository retry policies.
  The new outbox dispatcher must not reuse or reproduce these anti-patterns.
* **Trace Context Propagation**: Outbox event records must persist W3C trace context (`traceparent`) to connect asynchronous webhook dispatch logs with the originating checkout trace.

## Goals vs. Non-Goals

* **In-Scope Goals:**
  * Route currency conversions deterministically through `CurrencyService.Convert` via gRPC.
  * Implement an at-least-once transactional outbox table in `paymentservice`.
  * Implement an asynchronous outbox worker with exponential backoff, randomized jitter, and dead-letter handling.
  * Transmit deterministic `Idempotency-Key` headers on all merchant ERP webhooks.
  * Propagate distributed tracing headers (`traceparent`) into asynchronous delivery logs.

* **Out-of-Scope Non-Goals:**
  * Calling external LLMs or third-party AI endpoints on the checkout transaction path.
  * Firing synchronous third-party HTTP webhooks during `PaymentService.Charge`.
  * Implementing merchant-specific custom payload transformations inside `paymentservice` (standard JSON event envelopes only).
  * Supporting distributed two-phase commit (2PC) transactions across disparate data stores.

## Key Decisions & Staging for Next Steps

* **Decision 1**: Eliminate external LLM integration in favor of `currencyservice` (`CurrencyService.Convert`).
* **Decision 2**: Decouple ERP notifications via a transactional outbox table (`status: PENDING, PROCESSING, DELIVERED, DEAD_LETTER`).
* **Decision 3**: Standardize retry loops on exponential backoff with full jitter and a 5-attempt ceiling before moving events to `DEAD_LETTER`.
* **Staging**: Transition this brief to `/egm-draft` to author the formal design specification at `docs/designs/async-erp-outbox-rfc.md`.
