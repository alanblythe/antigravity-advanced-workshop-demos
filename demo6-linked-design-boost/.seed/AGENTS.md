# Online Boutique — Order Discount & Promo Service Guidelines

## §1. Standing Architectural Decision Records (`docs/adr/`)
- All service-wide architectural guardrails, currency precision rules, domain data contracts, and verification standards are defined in `@docs/adr/0001-decimal-currency-and-discount-caps.md`.
- Always enforce `@docs/adr/0001-decimal-currency-and-discount-caps.md` and `.agents/rules/discount-invariants.md` when reading or modifying any code in `src/discountservice/`.

## §2. Feature Specifications (`docs/specs/`) & Verification Gate
- Task-specific feature requirements and acceptance criteria are provided in numbered specification files (e.g., `@docs/specs/0001-stacked-promo-engine.md`) referenced in the conversation.
- Run `.venv/bin/pytest` and `python3 -m py_compile` before marking any task complete.
