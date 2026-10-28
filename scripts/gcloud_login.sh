#!/usr/bin/env bash
# ==============================================================================
# Dedicated Workshop Google Cloud ADC Login & Profile Initializer
# ==============================================================================
# Usage:
#   ./scripts/gcloud_login.sh          # Interactive login & setup
#   ./scripts/gcloud_login.sh --check  # Verify existing credentials & config
#   ./scripts/gcloud_login.sh --force  # Force re-authentication
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# 1. Load .env configuration
if [[ -f "${REPO_ROOT}/.env" ]]; then
    # shellcheck disable=SC1091
    set -a
    source "${REPO_ROOT}/.env"
    set +a
elif [[ -f "${REPO_ROOT}/.env.example" ]]; then
    echo "Notice: .env not found at repository root; using defaults from .env.example"
    # shellcheck disable=SC1091
    set -a
    source "${REPO_ROOT}/.env.example"
    set +a
fi

# Fallback defaults if not set in .env
GCLOUD_USER="${GCLOUD_USER:-admin@example.com}"
GOOGLE_CLOUD_PROJECT="${GOOGLE_CLOUD_PROJECT:-your-demo-project}"
GCLOUD_PROFILE="${GCLOUD_PROFILE:-antigravity-workshop}"
CLOUDSDK_CONFIG="${CLOUDSDK_CONFIG:-${HOME}/.config/gcloud-workshop}"
GOOGLE_APPLICATION_CREDENTIALS="${GOOGLE_APPLICATION_CREDENTIALS:-${CLOUDSDK_CONFIG}/application_default_credentials.json}"

FORCE_LOGIN=false
CHECK_ONLY=false

for arg in "$@"; do
    case "$arg" in
        --check)
            CHECK_ONLY=true
            ;;
        --force)
            FORCE_LOGIN=true
            ;;
        --help|-h)
            echo "Workshop GCloud ADC & Profile Setup"
            echo "Usage: $0 [--check | --force]"
            echo "  --check   Verify existing configuration and ADC file without logging in"
            echo "  --force   Force execution of gcloud auth application-default login"
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Usage: $0 [--check | --force]"
            exit 1
            ;;
    esac
done

echo "============================================================"
echo "  Google Cloud ADC & Configuration Setup (Workshop Workbench)"
echo "============================================================"
echo "  User:         ${GCLOUD_USER}"
echo "  Project:      ${GOOGLE_CLOUD_PROJECT}"
echo "  Profile:      ${GCLOUD_PROFILE}"
echo "  Config Dir:   ${CLOUDSDK_CONFIG}"
echo "  ADC Target:   ${GOOGLE_APPLICATION_CREDENTIALS}"
echo "============================================================"

# 2. Ensure isolated configuration directory exists
mkdir -p "${CLOUDSDK_CONFIG}"
export CLOUDSDK_CONFIG

# 3. Create or activate the named gcloud profile
EXISTING_CONFIGS=$(gcloud config configurations list --format="value(name)" 2>/dev/null || true)
if echo "${EXISTING_CONFIGS}" | grep -qx "${GCLOUD_PROFILE}"; then
    echo "==> Activating existing gcloud configuration profile: ${GCLOUD_PROFILE}..."
    gcloud config configurations activate "${GCLOUD_PROFILE}" --quiet
else
    echo "==> Creating and activating new gcloud configuration profile: ${GCLOUD_PROFILE}..."
    gcloud config configurations create "${GCLOUD_PROFILE}" --quiet
fi

# 4. Set account and project on the active configuration
echo "==> Setting gcloud account and project..."
gcloud config set account "${GCLOUD_USER}" --quiet
gcloud config set project "${GOOGLE_CLOUD_PROJECT}" --quiet

# 5. Check / execute Application Default Credentials (ADC) login
ADC_EXISTS=false
if [[ -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]]; then
    ADC_EXISTS=true
fi

if [[ "${CHECK_ONLY}" == "true" ]]; then
    echo "==> Running credential check mode (--check)..."
elif [[ "${ADC_EXISTS}" == "true" && "${FORCE_LOGIN}" != "true" ]]; then
    echo "✔ ADC credentials already exist at: ${GOOGLE_APPLICATION_CREDENTIALS}"
    echo "  (Pass --force to re-authenticate with your browser)"
else
    echo "==> Initiating Google Cloud Application Default Credentials login..."
    echo "    Credentials will be saved to isolated config directory: ${CLOUDSDK_CONFIG}"
    gcloud auth application-default login
fi

# 6. Verify credentials
echo ""
echo "============================================================"
echo "  Credential Verification Status"
echo "============================================================"
if [[ -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]]; then
    echo "✔ Application Default Credentials (ADC) file exists:"
    echo "  Location: ${GOOGLE_APPLICATION_CREDENTIALS}"
    if command -v jq &>/dev/null; then
        CRED_TYPE=$(jq -r '.type // "authorized_user"' "${GOOGLE_APPLICATION_CREDENTIALS}" 2>/dev/null || echo "authorized_user")
        CLIENT_ID_SNIPPET=$(jq -r '.client_id // "default"' "${GOOGLE_APPLICATION_CREDENTIALS}" 2>/dev/null | cut -c 1-20 || echo "default")
        echo "  Type:     ${CRED_TYPE}"
        echo "  Client:   ${CLIENT_ID_SNIPPET}..."
    fi
else
    echo "⚠ Warning: ADC file not found at ${GOOGLE_APPLICATION_CREDENTIALS}"
    echo "  Run '$0 --force' to authenticate."
fi

ACTIVE_ACCT=$(gcloud config get-value account 2>/dev/null || echo "not set")
ACTIVE_PROJ=$(gcloud config get-value project 2>/dev/null || echo "not set")
echo "  Active Profile: ${GCLOUD_PROFILE}"
echo "  Active Account: ${ACTIVE_ACCT}"
echo "  Active Project: ${ACTIVE_PROJ}"
echo "============================================================"
echo ""
echo "Next step: Source the environment in your presentation terminal:"
echo "  source ./scripts/set_gcloud_env.sh"
echo "============================================================"
