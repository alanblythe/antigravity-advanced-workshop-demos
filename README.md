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
├── start_demo.sh           # Deterministic workspace reset script
├── .seed/                  # Pristine seed template restored by start_demo.sh
└── workspace/              # 🎯 Dedicated Agent Execution Surface
    ├── AGENTS.md           # Local domain constitution & standards
    ├── src/                # Brownfield source code under development
    ├── tests/              # Contract tests / verification suite
    └── .agents/            # Path-scoped rules & custom subagent definitions
```

* **Presenter Harness (`demoX/`):** Contains the demo's `README.md`, `.seed/` pristine assets, and the `./start_demo.sh` reset engine.
* **Agent Execution Surface (`demoX/workspace/`):** The isolated working directory where the presenter/student executes `pytest`, launches `agy`, and where coding subagents write code and run test loops.

---

## Presenter Runbook & Step-by-Step Instructions

For exact command blocks, where to execute them (IDE vs. TUI vs. terminal), and what to highlight on screen during live presentation, see:

👉 **[DEMO_STEPS.md](./DEMO_STEPS.md)** — *The complete presenter flight plan.*

---

## Directory Overview

* **[`demo1-enterprise-surface/`](./demo1-enterprise-surface/)**: Enterprise authentication scripts, Linux Foundation AAIF open standards setup (`AGENTS.md`, `.agents/rules/`, `.agents/skills/`), and AST code-graph navigation.
* **[`demo2-spec-driven-sdlc/`](./demo2-spec-driven-sdlc/)**: Python reconciliation service with a seeded failure, spec drafting template, worktree-instructed subagent, and adversarial reviewer subagent.
* **[`demo3-database-guardrails/`](./demo3-database-guardrails/)**: Database MCP Toolbox configuration (`tools.yaml`), BigQuery telemetry schema, read-only query templates, and negative security testing configurations.
* **[`demo4-cloud-agent-platform/`](./demo4-cloud-agent-platform/)**: Containerized ADK agent (`bq-telemetry-agent`), Dockerfile bundling MCP Toolbox, `agents-cli deploy` scripts, and local Antigravity subagent definition calling the deployed cloud agent over A2A.
* **[`demo5-egm-architecture-rfc/`](./demo5-egm-architecture-rfc/)**: Open-source **Elephant-Goldfish Model (`egm`)** plugin demonstration (`/egm-brainstorm`), pitting a deep-context Elephant session against 6 parallel zero-context Goldfish subagents to stress-test a flawed checkout webhook proposal and publish an RFC (`concepts_brief.md` $\rightarrow$ `docs/designs/`).
* **[`demo6-linked-design-boost/`](./demo6-linked-design-boost/)**: Online Boutique **Order Discount & Promo Engine** demonstrating `AGENTS.md` linking to long-lived architectural guardrails in `@docs/adr/0001-decimal-currency-and-discount-caps.md`, path-scoped `.agents/rules/discount-invariants.md`, a single-conversation feature specification (`@docs/specs/0001-stacked-promo-engine.md`), and autonomous **`⚡ Boost`** (`/boost`) execution.
* **[`demo7-contract-spec-tdd/`](./demo7-contract-spec-tdd/)**: Online Boutique **Cart Inventory Reservation Service** starting with a pre-written failing 5-test contract suite (`Red` state) and `docs/specs/0001-stock-reservation-holds.md` edge cases, driving `/grill-me` clarification, `/plan` task breakdown, and an autonomous **Act $\rightarrow$ Verify** test-heal loop (`Green` state).
* **[`demo8-teamwork-monolith-refactor/`](./demo8-teamwork-monolith-refactor/)**: Online Boutique **Monolith Order Processor** (`monolith_order_app.py`) decomposed into `models.py`, `repositories.py`, `services.py`, and `routes.py` using `@fast-scout` (`ast-graph` MCP), `@architect` **Graph Planning** (`.scratch/refactor-dag.md`), and parallel **`/teamwork`** (`👥 Teamwork`) execution across `@coder` subagents.
* **[`demo9-adversarial-review-loop/`](./demo9-adversarial-review-loop/)**: Online Boutique **Payment Webhook & Settlement Dispatcher** in a "False-Green" state (`pytest` passes 100%, but 3 seeded security/resiliency/outbox regressions violate `@docs/adr/0001-payment-webhook-and-settlement-guardrails.md`), audited by a clean-context **`@adversarial-reviewer`** subagent that outputs a production guardrail table with `file:line` proof before human PR review.

---

## Prerequisites

1. **Operating System:** macOS 14+ (Sonoma/Sequoia) with Zsh (`/bin/zsh`).
2. **Antigravity CLI (`agy`):** Version 1.0+ logged in via enterprise Google Cloud credentials (`agy login`).
3. **VS Code / Antigravity 2.0:** Installed and signed in (`Use business account`).
4. **Google Cloud SDK (`gcloud`):** Authenticated with project access (`gcloud auth application-default login`).
5. **Python 3.11+:** With `uv`, `pytest`, and `ruff` installed (`pip install uv pytest ruff`).
6. **Database MCP Toolbox (`toolbox`):** Installed via `./scripts/install_toolbox.sh` (for Demos 3 & 4).
