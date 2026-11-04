# Demo 4: Production Cloud Agent Platform & A2A Collaboration

> **Focus:** Containerizing an ADK agent bundling Database MCP Toolbox, deploying to Gemini Enterprise Agent Platform (GEAP), and invoking the cloud agent from local Antigravity via Agent-to-Agent (A2A).

---

## Files in This Demo

* **`Dockerfile`**: Production container specification packaging Python 3.11, Google ADK, and Database MCP Toolbox binary.
* **`app/agent.py`**: ADK agent reasoning engine exposing telemetry diagnosis via `McpToolset`.
* **`tools.yaml`**: MCP Toolbox configuration bundled inside the container.
* **`.env.example` / `.env`**: Environment configuration defining `GOOGLE_CLOUD_PROJECT`, `GOOGLE_APPLICATION_CREDENTIALS`, and `GEAP_AGENT_URL`.
* **`.agents/agents/cloud-telemetry-agent.md`**: Local Antigravity subagent definition enabling local developers to query the deployed GEAP agent.
* **`scripts/deploy.sh`**: Production deployment command using `agents-cli deploy` (auto-sources workshop environment).
* **`scripts/test_invoke.sh`**: Verification script checking `agent-card.json` and streaming queries (auto-sources workshop environment).
* **`scripts/set_env.sh`**: Helper to source workshop ADC credentials into the local shell.

---

## Prerequisites & Environment Setup

Ensure workshop credentials and profile are active before starting:

1. One-time login (from repository root) if not already authenticated:
```bash
../../scripts/gcloud_login.sh
```

2. Source workshop environment in presentation shell:
```bash
source scripts/set_env.sh
```

---

## Quickstart

1. Reset and launch `agy` inside `workspace/` (or use VS Code Task **`Reset & Open: Demo 4`**):
```bash
source scripts/set_env.sh && ./start_demo.sh && cd workspace && agy
```

2. Inspect the pre-deployed agent's A2A Agent Card inside `agy`:
```text
Fetch and inspect the A2A agent card at $GEAP_AGENT_URL/a2a/app/.well-known/agent-card.json and summarize its capabilities, input schemas, and authentication scopes.
```

3. Invoke the deployed GEAP agent from Antigravity inside `agy`:
```text
@cloud-telemetry-agent Analyze query error anomalies in the enterprise BigQuery cluster across the last 24 hours.
```
