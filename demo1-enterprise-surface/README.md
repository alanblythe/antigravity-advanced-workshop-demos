# Demo 1: Enterprise Surface, Open Standards & Context Hygiene

> **Focus:** Resolving IDE/auth confusion, establishing Linux Foundation AAIF open standards (`AGENTS.md`), and AST code-graph navigation.

---

## Files in This Demo

* **`AGENTS.md`**: Neutral open-standard agent configuration adhering to Linux Foundation AAIF specifications.
* **`.agents/rules/`**: Progressive disclosure rules (`architecture.md`, `security.md`, `context-hygiene.md`) with explicit trigger frontmatter (`trigger: model_decision`, `paths: ["**/*.py"]`).
* **`.agents/agents/arch-scout.md`**: Fast Flash-tiered subagent constrained to AST code graph queries.
* **`.agents/skills/repo-health/SKILL.md`**: Portable skill demonstrating open-standard skill directory structure.
* **`.gemini/mcp_config.json`**: Native Antigravity Model Context Protocol configuration exposing AST symbol graph tools (`ast-graph` / LSP).
* **`scripts/standardize.py`**: Automated workspace harmonization script linking rules and skills across tools.

---

## Quickstart

1. Reset and launch `agy` inside `workspace/` (or use VS Code Task **`Reset & Open: Demo 1`**):
```bash
./start_demo.sh && cd workspace && agy
```

2. Harmonize workspace standards inside `agy`:
```text
Run scripts/standardize.py in dry-run mode to audit existing Cursor and Claude rules, then apply the merge strategy to generate a canonical AGENTS.md and backward-compatible symlinks.
```

3. Test symbol navigation via AST inside `agy`:
```text
Trace all callers of reconcile_transactions across the codebase using the code graph. Do not read the entire files.
```

4. Execute `arch-scout` subagent to map dependencies inside `agy`:
```text
Use invoke subagent to execute the arch-scout to map dependencies.
```
