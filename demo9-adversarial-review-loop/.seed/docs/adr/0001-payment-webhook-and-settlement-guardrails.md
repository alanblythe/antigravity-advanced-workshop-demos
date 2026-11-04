# Architectural Decision Record: Payment Webhook & Settlement Guardrails (`0001-payment-webhook-and-settlement-guardrails.md`)

**Component:** Online Boutique — Payment Webhook & Settlement Dispatcher (`src/settlement/dispatcher.py`)  
**Status:** Mandatory Production Security & Resiliency Specification

---

## §1. Resiliency Invariant — Exponential Backoff with Full Jitter
- When an outbound merchant settlement webhook raises a transient `WebhookDeliveryError`, retry delays MUST use **exponential backoff with full randomized jitter**:
  `delay = random.uniform(0, base_delay_sec * (2 ** attempt))`
- **Prohibited Pattern:** Fixed or linear sleeps (`time.sleep(base_delay_sec)` or `time.sleep(1.0)`) are strictly prohibited because they cause synchronized retry storms during downstream ERP recovery.

---

## §2. Security Invariant — Constant-Time HMAC Signature Verification
- Incoming webhook signatures (`X-Boutique-Signature`) MUST be verified against the computed HMAC-SHA256 digest using **`hmac.compare_digest(computed_sig, provided_sig)`**.
- **Prohibited Pattern:** Standard string equality (`computed_sig == provided_sig` or `!=`) is strictly prohibited due to byte-by-byte timing side-channel vulnerabilities.

---

## §3. Idempotency & Outbox Ordering Invariant — Persist Before External Dispatch
- To guarantee at-most-once settlement side effects when a network timeout occurs *after* the remote webhook server processes a request:
  1. Check if `event.event_id` already exists in `settlement_ledger` with status `SETTLED`. If so, return `SettlementResult(..., duplicate_skipped=True)` immediately without calling `webhook_client`.
  2. Insert or reserve the `event_id` record in SQLite **before** invoking the external `webhook_client` (or atomically transition state via a durable outbox record prior to dispatch) so a post-dispatch exception or retry never double-charges or loses idempotency tracking.
  3. Never leave `settlement_ledger` unwritten until *after* `webhook_client` returns without pre-recording the in-flight/settled idempotency key.
