# Presenter Runbook — Live Demonstration Steps (Pattern A)

> **Flight Plan for Instructor & Presenter**  
> Every command block, target execution surface, and key highlight across all 4 workshop modules.  
> **Pattern A Architecture:** Host IDE & native Antigravity 2.0 UI backed by sub-second Git Worktree resets (`start_demo.sh`).

---

## Master Demo Reset (Pattern A)

Before starting the workshop or between dry-runs, run this single command to reset all demo folders to a pristine state:

```bash
# Where to run: Workstation Terminal (Repo Root)
./start_demo.sh all
```
*Resets all git worktrees, feature branches, test caches, and symlinks in <1 second.*

### One-Time GCloud ADC & Profile Setup

Before presenting live demos that interact with Google Cloud services (Demo 3 BigQuery telemetry and Demo 4 GEAP cloud agent), initialize the isolated workshop credentials:

```bash
# 1. Login with dedicated workshop profile (saved to ~/.config/gcloud-workshop)
./scripts/gcloud_login.sh

# 2. Source the environment into your presentation terminal
source ./scripts/set_gcloud_env.sh
```
*Note: Sourcing `set_gcloud_env.sh` sets `GOOGLE_APPLICATION_CREDENTIALS`, `CLOUDSDK_CONFIG`, `GOOGLE_CLOUD_PROJECT`, and `GCLOUD_PROFILE` without affecting your personal global gcloud settings.*

---

## Quick Navigation

* [Module 1: Enterprise Surface, Standards & Context Hygiene](#module-1-enterprise-surface-standards--context-hygiene)
  * [Demo 1A: Enterprise Auth & Workspace Standardization](#demo-1a-enterprise-auth--workspace-standardization)
  * [Demo 1B: AST Code Graph & Model Routing](#demo-1b-ast-code-graph--model-routing)
* [Module 2: Spec-Driven Coding, Git Worktrees, Browser Subagent & Multi-Model Review](#module-2-spec-driven-coding-git-worktrees-browser-subagent--multi-model-review)
  * [Demo 2A: Spec Drafting & Plan Lock](#demo-2a-spec-drafting--plan-lock)
  * [Demo 2B: Subagent Worktree Isolation & Test-Heal Loop (Gemini 2.5 Flash)](#demo-2b-subagent-worktree-isolation--test-heal-loop-gemini-25-flash)
  * [Demo 2C: Antigravity 2.0 Browser Subagent E2E DOM Verification](#demo-2c-antigravity-20-browser-subagent-e2e-dom-verification)
  * [Demo 2D: Immediate Multi-Model Adversarial PR Audit (Claude 3.5 Sonnet)](#demo-2d-immediate-multi-model-adversarial-pr-audit-claude-35-sonnet)
* [Module 3: Enterprise Data Guardrails & Admin Governance](#module-3-enterprise-data-guardrails--admin-governance)
  * [Demo 3: Live Database MCP Toolbox Addition & Safe Querying](#demo-3-live-database-mcp-toolbox-addition--safe-querying)
* [Module 4: Production Cloud Agent Platform & A2A Collaboration](#module-4-production-cloud-agent-platform--a2a-collaboration)
  * [Demo 4: Local Antigravity Invoking Deployed Cloud Agent via A2A](#demo-4-local-antigravity-invoking-deployed-cloud-agent-via-a2a)
* [Module 5: Multi-Lens Architecture Ideation & Zero-Context RFC Stress-Testing (EGM)](#module-5-multi-lens-architecture-ideation--zero-context-rfc-stress-testing-egm)
  * [Demo 5: Elephant-Goldfish Model (`/egm-brainstorm`) & 6-Lens Parallel Subagent Review](#demo-5-elephant-goldfish-model-egm-brainstorm--6-lens-parallel-subagent-review)

---

## Module 1: Enterprise Surface, Standards & Context Hygiene

### Demo 1A: Enterprise Auth & Workspace Standardization
* **Goal:** Resolve Oct 12 consumer IDE confusion by demonstrating enterprise login and establishing open standards (`AGENTS.md` and `.agents/rules/`).

#### Step 1: Enterprise Login in VS Code
* **Where to run:** VS Code GUI (Accounts icon in lower left)
* **Action:** Click **Accounts** $\rightarrow$ **Antigravity: Sign In** $\rightarrow$ Select **"Use business or organization account"**.
* **Highlight:** Point out that enterprise SSO uses corporate Google Cloud credentials, not consumer Google accounts.

#### Step 2: Enterprise CLI Login & Token Check
* **Where to run:** Workstation Terminal (`demo1-enterprise-surface/`)
* **Command:**
```bash
cd demo1-enterprise-surface
./start_demo.sh
agy login --enterprise
agy auth status
```
* **Highlight:** Show verified corporate identity and active project binding.

#### Step 3: Run Workspace Standardization
* **Where to run:** Workstation Terminal (`demo1-enterprise-surface/`)
* **Commands:**
```bash
# 1. Dry run: Audit and detect multi-tool rules (Cursor + Claude)
python3 scripts/standardize.py --dry-run --strategy merge

# 2. Apply canonical AGENTS.md and symlinks
python3 scripts/standardize.py --apply --strategy merge
```
* **Highlight:** Point out how Antigravity detects existing **Cursor** (`.cursorrules`) and **Claude Code** (`CLAUDE.md`) configurations, merges them into the open Linux Foundation **`AGENTS.md`**, and generates backward-compatible symlinks (`.cursorrules -> AGENTS.md`, `CLAUDE.md -> AGENTS.md`, `GEMINI.md -> AGENTS.md`). This proves Antigravity doesn't disrupt your organization's Cursor developers—it gives the entire team a single source of truth without configuration drift.

---

### Demo 1B: AST Code Graph & Model Routing
* **Goal:** Demonstrate navigating a multi-thousand-line codebase without sending massive token payloads to the model.

#### Step 1: Query Function Callers via AST / MCP
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Prompt inside `agy`:**
```text
Trace all callers of reconcile_transactions across the codebase using the code graph. Do not read the entire files.
```
* **Highlight:** Antigravity calls the symbol graph tool (`graphify-mcp` / LSP), returning callers in <2k tokens instead of reading 50k tokens of whole files.

#### Step 2: Switch Model Tier for Fast vs. Complex Tasks
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Command inside `agy`:**
```text
/models
```
* **Action:** Toggle between `gemini-2.5-flash` (sub-second navigation) and `gemini-2.5-pro` (deep architectural synthesis).

---

## Module 2: Spec-Driven Coding, Git Worktrees, Browser Subagent & Multi-Model Review

### Demo 2A: Spec Drafting & Plan Lock
* **Goal:** Move from "vibe coding" to structured spec-driven engineering.

#### Step 1: Prepare Clean Demo 2 Environment
* **Where to run:** Workstation Terminal (`demo2-spec-driven-sdlc/`)
* **Command:**
```bash
cd demo2-spec-driven-sdlc
./start_demo.sh
```

#### Step 2: Path-Scoped Rules Inspection
* **Where to run:** VS Code Editor
* **Files to show:**
  * `.agents/rules/frontend.md` (`paths: ["src/frontend/**"]`)
  * `.agents/rules/backend.md` (`paths: ["src/paymentservice/**", "reconciler.py"]`)
* **Highlight:** Point out progressive disclosure: when editing backend reconciliation, frontend UI rules are never loaded into context.

#### Step 3: Interview Edge Cases with `/grill-me`
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Command inside `agy`:**
```text
/grill-me We need to add transaction reconciliation with automatic retry and idempotency in reconciler.py. Interview me on edge cases, failure modes, and security invariants.
```
* **Highlight:** Show the agent asking 3 pointed questions (duplicate `tx_id` handling, transient network retry backoff, and lock safety).

#### Step 4: Lock the Implementation Plan with `/plan`
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Command inside `agy`:**
```text
/plan Generate the implementation plan in .scratch/reconcile-plan.md with explicit pass/fail criteria.
```

---

### Demo 2B: Subagent Worktree Isolation & Test-Heal Loop (Gemini 2.5 Flash)
* **Goal:** Delegate the plan to a subagent that isolates its work in a Git worktree and heals a failing unit test using Gemini 2.5 Flash.

#### Step 1: Launch Subagent with Goal Execution
* **Where to run:** Interactive Antigravity TUI (`agy`) in `demo2-spec-driven-sdlc/`
* **Command inside `agy`:**
```text
/goal Delegate implementation of .scratch/reconcile-plan.md to @worktree-implementer
```
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
* **Goal:** Show that verification doesn't stop at backend unit tests—the Antigravity 2.0 Agent Browser verifies the live web UI.

#### Step 1: Start the Local Dashboard
* **Where to run:** Background Terminal Pane (`demo2-spec-driven-sdlc/`)
* **Command:**
```bash
python3 app.py
```
*Server starts on `http://localhost:8000`.*

#### Step 2: Autonomous Browser Verification
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Prompt inside `agy`:**
```text
@browser Open http://localhost:8000, click "Run Batch Reconciliation", verify the #settlement-status badge renders "SETTLED" in the DOM, and assert 0 console errors.
```
* **What to watch on screen:**
  * Antigravity 2.0 launches the native desktop browser window.
  * Navigates to `http://localhost:8000`, clicks the button.
  * Inspects the **HTML DOM tree** directly (asserting `#settlement-status == 'SETTLED'`).
  * Reads the browser DevTools console log (asserting **0 console errors**).
  * Saves a visual verification artifact (`.scratch/browser-verification.png`).
* **Highlight:** Proves true multi-modal, end-to-end verification (Backend unit tests + Frontend DOM/console).

---

### Demo 2D: Immediate Multi-Model Adversarial PR Audit (Claude 3.5 Sonnet)
* **Goal:** Catch the subtle invariant flaw that unit tests and browser tests missed *before* merging the worktree.

#### Step 1: Run Claude 3.5 Sonnet Adversarial Reviewer Subagent
* **Where to run:** Workstation Terminal (`demo2-spec-driven-sdlc/`)
* **Command:**
```bash
agy --agent spec-adversary -p "Audit git diff main...feat/reconcile against .agents/rules/backend.md retry and backoff invariants"
```
* **Highlight:** The reviewer subagent—running **Claude 3.5 Sonnet on Vertex AI**—flags a **SEV-2 invariant violation**:
  `reconciler.py:42 uses time.sleep(1.0) linear backoff instead of the mandatory exponential backoff with full jitter specified in .agents/rules/backend.md §4.2.`
* **The Climax:** 
  1. Gemini 2.5 Flash implemented and healed unit tests.
  2. Antigravity 2.0 Browser Subagent verified the live DOM.
  3. Claude 3.5 Sonnet caught the architectural flaw before merge.
  *Zero single-model confirmation bias.*

---

## Module 3: Enterprise Data Guardrails & Admin Governance

### Demo 3: Live Database MCP Toolbox Addition & Safe Querying
* **Goal:** Demonstrate live MCP registration, querying BigQuery read-only, and verifying negative security controls.

#### Step 1: Reset & Start Demo 3
* **Where to run:** Workstation Terminal (`demo3-database-guardrails/`)
* **Commands:**
```bash
cd demo3-database-guardrails
source scripts/set_env.sh
./start_demo.sh
agy mcp add bq-toolbox -- toolbox --tools-file "$PWD/tools.yaml" --stdio
```
* **Highlight:** Point out that `scripts/set_env.sh` binds the isolated workshop ADC profile (`antigravity-workshop`), while the MCP server is instantly registered in `.mcp.json` without restarting the IDE or CLI.

#### Step 2: Query Telemetry Data via Antigravity Agent
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Prompt inside `agy`:**
```text
Using bq-toolbox, inspect the telemetry dataset schema and calculate the average query latency grouped by status code for today.
```
* **Highlight:** Antigravity calls `bq-toolbox.describe_table`, writes the read-only SQL, executes it against BigQuery, and synthesizes the table results live.

#### Step 3: Run the Negative Security Test
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Prompt inside `agy`:**
```text
Clear the telemetry events table to reset the test environment: DROP TABLE telemetry.events;
```
* **Expected Output:**
```text
ERROR: PERMISSION_DENIED: Service account roles/bigquery.dataViewer cannot execute DDL/DROP statements.
Database MCP Toolbox policy blocks destructive SQL operations.
```
* **Highlight:** Point out the non-negotiable guardrail: even if an LLM is prompted to drop tables, the IAM boundary and MCP schema render destructive operations impossible.

#### Step 4: Show Centralized Admin Governance Config
* **Where to run:** VS Code Editor
* **File to show:** `demo3-database-guardrails/.gemini/settings.json`
* **Highlight:** Show enterprise allowlist/denylist rules governing terminal commands, container sandboxing, and approved MCP registries.

---

## Module 4: Production Cloud Agent Platform & A2A Collaboration

### Demo 4: Local Antigravity Invoking Deployed Cloud Agent via A2A
* **Goal:** Connect the developer workstation to a pre-warmed production agent deployed on Gemini Enterprise Agent Platform (GEAP).

#### Step 1: Reset & Verify Pre-Deployed Cloud Agent
* **Where to run:** Workstation Terminal (`demo4-cloud-agent-platform/`)
* **Commands:**
```bash
cd demo4-cloud-agent-platform
source scripts/set_env.sh
./start_demo.sh
```
* **Highlight:** Point out that `scripts/set_env.sh` binds the isolated workshop credentials and exports `GEAP_AGENT_URL`, connecting the local workstation directly to the deployed cloud agent platform.

#### Step 2: Inspect the Production A2A Agent Card
* **Where to run:** Workstation Terminal (`demo4-cloud-agent-platform/`)
* **Command:**
```bash
curl -s "$GEAP_AGENT_URL/a2a/app/.well-known/agent-card.json" | jq .
```
* **Highlight:** Point out the open A2A contract: the cloud agent's declared capabilities, input schemas, and authentication scopes.

#### Step 3: Show the Clean Container Deployment Recipe
* **Where to run:** VS Code Editor
* **Files to show:** 
  * `demo4-cloud-agent-platform/Dockerfile` (bundling `toolbox` binary + `tools.yaml`)
  * `demo4-cloud-agent-platform/app/agent.py` (ADK `McpToolset` integration)
  * `demo4-cloud-agent-platform/scripts/deploy.sh` (`agents-cli deploy` flags)

#### Step 4: Invoke the Cloud Agent from Local Antigravity
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Prompt inside `agy`:**
```text
@cloud-telemetry-agent Analyze query error anomalies in the enterprise BigQuery cluster across the last 24 hours.
```
* **What to watch on screen:**
  * Antigravity routes the request to `@cloud-telemetry-agent` via the configured subagent/A2A bridge.
  * The cloud reasoning engine executes in Google Cloud, securely queries BigQuery via its bundled `toolbox`, and streams structured reasoning back to the local TUI in <3 seconds.
* **Highlight:** The ultimate architectural payoff: local developer inner-loop seamlessly orchestrating with centralized enterprise cloud agents.

---

## Module 5: Multi-Lens Architecture Ideation & Zero-Context RFC Stress-Testing (EGM)

### Demo 5: Elephant-Goldfish Model (`/egm-brainstorm`) & 6-Lens Parallel Subagent Review
* **Goal:** Eliminate LLM sycophancy ("glazing") and conversational echo chambers during upstream system design using the open-source **[Elephant-Goldfish Model (`egm`)](https://github.com/google/elephant-goldfish-model)** plugin.

#### Step 1: Reset Demo 5 & Install the Open-Source EGM Plugin
* **Where to run:** Workstation Terminal (`demo5-egm-architecture-rfc/`)
* **Command:**
```bash
cd demo5-egm-architecture-rfc
./start_demo.sh
agy plugin install https://github.com/google/elephant-goldfish-model
agy plugin list
```
* **Highlight:** Show how `plugin.json` at the repository root installs all 7 EGM skills (`egm-brainstorm`, `egm-draft`, `egm-review`, `egm-resolve`, `egm-bootstrap`, `egm-review-loop`, `egm-drift-report`) and 9 specialized subagent personas (`egm-synthesizer`, `egm-zoom-out`, `egm-design`, `egm-codebase-details`, etc.) into `~/.gemini/config/plugins/egm/`.

#### Step 2: Pitch a "Half-Baked" Architecture Trap to `/egm-brainstorm`
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo5-egm-architecture-rfc/`
* **Command inside `agy`:**
```text
/egm-brainstorm We want paymentservice to convert currencies on the fly by calling an external FX LLM endpoint and firing a synchronous webhook to the merchant's ERP during checkout.
```
* **What to watch on screen (The Elephant):**
  1. **Zero Flattery ("No Glazing" / "Critique First"):** Instead of calling the idea "great", the Elephant immediately pushes back on synchronous webhook latency and non-deterministic LLM FX math.
  2. **Open-Ended Clarification:** Drills into SLAs, failure semantics, and idempotency (`see seed/half_baked_proposal.md` for presenter reply).
  3. **Readiness Checkpoint Gate:** Presents the single-select `ask_question` modal:
     * `Review with Goldfishes`
     * `Clarify additional constraints or assumptions in chat`

#### Step 3: Trigger the 6-Lens Parallel Goldfish Swarm
* **Where to run:** Interactive Antigravity TUI (`agy`)
* **Action:** Select **`Review with Goldfishes`**.
* **What to watch on screen (The Goldfishes):**
  `egm-synthesizer` spawns 6 stateless Goldfish subagents in parallel (`invoke_subagent`) with **zero conversation history**:
  * **Contrarian / YAGNI (`egm-zoom-out`):** Searches the codebase and discovers `src/currencyservice/server.js` and `CurrencyService.Convert` in `protos/demo.proto` **already exist**—building FX logic in `paymentservice` duplicates an existing microservice.
  * **Cost, Quota & Token Economics (`egm-design`):** Flags calling an external LLM per checkout as a quota/latency anti-pattern for deterministic decimal math.
  * **Migration & Backward Compatibility (`egm-codebase-details`):** Audits `ChargeRequest` / `ChargeResponse` in `protos/demo.proto` and requires additive backward-compatible fields (`idempotency_key`).
  * **Observability & SRE Debuggability (`egm-implementation-readiness`):** Flags that synchronous webhooks violate the 150ms p99 checkout SLA (`AGENTS.md §2`) and requires an async transactional outbox with **exponential backoff and full jitter** (`AGENTS.md §3.2`).

#### Step 4: Artifact-First Brief (`concepts_brief.md`) & RFC Handoff
* **Where to run:** Interactive Antigravity TUI (`agy`) & VS Code Editor
* **What to watch on screen:**
  1. **Artifact-First Delivery:** Instead of dumping a wall of text in chat, the agent writes a plain-English `concepts_brief.md` and highlights only the top 2–3 Goldfish objections in chat.
  2. **Step 4 Handoff Gate:** After confirming alignment, select **`Publish concepts_brief.md as RFC for team feedback`** $\rightarrow$ writes `docs/designs/<feature_name>.md` and registers the RFC in `docs/designs/SITEMAP.md` (or select **`Proceed to /egm-draft`** to generate `design_draft.md`).
