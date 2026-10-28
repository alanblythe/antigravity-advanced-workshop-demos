# Demo 5: Multi-Lens Architecture Ideation & Zero-Context RFC Stress-Testing (EGM)

> **Focus:** Installing the open-source **Elephant-Goldfish Model (`egm`)** plugin, defeating LLM sycophancy ("glazing") during system design, and dispatching 6 parallel zero-context Goldfish subagents to stress-test a feature hypothesis before writing code.

---

## Why the Elephant-Goldfish Model?

When engineers brainstorm with a single conversational agent over multiple turns, two failure modes emerge:
1. **Sycophancy ("Glazing"):** The model reflexively validates flawed assumptions (*"Great idea!"*).
2. **Conversational Context Bias:** Once the model helps co-author a direction in chat, it suffers from sunk-cost bias and fails to spot simpler alternatives or existing codebase services.

The **[Elephant-Goldfish Model (EGM)](https://github.com/google/elephant-goldfish-model)** separates ideation into two distinct cognitive roles:

| Role | Context | Responsibility |
| :--- | :--- | :--- |
| **Elephant** (Main Session) | Deep repository context, `AGENTS.md` invariants, and user conversation | Drills the engineer with open-ended, non-sycophantic questions until reaching an explicit **Readiness Gate**. |
| **Goldfish** (6 Parallel Subagents) | **Zero conversation history** — sees only the anchored hypothesis and source tree | Attacks the proposal simultaneously across 6 lenses (`egm-zoom-out`, `egm-design`, `egm-codebase-details`, `egm-comprehension`, `egm-implementation-readiness`, `egm-structural`). |
| **Engineer** (You) | Business goals and operational constraints | Resolves trade-offs, approves `concepts_brief.md`, and publishes the RFC or proceeds to `/egm-draft`. |

---

## The 6 Goldfish Brainstorming Lenses

| Subagent | Lens | What It Catches in This Demo |
| :--- | :--- | :--- |
| `egm-zoom-out` | **Contrarian / YAGNI** | Discovers that `src/currencyservice/` and `CurrencyService.Convert` in `protos/demo.proto` **already exist**—building FX logic inside `paymentservice` duplicates an existing microservice. |
| `egm-design` | **Cost, Quota & Token Economics** | Flags calling an external LLM on the synchronous checkout path as a latency/quota anti-pattern for deterministic currency math. |
| `egm-comprehension` | **UX & Developer Ergonomics** | Challenges ambiguous failure semantics when a merchant ERP webhook times out after a card charge succeeds. |
| `egm-codebase-details` | **Migration & Backward Compatibility** | Identifies breaking changes to `ChargeRequest` / `ChargeResponse` in `protos/demo.proto` and requires backward-compatible field numbering + `idempotency_key`. |
| `egm-implementation-readiness` | **Observability & SRE Debuggability** | Requires async outbox delivery, dead-letter queues (DLQ), `correlation_id` tracing, and exponential backoff with full jitter (`AGENTS.md §4.2`). |
| `egm-structural` | **Long-Term Tech Debt & Maintenance** | Warns against tight coupling between payment ledger settlement and third-party merchant webhook availability. |

---

## Files in This Demo

* **[`EGM_LIFECYCLE.md`](./EGM_LIFECYCLE.md)**: Visual architecture & process diagrams across all 7 EGM skills, 9 subagent personas, and lifecycle stages.
* **`AGENTS.md`**: Online Boutique architectural invariants and service boundary rules.
* **`protos/demo.proto`**: Canonical gRPC service definitions (`PaymentService`, `CurrencyService`).
* **`src/currencyservice/`**: Existing currency conversion microservice (`Convert` RPC + `currency_conversion.json`).
* **`src/paymentservice/reconciler.py`**: Existing payment settlement and reconciliation module.
* **`docs/designs/SITEMAP.md`**: Design RFC registry updated when publishing finalized concept briefs.
* **`seed/half_baked_proposal.md`**: Presenter copy-paste prompt and expected Goldfish objection matrix.
* **`start_demo.sh`**: Sub-second reset script removing generated `concepts_brief.md`, `design_draft.md`, and draft RFCs.

---

## Quickstart

1. Reset demo state:
```bash
./start_demo.sh
```

2. Install & verify the open-source EGM plugin:
```bash
agy plugin install https://github.com/google/elephant-goldfish-model
```
```bash
agy plugin list
```

3. Launch Antigravity TUI:
```bash
agy
```
Prompt inside `agy`:
```text
/egm-brainstorm We want paymentservice to convert currencies on the fly by calling an external FX LLM endpoint and firing a synchronous webhook to the merchant's ERP during checkout.
```
