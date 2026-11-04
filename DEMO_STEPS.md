# Presenter Runbook — Live Demonstration Steps (Pattern A)

> **Flight Plan for Instructor & Presenter**  
> Every command block, target execution surface, and key highlight across all workshop modules (Demos 1–5) and the **Antigravity 201: Spec-Driven Development & Multi-Agent Workflows** track (Demos 6–9).  
> **Pattern A Architecture:** Host IDE & native Antigravity 2.0 UI backed by sub-second deterministic resets (`./start_demo.sh`).

---

## Master Demo Reset (Pattern A)

Before starting a session or between dry-runs, run this single command to reset all demo folders to a pristine state:

```bash
# Reset all 9 demos (Demos 1-9):
./start_demo.sh all

# Or reset only the 4 Antigravity 201 demos (Demos 6-9):
./start_demo.sh 201
```
*Resets all source files, git worktrees, feature branches, `.scratch/` plans, test caches, and symlinks in <1 second.*

### One-Time GCloud ADC & Profile Setup

Before presenting live demos that interact with Google Cloud services (Demo 3 BigQuery telemetry and Demo 4 GEAP cloud agent), initialize the isolated workshop credentials:

1. Login with dedicated workshop profile (saved to `~/.config/gcloud-workshop`):
```bash
./scripts/gcloud_login.sh
```

2. Source the environment into your presentation terminal:
```bash
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
* [Antigravity 201 Track: Spec-Driven Development & Multi-Agent Workflows (Demos 6–9)](#antigravity-201-track-spec-driven-development--multi-agent-workflows-demos-69)
  * [Demo 6: Grounding Specs, Linked `@DESIGN.md` & `⚡ Boost` (`demo6-linked-design-boost`)](#demo-6-grounding-specs-linked-designmd--boost-demo6-linked-design-boost)
  * [Demo 7: Contract-First Spec Clarification & Test-Heal Loop (`demo7-contract-spec-tdd`)](#demo-7-contract-first-spec-clarification--test-heal-loop-demo7-contract-spec-tdd)
  * [Demo 8: Graph Planning & Multi-Agent `/teamwork` Monolith Refactoring (`demo8-teamwork-monolith-refactor`)](#demo-8-graph-planning--multi-agent-teamwork-monolith-refactoring-demo8-teamwork-monolith-refactor)
  * [Demo 9: Clean-Context Adversarial Review Loop (`demo9-adversarial-review-loop`)](#demo-9-clean-context-adversarial-review-loop-demo9-adversarial-review-loop)

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
* **Commands:**
```bash
cd demo1-enterprise-surface
./start_demo.sh
cd workspace
agy login --enterprise
agy auth status
```
* **Highlight:** Show verified corporate identity and active project binding.

#### Step 3: Run Workspace Standardization
* **Where to run:** Workstation Terminal (`demo1-enterprise-surface/workspace/`)
* **Commands:**
1. Dry run: Audit and detect multi-tool rules (Cursor + Claude):
```bash
python3 scripts/standardize.py --dry-run --strategy merge
```
2. Apply canonical AGENTS.md and symlinks:
```bash
python3 scripts/standardize.py --apply --strategy merge
```
* **Highlight:** Point out how Antigravity detects existing **Cursor** (`.cursorrules`) and **Claude Code** (`CLAUDE.md`) configurations, merges them into the open Linux Foundation **`AGENTS.md`**, and generates backward-compatible symlinks (`.cursorrules -> AGENTS.md`, `CLAUDE.md -> AGENTS.md`, `GEMINI.md -> AGENTS.md`).

---

### Demo 1B: AST Code Graph & Model Routing
* **Goal:** Demonstrate navigating a multi-thousand-line codebase without sending massive token payloads to the model.

#### Step 1: Query Function Callers via AST / MCP
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo1-enterprise-surface/workspace/`
* **Prompt inside `agy`:**
```text
Trace all callers of reconcile_transactions across the codebase using the code graph. Do not read the entire files.
```
* **Highlight:** Antigravity calls the symbol graph tool (`ast-graph` / LSP), returning callers in <2k tokens instead of reading 50k tokens of whole files.

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
* **Commands:**
```bash
cd demo2-spec-driven-sdlc
./start_demo.sh
cd workspace
```

#### Step 2: Path-Scoped Rules Inspection
* **Where to run:** VS Code Editor
* **Files to show:**
  * `workspace/.agents/rules/frontend.md` (`paths: ["src/frontend/**"]`)
  * `workspace/.agents/rules/backend.md` (`paths: ["src/paymentservice/**", "reconciler.py"]`)
* **Highlight:** Point out progressive disclosure: when editing backend reconciliation, frontend UI rules are never loaded into context.

#### Step 3: Interview Edge Cases with `/grill-me`
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Command inside `agy`:**
```text
/grill-me We need to add transaction reconciliation with automatic retry and idempotency in reconciler.py. Interview me on edge cases, failure modes, and security invariants.
```
* **Highlight:** Show the agent asking 3 pointed questions (duplicate `tx_id` handling, transient network retry backoff, and lock safety).

#### Step 4: Lock the Implementation Plan with `/plan`
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Command inside `agy`:**
```text
/plan Generate the implementation plan in .scratch/reconcile-plan.md with explicit pass/fail criteria.
```

---

### Demo 2B: Subagent Worktree Isolation & Test-Heal Loop (Gemini 2.5 Flash)
* **Goal:** Delegate the plan to a subagent that isolates its work in a Git worktree and heals a failing unit test using Gemini 2.5 Flash.

#### Step 1: Launch Subagent with Goal Execution
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
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
* **Where to run:** Background Terminal Pane (`demo2-spec-driven-sdlc/workspace/`)
* **Command:**
```bash
python3 app.py
```
*Server starts on `http://localhost:8000`.*

#### Step 2: Autonomous Browser Verification
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
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

#### Step 1: Run Adversarial Reviewer Subagent
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo2-spec-driven-sdlc/workspace/`
* **Commands:**
```bash
agy
```
* **Prompt inside `agy`:**
```text
Use invoke subagent to execute spec-adversary to audit git diff main...feat/reconcile against .agents/rules/backend.md retry and backoff invariants.
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

### Demo 3: In-Repo Database MCP Toolbox & Safe Querying
* **Goal:** Demonstrate repository-committed MCP configuration, querying BigQuery read-only, and verifying negative security controls.

#### Step 1: Reset & Start Demo 3
* **Where to run:** Workstation Terminal (`demo3-database-guardrails/`)
* **Commands:**
```bash
cd demo3-database-guardrails
source scripts/set_env.sh
./start_demo.sh
cd workspace
```
* **Highlight:** Point out that `scripts/set_env.sh` binds the isolated workshop ADC profile, while the MCP server is pre-configured and committed directly in `workspace/.mcp.json` (and `workspace/.gemini/mcp_config.json`), making tools immediately available without manual registration or polluting global user configs.

#### Step 2: Query Telemetry Data via Antigravity Agent
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo3-database-guardrails/workspace/`
* **Prompt inside `agy`:**
```text
Using bq-toolbox, inspect the telemetry dataset schema and calculate the average query latency grouped by status code for today.
```
* **Highlight:** Antigravity calls `bq-toolbox.describe_table`, writes the read-only SQL, executes it against BigQuery, and synthesizes the table results live.

#### Step 3: Run the Negative Security Test
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo3-database-guardrails/workspace/`
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
* **File to show:** `demo3-database-guardrails/workspace/.gemini/settings.json`
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
cd workspace
```
* **Highlight:** Point out that `scripts/set_env.sh` binds the isolated workshop credentials and exports `GEAP_AGENT_URL`, connecting the local workstation directly to the deployed cloud agent platform.

#### Step 2: Inspect the Production A2A Agent Card
* **Where to run:** Workstation Terminal (`demo4-cloud-agent-platform/workspace/`)
* **Command:**
```bash
curl -s "$GEAP_AGENT_URL/a2a/app/.well-known/agent-card.json" | jq .
```
* **Highlight:** Point out the open A2A contract: the cloud agent's declared capabilities, input schemas, and authentication scopes.

#### Step 3: Show the Clean Container Deployment Recipe
* **Where to run:** VS Code Editor
* **Files to show:** 
  * `demo4-cloud-agent-platform/workspace/Dockerfile` (bundling `toolbox` binary + `tools.yaml`)
  * `demo4-cloud-agent-platform/workspace/app/agent.py` (ADK `McpToolset` integration)
  * `demo4-cloud-agent-platform/workspace/scripts/deploy.sh` (`agents-cli deploy` flags)

#### Step 4: Invoke the Cloud Agent from Local Antigravity
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo4-cloud-agent-platform/workspace/`
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
* **Commands:**
```bash
cd demo5-egm-architecture-rfc
./start_demo.sh
cd workspace
agy plugin install https://github.com/google/elephant-goldfish-model
agy plugin list
```
* **Highlight:** Show how `plugin.json` at the repository root installs all 7 EGM skills (`egm-brainstorm`, `egm-draft`, `egm-review`, `egm-resolve`, `egm-bootstrap`, `egm-review-loop`, `egm-drift-report`) and 9 specialized subagent personas (`egm-synthesizer`, `egm-zoom-out`, `egm-design`, `egm-codebase-details`, etc.) into `~/.gemini/config/plugins/egm/`.

#### Step 2: Pitch a "Half-Baked" Architecture Trap to `/egm-brainstorm`
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo5-egm-architecture-rfc/workspace/`
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
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo5-egm-architecture-rfc/workspace/`
* **Action:** Select **`Review with Goldfishes`**.
* **What to watch on screen (The Goldfishes):**
  `egm-synthesizer` spawns 6 stateless Goldfish subagents in parallel (`invoke_subagent`) with **zero conversation history**:
  * **Contrarian / YAGNI (`egm-zoom-out`):** Searches the codebase and discovers `src/currencyservice/server.js` and `CurrencyService.Convert` in `protos/demo.proto` **already exist**—building FX logic in `paymentservice` duplicates an existing microservice.
  * **Cost, Quota & Token Economics (`egm-design`):** Flags calling an external LLM per checkout as a quota/latency anti-pattern for deterministic decimal math.
  * **Migration & Backward Compatibility (`egm-codebase-details`):** Audits `ChargeRequest` / `ChargeResponse` in `protos/demo.proto` and requires additive backward-compatible fields (`idempotency_key`).
  * **Observability & SRE Debuggability (`egm-implementation-readiness`):** Flags that synchronous webhooks violate the 150ms p99 checkout SLA (`AGENTS.md §2`) and requires an async transactional outbox with **exponential backoff and full jitter** (`AGENTS.md §3.2`).

#### Step 4: Artifact-First Brief (`concepts_brief.md`) & RFC Handoff
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo5-egm-architecture-rfc/workspace/` & VS Code Editor
* **What to watch on screen:**
  1. **Artifact-First Delivery:** Instead of dumping a wall of text in chat, the agent writes a plain-English `concepts_brief.md` and highlights only the top 2–3 Goldfish objections in chat.
  2. **Step 4 Handoff Gate:** After confirming alignment, select **`Publish concepts_brief.md as RFC for team feedback`** $\rightarrow$ writes `docs/designs/<feature_name>.md` and registers the RFC in `docs/designs/SITEMAP.md` (or select **`Proceed to /egm-draft`** to generate `design_draft.md`).

---

## Antigravity 201 Track: Spec-Driven Development & Multi-Agent Workflows (Demos 6–9)

> **60-Minute Developer Session Focus:**
> 1. Moving beyond single-loop prompts to explicit technical specs (`AGENTS.md` $\rightarrow$ `@DESIGN.md`) and executable acceptance criteria (`⚡ Boost`).
> 2. Translating product requirements (`SPEC.md` + failing contract tests) into structured implementation plans (`/grill-me` $\rightarrow$ `/plan`) and autonomous test-heal loops.
> 3. Multi-agent execution patterns: coordinating AST scouting (`@fast-scout`), Graph Planning (`@architect`), and parallel authoring (`@coder` via `/teamwork`).
> 4. Clean-context adversarial review loops (`@adversarial-reviewer`) that stress-test "false-green" code and catch regressions before human review.

---

### Demo 6: Grounding Specs, Linked `@DESIGN.md` & `⚡ Boost` (`demo6-linked-design-boost`)
* **Goal:** Show how separating `AGENTS.md` (concise project constitution) and `@DESIGN.md` (long-lived architectural guardrails, 50% ceiling, & testing procedures) from `@SPEC.md` (the single-conversation feature specification) plus path-scoped `.agents/rules/` lets **`⚡ Boost`** (`/boost`) implement complex features from a 1-sentence prompt.

#### Step 1: Reset & Inspect the 3-Tier Context Hierarchy (`AGENTS.md` $\rightarrow$ `@DESIGN.md` + `@SPEC.md`)
* **Where to run:** Workstation Terminal (`demo6-linked-design-boost/`)
* **Commands:**
```bash
cd demo6-linked-design-boost
./start_demo.sh
cd workspace
uv run pytest
```
* **Files to highlight in editor:**
  * `workspace/AGENTS.md` (concise entry point linking to `@DESIGN.md` for standing guardrails)
  * `workspace/DESIGN.md` (long-lived service architecture & testing procedures: `Decimal("0.01")` with `ROUND_HALF_UP`, `float` rejection with `TypeError`, `@dataclass(frozen=True)`, and the service-wide 50% maximum discount ceiling)
  * `workspace/SPEC.md` (task-specific feature specification for `evaluate_stacked_promos`: `PERCENT` before `FIXED` ordering, `min_subtotal` filtering, duplicate code deduplication, and `AC-1`–`AC-4`)
  * `workspace/.agents/rules/discount-invariants.md` (`paths: ["src/discountservice/**"]`)

#### Step 2: Execute `@SPEC.md` via `⚡ Boost` (`/boost`)
* **Where to run:** Antigravity 2.0 UI (`⚡ Boost` toggle) or `agy` CLI inside `demo6-linked-design-boost/workspace/`
* **Prompt:**
```text
/boost Implement @SPEC.md in src/discountservice/engine.py and add unit tests for all acceptance criteria.
```
* **Highlight:** Point out how `@SPEC.md` focuses purely on the feature being built in this conversation (`evaluate_stacked_promos`), while Antigravity automatically enforces all standing architectural and testing guardrails from `AGENTS.md` $\rightarrow$ `@DESIGN.md` and `.agents/rules/discount-invariants.md` and verifies `AC-1`–`AC-4` pass via `pytest`.

---

### Demo 7: Contract-First Spec Clarification & Test-Heal Loop (`demo7-contract-spec-tdd`)
* **Goal:** Start from a `SPEC.md` and pre-written failing `pytest` contract tests (`Red` state: `1 passed, 4 failed`), clarify edge cases via `/grill-me`, lock the task breakdown via `/plan`, and self-heal to `Green`.

#### Step 1: Reset & Show the Failing Contract Suite (`Red` State)
* **Where to run:** Workstation Terminal (`demo7-contract-spec-tdd/`)
* **Commands:**
```bash
cd demo7-contract-spec-tdd
./start_demo.sh
cd workspace
pytest
```
* **Highlight:** `tests/test_reservator.py` fails 4 contract tests (`AC-1` expired hold reclamation, `AC-2` atomic multi-SKU rollback, `AC-3` idempotent `reservation_id` replay, `AC-4` non-positive quantity validation).

#### Step 2: Clarify Edge Cases with `/grill-me` & Lock Plan with `/plan`
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo7-contract-spec-tdd/workspace/`
* **Prompts:**
```text
/grill-me Review @SPEC.md and tests/test_reservator.py. Ask me about any edge cases before we lock the implementation plan.
```
```text
/plan Write the implementation plan and task breakdown to .scratch/reservation-plan.md
```

#### Step 3: Autonomous Act $\rightarrow$ Verify Test-Heal Loop
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo7-contract-spec-tdd/workspace/`
* **Prompt:**
```text
/goal Implement .scratch/reservation-plan.md in src/inventoryservice/reservator.py and self-heal until pytest passes 100%.
```

---

### Demo 8: Graph Planning & Multi-Agent `/teamwork` Monolith Refactoring (`demo8-teamwork-monolith-refactor`)
* **Goal:** Decompose a 220-line monolithic Online Boutique Order Processor (`src/order_app/monolith_order_app.py`) into `models.py`, `repositories.py`, `services.py`, and `routes.py` using **Graph Planning** (`@architect` + `@fast-scout`) and **`/teamwork`** (`👥 Teamwork`) parallel `@coder` execution.

#### Step 1: Reset & Verify Monolith Baseline (`4 passed`)
* **Where to run:** Workstation Terminal (`demo8-teamwork-monolith-refactor/`)
* **Commands:**
```bash
cd demo8-teamwork-monolith-refactor
./start_demo.sh
cd workspace
pytest
```
* **Files to highlight in editor:**
  * `workspace/.agents/agents/architect.md` (Graph Planner persona)
  * `workspace/.agents/agents/fast-scout.md` (Flash AST Scout persona using `ast-graph` MCP)
  * `workspace/.agents/agents/coder.md` (Modular implementation persona)

#### Step 2: Graph Planning (`@architect` + `@fast-scout` $\rightarrow$ `.scratch/refactor-dag.md`)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Prompt:**
```text
/plan Use @architect and @fast-scout to inspect src/order_app/monolith_order_app.py via the ast-graph MCP tools and generate a 3-stage dependency graph (DAG) in .scratch/refactor-dag.md with non-overlapping file ownership.
```
* **Highlight:** Show the 3-stage DAG in `.scratch/refactor-dag.md`: Stage 1 extracts `models.py`; Stage 2 runs two `@coder` subagents **in parallel** on disjoint files (`repositories.py` and `services.py`); Stage 3 rewires `routes.py` and `monolith_order_app.py`.

#### Step 3: Execute Parallel Multi-Agent Refactor via `/teamwork` (`👥 Teamwork`)
* **Where to run:** Antigravity 2.0 (`👥 Teamwork`) or `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Prompt:**
```text
/teamwork Execute .scratch/refactor-dag.md using @coder subagents in parallel across Stage 2 (repositories.py and services.py), then rewire routes.py and monolith_order_app.py and verify pytest passes in a clean context.
```

---

### Demo 9: Clean-Context Adversarial Review Loop (`demo9-adversarial-review-loop`)
* **Goal:** Demonstrate why passing unit tests (`4 passed` — "False Green") are not enough, and how a clean-context **`@adversarial-reviewer`** subagent catches 3 subtle security, resiliency, and outbox ordering regressions against `@DESIGN.md` before human code review.

#### Step 1: Reset & Show the "False-Green" Test Suite (`4 passed`)
* **Where to run:** Workstation Terminal (`demo9-adversarial-review-loop/`)
* **Commands:**
```bash
cd demo9-adversarial-review-loop
./start_demo.sh
cd workspace
pytest
```
* **Highlight:** `pytest` passes 100% (`4 passed`), giving the author a false sense of security.

#### Step 2: Run the Clean-Context `@adversarial-reviewer` Subagent
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo9-adversarial-review-loop/workspace/`
* **Prompt:**
```text
Invoke @adversarial-reviewer to audit src/settlement/dispatcher.py and tests/test_dispatcher.py against @DESIGN.md and produce a falsifiable file:line invariant table.
```
* **What to watch on screen:**
  `@adversarial-reviewer` inspects `src/settlement/dispatcher.py` with zero authoring bias and flags **3 `FAIL` rows** in its falsifiable invariant table:
  1. **§1 Resiliency (`FAIL` at `dispatcher.py:85`):** Linear `self.sleep_fn(self.base_delay_sec)` instead of exponential backoff with full randomized jitter.
  2. **§2 Security (`FAIL` at `dispatcher.py:55`):** `provided_signature != expected` instead of constant-time `hmac.compare_digest()`.
  3. **§3 Idempotency / Outbox (`FAIL` at `dispatcher.py:78-98`):** Invokes external `self.webhook_client(event)` *before* recording the idempotency state in `settlement_ledger`.

#### Step 3: Remediate All 3 Findings & Re-Verify
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo9-adversarial-review-loop/workspace/`
* **Prompt:**
```text
/boost Fix all FAIL findings identified by @adversarial-reviewer in src/settlement/dispatcher.py, add regression tests in tests/test_dispatcher.py, and re-run @adversarial-reviewer to confirm 100% PASS.
```
