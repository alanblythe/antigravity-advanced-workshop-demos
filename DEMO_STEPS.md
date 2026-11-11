# Presenter Runbook — Master Facilitator Flight Plan (Pattern A)

> **Flight Plan for Instructor & Presenter**  
> Master session orchestration, environment setup, and global timings across all workshop modules (Demos 1–5) and the **Antigravity 201: Spec-Driven Development & Multi-Agent Workflows** track (Demos 6–9).  
> **Pattern A Architecture:** Host IDE & native Antigravity 2.0 UI backed by sub-second deterministic resets (`./start_demo.sh`).  
> *Detailed step-by-step commands, prompts, and screen highlights are located in each demo's dedicated `DEMO_STEPS.md` linked below.*

---

## Master Demo Reset & Workspace Launch (Pattern A)

Each demo can be reset and launched in a single step using the VS Code Command Palette (**`Tasks: Run Task`** $\rightarrow$ **`Reset & Open: Demo 1`** through **`Reset & Open: Demo 9`**), which resets the demo workspace to `.seed/` and opens a dedicated terminal running `agy` inside `workspace/`.

Or, before starting a session, reset demo folders from the root terminal:

```bash
# Reset all 9 demos (Demos 1-9):
./start_demo.sh all

# Or reset only the 4 Antigravity 201 demos (Demos 6-9):
./start_demo.sh 201

# Or reset a single demo:
./start_demo.sh <1-9>
```
* **Expected Result:** Target demo workspaces reset to `.seed/` state with 0 untracked git diffs in <1s.

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

## Track A: 3-Hour Advanced Developer Workshop (Demos 1–5)

### [Module 1: Enterprise Surface, Standards & Context Hygiene](./demo1-enterprise-surface/DEMO_STEPS.md) *(~15 mins total)*
* 👉 **[Open Demo 1 Presenter Flight Plan](./demo1-enterprise-surface/DEMO_STEPS.md)**
* **Demo 1A: Enterprise Auth & Workspace Standardization (~8 mins):** Demonstrating enterprise SSO vs. consumer IDE login, CLI authentication, and automated multi-tool rule harmonization (`scripts/standardize.py` merging Cursor/Claude rules into Linux Foundation `AGENTS.md` with symlinks).
* **Demo 1B: AST Code Graph & Model Routing (~7 mins):** Navigating multi-thousand-line codebases with AST symbol graphs (`ast-graph` MCP) in <2k tokens, plus switching model tiers (`/models`) between `gemini-2.5-flash` and `gemini-2.5-pro`.

### [Module 2: Spec-Driven Coding, Git Worktrees, Browser Subagent & Multi-Model Review](./demo2-spec-driven-sdlc/DEMO_STEPS.md) *(~35 mins total)*
* 👉 **[Open Demo 2 Presenter Flight Plan](./demo2-spec-driven-sdlc/DEMO_STEPS.md)**
* **Demo 2A: Spec Drafting, Artifact Comments & Plan Lock (~10 mins):** Path-scoped progressive disclosure (`.agents/rules/`), edge-case interview via `/grill-me`, `/plan` artifact generation, and human-in-the-loop inline artifact commenting to steer architectural invariants into `.scratch/reconcile-plan.md`.
* **Demo 2B: Subagent Worktree Isolation & Test-Heal Loop (~10 mins):** Delegating the locked plan via `/goal` to an isolated `@worktree-implementer` subagent in `.worktrees/feat-reconcile`, fixing seeded `KeyError`, and passing `pytest`.
* **Demo 2C: Antigravity 2.0 Browser Subagent E2E DOM Verification (~7 mins):** Verifying the live local web dashboard via `@browser`, asserting DOM status `#settlement-status == 'SETTLED'`, checking console logs for 0 errors, and capturing visual verification artifacts.
* **Demo 2D: Immediate Multi-Model Adversarial PR Audit (~8 mins):** Running `@spec-adversary` (Claude 3.5 Sonnet on Vertex AI) against the worktree diff to catch subtle invariant flaws (`time.sleep` linear backoff violating exponential backoff policies) before PR merge.

### [Module 3: Enterprise Data Guardrails & Admin Governance](./demo3-database-guardrails/DEMO_STEPS.md) *(~12 mins total)*
* 👉 **[Open Demo 3 Presenter Flight Plan](./demo3-database-guardrails/DEMO_STEPS.md)**
* **Demo 3: Live Database MCP Toolbox Addition & Safe Querying (~12 mins):** Declarative repository-scoped MCP configuration (`workspace/.mcp.json`, `tools.yaml`), safe read-only BigQuery schema inspection and aggregation queries, negative security testing (IAM/MCP boundary blocking destructive `DROP TABLE`), and central admin policy enforcement (`.gemini/settings.json`).

### [Module 4: Production Cloud Agent Platform & A2A Collaboration](./demo4-cloud-agent-platform/DEMO_STEPS.md) *(~12 mins total)*
* 👉 **[Open Demo 4 Presenter Flight Plan](./demo4-cloud-agent-platform/DEMO_STEPS.md)**
* **Demo 4: Local Antigravity Calling Deployed Cloud Agent via A2A (~12 mins):** Inspecting the open A2A Agent Card (`agent-card.json`), walking through the containerized ADK deployment recipe (`Dockerfile` + `agents-cli deploy`), and invoking the deployed Google Cloud agent (`@cloud-telemetry-agent`) directly from local Antigravity.

### [Module 5: Multi-Lens Architecture Ideation & Zero-Context RFC Stress-Testing (EGM)](./demo5-egm-architecture-rfc/DEMO_STEPS.md) *(~15 mins total)*
* 👉 **[Open Demo 5 Presenter Flight Plan](./demo5-egm-architecture-rfc/DEMO_STEPS.md)**
* **Demo 5: Elephant-Goldfish Model (`/egm-brainstorm`) (~15 mins):** Installing the open-source EGM plugin, pitching a "half-baked" currency conversion proposal to the non-sycophantic Elephant session, triggering a 6-lens parallel zero-context Goldfish swarm to attack the proposal, and publishing a formal RFC (`docs/designs/`).

---

## Track B: Antigravity 201 — Spec-Driven SDLC & Multi-Agent Workflows (Demos 6–9 | 45–50 Min Session)

### Suggested Presentation Order & Timing

> **Optimized Presentation Sequence: 7 $\rightarrow$ 6 $\rightarrow$ 8 (kickoff) $\rightarrow$ 9 (during 8's refactor) $\rightarrow$ 8 (finale)**  
> Total wall-clock runtime: **~42–45 minutes** (safely fitting within a 50-minute slot with buffer for live Q&A).

1. **[Demo 7: Contract-First Spec Clarification & Test-Heal Loop](./demo7-contract-spec-tdd/DEMO_STEPS.md)** — **~10 mins**  
   *Pre-written failing contract test suite (`Red` state) $\rightarrow$ `/grill-me` clarification $\rightarrow$ `/plan` task breakdown $\rightarrow$ autonomous test-heal loop (`Green` state).*
2. **[Demo 6: Grounding Specs, Linked ADRs & `⚡ Boost`](./demo6-linked-design-boost/DEMO_STEPS.md)** — **~9 mins**  
   *Three-tier context hierarchy (`AGENTS.md` entry point $\rightarrow$ long-lived `docs/adr/` guardrails + single-conversation `docs/specs/` + path-scoped rules) $\rightarrow$ autonomous `/boost` execution from a single-sentence prompt.*
3. **[Demo 8 Kickoff: Graph Planning & Launch `/teamwork`](./demo8-teamwork-monolith-refactor/DEMO_STEPS.md)** — **~8 mins**  
   *Monolith baseline verification $\rightarrow$ `@architect` + `@fast-scout` AST Graph Planning (`refactor-dag.md`) $\rightarrow$ launch parallel `/teamwork` across `@coder` subagents.*
4. **[Demo 9: Clean-Context Adversarial Review Loop](./demo9-adversarial-review-loop/DEMO_STEPS.md)** — **~10 mins**  
   *(Run concurrently while Demo 8's parallel `@coder` workers execute in background)*  
   *Auditing "False-Green" passing test suites against ADR guardrails with `@adversarial-reviewer` $\rightarrow$ catching seeded regressions $\rightarrow$ `/boost` remediation.*
5. **[Demo 8 Finale: Monolith Refactor Completion & Clean Verification](./demo8-teamwork-monolith-refactor/DEMO_STEPS.md#step-4-return-to-demo-8-for-finale--verification)** — **~3 mins**  
   *Return to Demo 8 terminal: inspect decomposed modular architecture (`models.py`, `repositories.py`, `services.py`, `routes.py`), verify re-export facade, and confirm green `pytest`.*
