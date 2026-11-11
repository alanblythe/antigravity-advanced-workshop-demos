# Demo 4 Presenter Flight Plan: Production Cloud Agent Platform & A2A Collaboration

> **Track:** Track A (Module 4)  
> **Total Suggested Timing:** ~12 minutes (A2A agent card: ~3m, container/ADK recipe: ~4m, live invocation: ~5m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 4`**.  
> **Prerequisites:** Workshop GCloud environment (`source ../scripts/set_gcloud_env.sh`).

---

## Demo 4: Local Antigravity Invoking Deployed Cloud Agent via A2A

* **Suggested Timing:** ~12 minutes
* **Goal:** Connect the developer workstation to a pre-warmed production agent deployed on Gemini Enterprise Agent Platform (GEAP).

### Step 1: Inspect the Production A2A Agent Card via Antigravity
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo4-cloud-agent-platform/workspace/`
* **Prompt inside `agy`:**
```text
Fetch and inspect the A2A agent card at $GEAP_AGENT_URL/.well-known/agent-card.json and summarize its capabilities, input schemas, and authentication scopes.
```
* **Expected Result:** Agent card parsed: lists agent capabilities, BigQuery query schemas, input/output schemas, and required ADC OAuth scopes.
* **Highlight:** Point out the open A2A contract: the cloud agent's declared capabilities, input schemas, and authentication scopes.

### Step 2: Show the Clean Container Deployment Recipe
* **Where to run:** VS Code Editor
* **Files to show:**
  * `demo4-cloud-agent-platform/workspace/Dockerfile` (bundling `toolbox` binary + `tools.yaml`)
  * `demo4-cloud-agent-platform/workspace/app/agent.py` (ADK `McpToolset` integration)
  * `demo4-cloud-agent-platform/workspace/scripts/deploy.sh` (`agents-cli deploy` flags)

### Step 3: Invoke the Cloud Agent from Local Antigravity
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo4-cloud-agent-platform/workspace/`
* **Prompt inside `agy`:**
```text
@cloud-telemetry-agent Analyze query error anomalies in the enterprise BigQuery cluster across the last 24 hours.
```
* **Expected Result:** Request routed over A2A bridge to GEAP; cloud agent queries BigQuery and streams back structured latency/error anomaly diagnosis in <3s.
* **What to watch on screen:**
  * Antigravity routes the request to `@cloud-telemetry-agent` via the configured subagent/A2A bridge.
  * The cloud reasoning engine executes in Google Cloud, securely queries BigQuery via its bundled `toolbox`, and streams structured reasoning back to the local TUI in <3 seconds.
* **Highlight:** The ultimate architectural payoff: local developer inner-loop seamlessly orchestrating with centralized enterprise cloud agents.
