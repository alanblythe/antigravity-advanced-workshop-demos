#!/usr/bin/env bash
set -euo pipefail

# Runs Database MCP Toolbox in stdio mode using local tools.yaml
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${DEMO_DIR}/.." && pwd)"

# Auto-source workshop environment if GOOGLE_APPLICATION_CREDENTIALS is not already set
if [[ -z "${GOOGLE_APPLICATION_CREDENTIALS:-}" && -f "${REPO_ROOT}/scripts/set_gcloud_env.sh" ]]; then
    # shellcheck disable=SC1091
    source "${REPO_ROOT}/scripts/set_gcloud_env.sh" >/dev/null
fi

TOOLBOX_BIN="${TOOLBOX_BIN:-toolbox}"

if ! command -v "$TOOLBOX_BIN" &>/dev/null; then
    if [[ -x "${REPO_ROOT}/scripts/install_toolbox.sh" ]]; then
        echo "Toolbox binary '${TOOLBOX_BIN}' not found on PATH. Attempting automated installation..."
        "${REPO_ROOT}/scripts/install_toolbox.sh"
        export PATH="${HOME}/.local/bin:${PATH}"
    fi
fi

if ! command -v "$TOOLBOX_BIN" &>/dev/null; then
    echo "ERROR: '${TOOLBOX_BIN}' binary not found on PATH. Run ../../scripts/install_toolbox.sh to install."
    exit 1
fi

exec "$TOOLBOX_BIN" --tools-file "${DEMO_DIR}/tools.yaml" --stdio
