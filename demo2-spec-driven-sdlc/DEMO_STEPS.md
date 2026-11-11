# Demo 2 Presenter Flight Plan: Spec-Driven SDLC, Git Worktrees, Browser Subagent & Multi-Model Review

> **Track:** Track A (Module 2)  
> **Total Suggested Timing:** ~35 minutes (Demo 2A: ~10m, Demo 2B: ~10m, Demo 2C: ~7m, Demo 2D: ~8m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 2`**.

---

## Demo 2A: Spec Drafting & Plan Lock

* **Suggested Timing:** ~10 minutes (2m path-scoped rules, 5m `/grill-me` interview, 3m `/plan` generation)
* **Goal:** Move from "vibe coding" to structured spec-driven engineering.

### Step 1: Path-Scoped Rules Inspection
* **Where to run:** VS Code Editor
* **Files to show:**
  * `workspace/.agents/rules/frontend.md` (`paths: ["src/frontend/**"]`)
  * `workspace/.agents/rules/backend.md` (`paths: ["src/paymentservice/**", "reconciler.py"]`)
* **Highlight:** Point out progressive disclosure: when editing backend reconciliation, frontend UI rules are never loaded into context.

### Step 2: Interview Edge Cases with `/grill-me`
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside `agy`:**
```text
/grill-me We need to add transaction reconciliation with automatic retry and idempotency in reconciler.py. Interview me on edge cases, failure modes, and security invariants.
```
* **Expected Result:** Agent asks 3 targeted questions on idempotency key uniqueness, jittered exponential backoff, and concurrent settlement locking.
* **Highlight:** Show the agent asking 3 pointed questions (duplicate `tx_id` handling, transient network retry backoff, and lock safety).

### Step 3: Lock the Implementation Plan with `/plan`
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside `agy`:**
```text
/plan Generate the implementation plan in .scratch/reconcile-plan.md with explicit pass/fail criteria.
```
* **Expected Result:** Creates `.scratch/reconcile-plan.md` containing 4 phased tasks, test definitions, and acceptance criteria.

---

## Demo 2B: Subagent Worktree Isolation & Test-Heal Loop (Gemini 2.5 Flash)

* **Suggested Timing:** ~10 minutes (2m worktree setup, 5m autonomous test-heal loop, 3m diff & lint review)
* **Goal:** Delegate the plan to a subagent that isolates its work in a Git worktree and heals a failing unit test using Gemini 2.5 Flash.

### Step 1: Launch Subagent with Goal Execution
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Command inside `agy`:**
```text
/goal Delegate implementation of .scratch/reconcile-plan.md to @worktree-implementer
```
* **Expected Result:** Subagent creates `.worktrees/feat-reconcile`, fixes seeded `KeyError: 'tx_id'`, passes `pytest` (3 passed), passes `ruff check` (0 errors), and commits to `feat/reconcile`.
* **What to watch on screen:**
  1. Subagent uses **Gemini 2.5 Flash** for rapid execution.
  2. Runs `git worktree add .worktrees/feat-reconcile -b feat/reconcile`.
  3. Registers `.worktrees/` in `.git/info/exclude`.
  4. Runs `pytest` (or `pytest src/paymentservice/test_reconciler.py` / `cd src/paymentservice && pytest`, with root discovery configured in `pyproject.toml`) $\rightarrow$ hits seeded failure: `KeyError: 'tx_id'`.
  5. Analyzes traceback, patches `src/paymentservice/reconciler.py` inside `.worktrees/feat-reconcile/`.
  6. Re-runs `pytest` (or `pytest src/paymentservice/test_reconciler.py`) $\rightarrow$ **PASSED (3 tests)**.
  7. Runs `ruff check .` $\rightarrow$ **0 lint errors**.
  8. Commits clean diff to `feat/reconcile`.
* **Highlight:** The main checkout was untouched; the developer's working state remained pristine.

---

## Demo 2C: Antigravity 2.0 Browser Subagent E2E DOM Verification

* **Suggested Timing:** ~7 minutes (2m dashboard startup, 5m live browser DOM & console verification)
* **Goal:** Show that verification doesn't stop at backend unit tests—the Antigravity 2.0 Agent Browser verifies the live web UI.

### Step 1: Start the Local Dashboard via Antigravity
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside `agy`:**
```text
Start the local dashboard server (python3 app.py) in the background on port 8000.
```
* **Expected Result:** Server process backgrounded on `http://localhost:8000` (PID logged, port 8000 listening).

### Step 2: Autonomous Browser Verification
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside `agy`:**
```text
@browser Open http://localhost:8000, click "Run Batch Reconciliation", verify the #settlement-status badge renders "SETTLED" in the DOM, and assert 0 console errors.
```
* **Expected Result:** Browser opens `http://localhost:8000`, clicks button, asserts DOM `#settlement-status` is `"SETTLED"`, asserts 0 console errors, and saves `.scratch/browser-verification.png`.
* **What to watch on screen:**
  * Antigravity 2.0 launches the native desktop browser window.
  * Navigates to `http://localhost:8000`, clicks the button.
  * Inspects the **HTML DOM tree** directly (asserting `#settlement-status == 'SETTLED'`).
  * Reads the browser DevTools console log (asserting **0 console errors**).
  * Saves a visual verification artifact (`.scratch/browser-verification.png`).
* **Highlight:** Proves true multi-modal, end-to-end verification (Backend unit tests + Frontend DOM/console).

---

## Demo 2D: Immediate Multi-Model Adversarial PR Audit (Claude 3.5 Sonnet)

* **Suggested Timing:** ~8 minutes (5m cross-model adversarial diff audit, 3m invariant violation debrief)
* **Goal:** Catch the subtle invariant flaw that unit tests and browser tests missed *before* merging the worktree.

### Step 1: Run Adversarial Reviewer Subagent
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside `agy`:**
```text
@spec-adversary Audit git diff main...feat/reconcile against .agents/rules/backend.md retry and backoff invariants.
```
*(Alternatively: `Use invoke subagent to execute @spec-adversary (or @staff-reviewer, powered by Claude 3.5 Sonnet on Vertex AI) to audit git diff main...feat/reconcile against .agents/rules/backend.md retry and backoff invariants.`)*
* **Expected Result:** Subagent running **Claude 3.5 Sonnet on Vertex AI** (`@spec-adversary` or `@staff-reviewer`) reports SEV-2 invariant violation at `src/paymentservice/reconciler.py:38` (linear `time.sleep(1.0)` violates mandatory exponential backoff with full jitter).
* **Highlight:** The reviewer subagent—running **Claude 3.5 Sonnet on Vertex AI** via `@spec-adversary` (or `@staff-reviewer`)—flags a **SEV-2 invariant violation**:
  `src/paymentservice/reconciler.py:38 uses time.sleep(1.0) linear backoff instead of the mandatory exponential backoff with full jitter specified in .agents/rules/backend.md §4.2.`
* **The Climax:**
  1. Gemini 2.5 Flash implemented and healed unit tests.
  2. Antigravity 2.0 Browser Subagent verified the live DOM.
  3. Claude 3.5 Sonnet caught the architectural flaw before merge.
  *Zero single-model confirmation bias.*
