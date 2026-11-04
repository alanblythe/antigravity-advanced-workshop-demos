# Demo 7: Contract-First Spec Clarification & Autonomous Test-Heal Loop

> **Focus:** Translating product requirements (`docs/specs/`) with pre-written failing contract tests (`Red` state) into a structured implementation plan (`/grill-me` $\rightarrow$ `/plan`) adhering to architectural invariants (`docs/adr/`), and running an autonomous **Act $\rightarrow$ Verify** test-heal loop (`Green` state).

---

## Files in This Demo

* **`docs/adr/0001-inventory-reservation-invariants.md`**: Architectural decision record governing hold expiration, atomicity, and idempotency guarantees.
* **`docs/specs/0001-stock-reservation-holds.md`**: Product requirement specification for `InventoryReservator.reserve_cart()`, including 4 core requirements and open edge-case questions for `/grill-me`.
* **`tests/test_reservator.py`**: Pre-written 5-test contract suite (`1 passed, 4 failed` in initial state).
* **`src/inventoryservice/reservator.py`**: Initial naive implementation missing expired-hold reclamation, atomic rollback, idempotency replay, and input validation.
* **`src/inventoryservice/schema.sql` & `seeds.json`**: Externalized SQLite DDL and seed inventory fixtures.

---

## Live Demo Steps

1. In Antigravity (`agy` inside `workspace/`, launched via VS Code Task **`Reset & Open: Demo 7`**), run the failing contract suite (`1 passed, 4 failed`):
```text
Run pytest.
```

2. Clarify ambiguities with **`/grill-me`**:
```text
/grill-me Review @docs/specs/0001-stock-reservation-holds.md and tests/test_reservator.py. Ask me about any edge cases before we lock the implementation plan.
```

3. Generate the task breakdown with **`/plan`**:
```text
/plan Write the implementation plan and task breakdown to .scratch/reservation-plan.md
```

4. Execute the autonomous Test-Heal Loop (`⚡ Boost` / `/goal`):
```text
/goal Implement .scratch/reservation-plan.md in src/inventoryservice/reservator.py and self-heal until pytest passes 100%.
```
