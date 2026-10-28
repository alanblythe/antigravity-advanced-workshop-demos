#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> [Demo 1] Resetting workspace to brownfield state (Cursor + Claude)..."
rm -f AGENTS.md GEMINI.md
rm -rf .gemini .agents

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
description: Audits codebase for Go best practices, error handling, and security leaks.
---

# Code Audit Skill
1. Check Go error wrapping with `%w`.
2. Ensure SQL queries use parameterized bindings.
3. Validate context cancellation propagation.
EOF
fi

echo "✔ Demo 1 reset to brownfield state (.cursorrules + CLAUDE.md ready for standardize.py)."
