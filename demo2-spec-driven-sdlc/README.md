# Demo 2: Spec-Driven Coding, Git Worktrees & Test-Heal Loop

> **Focus:** Spec drafting (`/grill-me` & `/plan`), isolated subagent execution in Git worktrees, autonomous test self-healing, and immediate multi-model adversarial PR auditing.

---

## Files in This Demo

* **`reconciler.py`**: Transaction reconciliation module containing a seeded edge-case bug (`KeyError: 'tx_id'` on legacy payload formats) and an invariant flaw (`time.sleep(1.0)` linear backoff).
* **`test_reconciler.py`**: Pytest suite catching transaction processing failures.
* **`.scratch/reconcile-plan.md`**: Implementation specification and dependency DAG generated via `/grill-me` and `/plan`.
* **`.agents/agents/worktree-implementer.md`**: Subagent definition with strict Git worktree isolation instructions.
* **`.agents/agents/spec-adversary.md`**: Adversarial reviewer subagent prompt auditing git diffs against `AGENTS.md`.
* **`AGENTS.md`**: Project invariants, including the mandatory exponential backoff with full jitter rule.

---

## Quickstart

1. Reset and launch `agy` inside `workspace/` (or use VS Code Task **`Reset & Open: Demo 2`**):
```bash
./start_demo.sh && cd workspace && agy
```

2. Interview edge cases and lock the implementation plan inside `agy`:
```text
/grill-me We need to add transaction reconciliation with automatic retry and idempotency in reconciler.py. Interview me on edge cases, failure modes, and security invariants.
```
```text
/plan Generate the implementation plan in .scratch/reconcile-plan.md with explicit pass/fail criteria.
```

3. Delegate the plan to the isolated Git worktree subagent inside `agy`:
```text
/goal Delegate implementation of .scratch/reconcile-plan.md to @worktree-implementer
```

4. Run the adversarial review against the completed worktree diff inside `agy`:
```text
Use invoke subagent to execute spec-adversary to audit git diff main...feat/reconcile against .agents/rules/backend.md retry and backoff invariants.
```
