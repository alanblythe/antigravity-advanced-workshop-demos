#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> [Demo 8] Resetting Teamwork Monolith Refactoring workspace..."
if [[ -d "workspace/.worktrees" ]]; then
    for wt in workspace/.worktrees/*; do
        [[ -d "$wt" ]] && (git worktree remove -f "$wt" 2>/dev/null || rm -rf "$wt")
    done
fi
mkdir -p workspace
(
    shopt -s nullglob dotglob
    rm -rf workspace/*
)
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -R .seed/. workspace/
mkdir -p workspace/.scratch
touch workspace/.scratch/.gitkeep
(cd workspace && uv sync --quiet 2>/dev/null) || true

echo "✔ Demo 8 clean: workspace ready for Graph Planning & /teamwork."
