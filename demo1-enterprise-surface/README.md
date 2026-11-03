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

1. Reset to initial brownfield state:
```bash
./start_demo.sh
```

2. Open the clean agent workspace (`workspace/`):
```bash
cd workspace
```

3. Harmonize workspace standards:
```bash
python3 scripts/standardize.py --dry-run --strategy merge
python3 scripts/standardize.py --apply --strategy merge
```

4. Test symbol navigation via AST inside `workspace/`:
```bash
agy -p "Trace all callers of reconcile_transactions using the symbol graph"
```

5. Execute ArchScout subagent to map dependencies:
```bash
agy
```
Prompt inside `agy`:
```text
Use invoke subagent to execute the arch-scout to map dependencies.
```
