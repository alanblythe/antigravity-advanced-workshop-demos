# Demo 8: Graph Planning & Multi-Agent `/teamwork` Monolith Refactoring

> **Focus:** Multi-agent execution patterns—coordinating AST scouting (`@fast-scout`), Graph Planning (`@architect` $\rightarrow$ `.scratch/refactor-dag.md`), parallel modular authoring (`@coder` via `/teamwork`), and clean-context verification.

---

## Files in This Demo

* **`AGENTS.md` & `DESIGN.md`**: Define the 4 target modules (`models.py`, `repositories.py`, `services.py`, `routes.py`), backward-compatible re-exports in `monolith_order_app.py`, and the 3-stage execution DAG.
* **`.agents/agents/architect.md`**: Graph Planner persona (`model: pro`) that maps dependencies and writes `.scratch/refactor-dag.md`.
* **`.agents/agents/fast-scout.md`**: Read-only Flash scout (`model: flash`) using the `ast-graph` MCP server (`scripts/ast_mcp.py`).
* **`.agents/agents/coder.md`**: Implementation subagent executing disjoint DAG nodes.
* **`src/order_app/monolith_order_app.py`**: 220-line monolithic Online Boutique Order Processor.
* **`tests/test_order_flow.py`**: End-to-end regression suite (`4 passed`).

---

## Live Demo Steps

1. In Antigravity (`agy` inside `workspace/`, launched via VS Code Task **`Reset & Open: Demo 8`**), verify the baseline monolith tests pass (`4 passed`):
```text
Run pytest.
```

2. Run **Graph Planning** with `@architect` and `@fast-scout`:
```text
/plan Use @architect and @fast-scout to inspect src/order_app/monolith_order_app.py via the ast-graph MCP tools and generate a 3-stage dependency graph (DAG) in .scratch/refactor-dag.md with non-overlapping file ownership. Include the assigned subagent for each step in both the stage breakdown and the Mermaid diagram.
```

3. Execute parallel multi-agent refactoring via **`/teamwork`** (`👥 Teamwork`):
```text
/teamwork Execute .scratch/refactor-dag.md using @coder subagents in parallel across Stage 2 (repositories.py and services.py), then rewire routes.py and monolith_order_app.py and verify pytest passes in a clean context.
```
