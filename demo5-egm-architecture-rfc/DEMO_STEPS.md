# Demo 5 Presenter Flight Plan: Multi-Lens Architecture Ideation & Zero-Context RFC Stress-Testing (EGM)

> **Track:** Track A (Module 5)  
> **Total Suggested Timing:** ~15 minutes (Plugin setup: ~2m, Elephant brainstorm: ~4m, 6-lens Goldfish swarm: ~6m, RFC handoff: ~3m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 5`**.

---

## Demo 5: Elephant-Goldfish Model (`/egm-brainstorm`) & 6-Lens Parallel Subagent Review

* **Suggested Timing:** ~15 minutes
* **Goal:** Eliminate LLM sycophancy ("glazing") and conversational echo chambers during upstream system design using the open-source **[Elephant-Goldfish Model (`egm`)](https://github.com/google/elephant-goldfish-model)** plugin.

### Step 1: Install the Open-Source EGM Plugin
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

### Step 2: Pitch a "Half-Baked" Architecture Trap to `/egm-brainstorm`
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

### Step 3: Trigger the 6-Lens Parallel Goldfish Swarm
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo5-egm-architecture-rfc/workspace/`
* **Action:** Select **`Review with Goldfishes`**.
* **Expected Result:** 6 parallel Goldfish subagents identify existing `currencyservice`, token cost/quota risks, missing idempotency keys in `ChargeRequest`, and 150ms checkout SLA breach.
* **What to watch on screen (The Goldfishes):**
  `egm-synthesizer` spawns 6 stateless Goldfish subagents in parallel (`invoke_subagent`) with **zero conversation history**:
  * **Contrarian / YAGNI (`egm-zoom-out`):** Searches the codebase and discovers `src/currencyservice/server.js` and `CurrencyService.Convert` in `protos/demo.proto` **already exist**—building FX logic in `paymentservice` duplicates an existing microservice.
  * **Cost, Quota & Token Economics (`egm-design`):** Flags calling an external LLM per checkout as a quota/latency anti-pattern for deterministic decimal math.
  * **Migration & Backward Compatibility (`egm-codebase-details`):** Audits `ChargeRequest` / `ChargeResponse` in `protos/demo.proto` and requires additive backward-compatible fields (`idempotency_key`).
  * **Observability & SRE Debuggability (`egm-implementation-readiness`):** Flags that synchronous webhooks violate the 150ms p99 checkout SLA (`AGENTS.md §2`) and requires an async transactional outbox with **exponential backoff and full jitter** (`AGENTS.md §3.2`).

### Step 4: Artifact-First Brief (`concepts_brief.md`) & RFC Handoff
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo5-egm-architecture-rfc/workspace/` & VS Code Editor
* **Expected Result:** `concepts_brief.md` written to workspace; selecting "Publish RFC" writes `docs/designs/currency-fx.md` and updates `docs/designs/SITEMAP.md`.
* **What to watch on screen:**
  1. **Artifact-First Delivery:** Instead of dumping a wall of text in chat, the agent writes a plain-English `concepts_brief.md` and highlights only the top 2–3 Goldfish objections in chat.
  2. **Step 4 Handoff Gate:** After confirming alignment, select **`Publish concepts_brief.md as RFC for team feedback`** $\rightarrow$ writes `docs/designs/<feature_name>.md` and registers the RFC in `docs/designs/SITEMAP.md` (or select **`Proceed to /egm-draft`** to generate `design_draft.md`).
