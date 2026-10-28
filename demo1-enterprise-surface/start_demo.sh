#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> [Demo 1] Resetting workspace to brownfield state (Cursor + Claude)..."
rm -f AGENTS.md GEMINI.md
rm -rf .codex .agents/skills

# Restore brownfield CLAUDE.md if it became a symlink or missing
if [[ -L "CLAUDE.md" ]] || [[ ! -f "CLAUDE.md" ]]; then
    rm -f CLAUDE.md
    cat << 'EOF' > CLAUDE.md
# Claude Code Development Guidelines

## Commands
- Build: `go build ./...`
- Test: `go test -v ./...`
- Lint: `golangci-lint run`

## Architecture
- All handlers must validate inputs using strict schema definitions.
- Keep context lean by preferring targeted file searches over global reading.
EOF
fi

# Restore brownfield .cursorrules if it became a symlink or missing
if [[ -L ".cursorrules" ]] || [[ ! -f ".cursorrules" ]]; then
    rm -f .cursorrules
    cat << 'EOF' > .cursorrules
# Cursor Editor Rules
- Always use Go 1.22+ conventions.
- Format all code with gofmt.
- Never commit secrets or hardcoded passwords.
- Handlers must validate all request fields before dispatch.
EOF
fi

# Restore .claude skill if moved
if [[ ! -d ".claude/skills/code-audit" ]]; then
    mkdir -p .claude/skills/code-audit
    cat << 'EOF' > .claude/skills/code-audit/SKILL.md
---
name: code-audit
description: Legacy Claude skill to audit codebase for lint errors.
---

# Code Audit Skill
Run `golangci-lint run ./...` and summarize findings.
EOF
fi

# Ensure Antigravity MCP configuration exists
mkdir -p .agents .gemini scripts
if [[ ! -f "scripts/ast_mcp.py" ]]; then
    cp "$SCRIPT_DIR/../scripts/ast_mcp.py" scripts/ast_mcp.py
fi

cat << 'EOF' > .agents/mcp_config.json
{
  "mcpServers": {
    "ast-graph": {
      "command": "python3",
      "args": [
        "scripts/ast_mcp.py"
      ]
    }
  }
}
EOF

cp .agents/mcp_config.json .gemini/mcp_config.json
cp .agents/mcp_config.json .mcp.json

if [[ ! -f ".gemini/settings.json" ]]; then
    cat << 'EOF' > .gemini/settings.json
{
  "permissions": {
    "allow": [
      "mcp(ast-graph/*)",
      "run_command(python3 scripts/ast_mcp.py*)",
      "run_command(git diff)",
      "run_command(git log)",
      "run_command(git status)"
    ]
  }
}
EOF
fi

# Ensure arch-scout agent exists
if [[ ! -f ".agents/agents/arch-scout.md" ]]; then
    mkdir -p .agents/agents
    cat << 'EOF' > .agents/agents/arch-scout.md
---
name: arch-scout
description: Fast, token-efficient architecture scout running on Flash with restricted source reads.
model: flash
tools:
  - mcp(ast-graph/*)
---

# Architecture Scout

You are a fast, token-efficient architecture analyst.
Direct reads of implementation files in `src/` are restricted by governance policy.
To analyze callers, dependencies, or structural impact, you MUST query `ast-graph` tools (`find_callers`, `list_symbols`).
EOF
fi

# Ensure context-hygiene rule exists
if [[ ! -f ".agents/rules/context-hygiene.md" ]]; then
    mkdir -p .agents/rules
    cat << 'EOF' > .agents/rules/context-hygiene.md
---
trigger: model_decision
description: Policy constraints for code graph exploration, AST navigation, and dependency tracing.
---

# Codebase Navigation Policy
- Full source file reads across `src/` are restricted by governance policy to prevent context dilution and token bloat.
- Use `mcp(ast-graph/find_callers)` to trace callers and dependency paths.
- Use `mcp(ast-graph/list_symbols)` to inspect class and function signatures without ingesting full implementation bodies.
EOF
fi

echo "✔ Demo 1 reset to brownfield state (.cursorrules + CLAUDE.md ready for standardize.py)."
