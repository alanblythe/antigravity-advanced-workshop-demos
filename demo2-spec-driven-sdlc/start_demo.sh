#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> [Demo 2] Cleaning subagent worktrees & test branches..."
if [[ -d "workspace/.worktrees/feat-reconcile" ]]; then
    git worktree remove -f workspace/.worktrees/feat-reconcile 2>/dev/null || rm -rf workspace/.worktrees/feat-reconcile
fi
if [[ -d ".worktrees/feat-reconcile" ]]; then
    git worktree remove -f .worktrees/feat-reconcile 2>/dev/null || rm -rf .worktrees/feat-reconcile
fi
git branch -D feat/reconcile 2>/dev/null || true
rm -rf workspace/.worktrees .worktrees workspace/.scratch/browser-verification.png
echo "✔ Demo 2 clean: pristine worktree state, legacy bug ready for subagent."
