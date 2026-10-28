#!/usr/bin/env bash
# Sourced helper to activate workshop ADC and environment for Demo 4
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "ERROR: This script must be SOURCED, not executed directly."
    echo "Run: source ${BASH_SOURCE[0]}"
    exit 1
fi

# shellcheck disable=SC1091
source "${REPO_ROOT}/scripts/set_gcloud_env.sh"
