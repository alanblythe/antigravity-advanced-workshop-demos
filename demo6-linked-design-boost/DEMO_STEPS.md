# Demo 6 Presenter Flight Plan: Grounding Specs, Linked ADRs & Boost

> **Track:** Track B (Antigravity 201)  
> **Total Suggested Timing:** ~10 minutes (Context hierarchy walkthrough: ~4m, /boost execution: ~6m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 6`**.

---

## Demo 6: Grounding Specs, Linked ADRs & `⚡ Boost`

* **Suggested Timing:** ~10 minutes
* **Goal:** Show how separating `AGENTS.md` (concise project constitution) and `docs/adr/` (long-lived architectural decision records: 50% discount ceiling, Decimal rounding, typing contracts) from `docs/specs/` (the single-conversation feature specification) plus path-scoped `.agents/rules/` lets **`⚡ Boost`** (`/boost`) implement complex features from a 1-sentence prompt.

### Step 1: Verify Baseline Tests & Inspect the 3-Tier Context Hierarchy (`AGENTS.md` $\rightarrow$ `docs/adr/` + `docs/specs/`)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo6-linked-design-boost/workspace/`
* **Prompt inside `agy`:**
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

### Step 2: Execute Feature Spec via `⚡ Boost` (`/boost`)
* **Where to run:** Antigravity 2.0 UI (`⚡ Boost` toggle) or `agy` CLI inside `demo6-linked-design-boost/workspace/`
* **Prompt inside `agy`:**
```text
/boost Implement @docs/specs/0001-stacked-promo-engine.md in src/discountservice/engine.py and add unit tests for all acceptance criteria.
```
* **Expected Result:** Implements `evaluate_stacked_promos` in `engine.py` adhering to the ADR (Decimal rounding, 50% cap, TypeError on float); adds tests in `tests/test_engine.py`; passes all tests.
* **Highlight:** Point out how `@docs/specs/0001-stacked-promo-engine.md` focuses purely on the feature being built in this conversation (`evaluate_stacked_promos`), while Antigravity automatically enforces all standing architectural guardrails from `AGENTS.md` $\rightarrow$ `@docs/adr/0001-decimal-currency-and-discount-caps.md` and `.agents/rules/discount-invariants.md` and verifies `AC-1`–`AC-4` pass via `pytest`.
