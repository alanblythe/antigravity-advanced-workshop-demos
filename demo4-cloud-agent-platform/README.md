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

1. Start and verify Demo 4 environment:
```bash
./start_demo.sh
```

2. Open the clean agent workspace (`workspace/`):
```bash
cd workspace
```

3. Inspect the pre-deployed agent's A2A Agent Card:
```bash
bash scripts/test_invoke.sh --card
```

4. Invoke the deployed GEAP agent from Antigravity TUI inside `workspace/`:
```bash
agy
```
Prompt inside `agy`:
```text
@cloud-telemetry-agent Analyze query error spikes across the cluster over the last 24h.
```

3. Inspect deployment recipe:
```bash
cat Dockerfile
```
```bash
cat scripts/deploy.sh
```
