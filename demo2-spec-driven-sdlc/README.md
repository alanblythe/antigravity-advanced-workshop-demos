# Demo 2: Spec-Driven Coding, Git Worktrees & Test-Heal Loop

> **Focus:** Spec drafting (`/grill-me` & `/plan`), isolated subagent execution in Git worktrees, autonomous test self-healing, and immediate multi-model adversarial PR auditing.  
> 👉 **[DEMO_STEPS.md](./DEMO_STEPS.md)** — *Step-by-step presenter flight plan & talk tracks.*

---

## Files in This Demo

* **`src/paymentservice/reconciler.py`**: Transaction reconciliation module containing a seeded edge-case bug (`KeyError: 'tx_id'` on legacy payload formats) and an invariant flaw (`time.sleep(1.0)` linear backoff).
* **`src/paymentservice/test_reconciler.py`**: Pytest suite catching transaction processing failures.
* **`.scratch/reconcile-plan.md`**: Implementation specification and dependency DAG generated via `/grill-me` and `/plan`.
* **`.agents/agents/worktree-implementer.md`**: Subagent definition with strict Git worktree isolation instructions.
* **`.agents/agents/backend-engineer.md`**: Senior backend systems engineer subagent persona owning `src/paymentservice`.
* **`.agents/agents/spec-adversary.md`**: Adversarial reviewer subagent prompt auditing git diffs against `AGENTS.md`.
* **`AGENTS.md`**: Project invariants, including the mandatory exponential backoff with full jitter rule.

---

## Quickstart

1. Reset and launch `agy` inside `workspace/` (or use VS Code Task **`Reset & Open: Demo 2`**):
```bash
./start_demo.sh && cd workspace && agy
```

2. Interview edge cases, generate plan, and review inline artifact comments inside `agy`:
```text
/grill-me We need to add transaction reconciliation with automatic retry and idempotency in src/paymentservice/reconciler.py. Interview me on edge cases, failure modes, and security invariants.
```
```text
/plan Generate the implementation plan in .scratch/reconcile-plan.md with explicit pass/fail criteria.
```
*Review the rendered plan in the Artifact panel, highlight the retry section, add an inline comment enforcing §4.2 jitter invariants, and update the plan.*

3. Delegate the plan to the isolated Git worktree subagent inside `agy`:
```text
/goal Delegate implementation of .scratch/reconcile-plan.md to @worktree-implementer
```
*Subagent creates `.worktrees/feat-reconcile`, self-heals unit tests, passes `ruff`, and commits.*

4. Merge changes back to main and clean up worktree:
```bash
git merge feat/reconcile && git worktree remove .worktrees/feat-reconcile
```

5. Launch local dashboard and verify live via browser subagent in two steps:
```bash
python3 app.py &
```
*Prompt 1 (Open & Inspect):*
```text
/browser Open http://localhost:8000 and verify that the settlement dashboard renders cleanly with 0 console errors.
```
*(Bring browser onto presentation screen to show initial PENDING badge)*

*Prompt 2 (Action & DOM Assert):*
```text
/browser Click the "Run Batch Reconciliation" button, verify the #settlement-status badge dynamically updates to "SETTLED" in the DOM, assert 0 console errors, and capture a screenshot to .scratch/browser-verification.png.
```

6. Run the adversarial review against the completed commit inside `agy`:
```text
@spec-adversary Audit HEAD~1...HEAD against AGENTS.md retry and backoff invariants.
```
```text
Use invoke subagent to execute spec-adversary to audit git diff main...feat/reconcile against .agents/rules/backend.md retry and backoff invariants.
```
