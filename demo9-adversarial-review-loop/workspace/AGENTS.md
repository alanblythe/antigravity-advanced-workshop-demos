# Online Boutique — Payment Webhook & Settlement Dispatcher Guidelines

## §1. Production Invariant Specification (`@DESIGN.md`)
- Changes to `src/settlement/` must comply with the production invariants defined in `@DESIGN.md` (§1 Resiliency, §2 Security, §3 Idempotency / Transactional Outbox).

## §2. Testing & Verification
- Run unit tests using `.venv/bin/pytest`.
- Do not install packages or modify the environment when running tests.
