# Online Boutique — Cart Inventory Reservation Guidelines

## §1. Spec-Driven Workflow Mandate
- Read `@SPEC.md` before planning or modifying any code in `src/inventoryservice/`.
- Use `/grill-me` to clarify any ambiguous edge cases in `@SPEC.md` before locking an implementation plan in `.scratch/reservation-plan.md` via `/plan`.
- Never modify or weaken the pre-written contract tests in `tests/test_reservator.py`.

## §2. Engineering & Verification Standards
- Keep SQL DDL in `src/inventoryservice/schema.sql` and seed data in `src/inventoryservice/seeds.json`.
- Use context managers (`with conn:`) for atomic SQLite transactions.
- Run `pytest` and self-heal until 100% of contract tests pass.
