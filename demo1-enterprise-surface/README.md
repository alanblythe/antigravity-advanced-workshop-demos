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

1. Verify enterprise authentication:
```bash
agy auth status
```

2. Harmonize workspace standards:
```bash
python3 scripts/standardize.py
```

3. Test symbol navigation via AST:
```bash
agy -p "Trace all callers of reconcile_transactions using the symbol graph"
```

4. Execute ArchScout subagent to map dependencies:
```bash
agy
```
Prompt inside `agy`:
```text
Use invoke subagent to execute the arch-scout to map dependencies.
```
