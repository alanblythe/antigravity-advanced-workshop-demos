---
trigger: model_decision
description: Policy constraints for code graph exploration, AST navigation, and dependency tracing.
---

# Codebase Navigation Policy
- Full source file reads across `src/` are restricted by governance policy to prevent context dilution and token bloat.
- Use `mcp(ast-graph/find_callers)` to trace callers and dependency paths.
- Use `mcp(ast-graph/list_symbols)` to inspect class and function signatures without ingesting full implementation bodies.
