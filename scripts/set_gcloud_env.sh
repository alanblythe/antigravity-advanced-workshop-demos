#!/usr/bin/env bash
# ==============================================================================
# Sourced Environment Setter for Workshop Google Cloud ADC & Profile
# ==============================================================================
# Usage:
#   source ./scripts/set_gcloud_env.sh
#   - or -
#   . ./scripts/set_gcloud_env.sh
# ==============================================================================

# Ensure script is being sourced, not executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "============================================================"
    echo "ERROR: This script must be SOURCED, not executed directly."
    echo ""
    echo "Run:"
    echo "  source ${BASH_SOURCE[0]}"
    echo "============================================================"
    exit 1
fi

_ENV_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_ENV_REPO_ROOT="$(cd "${_ENV_SCRIPT_DIR}/.." && pwd)"

# 1. Load .env or .env.example
if [[ -f "${_ENV_REPO_ROOT}/.env" ]]; then
    set -a
    # shellcheck disable=SC1090
    source "${_ENV_REPO_ROOT}/.env"
    set +a
elif [[ -f "${_ENV_REPO_ROOT}/.env.example" ]]; then
    set -a
    # shellcheck disable=SC1090
    source "${_ENV_REPO_ROOT}/.env.example"
    set +a
fi

# 2. Export environment variables
export GCLOUD_PROFILE="${GCLOUD_PROFILE:-antigravity-workshop}"
export CLOUDSDK_ACTIVE_CONFIG_NAME="${GCLOUD_PROFILE}"
export CLOUDSDK_CONFIG="${CLOUDSDK_CONFIG:-${HOME}/.config/gcloud-workshop}"
export GOOGLE_APPLICATION_CREDENTIALS="${GOOGLE_APPLICATION_CREDENTIALS:-${CLOUDSDK_CONFIG}/application_default_credentials.json}"
export GOOGLE_CLOUD_PROJECT="${GOOGLE_CLOUD_PROJECT:-your-demo-project}"
export GCLOUD_USER="${GCLOUD_USER:-admin@example.com}"
export GEAP_AGENT_URL="${GEAP_AGENT_URL:-https://us-central1-your-demo-project.cloudfunctions.net/a2a/app}"
export TOOLBOX_BIN="${TOOLBOX_BIN:-toolbox}"

# 3. Check status of ADC file
_ADC_STATUS="NOT FOUND"
if [[ -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]]; then
    _ADC_STATUS="VALID (Ready)"
else
    _ADC_STATUS="MISSING -> Run ./scripts/gcloud_login.sh"
fi

# 4. Print high-signal confirmation banner
echo "============================================================"
echo "  Google Cloud Workshop Environment Active"
echo "============================================================"
echo "  GCLOUD_PROFILE:                ${CLOUDSDK_ACTIVE_CONFIG_NAME}"
echo "  GCLOUD_USER:                   ${GCLOUD_USER}"
echo "  GOOGLE_CLOUD_PROJECT:          ${GOOGLE_CLOUD_PROJECT}"
echo "  CLOUDSDK_CONFIG:               ${CLOUDSDK_CONFIG}"
echo "  GOOGLE_APPLICATION_CREDENTIALS:${GOOGLE_APPLICATION_CREDENTIALS}"
echo "  ADC Status:                    ${_ADC_STATUS}"
if [[ -n "${GEAP_AGENT_URL:-}" ]]; then
echo "  GEAP_AGENT_URL:                ${GEAP_AGENT_URL}"
fi
echo "============================================================"
