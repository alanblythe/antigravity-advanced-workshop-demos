#!/usr/bin/env bash
# ==============================================================================
# Demo 3: Grant BigQuery Read-Only IAM Roles
# ==============================================================================
# Idempotently grants read-only BigQuery permissions (roles/bigquery.dataViewer
# and roles/bigquery.jobUser) to a specified developer/tester user on the target
# demo project.
#
# Environment variables (.env):
#   GOOGLE_CLOUD_PROJECT : Target GCP Project (e.g. your-demo-project)
#   DEMO_READER_USER     : Target user email (e.g. dev1@example.com)
#
# Arguments (optional overrides):
#   $1 : Target user email
#   $2 : Target GCP Project ID
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${DEMO_DIR}/.." && pwd)"

# 1. Load environment variables from .env if present
if [[ -f "${DEMO_DIR}/.env" ]]; then
    # shellcheck disable=SC1091
    source "${DEMO_DIR}/.env"
elif [[ -f "${REPO_ROOT}/.env" ]]; then
    # shellcheck disable=SC1091
    source "${REPO_ROOT}/.env"
fi

# 2. Resolve target user and project (CLI args take precedence over .env)
TARGET_USER="${1:-${DEMO_READER_USER:-${GCLOUD_USER:-}}}"
TARGET_PROJECT="${2:-${GOOGLE_CLOUD_PROJECT:-}}"

if [[ -z "${TARGET_PROJECT}" ]]; then
    echo "ERROR: GOOGLE_CLOUD_PROJECT is not set." >&2
    echo "Set GOOGLE_CLOUD_PROJECT in ${DEMO_DIR}/.env or pass as argument 2." >&2
    exit 1
fi

if [[ -z "${TARGET_USER}" ]]; then
    echo "ERROR: Target user email is not set." >&2
    echo "Set DEMO_READER_USER in ${DEMO_DIR}/.env or pass as argument 1." >&2
    exit 1
fi

echo "=============================================================================="
echo "Assigning BigQuery Read-Only Guardrail Roles"
echo "=============================================================================="
echo "Project : ${TARGET_PROJECT}"
echo "User    : ${TARGET_USER}"
echo "Roles   : roles/bigquery.dataViewer"
echo "          roles/bigquery.jobUser"
echo "------------------------------------------------------------------------------"

# 3. Apply IAM Bindings
ROLES=(
    "roles/bigquery.dataViewer"
    "roles/bigquery.jobUser"
)

for ROLE in "${ROLES[@]}"; do
    echo "Granting ${ROLE}..."
    gcloud projects add-iam-policy-binding "${TARGET_PROJECT}" \
        --member="user:${TARGET_USER}" \
        --role="${ROLE}" \
        --condition=None \
        --quiet >/dev/null
done

echo "------------------------------------------------------------------------------"
echo "✓ IAM roles successfully assigned."
echo ""
echo "Verifying active policy bindings on [${TARGET_PROJECT}]:"
gcloud projects get-iam-policy "${TARGET_PROJECT}" \
    --flatten="bindings[].members" \
    --format="table(bindings.role, bindings.members)" \
    --filter="bindings.members:user:${TARGET_USER}"

echo "=============================================================================="
