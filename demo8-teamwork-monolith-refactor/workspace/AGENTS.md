# Online Boutique — Order Processor Service Guidelines

## §1. Standing Architectural Decision Records (`docs/adr/`)
- Target module boundaries, dependency layering, and backward-compatibility requirements for `src/order_app/` are defined in `@docs/adr/0001-order-service-layered-decomposition.md`.
- Always consult `@docs/adr/0001-order-service-layered-decomposition.md` before planning or refactoring `src/order_app/monolith_order_app.py`.

## §2. Testing & Verification
- Run the test suite using `.venv/bin/pytest`.
- Do not install packages or modify the environment when running tests.

## §3. Specialized Subagents (`.agents/agents/`)
- **`@architect`:** Architectural planner that uses `@fast-scout` to map symbol dependencies and design non-overlapping module boundaries.
- **`@fast-scout`:** Read-only Flash scout that uses the `ast-graph` MCP server (`list_symbols`, `find_callers`) to inspect symbol coupling without reading full files into context.
- **`@coder`:** Implementation subagent that executes assigned module extractions with strict file ownership and verifies `.venv/bin/pytest`.
