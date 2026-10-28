---
trigger: model_decision
paths:
  - "src/paymentservice/**"
  - "reconciler.py"
---

# Backend Service & Reconciliation Rules

- All currency and transaction math must use decimal precision. Never use floating-point for financial balances.
- **CRITICAL RETRY INVARIANT (§4.2):** All network, database, or reconciliation retries MUST implement **exponential backoff with full randomized jitter**. Linear backoffs (`time.sleep(1.0)`) or un-jittered retries are strictly prohibited in production pathways.
