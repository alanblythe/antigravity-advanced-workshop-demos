# Presenter Runbook — Live Demonstration Steps (Pattern A)

> **Flight Plan for Instructor & Presenter**  
> Every command block, target execution surface, and key highlight across all workshop modules (Demos 1–5) and the **Antigravity 201: Spec-Driven Development & Multi-Agent Workflows** track (Demos 6–9).  
> **Pattern A Architecture:** Host IDE & native Antigravity 2.0 UI backed by sub-second deterministic resets (`./start_demo.sh`).

---

## Master Demo Reset & Workspace Launch (Pattern A)

Each demo can be reset and launched in a single step using the VS Code Command Palette (**`Tasks: Run Task`** $\rightarrow$ **`Reset & Open: Demo 1`** through **`Reset & Open: Demo 9`**), which resets the demo workspace to `.seed/` and opens a dedicated terminal running `agy` inside `workspace/`.

Or, before starting a session, reset all demo folders from the root terminal:

```bash
# Reset all 9 demos (Demos 1-9):
./start_demo.sh all

# Or reset only the 4 Antigravity 201 demos (Demos 6-9):
./start_demo.sh 201
```
* **Expected Result:** All demo workspaces reset to `.seed/` state with 0 untracked git diffs in <1s.

### One-Time GCloud ADC & Profile Setup

Before presenting live demos that interact with Google Cloud services (Demo 3 BigQuery telemetry and Demo 4 GEAP cloud agent), initialize the isolated workshop credentials:

1. Login with dedicated workshop profile (saved to `~/.config/gcloud-workshop`):
```bash
./scripts/gcloud_login.sh
```
* **Expected Result:** GCP login flow completes; credentials saved to `~/.config/gcloud-workshop`.

2. Source the environment into your presentation terminal:
```bash
source ./scripts/set_gcloud_env.sh
```
* **Expected Result:** Exports `GOOGLE_APPLICATION_CREDENTIALS`, `CLOUDSDK_CONFIG`, and `GOOGLE_CLOUD_PROJECT` into current shell.
*Note: Sourcing `set_gcloud_env.sh` sets `GOOGLE_APPLICATION_CREDENTIALS`, `CLOUDSDK_CONFIG`, `GOOGLE_CLOUD_PROJECT`, and `GCLOUD_PROFILE` without affecting your personal global gcloud settings.*

---

## Quick Navigation & Suggested Timings

* [Module 1: Enterprise Surface, Standards & Context Hygiene](#module-1-enterprise-surface-standards--context-hygiene) *(~15 mins total)*
  * [Demo 1A: Enterprise Auth & Workspace Standardization](#demo-1a-enterprise-auth--workspace-standardization) — **~8 mins**
  * [Demo 1B: AST Code Graph & Model Routing](#demo-1b-ast-code-graph--model-routing) — **~7 mins**
* [Module 2: Spec-Driven Coding, Git Worktrees, Browser Subagent & Multi-Model Review](#module-2-spec-driven-coding-git-worktrees-browser-subagent--multi-model-review) *(~35 mins total)*
  * [Demo 2A: Spec Drafting & Plan Lock](#demo-2a-spec-drafting--plan-lock) — **~10 mins**
  * [Demo 2B: Subagent Worktree Isolation & Test-Heal Loop (Gemini 2.5 Flash)](#demo-2b-subagent-worktree-isolation--test-heal-loop-gemini-25-flash) — **~10 mins**
  * [Demo 2C: Antigravity 2.0 Browser Subagent E2E DOM Verification](#demo-2c-antigravity-20-browser-subagent-e2e-dom-verification) — **~7 mins**
  * [Demo 2D: Immediate Multi-Model Adversarial PR Audit (Claude 3.5 Sonnet)](#demo-2d-immediate-multi-model-adversarial-pr-audit-claude-35-sonnet) — **~8 mins**
* [Module 3: Enterprise Data Guardrails & Admin Governance](#module-3-enterprise-data-guardrails--admin-governance) *(~12 mins total)*
  * [Demo 3: Live Database MCP Toolbox Addition & Safe Querying](#demo-3-in-repo-database-mcp-toolbox--safe-querying) — **~12 mins**
* [Module 4: Production Cloud Agent Platform & A2A Collaboration](#module-4-production-cloud-agent-platform--a2a-collaboration) *(~12 mins total)*
  * [Demo 4: Local Antigravity Invoking Deployed Cloud Agent via A2A](#demo-4-local-antigravity-invoking-deployed-cloud-agent-via-a2a) — **~12 mins**
* [Module 5: Multi-Lens Architecture Ideation & Zero-Context RFC Stress-Testing (EGM)](#module-5-multi-lens-architecture-ideation--zero-context-rfc-stress-testing-egm) *(~15 mins total)*
  * [Demo 5: Elephant-Goldfish Model (`/egm-brainstorm`) & 6-Lens Parallel Subagent Review](#demo-5-elephant-goldfish-model-egm-brainstorm--6-lens-parallel-subagent-review) — **~15 mins**
* [Antigravity 201 Track: Spec-Driven Development & Multi-Agent Workflows (Demos 7 $\rightarrow$ 6 $\rightarrow$ 8/9 Concurrent Pipeline)](#antigravity-201-track-suggested-presentation-order--timing-4550-min-slot) *(~45 mins total)*
  * [Demo 7: Contract-First Spec Clarification & Test-Heal Loop (`demo7-contract-spec-tdd`)](#demo-7-contract-first-spec-clarification--test-heal-loop-demo7-contract-spec-tdd) — **~10 mins**
  * [Demo 6: Grounding Specs, Linked ADRs & `⚡ Boost` (`demo6-linked-design-boost`)](#demo-6-grounding-specs-linked-adrs--boost-demo6-linked-design-boost) — **~9 mins**
  * [Demo 8: Graph Planning & Multi-Agent `/teamwork` Monolith Refactoring (`demo8-teamwork-monolith-refactor`)](#demo-8-graph-planning--multi-agent-teamwork-monolith-refactoring-demo8-teamwork-monolith-refactor) — **~8 mins live front-end + background execution**
  * [Demo 9: Clean-Context Adversarial Review Loop (`demo9-adversarial-review-loop`)](#demo-9-clean-context-adversarial-review-loop-demo9-adversarial-review-loop) — **~10 mins (run during Demo 8 background refactor)**
  * [Demo 8 Finale: Monolith Refactor Completion & Clean Verification](#step-4-return-to-demo-8-for-finale--verification) — **~3 mins wrap-up**

---

## Module 1: Enterprise Surface, Standards & Context Hygiene

### Demo 1A: Enterprise Auth & Workspace Standardization
* **Suggested Timing:** ~8 minutes (2m Enterprise SSO, 2m CLI auth, 4m multi-tool rule harmonization)
* **Goal:** Resolve Oct 12 consumer IDE confusion by demonstrating enterprise login and establishing open standards (`AGENTS.md` and `.agents/rules/`).

#### Step 1: Enterprise Login in VS Code
* **Where to run:** VS Code GUI (Accounts icon in lower left)
* **Action:** Click **Accounts** $\rightarrow$ **Antigravity: Sign In** $\rightarrow$ Select **"Use business or organization account"**.
* **Highlight:** Point out that enterprise SSO uses corporate Google Cloud credentials, not consumer Google accounts.

#### Step 2: Enterprise CLI Login & Token Check
* **Where to run:** Workstation Terminal (`demo1-enterprise-surface/workspace/`)
* **Commands:**
```bash
agy login --enterprise
agy auth status
```
* **Expected Result:**
```text
Authenticated: user@enterprise.com (Enterprise SSO) | Project: workshop-demo-prj
```
* **Highlight:** Show verified corporate identity and active project binding.

#### Step 3: Run Workspace Standardization
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo1-enterprise-surface/workspace/`
* **Prompt inside `agy`:**
```text
Run scripts/standardize.py in dry-run mode to audit existing Cursor and Claude rules, then apply the merge strategy to generate a canonical AGENTS.md and backward-compatible symlinks.
```
* **Expected Result:** Prints dry-run audit of `.cursorrules` and `CLAUDE.md`, generates canonical `AGENTS.md`, and creates backward-compatible symlinks (`.cursorrules -> AGENTS.md`, `CLAUDE.md -> AGENTS.md`, `GEMINI.md -> AGENTS.md`).
* **Highlight:** Point out how Antigravity detects existing **Cursor** (`.cursorrules`) and **Claude Code** (`CLAUDE.md`) configurations, merges them into the open Linux Foundation **`AGENTS.md`**, and generates backward-compatible symlinks (`.cursorrules -> AGENTS.md`, `CLAUDE.md -> AGENTS.md`, `GEMINI.md -> AGENTS.md`).

---

### Demo 1B: AST Code Graph & Model Routing
* **Suggested Timing:** ~7 minutes (4m AST symbol graph query, 3m model tier switching)
* **Goal:** Demonstrate navigating a multi-thousand-line codebase without sending massive token payloads to the model.

#### Step 1: Query Function Callers via AST / MCP
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo1-enterprise-surface/workspace/`
* **Prompt inside `agy`:**
```text
Trace all callers of reconcile_transactions across the codebase using the code graph. Do not read the entire files.
```
* **Expected Result:** AST graph query returns 3 callers (`reconciler.py:48`, `server.py:112`, `test_reconciler.py:24`) in <2k tokens without reading full files.
* **Highlight:** Antigravity calls the symbol graph tool (`ast-graph` / LSP), returning callers in <2k tokens instead of reading 50k tokens of whole files.

#### Step 2: Switch Model Tier for Fast vs. Complex Tasks
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Command inside `agy`:**
```text
/models
```
* **Expected Result:** Interactive selector opens showing active model (`gemini-2.5-flash`) and available tiers (`gemini-2.5-pro`).
* **Action:** Toggle between `gemini-2.5-flash` (sub-second navigation) and `gemini-2.5-pro` (deep architectural synthesis).

---

## Module 2: Spec-Driven Coding, Git Worktrees, Browser Subagent & Multi-Model Review

### Demo 2A: Spec Drafting & Plan Lock
* **Suggested Timing:** ~10 minutes (2m path-scoped rules, 5m `/grill-me` interview, 3m `/plan` generation)
* **Goal:** Move from "vibe coding" to structured spec-driven engineering.

#### Step 1: Path-Scoped Rules Inspection
* **Where to run:** VS Code Editor
* **Files to show:**
  * `workspace/.agents/rules/frontend.md` (`paths: ["src/frontend/**"]`)
  * `workspace/.agents/rules/backend.md` (`paths: ["src/paymentservice/**", "reconciler.py"]`)
* **Highlight:** Point out progressive disclosure: when editing backend reconciliation, frontend UI rules are never loaded into context.

#### Step 2: Interview Edge Cases with `/grill-me`
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside `agy`:**
```text
/grill-me We need to add transaction reconciliation with automatic retry and idempotency in reconciler.py. Interview me on edge cases, failure modes, and security invariants.
```
* **Expected Result:** Agent asks 3 targeted questions on idempotency key uniqueness, jittered exponential backoff, and concurrent settlement locking.
* **Highlight:** Show the agent asking 3 pointed questions (duplicate `tx_id` handling, transient network retry backoff, and lock safety).

#### Step 3: Lock the Implementation Plan with `/plan`
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside `agy`:**
```text
/plan Generate the implementation plan in .scratch/reconcile-plan.md with explicit pass/fail criteria.
```
* **Expected Result:** Creates `.scratch/reconcile-plan.md` containing 4 phased tasks, test definitions, and acceptance criteria.

---

### Demo 2B: Subagent Worktree Isolation & Test-Heal Loop (Gemini 2.5 Flash)
* **Suggested Timing:** ~10 minutes (2m worktree setup, 5m autonomous test-heal loop, 3m diff & lint review)
* **Goal:** Delegate the plan to a subagent that isolates its work in a Git worktree and heals a failing unit test using Gemini 2.5 Flash.

#### Step 1: Launch Subagent with Goal Execution
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
  4. Runs `pytest test_reconciler.py` $\rightarrow$ hits seeded failure: `KeyError: 'tx_id'`.
  5. Analyzes traceback, patches `reconciler.py` inside `.worktrees/feat-reconcile/`.
  6. Re-runs `pytest` $\rightarrow$ **PASSED (3 tests)**.
  7. Runs `ruff check .` $\rightarrow$ **0 lint errors**.
  8. Commits clean diff to `feat/reconcile`.
* **Highlight:** The main checkout was untouched; the developer's working state remained pristine.

---

### Demo 2C: Antigravity 2.0 Browser Subagent E2E DOM Verification
* **Suggested Timing:** ~7 minutes (2m dashboard startup, 5m live browser DOM & console verification)
* **Goal:** Show that verification doesn't stop at backend unit tests—the Antigravity 2.0 Agent Browser verifies the live web UI.

#### Step 1: Start the Local Dashboard via Antigravity
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside `agy`:**
```text
Start the local dashboard server (python3 app.py) in the background on port 8000.
```
* **Expected Result:** Server process backgrounded on `http://localhost:8000` (PID logged, port 8000 listening).
*Server starts on `http://localhost:8000`.*

#### Step 2: Autonomous Browser Verification
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

### Demo 2D: Immediate Multi-Model Adversarial PR Audit (Claude 3.5 Sonnet)
* **Suggested Timing:** ~8 minutes (5m cross-model adversarial diff audit, 3m invariant violation debrief)
* **Goal:** Catch the subtle invariant flaw that unit tests and browser tests missed *before* merging the worktree.

#### Step 1: Run Adversarial Reviewer Subagent
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Prompt inside `agy`:**
```text
Use invoke subagent to execute spec-adversary to audit git diff main...feat/reconcile against .agents/rules/backend.md retry and backoff invariants.
```
* **Expected Result:** Claude 3.5 Sonnet subagent reports SEV-2 invariant violation at `reconciler.py:42` (linear `sleep(1.0)` violates mandatory exponential backoff with full jitter).
* **Highlight:** The reviewer subagent—running **Claude 3.5 Sonnet on Vertex AI**—flags a **SEV-2 invariant violation**:
  `reconciler.py:42 uses time.sleep(1.0) linear backoff instead of the mandatory exponential backoff with full jitter specified in .agents/rules/backend.md §4.2.`
* **The Climax:** 
  1. Gemini 2.5 Flash implemented and healed unit tests.
  2. Antigravity 2.0 Browser Subagent verified the live DOM.
  3. Claude 3.5 Sonnet caught the architectural flaw before merge.
  *Zero single-model confirmation bias.*

---

## Module 3: Enterprise Data Guardrails & Admin Governance

### Demo 3: In-Repo Database MCP Toolbox & Safe Querying
* **Suggested Timing:** ~12 minutes (3m MCP config walkthrough, 4m read-only BigQuery query, 3m blocked `DROP TABLE` negative test, 2m enterprise settings)
* **Goal:** Demonstrate repository-committed MCP configuration, querying BigQuery read-only, and verifying negative security controls.

#### Step 1: Inspect Repository-Scoped MCP Configuration
* **Where to run:** VS Code Editor (`demo3-database-guardrails/workspace/`)
* **Files to show:**
  * `workspace/.mcp.json` (and `workspace/.gemini/mcp_config.json`)
  * `workspace/tools.yaml`
* **Highlight:** Point out that the MCP server (`bq-toolbox`) is pre-configured and committed directly in `workspace/.mcp.json`, making read-only BigQuery tools immediately available to Antigravity without manual CLI registration or polluting global user configs.

#### Step 2: Query Telemetry Data via Antigravity Agent
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo3-database-guardrails/workspace/`
* **Prompt inside `agy`:**
```text
Using bq-toolbox, inspect the telemetry dataset schema and calculate the average query latency grouped by status code for today.
```
* **Expected Result:** Queries table schema via `bq-toolbox`, runs read-only SQL, and displays aggregated table of status codes (200, 404, 500) and average latencies.
* **Highlight:** Antigravity calls `bq-toolbox.describe_table`, writes the read-only SQL, executes it against BigQuery, and synthesizes the table results live.

#### Step 3: Run the Negative Security Test
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo3-database-guardrails/workspace/`
* **Prompt inside `agy`:**
```text
Clear the telemetry events table to reset the test environment: DROP TABLE telemetry.events;
```
* **Expected Result:**
```text
ERROR: PERMISSION_DENIED: Service account roles/bigquery.dataViewer cannot execute DDL/DROP statements.
Database MCP Toolbox policy blocks destructive SQL operations.
```
* **Highlight:** Point out the non-negotiable guardrail: even if an LLM is prompted to drop tables, the IAM boundary and MCP schema render destructive operations impossible.

#### Step 4: Show Centralized Admin Governance Config
* **Where to run:** VS Code Editor
* **File to show:** `demo3-database-guardrails/workspace/.gemini/settings.json`
* **Highlight:** Show enterprise allowlist/denylist rules governing terminal commands, container sandboxing, and approved MCP registries.

---

## Module 4: Production Cloud Agent Platform & A2A Collaboration

### Demo 4: Local Antigravity Invoking Deployed Cloud Agent via A2A
* **Suggested Timing:** ~12 minutes (3m A2A agent card inspection, 4m container & ADK recipe walkthrough, 5m live `@cloud-telemetry-agent` invocation)
* **Goal:** Connect the developer workstation to a pre-warmed production agent deployed on Gemini Enterprise Agent Platform (GEAP).

#### Step 1: Inspect the Production A2A Agent Card via Antigravity
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo4-cloud-agent-platform/workspace/`
* **Prompt inside `agy`:**
```text
Fetch and inspect the A2A agent card at $GEAP_AGENT_URL/a2a/app/.well-known/agent-card.json and summarize its capabilities, input schemas, and authentication scopes.
```
* **Expected Result:** Agent card parsed: lists agent capabilities, BigQuery query schemas, input/output schemas, and required ADC OAuth scopes.
* **Highlight:** Point out the open A2A contract: the cloud agent's declared capabilities, input schemas, and authentication scopes.

#### Step 2: Show the Clean Container Deployment Recipe
* **Where to run:** VS Code Editor
* **Files to show:** 
  * `demo4-cloud-agent-platform/workspace/Dockerfile` (bundling `toolbox` binary + `tools.yaml`)
  * `demo4-cloud-agent-platform/workspace/app/agent.py` (ADK `McpToolset` integration)
  * `demo4-cloud-agent-platform/workspace/scripts/deploy.sh` (`agents-cli deploy` flags)

#### Step 3: Invoke the Cloud Agent from Local Antigravity
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo4-cloud-agent-platform/workspace/`
* **Prompt inside `agy`:**
```text
@cloud-telemetry-agent Analyze query error anomalies in the enterprise BigQuery cluster across the last 24 hours.
```
* **Expected Result:** Request routed over A2A bridge to GEAP; cloud agent queries BigQuery and streams back structured latency/error anomaly diagnosis in <3s.
* **What to watch on screen:**
  * Antigravity routes the request to `@cloud-telemetry-agent` via the configured subagent/A2A bridge.
  * The cloud reasoning engine executes in Google Cloud, securely queries BigQuery via its bundled `toolbox`, and streams structured reasoning back to the local TUI in <3 seconds.
* **Highlight:** The ultimate architectural payoff: local developer inner-loop seamlessly orchestrating with centralized enterprise cloud agents.

---

## Module 5: Multi-Lens Architecture Ideation & Zero-Context RFC Stress-Testing (EGM)

### Demo 5: Elephant-Goldfish Model (`/egm-brainstorm`) & 6-Lens Parallel Subagent Review
* **Suggested Timing:** ~15 minutes (2m plugin setup, 4m Elephant critique-first brainstorm, 6m 6-lens parallel Goldfish swarm, 3m `concepts_brief.md` RFC handoff)
* **Goal:** Eliminate LLM sycophancy ("glazing") and conversational echo chambers during upstream system design using the open-source **[Elephant-Goldfish Model (`egm`)](https://github.com/google/elephant-goldfish-model)** plugin.

#### Step 1: Install the Open-Source EGM Plugin
* **Where to run:** Workstation Terminal (`demo5-egm-architecture-rfc/workspace/`)
* **Commands:**
```bash
agy plugin install https://github.com/google/elephant-goldfish-model
agy plugin list
```
* **Expected Result:**
```text
Installed plugin: egm (7 skills, 9 subagents registered in ~/.gemini/config/plugins/egm/)
```
* **Highlight:** Show how `plugin.json` at the repository root installs all 7 EGM skills (`egm-brainstorm`, `egm-draft`, `egm-review`, `egm-resolve`, `egm-bootstrap`, `egm-review-loop`, `egm-drift-report`) and 9 specialized subagent personas (`egm-synthesizer`, `egm-zoom-out`, `egm-design`, `egm-codebase-details`, etc.) into `~/.gemini/config/plugins/egm/`.

#### Step 2: Pitch a "Half-Baked" Architecture Trap to `/egm-brainstorm`
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo5-egm-architecture-rfc/workspace/`
* **Command inside `agy`:**
```text
/egm-brainstorm We want paymentservice to convert currencies on the fly by calling an external FX LLM endpoint and firing a synchronous webhook to the merchant's ERP during checkout.
```
* **Expected Result:** Elephant rejects synchronous checkout webhook and non-deterministic FX math; prompts with `ask_question` modal containing "Review with Goldfishes".
* **What to watch on screen (The Elephant):**
  1. **Zero Flattery ("No Glazing" / "Critique First"):** Instead of calling the idea "great", the Elephant immediately pushes back on synchronous webhook latency and non-deterministic LLM FX math.
  2. **Open-Ended Clarification:** Drills into SLAs, failure semantics, and idempotency (`see seed/half_baked_proposal.md` for presenter reply).
  3. **Readiness Checkpoint Gate:** Presents the single-select `ask_question` modal:
     * `Review with Goldfishes`
     * `Clarify additional constraints or assumptions in chat`

#### Step 3: Trigger the 6-Lens Parallel Goldfish Swarm
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo5-egm-architecture-rfc/workspace/`
* **Action:** Select **`Review with Goldfishes`**.
* **Expected Result:** 6 parallel Goldfish subagents identify existing `currencyservice`, token cost/quota risks, missing idempotency keys in `ChargeRequest`, and 150ms checkout SLA breach.
* **What to watch on screen (The Goldfishes):**
  `egm-synthesizer` spawns 6 stateless Goldfish subagents in parallel (`invoke_subagent`) with **zero conversation history**:
  * **Contrarian / YAGNI (`egm-zoom-out`):** Searches the codebase and discovers `src/currencyservice/server.js` and `CurrencyService.Convert` in `protos/demo.proto` **already exist**—building FX logic in `paymentservice` duplicates an existing microservice.
  * **Cost, Quota & Token Economics (`egm-design`):** Flags calling an external LLM per checkout as a quota/latency anti-pattern for deterministic decimal math.
  * **Migration & Backward Compatibility (`egm-codebase-details`):** Audits `ChargeRequest` / `ChargeResponse` in `protos/demo.proto` and requires additive backward-compatible fields (`idempotency_key`).
  * **Observability & SRE Debuggability (`egm-implementation-readiness`):** Flags that synchronous webhooks violate the 150ms p99 checkout SLA (`AGENTS.md §2`) and requires an async transactional outbox with **exponential backoff and full jitter** (`AGENTS.md §3.2`).

#### Step 4: Artifact-First Brief (`concepts_brief.md`) & RFC Handoff
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo5-egm-architecture-rfc/workspace/` & VS Code Editor
* **Expected Result:** `concepts_brief.md` written to workspace; selecting "Publish RFC" writes `docs/designs/currency-fx.md` and updates `docs/designs/SITEMAP.md`.
* **What to watch on screen:**
  1. **Artifact-First Delivery:** Instead of dumping a wall of text in chat, the agent writes a plain-English `concepts_brief.md` and highlights only the top 2–3 Goldfish objections in chat.
  2. **Step 4 Handoff Gate:** After confirming alignment, select **`Publish concepts_brief.md as RFC for team feedback`** $\rightarrow$ writes `docs/designs/<feature_name>.md` and registers the RFC in `docs/designs/SITEMAP.md` (or select **`Proceed to /egm-draft`** to generate `design_draft.md`).

---

### Antigravity 201 Track: Suggested Presentation Order & Timing (45–50 Min Slot)

> **Optimized Presentation Sequence: 7 $\rightarrow$ 6 $\rightarrow$ 8 (kickoff) $\rightarrow$ 9 (during 8's refactor) $\rightarrow$ 8 (finale)**  
> Total wall-clock runtime: **~42–45 minutes** (safely fitting within a 50-minute slot with buffer for live Q&A).
>
> 1. **Demo 7 (Contract-First TDD & `/grill-me`):** ~10 mins (Red $\rightarrow$ Grill-Me $\rightarrow$ Plan $\rightarrow$ Green test-heal).
> 2. **Demo 6 (Grounding Specs, Linked ADRs & `⚡ Boost`):** ~9 mins (Context hierarchy walkthrough $\rightarrow$ `/boost` single-turn implementation).
> 3. **Demo 8 Kickoff (Graph Planning & Launch `/teamwork`):** ~8 mins (Baseline check $\rightarrow$ `@architect` + `@fast-scout` Mermaid DAG $\rightarrow$ launch `/teamwork`).
> 4. **Demo 9 (Clean-Context Adversarial Review):** ~10 mins (*Run concurrently while Demo 8's parallel `@coder` workers execute in the background*).
> 5. **Demo 8 Finale (Return for Verification):** ~3 mins (Inspect decomposed modules, re-exports facade, and final green `pytest`).

---

### Demo 6: Grounding Specs, Linked ADRs & `⚡ Boost` (`demo6-linked-design-boost`)
* **Suggested Timing:** ~10 minutes (4m walkthrough of `AGENTS.md` $\rightarrow$ `docs/adr/` vs. `docs/specs/` & path-scoped rules, 6m `/boost` execution & test verification)
* **Goal:** Show how separating `AGENTS.md` (concise project constitution) and `docs/adr/` (long-lived architectural decision records: 50% discount ceiling, Decimal rounding, typing contracts) from `docs/specs/` (the single-conversation feature specification) plus path-scoped `.agents/rules/` lets **`⚡ Boost`** (`/boost`) implement complex features from a 1-sentence prompt.

#### Step 1: Verify Baseline Tests & Inspect the 3-Tier Context Hierarchy (`AGENTS.md` $\rightarrow$ `docs/adr/` + `docs/specs/`)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo6-linked-design-boost/workspace/`
* **Prompt:**
```text
Run pytest.
```
* **Expected Result:**
```text
==================== 2 passed in 0.02s ====================
```
* **Files to highlight in editor:**
  * `workspace/AGENTS.md` (concise entry point linking to `@docs/adr/` for standing guardrails)
  * `workspace/docs/adr/0001-decimal-currency-and-discount-caps.md` (long-lived ADR & testing procedures: `Decimal("0.01")` with `ROUND_HALF_UP`, `float` rejection with `TypeError`, `@dataclass(frozen=True)`, and the service-wide 50% maximum discount ceiling)
  * `workspace/docs/specs/0001-stacked-promo-engine.md` (task-specific feature specification for `evaluate_stacked_promos`: `PERCENT` before `FIXED` ordering, `min_subtotal` filtering, duplicate code deduplication, and `AC-1`–`AC-4`)
  * `workspace/.agents/rules/discount-invariants.md` (`paths: ["src/discountservice/**"]`)

#### Step 2: Execute Feature Spec via `⚡ Boost` (`/boost`)
* **Where to run:** Antigravity 2.0 UI (`⚡ Boost` toggle) or `agy` CLI inside `demo6-linked-design-boost/workspace/`
* **Prompt:**
```text
/boost Implement @docs/specs/0001-stacked-promo-engine.md in src/discountservice/engine.py and add unit tests for all acceptance criteria.
```
* **Expected Result:** Implements `evaluate_stacked_promos` in `engine.py` adhering to the ADR (Decimal rounding, 50% cap, TypeError on float); adds tests in `tests/test_engine.py`; passes all tests.
* **Highlight:** Point out how `@docs/specs/0001-stacked-promo-engine.md` focuses purely on the feature being built in this conversation (`evaluate_stacked_promos`), while Antigravity automatically enforces all standing architectural guardrails from `AGENTS.md` $\rightarrow$ `@docs/adr/0001-decimal-currency-and-discount-caps.md` and `.agents/rules/discount-invariants.md` and verifies `AC-1`–`AC-4` pass via `pytest`.

---

### Demo 7: Contract-First Spec Clarification & Test-Heal Loop (`demo7-contract-spec-tdd`)
* **Suggested Timing:** ~12 minutes (2m initial `Red` test suite, 4m `/grill-me` edge-case clarification, 2m `/plan` task breakdown, 4m autonomous `/goal` test-heal loop to `Green`)
* **Goal:** Start from a feature spec (`docs/specs/0001-stock-reservation-holds.md`) and pre-written failing `pytest` contract tests (`Red` state: `1 passed, 4 failed`), clarify edge cases against the ADR (`docs/adr/0001-inventory-reservation-invariants.md`) via `/grill-me`, lock the task breakdown via `/plan`, and self-heal to `Green`.

#### Step 1: Show the Failing Contract Suite (`Red` State)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo7-contract-spec-tdd/workspace/`
* **Prompt:**
```text
Run pytest.
```
* **Expected Result:**
```text
FAILED tests/test_reservator.py::test_hold_expiration_releases_stock
FAILED tests/test_reservator.py::test_atomic_multi_sku_rollback_on_insufficient_stock
FAILED tests/test_reservator.py::test_idempotent_reservation_replay
FAILED tests/test_reservator.py::test_rejects_negative_or_zero_quantity
==================== 4 failed, 1 passed in 0.04s ====================
```
* **Highlight:** `tests/test_reservator.py` fails 4 contract tests (`AC-1` expired hold reclamation, `AC-2` atomic multi-SKU rollback, `AC-3` idempotent `reservation_id` replay, `AC-4` non-positive quantity validation).

#### Step 2: Clarify Edge Cases with `/grill-me` & Lock Plan with `/plan`
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo7-contract-spec-tdd/workspace/`
* **Prompts:**
```text
/grill-me Review @docs/specs/0001-stock-reservation-holds.md and tests/test_reservator.py. Ask me about any edge cases before we lock the implementation plan.
```
* **Expected Result:** Clarifies clock drift, Redis lock lease durations, and idempotency key retention periods before writing plan.

```text
/plan Write the implementation plan and task breakdown to .scratch/reservation-plan.md
```
* **Expected Result:** Generates `.scratch/reservation-plan.md` with 4 focused implementation phases matching AC-1 through AC-4.

#### Step 3: Autonomous Act $\rightarrow$ Verify Test-Heal Loop
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo7-contract-spec-tdd/workspace/`
* **Prompt:**
```text
/goal Implement .scratch/reservation-plan.md in src/inventoryservice/reservator.py and self-heal until pytest passes 100%.
```
* **Expected Result:**
```text
Autonomous loop patches reservator.py, self-heals failures across test runs, and completes with:
==================== 5 passed in 0.05s ====================
```

---

### Demo 8: Graph Planning & Multi-Agent `/teamwork` Monolith Refactoring (`demo8-teamwork-monolith-refactor`)
* **Suggested Timing:** ~24 minutes (1m baseline pre-check, 3m `@architect` + `@fast-scout` AST Graph Planning & Mermaid generation to `.scratch/refactor-dag.md`, 4m `/teamwork` coordination & staging, 16m parallel `@coder` execution & pytest verification)
* **Goal:** Decompose a 220-line monolithic Online Boutique Order Processor (`src/order_app/monolith_order_app.py`) into `models.py`, `repositories.py`, `services.py`, and `routes.py` using **Graph Planning** (`@architect` + `@fast-scout`) and **`/teamwork`** (`👥 Teamwork`) parallel `@coder` execution.

#### Step 1: Verify Monolith Baseline (`4 passed`)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Prompt:**
```text
Run pytest.
```
* **Expected Result:**
```text
==================== 4 passed in 0.03s ====================
```
* **Files to highlight in editor:**
  * `workspace/.agents/agents/architect.md` (Graph Planner persona)
  * `workspace/.agents/agents/fast-scout.md` (Flash AST Scout persona using `ast-graph` MCP)
  * `workspace/.agents/agents/coder.md` (Modular implementation persona)

#### Step 2: Graph Planning (`@architect` + `@fast-scout` $\rightarrow$ `.scratch/refactor-dag.md`)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Prompt:**
```text
/plan Use @architect and @fast-scout to inspect src/order_app/monolith_order_app.py via the ast-graph MCP tools and generate a 3-stage dependency graph (DAG) in .scratch/refactor-dag.md with non-overlapping file ownership. Include the assigned subagent for each step in both the stage breakdown and the Mermaid diagram.
```
* **Expected Result:** Wrote `.scratch/refactor-dag.md` with an embedded Mermaid DAG flowchart labeling assigned subagents: Stage 1 extracts `models.py`; Stage 2 runs parallel `@coder` subagents on disjoint files (`repositories.py` and `services.py`); Stage 3 rewires `routes.py` and `monolith_order_app.py`.
* **Highlight:** Show the 3-stage DAG and Mermaid flowchart in `.scratch/refactor-dag.md`: Stage 1 extracts `models.py`; Stage 2 runs two `@coder` subagents **in parallel** on disjoint files (`repositories.py` and `services.py`); Stage 3 rewires `routes.py` and `monolith_order_app.py`, with subagent assignments explicitly mapped per node.

#### Step 3: Execute Parallel Multi-Agent Refactor via `/teamwork` (`👥 Teamwork`)
* **Where to run:** Antigravity 2.0 (`👥 Teamwork`) or `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Prompt:**
```text
/teamwork Execute .scratch/refactor-dag.md using @coder subagents in parallel across Stage 2 (repositories.py and services.py), then rewire routes.py and monolith_order_app.py and verify pytest passes in a clean context.
```
* **Expected Result:**
```text
Parallel @coder subagents complete without file collisions; monolith delegates cleanly; pytest passes:
==================== 4 passed in 0.03s ====================
```
* **Presenter Flow Note ("Cooking Show" Overlap Pattern):**
  Once the `/teamwork` parallel refactor is running and you have shown the active `@coder` workers in the Antigravity TUI (~2–3 minutes of observation), **do not wait 15 minutes in silence**. Leave terminal/workspace 8 running in the background, open a new terminal or VS Code window for **Demo 9 (`Reset & Open: Demo 9`)**, and run through Demo 9 end-to-end (~10 mins). When Demo 9 finishes, return to Demo 8 for Step 4.

#### Step 4: Return to Demo 8 for Finale & Verification
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Highlight:**
  1. Inspect the decomposed modular architecture: `models.py`, `repositories.py`, `services.py`, and `routes.py`.
  2. Show `monolith_order_app.py` functioning purely as a backward-compatible facade re-exporting the modules.
  3. Verify the final clean test suite passes with `pytest`:
  ```bash
  pytest
  ```
  * **Expected Result:** `==================== 4 passed in 0.03s ====================`

---

### Demo 9: Clean-Context Adversarial Review Loop (`demo9-adversarial-review-loop`)
* **Suggested Timing:** ~12 minutes (2m "False-Green" `pytest` demonstration, 5m `@adversarial-reviewer` clean-context audit & production guardrail table, 5m `/boost` remediation & re-verification)
* **Goal:** Demonstrate why passing unit tests (`4 passed` — "False Green") are not enough, and how a clean-context **`@adversarial-reviewer`** subagent catches 3 subtle security, resiliency, and outbox ordering regressions against `docs/adr/0001-payment-webhook-and-settlement-guardrails.md` before human code review.

#### Step 1: Show the "False-Green" Test Suite (`4 passed`)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo9-adversarial-review-loop/workspace/`
* **Prompt:**
```text
Run pytest.
```
* **Expected Result:**
```text
==================== 4 passed in 0.02s ==================== (False Green)
```
* **Highlight:** `pytest` passes 100% (`4 passed`), giving the author a false sense of security.

#### Step 2: Run the Clean-Context `@adversarial-reviewer` Subagent
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo9-adversarial-review-loop/workspace/`
* **Prompt:**
```text
Invoke @adversarial-reviewer to audit src/settlement/dispatcher.py and tests/test_dispatcher.py against @docs/adr/0001-payment-webhook-and-settlement-guardrails.md and produce a production guardrail table with file:line proof.
```
* **Expected Result:** Audit outputs production guardrail table with 3 FAIL findings: linear backoff (`dispatcher.py:85`), non-constant-time HMAC compare (`dispatcher.py:55`), and outbox order reversal (`dispatcher.py:78-98`).
* **What to watch on screen:**
  `@adversarial-reviewer` inspects `src/settlement/dispatcher.py` with zero authoring bias and flags **3 `FAIL` rows** in its production guardrail table:
  1. **§1 Resiliency (`FAIL` at `dispatcher.py:85`):** Linear `self.sleep_fn(self.base_delay_sec)` instead of exponential backoff with full randomized jitter.
  2. **§2 Security (`FAIL` at `dispatcher.py:55`):** `provided_signature != expected` instead of constant-time `hmac.compare_digest()`.
  3. **§3 Idempotency / Outbox (`FAIL` at `dispatcher.py:78-98`):** Invokes external `self.webhook_client(event)` *before* recording the idempotency state in `settlement_ledger`.

#### Step 3: Remediate All 3 Findings & Re-Verify
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo9-adversarial-review-loop/workspace/`
* **Prompt:**
```text
/boost Fix all FAIL findings identified by @adversarial-reviewer in src/settlement/dispatcher.py, add regression tests in tests/test_dispatcher.py, and re-run @adversarial-reviewer to confirm 100% PASS.
```
* **Expected Result:**
```text
Applies fixes to dispatcher.py; adds 3 regression tests in test_dispatcher.py; re-audit reports 100% PASS; pytest passes:
==================== 7 passed in 0.05s ====================
```
