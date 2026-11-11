# Demo 7 Presenter Flight Plan: Contract-First Spec Clarification & TDD

> **Track:** Track B (Antigravity 201)  
> **Total Suggested Timing:** ~12 minutes (Failing contract suite: ~2m, /grill-me & /plan: ~6m, test-heal loop: ~4m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 7`**.

---

## Demo 7: Contract-First Spec Clarification & Test-Heal Loop

* **Suggested Timing:** ~12 minutes
* **Goal:** Start from a feature spec (`docs/specs/0001-stock-reservation-holds.md`) and pre-written failing `pytest` contract tests (`Red` state: `1 passed, 4 failed`), clarify edge cases against the ADR (`docs/adr/0001-inventory-reservation-invariants.md`) via `/grill-me`, lock the task breakdown via `/plan`, and self-heal to `Green`.

### Step 1: Show the Failing Contract Suite (`Red` State)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo7-contract-spec-tdd/workspace/`
* **Prompt inside `agy`:**
```text
Run pytest.
```
* **Expected Result:**
```text
FAILED tests/test_reservator.py::test_reclaims_expired_holds_before_checking_stock
FAILED tests/test_reservator.py::test_atomic_rollback_when_second_sku_insufficient
FAILED tests/test_reservator.py::test_idempotent_replay_does_not_double_deduct_stock
FAILED tests/test_reservator.py::test_rejects_non_positive_quantity_or_empty_cart
==================== 4 failed, 1 passed in 0.04s ====================
```
* **Highlight:** `tests/test_reservator.py` fails 4 contract tests (`AC-1` expired hold reclamation, `AC-2` atomic multi-SKU rollback, `AC-3` idempotent `reservation_id` replay, `AC-4` non-positive quantity validation).

### Step 2: Clarify Edge Cases with `/grill-me` & Lock Plan with `/plan`
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo7-contract-spec-tdd/workspace/`
* **Prompts inside `agy`:**
```text
/grill-me Review @docs/specs/0001-stock-reservation-holds.md and tests/test_reservator.py. Ask me about any edge cases before we lock the implementation plan.
```
* **Expected Result:** Clarifies clock drift, Redis lock lease durations, and idempotency key retention periods before writing plan.

```text
/plan Write the implementation plan and task breakdown to .scratch/reservation-plan.md
```
* **Expected Result:** Generates `.scratch/reservation-plan.md` with 4 focused implementation phases matching AC-1 through AC-4.

### Step 3: Autonomous Act $\rightarrow$ Verify Test-Heal Loop
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo7-contract-spec-tdd/workspace/`
* **Prompt inside `agy`:**
```text
/goal Implement .scratch/reservation-plan.md in src/inventoryservice/reservator.py and self-heal until pytest passes 100%.
```
* **Expected Result:**
```text
Autonomous loop patches reservator.py, self-heals failures across test runs, and completes with:
==================== 5 passed in 0.05s ====================
```
