#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> [Demo 7] Resetting Contract-First Spec TDD workspace to Red state..."
rm -rf src tests .scratch .pytest_cache
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -r .seed/AGENTS.md .seed/SPEC.md .
cp -r .seed/src .seed/tests .
mkdir -p .scratch
touch .scratch/.gitkeep

echo "✔ Demo 7 clean: 4 failing contract tests ready for /grill-me -> /plan -> Test-Heal loop."
