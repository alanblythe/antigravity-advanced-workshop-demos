# Implementation Plan: Legacy Transaction ID Support, Tenant Isolation & Idempotent Reconciliation

- **Author:** Antigravity Planning Agent (`/plan`)
- **Status:** PENDING APPROVAL
- **Target Files:**
  - `src/paymentservice/reconciler.py`
  - `src/paymentservice/test_reconciler.py`
- **Worktree Branch:** `feat/reconcile` (isolated in `.worktrees/feat-reconcile`)

---

## 1. Goal Description

Upgrade `TransactionReconciler` in `src/paymentservice/reconciler.py` to resolve legacy payload `KeyError` crashes, enforce strict `tenant_id` isolation, provide per-tenant idempotency with conflict detection (§4.1), use `Decimal` precision for financial arithmetic, and replace the prohibited fixed `time.sleep(1.0)` with exponential backoff and full randomized jitter (§4.2) to strictly prevent thundering herds.

---

## 2. Architectural Invariants & Design Decisions

1. **Legacy Transaction Identifier Normalization**:
   - Accept `tx_id`, `transaction_id`, or `id` (evaluated in priority order) and normalize to `tx_id`.
   - Raise `ReconciliationError` immediately (0 retries) if none of the keys are present or if the resolved identifier is empty/whitespace.
2. **Tenant Isolation Guardrail (`.agents/rules/backend.md`)**:
   - `TransactionReconciler.__init__` accepts `default_tenant_id: str = "default"`.
   - Every record resolves `tenant_id = record.get("tenant_id", self.default_tenant_id)`. If `tenant_id` is `None` or empty/whitespace, raise `ReconciliationError` immediately.
   - `reconcile_batch(batch, tenant_id=None)` enforces a single active tenant boundary across all records in the batch; cross-tenant records in the same batch raise `ReconciliationError` pre-execution.
3. **Financial Decimal Precision & JSON Serialization (`.agents/rules/backend.md`)**:
   - Parse `record["amount"]` via `Decimal(str(amount)).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)`.
   - Reject missing amounts, non-numeric values, `NaN`, `Infinity`, or negative amounts (`< Decimal("0.00")`) with `ReconciliationError` immediately.
   - Store `Decimal` internally in the idempotency ledger and expose `float(quantized_amount)` in the returned dictionary so `json.dumps()` in `app.py` and existing equality assertions in `test_reconciler.py` remain 100% compatible.
4. **Idempotency & Conflict Detection (`AGENTS.md §4.1`)**:
   - Maintain an in-memory ledger `_ledger: Dict[Tuple[str, str], Dict[str, Any]]` keyed by `(tenant_id, tx_id)`.
   - If `(tenant_id, tx_id)` already exists with the exact same quantized `Decimal` amount and status semantics, return a copy of the cached settled payload without re-running ledger I/O.
   - If `(tenant_id, tx_id)` already exists with a different quantized `Decimal` amount, raise `ReconciliationError` immediately (idempotency payload conflict).
5. **Exponential Backoff with Full Randomized Jitter (`AGENTS.md §4.2`)**:
   - **CRITICAL ANTI-THUNDERING-HERD MANDATE**: Linear delays (e.g. `time.sleep(1.0)`) or un-jittered retries are strictly prohibited in production pathways.
   - Validation, tenant boundary, and idempotency conflict errors (`ReconciliationError`) fail fast without retrying.
   - Transient ledger/network exceptions retry up to `max_retries` using full randomized jitter:
     `sleep_seconds = random.uniform(0, min(self.max_delay, self.base_delay * (2 ** attempt)))`
   - Test harness will explicitly verify the random jitter distribution (e.g., via monkeypatch or statistical variance checks on sleep intervals) to confirm no deterministic or linear sleep intervals are invoked.
6. **Batch Atomicity**:
   - `reconcile_batch` pre-validates all records in the batch (identifier, amount, tenant boundary, and intra-batch/ledger idempotency conflicts) and stages ledger writes so any failure leaves `self._ledger` untouched.

---

## 3. Explicit Pass/Fail Acceptance Criteria

| ID | Criterion | Verification Command / Assertion | Pass Condition |
| :--- | :--- | :--- | :--- |
| **AC-1** | **Worktree Isolation (`AGENTS.md §1`)** | `git status` on `main` & `git worktree list` | Main working tree is 100% clean; `.worktrees/` is registered in `.git/info/exclude`; changes reside on branch `feat/reconcile` inside `.worktrees/feat-reconcile`. |
| **AC-2** | **Legacy Key Compatibility** | `pytest src/paymentservice/test_reconciler.py` | Records with `tx_id`, `transaction_id`, or `id` reconcile cleanly and return normalized `"tx_id"`. Missing/empty ID raises `ReconciliationError`. |
| **AC-3** | **Tenant Isolation Guardrail** | `pytest src/paymentservice/test_reconciler.py -k tenant` | Cross-tenant batches and blank `tenant_id` values raise `ReconciliationError` with 0 partial ledger writes. |
| **AC-4** | **Idempotency & Conflict Guard (`§4.1`)** | `pytest src/paymentservice/test_reconciler.py -k idempotency` | Duplicate `(tenant_id, tx_id)` with identical amount returns cached result; duplicate with mutated amount raises `ReconciliationError`. |
| **AC-5** | **Full-Jitter Exponential Backoff Anti-Thundering-Herd (`§4.2`)** | `grep -n "time.sleep(1.0)" src/paymentservice/reconciler.py` & `pytest src/paymentservice/test_reconciler.py -k jitter` | Zero fixed/linear sleeps in `reconciler.py`; test asserts `random.uniform(0, min(max_delay, base_delay * (2 ** attempt)))` is invoked across multiple simulated retry runs with non-deterministic intervals to prevent thundering herds. |
| **AC-6** | **Decimal Precision & JSON Compatibility** | `pytest src/paymentservice/test_reconciler.py` & `POST /api/reconcile` in `app.py` | Amounts are quantized via `Decimal("0.01")`; negative/NaN amounts raise `ReconciliationError`; `json.dumps()` succeeds without `TypeError`. |
| **AC-7** | **Linter & Static Analysis (`§2`)** | `ruff check src/paymentservice/` | Exits with code `0` and `0` warnings/errors. |
