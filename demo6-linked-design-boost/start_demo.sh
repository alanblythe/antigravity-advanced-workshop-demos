#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> [Demo 6] Resetting Linked DESIGN.md & Boost workspace..."
rm -rf workspace
mkdir -p workspace
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

cp -r .seed/* workspace/

echo "✔ Demo 6 clean: workspace ready for /boost."
