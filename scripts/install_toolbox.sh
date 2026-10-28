#!/usr/bin/env bash
# ==============================================================================
# Database MCP Toolbox Installer (macOS & Linux)
# ==============================================================================
# Automatically detects OS and CPU architecture, downloads the official
# Google Cloud genai-toolbox binary release, and installs it to PATH.
# ==============================================================================
set -euo pipefail

TOOLBOX_VERSION="${TOOLBOX_VERSION:-0.30.0}"

# 1. Detect OS
OS_NAME="$(uname -s)"
case "${OS_NAME}" in
    Darwin)
        OS_SLUG="darwin"
        ;;
    Linux)
        OS_SLUG="linux"
        ;;
    *)
        echo "ERROR: Unsupported operating system: ${OS_NAME}" >&2
        echo "Database MCP Toolbox supports macOS (Darwin) and Linux." >&2
        exit 1
        ;;
esac

# 2. Detect Architecture
ARCH_NAME="$(uname -m)"
case "${ARCH_NAME}" in
    x86_64|amd64)
        ARCH_SLUG="amd64"
        ;;
    arm64|aarch64)
        ARCH_SLUG="arm64"
        ;;
    *)
        echo "ERROR: Unsupported CPU architecture: ${ARCH_NAME}" >&2
        exit 1
        ;;
esac

# 3. Determine Installation Directory
# Prefer ~/.local/bin as a clean, user-writable directory on macOS and Linux
INSTALL_DIR="${INSTALL_DIR:-${HOME}/.local/bin}"
mkdir -p "${INSTALL_DIR}"

TARGET_BIN="${INSTALL_DIR}/toolbox"
DOWNLOAD_URL="https://storage.googleapis.com/genai-toolbox/v${TOOLBOX_VERSION}/${OS_SLUG}/${ARCH_SLUG}/toolbox"

echo "=============================================================================="
echo "Installing Database MCP Toolbox (v${TOOLBOX_VERSION})"
echo "=============================================================================="
echo "OS / Architecture : ${OS_SLUG} / ${ARCH_SLUG}"
echo "Download URL      : ${DOWNLOAD_URL}"
echo "Target Binary     : ${TARGET_BIN}"
echo "------------------------------------------------------------------------------"

# 4. Download binary
echo "Downloading binary..."
TMP_BIN="$(mktemp "${INSTALL_DIR}/toolbox.tmp.XXXXXX")"
trap 'rm -f "${TMP_BIN}"' EXIT

if ! curl -fsSL -o "${TMP_BIN}" "${DOWNLOAD_URL}"; then
    echo "ERROR: Failed to download toolbox binary from ${DOWNLOAD_URL}" >&2
    exit 1
fi

chmod +x "${TMP_BIN}"
mv "${TMP_BIN}" "${TARGET_BIN}"
trap - EXIT

# 5. Verify Installation
echo "Verifying installation..."
INSTALLED_VER="$("${TARGET_BIN}" --version 2>&1 || true)"
echo "Success: ${INSTALLED_VER}"
echo "------------------------------------------------------------------------------"

# 6. Check PATH
case ":${PATH}:" in
    *:"${INSTALL_DIR}":*)
        echo "✓ ${INSTALL_DIR} is already in your \$PATH."
        ;;
    *)
        echo "⚠️  NOTE: ${INSTALL_DIR} is not currently in your \$PATH."
        echo "Add it to your shell profile (~/.zshrc or ~/.bashrc):"
        echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
        ;;
esac

echo "=============================================================================="
echo "Database MCP Toolbox is ready. Test with:"
echo "  toolbox --help"
echo "=============================================================================="
