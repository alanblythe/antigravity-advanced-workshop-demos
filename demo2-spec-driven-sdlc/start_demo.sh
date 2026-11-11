#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SCRIPT_DIR"

echo "==> [Demo 2] Resetting Spec-Driven SDLC workspace from .seed/..."

# 1. Clean subagent worktrees and test branches
if [[ -d "workspace/.worktrees/feat-reconcile" ]]; then
    git worktree remove -f workspace/.worktrees/feat-reconcile 2>/dev/null || rm -rf workspace/.worktrees/feat-reconcile
fi
if [[ -d ".worktrees/feat-reconcile" ]]; then
    git worktree remove -f .worktrees/feat-reconcile 2>/dev/null || rm -rf .worktrees/feat-reconcile
fi
git branch -D feat/reconcile 2>/dev/null || true
rm -rf workspace/.worktrees .worktrees

# 2. Clean up git exclude if worktree paths were added
if [[ -w "$ROOT_DIR/.git/info/exclude" ]]; then
    (grep -v '\.worktrees' "$ROOT_DIR/.git/info/exclude" > /tmp/exclude.tmp 2>/dev/null && mv /tmp/exclude.tmp "$ROOT_DIR/.git/info/exclude" 2>/dev/null) || rm -f /tmp/exclude.tmp 2>/dev/null || true
fi

# 3. Preserve directory inode and reset workspace contents from .seed/
mkdir -p workspace
(
    shopt -s nullglob dotglob
    rm -rf workspace/*
)
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -R .seed/. workspace/

echo "✔ Demo 2 clean: pristine workspace restored from .seed/, legacy bug ready for subagent."
