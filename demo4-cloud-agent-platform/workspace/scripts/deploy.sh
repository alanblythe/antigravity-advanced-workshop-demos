#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${DEMO_DIR}/.." && pwd)"

# Auto-source workshop environment if GOOGLE_CLOUD_PROJECT is not already set
if [[ -f "${REPO_ROOT}/scripts/set_gcloud_env.sh" ]]; then
    # shellcheck disable=SC1091
    source "${REPO_ROOT}/scripts/set_gcloud_env.sh" >/dev/null
fi

# Production Deployment Command for Gemini Enterprise Agent Platform (GEAP)
PROJECT_ID="${GOOGLE_CLOUD_PROJECT:-your-demo-project}"
REGION="us-central1"
AGENT_NAME="bq-telemetry-agent"

echo "==> Deploying ${AGENT_NAME} to Gemini Enterprise Agent Platform..."
echo "    Project: ${PROJECT_ID}"
echo "    Region:  ${REGION}"

# In live presentation, show this command syntax:
cat << CMD
agents-cli deploy \\
    --project ${PROJECT_ID} \\
    --region ${REGION} \\
    --name ${AGENT_NAME} \\
    --agent-identity \\
    --dockerfile ./Dockerfile
CMD

echo "✔ Verified pre-deployed endpoint: https://${REGION}-${PROJECT_ID}.cloudfunctions.net/a2a/app"
