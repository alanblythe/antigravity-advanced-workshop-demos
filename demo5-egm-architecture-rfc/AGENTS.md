# Online Boutique — Architecture & RFC Governance Guidelines

## §1. Service Boundaries & Ownership
- **`src/paymentservice/`**: Responsible strictly for card charging (`Charge` RPC) and transaction ledger reconciliation (`reconciler.py`).
- **`src/currencyservice/`**: Canonical owner of all foreign exchange (FX) rate lookups and currency conversions (`GetSupportedCurrencies` and `Convert` RPCs defined in `protos/demo.proto`).
- Cross-service communication must use the typed gRPC contracts in `protos/demo.proto`.

## §2. Checkout Critical Path SLAs
- Checkout p99 latency budget for `PaymentService.Charge` is **150ms**.
- Synchronous calls to external third-party webhooks or non-deterministic LLM endpoints on the synchronous `Charge` path are prohibited.

## §3. Resiliency, Idempotency & Retry Invariants
- **§3.1 (Idempotency):** Every payment charge and outbound settlement notification must carry a deterministic `tx_id` / `idempotency_key` to prevent double-charging or duplicate ledger entries.
- **§3.2 (Exponential Backoff with Full Jitter):** All retry loops (database, gRPC, or asynchronous webhook workers) MUST use **exponential backoff with full randomized jitter**. Fixed or linear sleeps (`time.sleep(1.0)`) are strictly prohibited.

## §4. Design Documentation & RFCs
- New cross-service features require a vetted concept brief (`concepts_brief.md`) stress-tested via `/egm-brainstorm` before implementation.
- Published RFCs live under `docs/designs/<feature-slug>.md` and must be indexed in `docs/designs/SITEMAP.md`.
