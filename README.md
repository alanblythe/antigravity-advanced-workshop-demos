# Advanced Antigravity Developer Workshop — Demonstration Workbench

> **Live Technical Enablement & Presenter Repository**  
> Complete runnable source code, configurations, subagents, and step-by-step presenter runbook for the **Advanced Antigravity Developer Workshop**.

---

## What This Repository Is

This repository contains the end-to-end, runnable demonstration artifacts used during the 3-hour **Advanced Antigravity Developer Workshop**. Designed for enterprise Centers of Excellence (COE), software architects, and senior engineering advocates, it bridges the gap between local workstation developer workflows (**The Inner Loop**) and governed enterprise cloud execution (**The Outer Loop**).

Every demo is self-contained in its respective directory, complete with realistic configs, brownfield source code, negative security test cases, and authentic terminal commands.

---

## 5-Module Workshop Architecture

The workshop follows a progressive **Inner Loop $\rightarrow$ Outer Loop** delivery:

```
PART 1: THE DEVELOPER INNER LOOP (Modules 1, 2 & 5 | 0:00 – 1:45)
├── demo1-enterprise-surface/
│   ├── Demo 1A: Enterprise Auth & Workspace Harmonization (AAIF Standards, AGENTS.md, symlinks)
│   └── Demo 1B: Large-Repo Context Hygiene (AST Code Graph, graphify-mcp, Model Tier Routing)
├── demo5-egm-architecture-rfc/
│   └── Demo 5: Elephant-Goldfish Model (EGM) — Multi-Lens Ideation & Zero-Context RFC Stress-Testing (/egm-brainstorm)
└── demo2-spec-driven-sdlc/
    ├── Demo 2A: Spec-Driven Planning (/grill-me & /plan -> .scratch/reconcile-plan.md)
    ├── Demo 2B: Subagent Isolation via Git Worktrees & Test-Heal Loop (/goal -> pytest -> ruff)
    └── Demo 2C: Immediate Multi-Model Adversarial PR Audit (staff-reviewer vs. AGENTS.md invariants)

☕ MIDPOINT BREAK (1:45 – 1:55)

PART 2: ENTERPRISE PLATFORM & PRODUCTION (Modules 3 & 4 | 1:55 – 3:00)
├── demo3-database-guardrails/
│   ├── Demo 3: Live Database MCP Toolbox Addition & Safe Querying (BigQuery schema & blocked DROP TABLE)
│   └── Admin Governance: Centralized settings.json allowlists & container sandboxing
└── demo4-cloud-agent-platform/
    ├── Cloud Agent Architecture: Local ADK bq-telemetry-agent to Gemini Enterprise Agent Platform (GEAP)
    ├── Demo 4: Local Antigravity Calling Deployed Cloud Agent via Agent-to-Agent (A2A) (@cloud-telemetry-agent)
    └── Leave-Behind Lab: Onboarding to self-paced asynchronous learning repository
```

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

---

## Prerequisites

1. **Antigravity CLI (`agy`):** Version 1.0+ logged in via enterprise Google Cloud credentials (`agy login`).
2. **VS Code:** With the official **Antigravity** extension installed (`Use business account`).
3. **Google Cloud SDK (`gcloud`):** Authenticated with project access (`gcloud auth application-default login`).
4. **Python 3.11+:** With `pytest` and `ruff` installed (`pip install pytest ruff`).
5. **Database MCP Toolbox (`toolbox`):** Installed via `./scripts/install_toolbox.sh` (or accessible on `$PATH`).
