# Implementation Plan: Legacy Transaction ID Support & Idempotent Reconciliation

- **Author:** Antigravity Planning Agent (/plan)
- **Status:** APPROVED & LOCKED
- **Target File:** `reconciler.py`

## Acceptance Criteria
1. Reconciler must accept both `tx_id`, `transaction_id`, or `id` keys gracefully.
2. In-harness test suite (`pytest test_reconciler.py`) must pass 100% green.
3. Code style must pass `ruff check .` with 0 warnings.
4. Git isolation: All changes committed to branch `feat/reconcile` inside a `.worktrees/` directory.
