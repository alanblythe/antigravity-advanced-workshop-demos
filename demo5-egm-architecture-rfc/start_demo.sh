#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$DIR/workspace"
cd "$DIR/workspace"

echo "==> [Demo 5] Resetting Elephant-Goldfish Model (EGM) workspace..."
rm -f concepts_brief.md design_draft.md goldfish_review_report.md
find docs/designs -type f ! -name 'SITEMAP.md' ! -name 'baseline-microservices.md' -delete 2>/dev/null || true

cat > docs/designs/SITEMAP.md << 'EOF'
# Online Boutique — Architecture RFC & Design Sitemap

This index tracks approved and draft Request for Comments (RFCs) and design specifications generated via the Elephant-Goldfish Model (`/egm-brainstorm` and `/egm-draft`).

| RFC / Design Document | Status | Owner | Summary |
| :--- | :--- | :--- | :--- |
| [`baseline-microservices.md`](baseline-microservices.md) | APPROVED | Architecture COE | Baseline gRPC contracts for `PaymentService`, `CurrencyService`, and `ProductCatalogService`. |
EOF

if [[ ! -f docs/designs/baseline-microservices.md ]]; then
    cat > docs/designs/baseline-microservices.md << 'EOF'
# RFC 001: Baseline Microservices Architecture Specification

* **Status:** APPROVED
* **Owner:** Architecture Center of Excellence (COE)
* **Last Updated:** 2026-11-04
* **Applies To:** `PaymentService`, `CurrencyService`, `ProductCatalogService`

---

## 1. Problem Statement & Scope

The Online Boutique e-commerce platform relies on decoupled microservices communicating via gRPC over HTTP/2 using canonical Protocol Buffer definitions (`protos/demo.proto`).

This document formalizes the baseline contracts, boundaries, and reliability invariants for the core transaction and catalog services, establishing the architectural foundation for subsequent RFCs generated via the Elephant-Goldfish Model (EGM).

---

## 2. Core Service Boundaries & Contracts

### 2.1 PaymentService (`hipstershop.PaymentService`)
* **RPCs:**
  * `Charge(ChargeRequest) returns (ChargeResponse)`
* **Responsibilities:**
  * Authorizes payment methods and charges credit card transactions.
  * Reconciles transaction status with internal settlement ledgers (`src/paymentservice/reconciler.py`).
* **Invariants:**
  * **No Direct FX Logic:** `PaymentService` must never perform currency conversion or FX rate calculations directly. All cross-currency settlement must delegate to `CurrencyService.Convert`.
  * **Idempotency:** Payment charge attempts must accept an `idempotency_key` or unique transaction identifier to prevent double-charging on network retries.
  * **Retry Policy:** Transmit failures must follow §4.2 invariants: exponential backoff with full jitter. Fixed linear sleeps (`time.sleep(1.0)`) are strictly prohibited.

### 2.2 CurrencyService (`hipstershop.CurrencyService`)
* **RPCs:**
  * `GetSupportedCurrencies(Empty) returns (GetSupportedCurrenciesResponse)`
  * `Convert(CurrencyConversionRequest) returns (Money)`
* **Responsibilities:**
  * Maintains deterministic exchange rate tables loaded from `currency_conversion.json`.
  * Executes decimal-accurate currency conversion using standard `Money` structures (`currency_code`, `units`, `nanos`).
* **Invariants:**
  * Zero floating-point drift: conversions must maintain integer `units` and `nanos` arithmetic.

### 2.3 ProductCatalogService (`hipstershop.ProductCatalogService`)
* **RPCs:**
  * `ListProducts(Empty) returns (ListProductsResponse)`
  * `GetProduct(GetProductRequest) returns (Product)`
  * `SearchProducts(SearchProductsRequest) returns (SearchProductsResponse)`
* **Responsibilities:**
  * Serves immutable product definitions, localized descriptions, categories, and USD baseline pricing.

---

## 3. Communication & Protocol Standards

1. **Protocol Buffers:** All inter-service communication must strictly adhere to the schemas declared in `protos/demo.proto`.
2. **Context Deadlines:** All outgoing gRPC calls must propagate context deadlines (default: 3000ms timeout).
3. **Graceful Degradation:** Downstream service failures must return canonical gRPC status codes (`UNAVAILABLE`, `DEADLINE_EXCEEDED`, `INVALID_ARGUMENT`) rather than generic application crashes.

---

## 4. Alternatives Considered & Rejected

* **Unified Monolithic Payment & Currency Module:**
  * *Rejected:* Consolidating currency conversions inside `PaymentService` creates tight runtime coupling, increases deployment blast radius, and duplicates logic already provided by `CurrencyService`.
* **Synchronous External FX Rate Lookups:**
  * *Rejected:* Querying external commercial FX APIs on the synchronous checkout path introduces latency variance and third-party quota risks. Cached deterministic conversion is retained.

---

## 5. Security & Invariant Invariants

* **Secrets Management:** Credentials, API tokens, and payment card details must never be logged in plaintext or committed to version control (`AGENTS.md §1`).
* **Tracing:** All inter-service requests must propagate standard OpenTelemetry distributed trace headers.
EOF
fi

echo "✔ Demo 5 clean: ready for /egm-brainstorm multi-lens ideation."
