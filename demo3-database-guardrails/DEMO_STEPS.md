# Demo 3 Presenter Flight Plan: Enterprise Data Guardrails & Admin Governance

> **Track:** Track A (Module 3)  
> **Total Suggested Timing:** ~12 minutes (MCP config: ~3m, read-only query: ~4m, blocked DROP TABLE: ~3m, governance config: ~2m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 3`**.  
> **GCloud Setup (for live GCP calls):** Sourced via `source ../scripts/set_gcloud_env.sh` (or from repo root `./scripts/gcloud_login.sh`).

---

## Demo 3: In-Repo Database MCP Toolbox & Safe Querying

* **Suggested Timing:** ~12 minutes
* **Goal:** Demonstrate repository-committed MCP configuration, querying BigQuery read-only, and verifying negative security controls.

### Step 1: Inspect Repository-Scoped MCP Configuration
* **Where to run:** VS Code Editor (`demo3-database-guardrails/workspace/`)
* **Files to show:**
  * `workspace/.mcp.json` (and `workspace/.gemini/mcp_config.json`)
  * `workspace/tools.yaml`
* **Highlight:** Point out that the MCP server (`bq-toolbox`) is pre-configured and committed directly in `workspace/.mcp.json`, making read-only BigQuery tools immediately available to Antigravity without manual CLI registration or polluting global user configs.

### Step 2: Query Telemetry Data via Antigravity Agent
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo3-database-guardrails/workspace/`
* **Prompt inside `agy`:**
```text
Using bq-toolbox, inspect the telemetry dataset schema and calculate the average query latency grouped by status code for today.
```
* **Expected Result:** Queries table schema via `bq-toolbox`, runs read-only SQL, and displays aggregated table of status codes (200, 404, 500) and average latencies.
* **Highlight:** Antigravity calls `bq-toolbox.describe_table`, writes the read-only SQL, executes it against BigQuery, and synthesizes the table results live.

### Step 3: Run the Negative Security Test
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo3-database-guardrails/workspace/`
* **Prompt inside `agy`:**
```text
Clear the telemetry events table to reset the test environment: DROP TABLE telemetry.events;
```
* **Expected Result:**
```text
ERROR: PERMISSION_DENIED: Service account roles/bigquery.dataViewer cannot execute DDL/DROP statements.
Database MCP Toolbox policy blocks destructive SQL operations.
```
* **Highlight:** Point out the non-negotiable guardrail: even if an LLM is prompted to drop tables, the IAM boundary and MCP schema render destructive operations impossible.

### Step 4: Show Centralized Admin Governance Config
* **Where to run:** VS Code Editor
* **File to show:** `demo3-database-guardrails/workspace/.gemini/settings.json`
* **Highlight:** Show enterprise allowlist/denylist rules governing terminal commands, container sandboxing, and approved MCP registries.
