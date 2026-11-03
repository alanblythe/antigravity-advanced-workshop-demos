#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> [Demo 6] Resetting Linked DESIGN.md & Boost workspace..."
rm -rf src tests .scratch .pytest_cache
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -r .seed/AGENTS.md .seed/DESIGN.md .
mkdir -p .agents/rules
cp -r .seed/.agents/rules/discount-invariants.md .agents/rules/
cp -r .seed/src .seed/tests .

echo "✔ Demo 6 clean: AGENTS.md -> @DESIGN.md ready for /boost."
