#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> [Demo 7] Resetting Contract-First Spec TDD workspace to Red state..."
rm -rf workspace
mkdir -p workspace
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -R .seed/. workspace/
mkdir -p workspace/.scratch
touch workspace/.scratch/.gitkeep

echo "✔ Demo 7 clean: workspace ready for /grill-me -> /plan -> Test-Heal loop."
