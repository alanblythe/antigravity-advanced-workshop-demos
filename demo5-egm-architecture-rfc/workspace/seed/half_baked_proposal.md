# Seeded Presenter Prompt & Goldfish Critique Matrix

## 1. Copy-Paste Prompt for `/egm-brainstorm`

Run inside interactive `agy`:

```text
/egm-brainstorm We want paymentservice to convert currencies on the fly by calling an external FX LLM endpoint and firing a synchronous webhook to the merchant's ERP during checkout.
```

---

## 2. Suggested Follow-Up Answers During Step 1 (Elephant Drilling)

When the Elephant challenges the proposal with open-ended questions before the Readiness Checkpoint Gate, use this concise response to lock the hypothesis and trigger the gate:

```text
Merchants need real-time ERP order reconciliation in their local currency (EUR, GBP, JPY) within 5 seconds of checkout. If the merchant ERP is down, we still cannot lose the transaction or double-charge the customer, and checkout latency must stay under 150ms p99.
```

---

## 3. What the 6 Zero-Context Goldfish Subagents Will Catch (Step 2)

1. **Contrarian / YAGNI (`egm-zoom-out`):**
   - `src/currencyservice/server.js` and `CurrencyService.Convert` in `protos/demo.proto` already implement deterministic currency conversion backed by `currency_conversion.json`. Calling an LLM for FX math inside `paymentservice` is redundant and violates service boundaries.
2. **Cost, Quota & Token Economics (`egm-design`):**
   - Invoking an LLM per checkout transaction introduces unbounded token spend, rate-limit exhaustion, and floating-point/hallucination risk on financial amounts.
3. **Migration & Backward Compatibility (`egm-codebase-details`):**
   - Modifying `ChargeRequest` / `ChargeResponse` in `protos/demo.proto` requires additive optional fields (e.g., `idempotency_key`) to avoid breaking existing gRPC clients.
4. **Observability & SRE Debuggability (`egm-implementation-readiness`):**
   - Synchronous HTTP webhooks inside `PaymentService.Charge` will breach the 150ms p99 SLA and cause cascading thread exhaustion when a merchant ERP slows down. Requires an asynchronous transactional outbox worker with exponential backoff + full jitter (`AGENTS.md §3.2`) and a dead-letter queue (DLQ).
5. **UX & Developer Ergonomics (`egm-comprehension`):**
   - Separates synchronous card capture (`SETTLED` / `PENDING`) from asynchronous ERP webhook delivery state so callers get deterministic error codes.
6. **Long-Term Tech Debt (`egm-structural`):**
   - Keeps `paymentservice` decoupled from merchant-specific ERP payload schemas via an event envelope.
