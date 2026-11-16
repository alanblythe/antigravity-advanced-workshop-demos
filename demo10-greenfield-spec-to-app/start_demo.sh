#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SCRIPT_DIR"

echo "==> [Demo 10] Resetting Greenfield Spec-to-App workspace from .seed/..."

# 1. Clean any stray worktrees or branches if created during a run
rm -rf workspace/.worktrees .worktrees
if [[ -w "$ROOT_DIR/.git/info/exclude" ]]; then
    (grep -v '\.worktrees' "$ROOT_DIR/.git/info/exclude" > /tmp/exclude.tmp 2>/dev/null && mv /tmp/exclude.tmp "$ROOT_DIR/.git/info/exclude" 2>/dev/null) || rm -f /tmp/exclude.tmp 2>/dev/null || true
fi

# 2. Preserve directory inode and reset workspace contents from .seed/
mkdir -p workspace
(
    shopt -s nullglob dotglob
    rm -rf workspace/*
)
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -R .seed/. workspace/

echo "✔ Demo 10 clean: pristine greenfield workspace restored from .seed/ (0 preseeded app/spec files)."
