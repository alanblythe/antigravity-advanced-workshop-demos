#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> [Demo 9] Resetting Adversarial Review Loop workspace to seeded False-Green state..."
rm -rf workspace
mkdir -p workspace
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -r .seed/* workspace/
mkdir -p workspace/.scratch
touch workspace/.scratch/.gitkeep

echo "✔ Demo 9 clean: workspace ready for @adversarial-reviewer."
