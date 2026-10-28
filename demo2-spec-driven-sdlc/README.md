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

1. Inspect the failing test case:
```bash
pytest test_reconciler.py
```

2. Run the spec-driven worktree subagent via Antigravity:
```bash
agy
```
Prompt inside `agy`:
```text
/goal Delegate implementation of .scratch/reconcile-plan.md to @worktree-implementer
```

3. Run the adversarial review against the completed worktree diff:
```bash
agy --agent spec-adversary -p "Audit git diff main...feat/reconcile against AGENTS.md"
```
