#!/usr/bin/env bash
set -euo pipefail
echo "==> [Demo 2] Cleaning subagent worktrees & test branches..."
if [[ -d ".worktrees/feat-reconcile" ]]; then
    git worktree remove -f .worktrees/feat-reconcile 2>/dev/null || rm -rf .worktrees/feat-reconcile
fi
git branch -D feat/reconcile 2>/dev/null || true
rm -rf .worktrees .scratch/browser-verification.png
echo "✔ Demo 2 clean: pristine worktree state, legacy bug ready for subagent."
