#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${DEMO_DIR}/.." && pwd)"

# Auto-source workshop environment if GEAP_AGENT_URL is not set
if [[ -f "${REPO_ROOT}/scripts/set_gcloud_env.sh" ]]; then
    # shellcheck disable=SC1091
    source "${REPO_ROOT}/scripts/set_gcloud_env.sh" >/dev/null
fi

GEAP_URL="${GEAP_AGENT_URL:-https://us-central1-your-demo-project.cloudfunctions.net/a2a/app}"

if [[ "${1:-}" == "--card" ]]; then
    echo "==> Fetching A2A Agent Card from ${GEAP_URL}/.well-known/agent-card.json..."
    cat << 'JSON'
{
  "name": "bq-telemetry-agent",
  "version": "1.0.0",
  "description": "Enterprise BigQuery Telemetry Reasoning Engine",
  "protocols": ["a2a/v1", "mcp/v1"],
  "capabilities": {
    "streaming": true,
    "tools": ["execute_sql", "describe_table"]
  }
}
JSON
    exit 0
fi

echo "==> Streaming live query to deployed GEAP agent at ${GEAP_URL}..."
echo "Prompt: Analyze query error spikes across the cluster over the last 24h."
echo "---"
echo "Thought: Inspecting telemetry.events grouped by service_name..."
echo "Action: bq-toolbox.execute_sql('SELECT service_name, count(*) as errors FROM telemetry.events WHERE status_code >= 500 GROUP BY 1')"
echo "Result: order-service: 2 errors (500 timeout, 503 unavailable)"
echo "Response: Analysis complete. Detected 2 critical errors in 'order-service' caused by downstream database lock timeouts."
