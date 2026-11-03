#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> [Demo 9] Resetting Adversarial Review Loop workspace to seeded False-Green state..."
rm -rf src tests .scratch .pytest_cache
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -r .seed/AGENTS.md .seed/DESIGN.md .
cp -r .seed/.agents .seed/src .seed/tests .
mkdir -p .scratch
touch .scratch/.gitkeep

echo "✔ Demo 9 clean: 4 passing unit tests + 3 seeded @DESIGN.md invariant bugs ready for @adversarial-reviewer."
