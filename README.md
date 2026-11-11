# Advanced Antigravity Developer Workshop — Demonstration Workbench

> [!IMPORTANT]
> **Disclaimer:** I work for Google, but this is a personal open-source repository licensed under [Apache-2.0](LICENSE). This is not an officially supported Google product, and it is provided as-is without warranty.
>
> **Supported Platform: macOS Only**  
> This workbench, including its VS Code integrated terminal profiles, automated reset tasks, and presenter flight paths, is tested and supported exclusively on **macOS** (Apple Silicon / Intel). Linux and Windows (WSL) environments are currently unsupported out of the box, though the underlying scripts and runtimes are largely platform-agnostic and can be adapted with minimal effort (e.g., adding Linux VS Code terminal profiles and ensuring Zsh availability).

> **Live Technical Enablement & Presenter Repository**  
> Complete runnable source code, configurations, subagents, and step-by-step presenter runbook for the **Advanced Antigravity Developer Workshop** and **Antigravity 201: Spec-Driven Development & Multi-Agent Workflows**.

---

## What This Repository Is

This repository contains the end-to-end, runnable demonstration artifacts used during the **Advanced Antigravity Developer Workshop** (Modules 1–5) and the 60-minute **Antigravity 201: Spec-Driven Development & Multi-Agent Workflows** track (Demos 6–9). Designed for enterprise Centers of Excellence (COE), software architects, and senior engineering advocates, it bridges the gap between local workstation developer workflows (**The Inner Loop**) and governed enterprise cloud execution (**The Outer Loop**).

Every demo is self-contained in its respective directory, complete with realistic configs, brownfield source code, negative security test cases, deterministic `./start_demo.sh` reset scripts, and authentic terminal commands.

---

## Workshop & 201 Track Architecture

```
TRACK A: 3-HOUR ADVANCED DEVELOPER WORKSHOP (Demos 1–5)
├── demo1-enterprise-surface/
│   ├── Demo 1A: Enterprise Auth & Workspace Harmonization (AAIF Standards, AGENTS.md, symlinks)
│   └── Demo 1B: Large-Repo Context Hygiene (AST Code Graph, graphify-mcp, Model Tier Routing)
├── demo5-egm-architecture-rfc/
│   └── Demo 5: Elephant-Goldfish Model (EGM) — Multi-Lens Ideation & Zero-Context RFC Stress-Testing (/egm-brainstorm)
├── demo2-spec-driven-sdlc/
│   ├── Demo 2A: Spec-Driven Planning (/grill-me & /plan -> .scratch/reconcile-plan.md)
│   ├── Demo 2B: Subagent Isolation via Git Worktrees & Test-Heal Loop (/goal -> pytest -> ruff)
│   ├── Demo 2C: Antigravity 2.0 Browser Subagent E2E DOM Verification (@browser -> localhost:8000)
│   └── Demo 2D: Immediate Multi-Model Adversarial PR Audit (@spec-adversary / Claude 3.5 Sonnet vs. AGENTS.md invariants)
├── demo3-database-guardrails/
│   └── Demo 3: Live Database MCP Toolbox Addition & Safe Querying (BigQuery schema & blocked DROP TABLE)
└── demo4-cloud-agent-platform/
    └── Demo 4: Local Antigravity Calling Deployed Cloud Agent via Agent-to-Agent (A2A) (@cloud-telemetry-agent)

TRACK B: ANTIGRAVITY 201 — SPEC-DRIVEN SDLC & MULTI-AGENT WORKFLOWS (Demos 6–9 | 60-Min Session)
├── demo6-linked-design-boost/
│   └── Demo 6: Grounding Specs, Linked ADRs, Path-Scoped Rules & ⚡ Boost (/boost)
├── demo7-contract-spec-tdd/
│   └── Demo 7: Contract-First Spec Clarification (/grill-me -> /plan) & Autonomous Test-Heal Loop (Red -> Green)
├── demo8-teamwork-monolith-refactor/
│   └── Demo 8: Graph Planning (@architect + @fast-scout DAG) & Parallel /teamwork Monolith Decomposition
└── demo9-adversarial-review-loop/
    └── Demo 9: Clean-Context Adversarial Review Loop (@adversarial-reviewer) Catching Seeded Regressions
```

---

### Harness vs. Workspace Execution Architecture

To prevent coding agents from cheating or suffering prompt dilution by discovering presenter cheat sheets, defect notes, or runbooks (`DEMO_STEPS.md`), every demo directory enforces a two-tier boundary:

```
demoX-.../
├── README.md               # Presenter & student guide (harness level)
├── DEMO_STEPS.md           # Dedicated step-by-step presenter flight plan
├── start_demo.sh           # Deterministic workspace reset script
├── .seed/                  # Pristine seed template restored by start_demo.sh
└── workspace/              # 🎯 Dedicated Agent Execution Surface
    ├── AGENTS.md           # Local domain constitution & standards
    ├── src/                # Brownfield source code under development
    ├── tests/              # Contract tests / verification suite
    └── .agents/            # Path-scoped rules & custom subagent definitions
```

* **Presenter Harness (`demoX/`):** Contains the demo's `README.md`, `DEMO_STEPS.md`, `.seed/` pristine assets, and the `./start_demo.sh` reset engine.
* **Agent Execution Surface (`demoX/workspace/`):** The isolated working directory where the presenter/student executes `pytest`, launches `agy`, and where coding subagents write code and run test loops.

---

## Demo Launch & Reset

Every demo follows an identical sub-second deterministic reset pattern:

* **Via VS Code Tasks (Recommended):**  
  Open the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`) $\rightarrow$ select **`Tasks: Run Task`** $\rightarrow$ choose **`Reset & Open: Demo <N>`** (e.g., `Reset & Open: Demo 1`). This restores `workspace/` from `.seed/` in <1s and opens a dedicated terminal running `agy` directly inside `workspace/`.

* **Via Terminal CLI from Repo Root:**
  ```bash
  ./start_demo.sh <N>     # Reset a specific demo (1-9)
  ./start_demo.sh 201     # Reset all 4 Antigravity 201 demos (Demos 6-9)
  ./start_demo.sh all     # Reset all 9 workshop demos
  ```

* **Via Terminal CLI from Demo Directory:**
  ```bash
  cd demo<N>-<name> && ./start_demo.sh && cd workspace && agy
  ```

---

## Demonstrations & Presenter Runbooks

For global timing allocations, session flow notes, and workshop credential setup, see the master runbook:  
👉 **[DEMO_STEPS.md](./DEMO_STEPS.md)** — *The master facilitator flight plan & global timings.*

Each demo provides its own dedicated step-by-step presenter runbook linked in the table below:

| Demo | Focus & Key Concepts | Track | Presenter Steps |
|:---:|---|:---:|---|
| **Demo 1** | [Enterprise Surface & Workspace Harmonization](./demo1-enterprise-surface/)<br>• Linux Foundation AAIF (`AGENTS.md`) & cross-tool rule harmonization<br>• AST code-graph navigation & model tier routing | Track A<br>*(Module 1)* | [demo1-enterprise-surface/DEMO_STEPS.md](./demo1-enterprise-surface/DEMO_STEPS.md) |
| **Demo 2** | [Spec-Driven SDLC & Multi-Model Review](./demo2-spec-driven-sdlc/)<br>• `/grill-me` interview & `/plan` specification lock<br>• Subagent worktree isolation & autonomous test healing<br>• Agent browser DOM & console verification<br>• Adversarial diff audit with Claude 3.5 Sonnet | Track A<br>*(Module 2)* | [demo2-spec-driven-sdlc/DEMO_STEPS.md](./demo2-spec-driven-sdlc/DEMO_STEPS.md) |
| **Demo 3** | [Database MCP Toolbox & Guardrails](./demo3-database-guardrails/)<br>• Repository-scoped MCP Toolbox (`tools.yaml`)<br>• BigQuery telemetry & blocked `DROP TABLE` negative test | Track A<br>*(Module 3)* | [demo3-database-guardrails/DEMO_STEPS.md](./demo3-database-guardrails/DEMO_STEPS.md) |
| **Demo 4** | [Cloud Agent Platform & A2A Collaboration](./demo4-cloud-agent-platform/)<br>• Containerized ADK agent deployment (`agents-cli deploy`)<br>• Local Antigravity invoking deployed cloud agent via A2A | Track A<br>*(Module 4)* | [demo4-cloud-agent-platform/DEMO_STEPS.md](./demo4-cloud-agent-platform/DEMO_STEPS.md) |
| **Demo 5** | [Elephant-Goldfish Model (EGM) RFC Ideation](./demo5-egm-architecture-rfc/)<br>• Deep-context Elephant ideation (`/egm-brainstorm`)<br>• 6 parallel zero-context Goldfish review lenses & RFC publish | Track A<br>*(Module 5)* | [demo5-egm-architecture-rfc/DEMO_STEPS.md](./demo5-egm-architecture-rfc/DEMO_STEPS.md) |
| **Demo 6** | [Grounding Specs, Linked ADRs & Boost](./demo6-linked-design-boost/)<br>• Three-tier context hierarchy (`AGENTS.md` $\rightarrow$ `docs/adr/` + `docs/specs/`)<br>• Autonomous `⚡ Boost` (`/boost`) execution | Track B<br>*(201)* | [demo6-linked-design-boost/DEMO_STEPS.md](./demo6-linked-design-boost/DEMO_STEPS.md) |
| **Demo 7** | [Contract-First Spec Clarification & TDD](./demo7-contract-spec-tdd/)<br>• Red-to-green contract suite<br>• `/grill-me` clarification, `/plan`, and autonomous test-heal loop | Track B<br>*(201)* | [demo7-contract-spec-tdd/DEMO_STEPS.md](./demo7-contract-spec-tdd/DEMO_STEPS.md) |
| **Demo 8** | [Graph Planning & Parallel Teamwork Refactoring](./demo8-teamwork-monolith-refactor/)<br>• `@architect` DAG planning (`.scratch/refactor-dag.md`)<br>• Multi-agent `/teamwork` monolith decomposition | Track B<br>*(201)* | [demo8-teamwork-monolith-refactor/DEMO_STEPS.md](./demo8-teamwork-monolith-refactor/DEMO_STEPS.md) |
| **Demo 9** | [Clean-Context Adversarial Review Loop](./demo9-adversarial-review-loop/)<br>• Auditing "False-Green" test suite<br>• Catching seeded ADR regressions with clean `@adversarial-reviewer` | Track B<br>*(201)* | [demo9-adversarial-review-loop/DEMO_STEPS.md](./demo9-adversarial-review-loop/DEMO_STEPS.md) |

---

## Prerequisites

1. **Operating System:** macOS 14+ (Sonoma/Sequoia) with Zsh (`/bin/zsh`).
2. **Antigravity CLI (`agy`):** Version 1.0+ logged in via enterprise Google Cloud credentials (`agy login`).
3. **VS Code / Antigravity 2.0:** Installed and signed in (`Use business account`).
4. **Google Cloud SDK (`gcloud`):** Authenticated with project access (`gcloud auth application-default login`).
5. **Python 3.11+:** With `uv`, `pytest`, and `ruff` installed (`pip install uv pytest ruff`).
6. **Database MCP Toolbox (`toolbox`):** Installed via `./scripts/install_toolbox.sh` (for Demos 3 & 4).
