#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> [Demo 8] Resetting Teamwork Monolith Refactoring workspace..."
if [[ -d ".worktrees" ]]; then
    for wt in .worktrees/*; do
        [[ -d "$wt" ]] && (git worktree remove -f "$wt" 2>/dev/null || rm -rf "$wt")
    done
    rm -rf .worktrees
fi
rm -rf src tests .scratch .pytest_cache
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -r .seed/AGENTS.md .seed/DESIGN.md .seed/.mcp.json .
cp -r .seed/.gemini .seed/.agents .seed/scripts .seed/src .seed/tests .
mkdir -p .scratch
touch .scratch/.gitkeep

echo "✔ Demo 8 clean: monolith_order_app.py restored and ready for Graph Planning & /teamwork."
