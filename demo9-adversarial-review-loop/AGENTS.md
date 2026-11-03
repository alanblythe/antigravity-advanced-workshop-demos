# Online Boutique — Payment Webhook & Settlement Dispatcher Guidelines

## §1. Production Invariant Specification (`@DESIGN.md`)
- Every change to `src/settlement/` MUST comply with all 3 production invariants in `@DESIGN.md` (§1 Resiliency, §2 Security, §3 Idempotency / Transactional Outbox).
- Passing unit tests alone is NOT sufficient for PR readiness.

## §2. Mandatory Adversarial Review Gate
- Before human code review, invoke `@adversarial-reviewer` in a clean context to audit `src/settlement/dispatcher.py` line-by-line against `@DESIGN.md` and emit a falsifiable `file:line` invariant table.
- Any `FAIL` row in the adversarial review table blocks merge until remediated and covered by a dedicated regression test in `tests/test_dispatcher.py`.
