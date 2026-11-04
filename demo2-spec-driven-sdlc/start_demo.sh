#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
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

# Clean up git exclude if worktree paths were added
if [[ -w "$ROOT_DIR/.git/info/exclude" ]]; then
    (grep -v '\.worktrees' "$ROOT_DIR/.git/info/exclude" > /tmp/exclude.tmp 2>/dev/null && mv /tmp/exclude.tmp "$ROOT_DIR/.git/info/exclude" 2>/dev/null) || rm -f /tmp/exclude.tmp 2>/dev/null || true
fi

# Reset uncommitted modifications in workspace
git checkout HEAD -- workspace/ 2>/dev/null || git checkout -- workspace/ 2>/dev/null || true

# Ensure app.py imports reconciler reliably regardless of working directory
python3 -c '
p = "workspace/app.py"
try:
    with open(p, "r") as f:
        c = f.read()
    if "sys.path.insert(0" not in c:
        c = c.replace("from reconciler import TransactionReconciler", "sys.path.insert(0, os.path.join(os.path.dirname(__file__), \"src\", \"paymentservice\"))\nfrom reconciler import TransactionReconciler")
        if "import sys" not in c:
            c = c.replace("import os", "import os\nimport sys")
        with open(p, "w") as f:
            f.write(c)
except Exception:
    pass
' 2>/dev/null || true

echo "✔ Demo 2 clean: pristine worktree state, legacy bug ready for subagent."
