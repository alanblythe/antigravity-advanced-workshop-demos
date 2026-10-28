#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "==> [Demo 5] Resetting Elephant-Goldfish Model (EGM) workspace..."
rm -f concepts_brief.md design_draft.md goldfish_review_report.md
find docs/designs -type f ! -name 'SITEMAP.md' -delete 2>/dev/null || true

cat > docs/designs/SITEMAP.md << 'EOF'
# Online Boutique — Architecture RFC & Design Sitemap

This index tracks approved and draft Request for Comments (RFCs) and design specifications generated via the Elephant-Goldfish Model (`/egm-brainstorm` and `/egm-draft`).

| RFC / Design Document | Status | Owner | Summary |
| :--- | :--- | :--- | :--- |
| `docs/designs/baseline-microservices.md` | APPROVED | Architecture COE | Baseline gRPC contracts for `PaymentService`, `CurrencyService`, and `ProductCatalogService`. |
EOF

echo "✔ Demo 5 clean: ready for /egm-brainstorm multi-lens ideation."
