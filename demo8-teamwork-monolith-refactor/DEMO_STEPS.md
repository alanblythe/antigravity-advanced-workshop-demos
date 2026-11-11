# Demo 8 Presenter Flight Plan: Graph Planning & Multi-Agent Teamwork Monolith Refactoring

> **Track:** Track B (Antigravity 201)  
> **Total Suggested Timing:** ~24 minutes (Baseline check: ~1m, Graph planning: ~3m, Teamwork staging: ~4m, Parallel execution & verification: ~16m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 8`**.

---

## Demo 8: Graph Planning & Multi-Agent `/teamwork` Monolith Refactoring

* **Suggested Timing:** ~24 minutes
* **Goal:** Decompose a 220-line monolithic Online Boutique Order Processor (`src/order_app/monolith_order_app.py`) into `models.py`, `repositories.py`, `services.py`, and `routes.py` using **Graph Planning** (`@architect` + `@fast-scout`) and **`/teamwork`** (`👥 Teamwork`) parallel `@coder` execution.

### Step 1: Verify Monolith Baseline (`4 passed`)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Prompt inside `agy`:**
```text
Run pytest.
```
* **Expected Result:**
```text
==================== 4 passed in 0.03s ====================
```
* **Files to highlight in editor:**
  * `workspace/.agents/agents/architect.md` (Graph Planner persona)
  * `workspace/.agents/agents/fast-scout.md` (Flash AST Scout persona using `ast-graph` MCP)
  * `workspace/.agents/agents/coder.md` (Modular implementation persona)

### Step 2: Graph Planning (`@architect` + `@fast-scout` $\rightarrow$ `.scratch/refactor-dag.md`)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Prompt inside `agy`:**
```text
/plan Use @architect and @fast-scout to inspect src/order_app/monolith_order_app.py via the ast-graph MCP tools and generate a 3-stage dependency graph (DAG) in .scratch/refactor-dag.md with non-overlapping file ownership. Include the assigned subagent for each step in both the stage breakdown and the Mermaid diagram.
```
* **Expected Result:** Wrote `.scratch/refactor-dag.md` with an embedded Mermaid DAG flowchart labeling assigned subagents: Stage 1 extracts `models.py`; Stage 2 runs parallel `@coder` subagents on disjoint files (`repositories.py` and `services.py`); Stage 3 rewires `routes.py` and `monolith_order_app.py`.
* **Highlight:** Show the 3-stage DAG and Mermaid flowchart in `.scratch/refactor-dag.md`: Stage 1 extracts `models.py`; Stage 2 runs two `@coder` subagents **in parallel** on disjoint files (`repositories.py` and `services.py`); Stage 3 rewires `routes.py` and `monolith_order_app.py`, with subagent assignments explicitly mapped per node.

### Step 3: Execute Parallel Multi-Agent Refactor via `/teamwork` (`👥 Teamwork`)
* **Where to run:** Antigravity 2.0 (`👥 Teamwork`) or `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Prompt inside `agy`:**
```text
/teamwork Execute .scratch/refactor-dag.md using @coder subagents in parallel across Stage 2 (repositories.py and services.py), then rewire routes.py and monolith_order_app.py and verify pytest passes in a clean context.
```
* **Expected Result:**
```text
Parallel @coder subagents complete without file collisions; monolith delegates cleanly; pytest passes:
==================== 4 passed in 0.03s ====================
```
* **Presenter Flow Note ("Cooking Show" Overlap Pattern):**
  Once the `/teamwork` parallel refactor is running and you have shown the active `@coder` workers in the Antigravity TUI (~2–3 minutes of observation), **do not wait 15 minutes in silence**. Leave terminal/workspace 8 running in the background, open a new terminal or VS Code window for **Demo 9 (`Reset & Open: Demo 9`)**, and run through Demo 9 end-to-end (~10 mins). When Demo 9 finishes, return to Demo 8 for Step 4.

### Step 4: Return to Demo 8 for Finale & Verification
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo8-teamwork-monolith-refactor/workspace/`
* **Highlight:**
  1. Inspect the decomposed modular architecture: `models.py`, `repositories.py`, `services.py`, and `routes.py`.
  2. Show `monolith_order_app.py` functioning purely as a backward-compatible facade re-exporting the modules.
  3. Verify the final clean test suite passes with `pytest`:
  ```bash
  pytest
  ```
  * **Expected Result:** `==================== 4 passed in 0.03s ====================`
