# Online Boutique — Payment Webhook & Settlement Dispatcher Guidelines

## §1. Standing Architectural Decision Records (`docs/adr/`)
- Changes to `src/settlement/` must comply with the production guardrails defined in `@docs/adr/0001-payment-webhook-and-settlement-guardrails.md` (§1 Resiliency, §2 Security, §3 Idempotency / Transactional Outbox).

## §2. Testing & Verification
- Run unit tests using `.venv/bin/pytest`.
- Do not install packages or modify the environment when running tests.
