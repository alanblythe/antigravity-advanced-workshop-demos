# Elephant-Goldfish Model (EGM) — End-to-End Lifecycle & Skill Architecture

> **Design with an Elephant (full project context). Review with a Goldfish (zero conversation context).**  
> Reference overview of how all **7 EGM skills**, **9 subagent personas**, **3 roles (Human, Elephant, Goldfish)**, and **checked-in artifacts** fit together across the software engineering lifecycle.

---

## 1. Unified Process Across All 7 EGM Skills

```mermaid
flowchart TD
    subgraph Prep["0. Codebase Context (Brownfield Onboarding)"]
        Boot["/egm-bootstrap<br/>(Bottom-Up Recursive Summarizer)"]
        Readmes[("Hierarchy of<br/>Directory README.md")]
        Boot --> Readmes
    end

    subgraph Ideation["1. Upstream Ideation (Elephant + 6 Goldfishes)"]
        Brainstorm["/egm-brainstorm<br/>(Elephant Open-Ended Drilling)"]
        Gate1{"Human Readiness<br/>Gate"}
        Swarm1["egm-synthesizer +<br/>6 Zero-Context Goldfish Lenses"]
        Brief[("concepts_brief.md")]

        Brainstorm --> Gate1
        Gate1 -- "Review with Goldfishes" --> Swarm1
        Swarm1 --> Brief
    end

    subgraph Authoring["2. Specification Drafting (Elephant + Human)"]
        Draft["/egm-draft<br/>(Section-by-Section Compiler)"]
        Spec[("docs/designs/FEATURE.md<br/>+ SITEMAP.md")]
        Brief --> Draft
        Readmes -. "Deep Context" .-> Brainstorm
        Readmes -. "Deep Context" .-> Draft
        Draft --> Spec
    end

    subgraph Verification["3. Zero-Context Verification & Resolution (Goldfishes + Human)"]
        Review["/egm-review<br/>(5-Stage Audit Pipeline)"]
        ReviewLoop["/egm-review-loop<br/>(Parallel A/B Goldfish Dispatcher)"]
        Report[("goldfish_review_report.md<br/>(Blocker / Major / Nit)")]
        Resolve["/egm-resolve<br/>(Interactive Triage & Patching)"]

        Spec --> Review
        Review --> ReviewLoop
        ReviewLoop --> Report
        Report --> Resolve
        Resolve -- "Updates Spec" --> Spec
    end

    subgraph Execution["4. Implementation & Living Maintenance"]
        Impl["Coding Agent / Worktree<br/>(Builds Against Approved Spec)"]
        Code[("Production Codebase")]
        Drift["/egm-drift-report<br/>(Weekly Spec vs. Code Audit)"]

        Spec -- "Human PR Approval" --> Impl
        Impl --> Code
        Code --> Drift
        Spec --> Drift
        Drift -. "Reconcile Doc or Code" .-> Spec
    end
```

---

## 2. How the 7 Skills Map to the Lifecycle

| Stage | Skill | Active Role(s) | Input $\rightarrow$ Output Artifact | When to Use |
| :--- | :--- | :--- | :--- | :--- |
| **0. Context Setup** | `/egm-bootstrap` | Elephant + `egm-bootstrap-orchestrator` | Source tree $\rightarrow$ Bottom-up `README.md` hierarchy | Onboarding an existing brownfield repository so the Elephant can navigate architecture cheaply. |
| **1. Ideation** | `/egm-brainstorm` | Elephant + `egm-synthesizer` + 6 Goldfish Lenses | Raw feature idea $\rightarrow$ `concepts_brief.md` (or RFC in `docs/designs/`) | Stress-testing a "half-baked" idea before investing in a full design specification. |
| **2. Spec Drafting** | `/egm-draft` | Elephant + Human Checkpoints | `concepts_brief.md` $\rightarrow$ `docs/designs/<feature>.md` + `SITEMAP.md` | Turning an agreed concept brief into a formal design specification, section by section. |
| **3a. Full Audit** | `/egm-review` | 5-Stage Goldfish Pipeline | `docs/designs/<feature>.md` $\rightarrow$ `goldfish_review_report.md` | Running the full 5-stage zero-context audit (Zoom Out $\rightarrow$ Comprehension $\rightarrow$ Critic $\rightarrow$ Zoom Out $\rightarrow$ Readiness). |
| **3b. Targeted Audit** | `/egm-review-loop` | `egm-synthesizer` + Selected Goldfishes (A/B) | Specific file/line range $\rightarrow$ `goldfish_review_report.md` | Running a specific subset of Goldfish reviewers on a targeted section or document. |
| **4. Triage & Fix** | `/egm-resolve` | Human + Elephant | `goldfish_review_report.md` $\rightarrow$ Patched `docs/designs/<feature>.md` | Stepping through Blocker/Major/Nit findings interactively and applying approved edits. |
| **5. Maintenance** | `/egm-drift-report` | Drift Auditor | Checked-in `docs/designs/*.md` + live source tree $\rightarrow$ Drift report | Periodic (e.g., weekly) audit to catch divergence between production code and design specs. |

---

## 3. Deep Dive: `/egm-brainstorm` Sequence (`Mode: BRAINSTORM`)

```mermaid
sequenceDiagram
    autonumber
    actor Human as Software Engineer
    participant Brainstorm as egm-brainstorm (Elephant)
    participant Synth as egm-synthesizer (Mode: BRAINSTORM)
    participant Swarm as 6-Lens Goldfish Swarm
    participant Artifact as concepts_brief.md

    Human->>Brainstorm: /egm-brainstorm (Raw Feature Idea)
    loop Multi-Turn Open-Ended Drilling
        Brainstorm->>Human: Probing questions (No Glazing / Critique First)
        Human->>Brainstorm: Clarifications, SLAs & constraints
    end
    Brainstorm->>Human: Readiness Checkpoint Gate (Anchored Hypothesis)
    Human->>Brainstorm: Select "Review with Goldfishes"
    Brainstorm->>Synth: invoke_subagent (Mode: BRAINSTORM, FeatureConcept)
    Synth->>Swarm: Parallel shootdown across 6 zero-context lenses
    Swarm-->>Synth: Raw critiques, YAGNI checks & codebase reuse hits
    Synth->>Artifact: write_to_file (concepts_brief.md)
    Synth-->>Brainstorm: send_message (Completion & artifact path)
    Brainstorm->>Human: Highlight top 2-3 objections & invite iteration
    Human->>Brainstorm: Handoff Gate -> Publish RFC or proceed to /egm-draft
```

---

## 4. Deep Dive: `/egm-review` 5-Stage Pipeline (`Mode: REVIEW`)

```mermaid
flowchart TD
    Start(["Target Design Doc (docs/designs/FEATURE.md)"]) --> Step5["Step 5: Zoom Out Review (egm-zoom-out)"]
    Step5 --> Gate5{"Pass / Abort?"}
    Gate5 -- "Abort" --> FixArch["Refactor High-Level Architecture"]
    Gate5 -- "Pass" --> Step6["Step 6: Comprehension Test (egm-comprehension)"]
    Step6 --> Gate6{"Gaps Found?"}
    Gate6 -- "Yes" --> UpdateContext["Clarify Definitions & Prerequisites"]
    Gate6 -- "No" --> Step7["Step 7: Critic Review (egm-design + egm-structural + egm-style)"]
    Step7 --> Resolve7["/egm-resolve (Triage & Patch)"]
    Resolve7 --> Step8["Step 8: Intermediate Zoom Out Check (egm-zoom-out)"]
    Step8 --> Gate8{"YAGNI / Defensive Bloat?"}
    Gate8 -- "Yes" --> PruneBloat["Prune Over-Engineering"]
    Gate8 -- "No / Resolved" --> Step9["Step 9: Implementation Readiness (egm-implementation-readiness + egm-codebase-details + egm-style)"]
    Step9 --> Resolve9["/egm-resolve (Final Triage)"]
    Resolve9 --> Done(["Ready for Human Peer Review & Coding Agent Implementation"])
```

---

## 5. The 9 Registered Agent Personas (`agents/`)

| Agent Name | Role in EGM | Context Mode | Primary Responsibility |
| :--- | :--- | :--- | :--- |
| `egm-synthesizer` | Swarm Compiler & Orchestrator | Intermediate Subagent | Spawns parallel Goldfish subagents, deduplicates findings, triages severity (🔴 Blocker, 🟡 Major, 🟢 Nit), and writes artifacts. |
| `egm-zoom-out` | Skeptical Architect | Zero-Context Goldfish | Enforces simplicity, YAGNI, high-level focus, and searches codebase for existing components to reuse. |
| `egm-design` | Hostile Design Critic | Zero-Context Goldfish | Challenges scalability, SPOFs, quota/token economics, latency budgets, and failure modes. |
| `egm-codebase-details` | Technical Quality Auditor | Zero-Context Goldfish | Verifies exact file paths, proto schemas, function signatures, and backward compatibility against live code. |
| `egm-comprehension` | Naive Reader | Zero-Context Goldfish | Audits documents with zero assumed institutional knowledge; flags undefined terms and ergonomic friction. |
| `egm-implementation-readiness` | Pragmatic Tech Lead | Zero-Context Goldfish | Verifies unambiguous execution instructions, observability/SRE telemetry, and testability. |
| `egm-structural` | Document Architect | Zero-Context Goldfish | Audits structural symmetry, long-term maintainability, Coupling/Tech Debt, and template compliance. |
| `egm-style` | Technical Copy Editor | Zero-Context Goldfish | Enforces plain English, strips promotional buzzwords/adverbs, and ensures precision. |
| `egm-bootstrap-orchestrator` | Documentation Bootstrapper | Orchestrator Subagent | Partitions directory trees for bottom-up recursive `README.md` generation during `/egm-bootstrap`. |
