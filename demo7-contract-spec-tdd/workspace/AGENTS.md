# Online Boutique — Cart Inventory Reservation Service Guidelines

## §1. Standing Architectural Decision Records (`docs/adr/`)
- All inventory reservation guardrails, atomicity rules, and idempotency guarantees are governed by `@docs/adr/0001-inventory-reservation-invariants.md`.
- Keep SQL DDL in `src/inventoryservice/schema.sql` and seed data in `src/inventoryservice/seeds.json`.
- Use context managers (`with conn:`) for atomic SQLite transactions.
- Use Python 3.11+ native typing and `@dataclass(frozen=True)` for domain models in `src/inventoryservice/models.py`.

## §2. Feature Specifications (`docs/specs/`) & Testing Gate
- Active feature specifications are located in `@docs/specs/` (e.g., `@docs/specs/0001-stock-reservation-holds.md`).
- Never modify or weaken existing contract tests in `tests/test_reservator.py`.
- Run `.venv/bin/pytest` to verify the contract test suite.
