# Demo 2 Presenter Flight Plan: Spec-Driven SDLC, Git Worktrees, Browser Subagent & Multi-Tier Review

> **Track:** Track A (Module 2)  
> **Total Suggested Timing:** ~35 minutes (Demo 2A: ~10m, Demo 2B: ~10m, Demo 2C: ~7m, Demo 2D: ~8m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 2`**.

---

## Demo 2A: Spec Drafting, Artifact Comments & Plan Lock

* **Suggested Timing:** ~10 minutes (2m path-scoped rules, 4m `/grill-me` interview, 2m `/plan` generation, 2m inline artifact review)
* **Goal:** Move from "vibe coding" to structured spec-driven engineering with human-in-the-loop artifact review.

### Step 1: Path-Scoped Rules & Boundary Inspection
* **Where to run:** VS Code Editor
* **Files to show:**
  * `workspace/.agents/rules/frontend.md` (`paths: ["src/frontend/**"]`)
  * `workspace/.agents/rules/backend.md` (`paths: ["src/paymentservice/**", "reconciler.py"]`)
  * `workspace/.agents/agents/backend-engineer.md` (Notice **Rule 9: Directory Boundary Guardrail**)
* **Highlight:** Point out progressive disclosure: when editing backend reconciliation, frontend UI rules are never loaded into context.

### Step 2: Negative Test — Out-of-Bounds Edit Refusal
* **Where to run:** Antigravity 2.0 App / Chat Panel (or terminal `agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside chat:**
```text
@backend-engineer Please update the button styles and status badge colors in app.py.
```
* **Expected Result:** Subagent explicitly **refuses** the request, citing Rule 9 of its role instructions: it is strictly confined to `src/paymentservice/**` and cannot modify frontend UI or `app.py`. It suggests delegating to `@frontend-engineer`.
* **Highlight:** Demonstrates enforceable directory boundaries and governance: agents autonomously reject out-of-domain scope creep without human micromanagement.

### Step 3: Interview Edge Cases with `/grill-me`
* **Where to run:** Antigravity 2.0 App / Chat Panel (or terminal `agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside chat:**
```text
/grill-me We need to add transaction reconciliation with automatic retry and idempotency in reconciler.py. Interview me on edge cases, failure modes, and security invariants.
```
* **Expected Result:** Agent asks 3 targeted questions on idempotency key uniqueness, jittered exponential backoff, and concurrent settlement locking.
* **Highlight:** Show the agent asking 3 pointed questions (duplicate `tx_id` handling, transient network retry backoff, and lock safety).

### Step 4: Generate the Implementation Plan with `/plan`
* **Where to run:** Antigravity 2.0 App / Chat Panel (or terminal `agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside chat:**
```text
/plan Generate the implementation plan in .scratch/reconcile-plan.md with explicit pass/fail criteria.
```
* **Expected Result:** Creates `.scratch/reconcile-plan.md` containing 4 phased tasks, test definitions, and acceptance criteria. Renders the artifact in the Antigravity preview panel.

### Step 5: Human-in-the-Loop Artifact Review & Inline Commenting
* **Where to run:** Antigravity 2.0 Artifact Preview Panel (viewing `.scratch/reconcile-plan.md`)
* **Presenter Action:**
  1. Open `.scratch/reconcile-plan.md` in the side-by-side artifact viewer.
  2. Highlight the **"Resilient Retry Loop"** bullet (under `Proposed Changes`) or the **"Full Jitter Backoff"** row in the criteria matrix.
  3. Click **Add Comment** (or press `Cmd+K` / click the inline comment icon) and enter:
     ```text
     Verify that reconciler retries use random jitter to avoid thundering herds (§4.2 invariant).
     ```
  4. Submit the comment and ask the agent to incorporate it:
     ```text
     Update .scratch/reconcile-plan.md to address the inline review comments on the artifact.
     ```
* **Expected Result:** Agent ingests the comment, refines `.scratch/reconcile-plan.md` with explicit jitter requirements and formula ($\text{delay} = \text{random.uniform}(0, \min(2.0, 0.1 \times 2^{\text{attempt}}))$), and marks the plan locked.
* **Highlight:** Demonstrate that human engineers steer architectural constraints directly on artifacts like PR review comments before delegating code execution to subagents.

---

## Demo 2B: Subagent Worktree Isolation & Test-Heal Loop (Gemini 2.5 Flash)

* **Suggested Timing:** ~10 minutes (2m worktree setup, 5m autonomous test-heal loop, 3m diff & lint review)
* **Goal:** Delegate the plan to a subagent that isolates its work in a Git worktree and heals a failing unit test using Gemini 2.5 Flash.

### Step 1: Launch Subagent with Goal Execution
* **Where to run:** Antigravity 2.0 App / Chat Panel (or terminal `agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Command inside chat:**
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

### Step 2: Land the Worktree & Reintegrate to Main
* **Where to run:** Antigravity 2.0 App / Chat Panel (or terminal `agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside chat:**
```text
Merge feat/reconcile into main and remove the .worktrees/feat-reconcile worktree.
```
*(Alternatively from terminal: `git merge feat/reconcile && git worktree remove .worktrees/feat-reconcile`)*
* **Expected Result:** Changes from branch `feat/reconcile` fast-forward into `main`, and the auxiliary worktree directory is cleanly removed.
* **Highlight:** Demonstrates complete lifecycle hygiene: isolate in a worktree, self-heal, verify tests, and reintegrate cleanly without leaving orphan worktrees behind.

---

## Demo 2C: Antigravity 2.0 Browser Subagent E2E DOM Verification

* **Suggested Timing:** ~7 minutes (2m dashboard startup, 5m live browser DOM & console verification)
* **Goal:** Show that verification doesn't stop at backend unit tests—the Antigravity 2.0 Agent Browser verifies the live web UI.

### Step 1: Start the Local Dashboard via Antigravity
* **Where to run:** Antigravity 2.0 App / Chat Panel (or terminal `agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside chat:**
```text
Start the local dashboard server (python3 app.py) in the background on port 8000.
```
* **Expected Result:** Server process backgrounded on `http://localhost:8000` (PID logged, port 8000 listening).

### Step 2: Browser Launch & Visual UI Verification
* **Where to run:** Antigravity 2.0 App / Chat Panel (or terminal `agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside chat (Prompt 1 — Open & Inspect):**
```text
/browser Open http://localhost:8000 and verify that the settlement dashboard renders cleanly with 0 console errors.
```
* **Expected Result:** Browser window opens, navigates to `http://localhost:8000`, displays the Online Boutique Settlement Dashboard, and reports 0 console errors.
* **Presenter Action:** Bring the browser window onto the presentation screen/stage so the audience sees the initial state: `legacy_9901` showing yellow badge `PENDING`.

### Step 3: Interactive Reconciliation & DOM State Assertion
* **Where to run:** Antigravity 2.0 App / Chat Panel (or terminal `agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside chat (Prompt 2 — Action & Verify):**
```text
/browser Click the "Run Batch Reconciliation" button, verify the #settlement-status badge dynamically updates to "SETTLED" in the DOM, assert 0 console errors, and capture a screenshot to .scratch/browser-verification.png.
```
* **Expected Result:** Browser clicks the button, asserts DOM `#settlement-status` updates to `"SETTLED"`, asserts 0 console errors, and saves `.scratch/browser-verification.png`.
* **What to watch on screen:**
  * The audience watches the live browser window on screen.
  * Antigravity triggers the click on "Run Batch Reconciliation".
  * The `PENDING` badge turns green and displays `SETTLED`.
  * Agent inspects the **HTML DOM tree** directly (asserting `#settlement-status == 'SETTLED'`).
  * Agent checks DevTools console logs (asserting **0 console errors**).
  * Agent saves a visual verification artifact (`.scratch/browser-verification.png`).
* **Highlight:** Proves true multi-modal, end-to-end verification (Backend unit tests + live Frontend DOM/console) with interactive visual proof for the audience.

---

## Demo 2D: Immediate Multi-Model Adversarial PR Audit (Gemini 3.1 Pro)

* **Suggested Timing:** ~8 minutes (5m adversarial diff audit, 3m invariant violation debrief)
* **Goal:** Catch the subtle invariant flaw that unit tests and browser tests missed *before* merging the worktree.

### Step 1: Run Adversarial Reviewer Subagent
* **Where to run:** Antigravity 2.0 App / Chat Panel (or terminal `agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside chat:**
```text
@spec-adversary Audit HEAD~1...HEAD against .agents/rules/backend.md retry and backoff invariants.
```
*(Alternatively: `Use invoke subagent to execute @spec-adversary (or @staff-reviewer, powered by Gemini 3.1 Pro) to audit HEAD~1...HEAD against .agents/rules/backend.md retry and backoff invariants.`)*
* **Expected Result:** Subagent running **Gemini 3.1 Pro** (`@spec-adversary` or `@staff-reviewer`) reports SEV-2 invariant violation at `src/paymentservice/reconciler.py:38` (linear `time.sleep(1.0)` violates mandatory exponential backoff with full jitter).
* **Highlight:** The reviewer subagent—running **Gemini 3.1 Pro** via `@spec-adversary` (or `@staff-reviewer`)—flags a **SEV-2 invariant violation**:
  `src/paymentservice/reconciler.py:38 uses time.sleep(1.0) linear backoff instead of the mandatory exponential backoff with full jitter specified in .agents/rules/backend.md §4.2.`
* **The Climax:**
  1. Gemini 2.5 Flash implemented and healed unit tests.
  2. Antigravity 2.0 Browser Subagent verified the live DOM.
  3. Gemini 3.1 Pro caught the architectural flaw before merge.
  *Zero single-tier confirmation bias.*
