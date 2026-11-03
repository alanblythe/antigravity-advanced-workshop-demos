# Online Boutique — Monolith Decomposition & Multi-Agent Teamwork Guidelines

## §1. Architectural Contract (`@DESIGN.md`)
- All target module boundaries, dependency DAG stages, and backward-compatibility requirements are defined in `@DESIGN.md`.
- Always read `@DESIGN.md` before planning or executing any refactoring of `src/order_app/monolith_order_app.py`.

## §2. Multi-Agent Persona Roster & Non-Overlapping Ownership
1. **`@architect` (`.agents/agents/architect.md`):** Performs **Graph Planning**—invokes `@fast-scout` to map AST symbols and outputs the 3-stage execution DAG to `.scratch/refactor-dag.md`.
2. **`@fast-scout` (`.agents/agents/fast-scout.md`):** Read-only Flash scout that uses the `ast-graph` MCP server (`list_symbols`, `find_callers`) to map coupling without reading full files into the main context.
3. **`@coder` (`.agents/agents/coder.md`):** Executes assigned DAG slices with strict non-overlapping file ownership (`models.py`, `repositories.py`, `services.py`, `routes.py`) and verifies `pytest` passes 100%.
