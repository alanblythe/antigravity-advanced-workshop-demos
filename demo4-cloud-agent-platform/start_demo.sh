#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> Preparing Demo 4: Cloud Agent Platform (GEAP)..."
echo "✔ Pre-deployed agent endpoint: ${GEAP_AGENT_URL:-https://us-central1-your-demo-project.cloudfunctions.net/a2a/app}"

ADC_TARGET="${GOOGLE_APPLICATION_CREDENTIALS:-${HOME}/.config/gcloud-workshop/application_default_credentials.json}"
if [[ -f "${ADC_TARGET}" ]]; then
    echo "✔ Google Cloud ADC file verified at: ${ADC_TARGET}"
else
    echo "ℹ Note: ADC file not found at ${ADC_TARGET}."
    echo "  Run '${REPO_ROOT}/scripts/gcloud_login.sh' and 'source ${REPO_ROOT}/scripts/set_gcloud_env.sh' before live agent invocation."
fi
