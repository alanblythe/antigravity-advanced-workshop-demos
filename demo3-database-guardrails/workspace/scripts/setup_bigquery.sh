#!/usr/bin/env bash
# ==============================================================================
# Demo 3: Setup & Seed BigQuery Telemetry Dataset
# ==============================================================================
# Idempotently provisions the BigQuery dataset, deploys the telemetry table
# schema, and seeds mock service telemetry records using schema/telemetry_schema.sql.
#
# Environment variables (.env):
#   GOOGLE_CLOUD_PROJECT : Target GCP Project (e.g. your-demo-project)
#   BIGQUERY_DATASET     : Target BigQuery Dataset (default: telemetry)
#   BIGQUERY_LOCATION    : Dataset location (default: us-central1)
#
# Arguments (optional overrides):
#   $1 : Target GCP Project ID
#   $2 : Target BigQuery Dataset name
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

# 2. Resolve parameters (CLI args take precedence over .env)
TARGET_PROJECT="${1:-${GOOGLE_CLOUD_PROJECT:-}}"
TARGET_DATASET="${2:-${BIGQUERY_DATASET:-telemetry}}"
TARGET_LOCATION="${BIGQUERY_LOCATION:-us-central1}"

if [[ -z "${TARGET_PROJECT}" ]]; then
    echo "ERROR: GOOGLE_CLOUD_PROJECT is not set." >&2
    echo "Set GOOGLE_CLOUD_PROJECT in ${DEMO_DIR}/.env or pass as argument 1." >&2
    exit 1
fi

SCHEMA_FILE="${DEMO_DIR}/schema/telemetry_schema.sql"
if [[ ! -f "${SCHEMA_FILE}" ]]; then
    echo "ERROR: Schema file not found at ${SCHEMA_FILE}" >&2
    exit 1
fi

echo "=============================================================================="
echo "Provisioning & Seeding BigQuery Telemetry Database"
echo "=============================================================================="
echo "Project  : ${TARGET_PROJECT}"
echo "Dataset  : ${TARGET_DATASET}"
echo "Location : ${TARGET_LOCATION}"
echo "Schema   : ${SCHEMA_FILE}"
echo "------------------------------------------------------------------------------"

# 3. Ensure Dataset Exists
if bq show "${TARGET_PROJECT}:${TARGET_DATASET}" &>/dev/null; then
    echo "✓ Dataset [${TARGET_PROJECT}:${TARGET_DATASET}] already exists."
else
    echo "Creating dataset [${TARGET_PROJECT}:${TARGET_DATASET}] in ${TARGET_LOCATION}..."
    bq --location="${TARGET_LOCATION}" mk \
        --dataset \
        --description="Enterprise service telemetry for Antigravity guardrails demo" \
        "${TARGET_PROJECT}:${TARGET_DATASET}"
    echo "✓ Dataset created."
fi

# 4. Deploy Schema & Idempotent Seed Data
echo "Applying schema and idempotent seed records via bq query..."
bq query \
    --project_id="${TARGET_PROJECT}" \
    --use_legacy_sql=false \
    < "${SCHEMA_FILE}"

echo "------------------------------------------------------------------------------"
echo "✓ Schema and seed data successfully initialized."
echo ""
echo "Verifying records in [${TARGET_PROJECT}.${TARGET_DATASET}.events]:"
bq query \
    --project_id="${TARGET_PROJECT}" \
    --use_legacy_sql=false \
    "SELECT event_id, service_name, operation, status_code, latency_ms, error_message FROM \`${TARGET_PROJECT}.${TARGET_DATASET}.events\` ORDER BY event_id"

echo "=============================================================================="
echo "BigQuery telemetry instance is ready for Database MCP Toolbox demo."
echo "=============================================================================="
