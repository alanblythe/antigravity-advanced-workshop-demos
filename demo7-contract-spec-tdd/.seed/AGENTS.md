# Online Boutique — Cart Inventory Reservation Service Guidelines

## §1. Engineering & Persistence Standards
- Keep SQL DDL in `src/inventoryservice/schema.sql` and seed data in `src/inventoryservice/seeds.json`.
- Use context managers (`with conn:`) for atomic SQLite transactions.
- Use Python 3.11+ native typing and `@dataclass(frozen=True)` for domain models in `src/inventoryservice/models.py`.

## §2. Testing & Verification Gate
- Never modify or weaken existing contract tests in `tests/test_reservator.py`.
- Run `.venv/bin/pytest` to verify the contract test suite.
