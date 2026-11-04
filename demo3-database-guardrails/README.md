# Demo 3: Enterprise Data Guardrails & Admin Governance

> **Focus:** Declarative Database MCP Toolbox configuration committed in-repo, querying BigQuery read-only via MCP, demonstrating negative security controls (blocked `DROP TABLE`), and centralized admin governance.

---

## Files in This Demo

* **`.mcp.json` / `.gemini/mcp_config.json`**: Repository-scoped MCP configurations exposing the Database MCP Toolbox (`bq-toolbox`) using local `tools.yaml`.
* **`tools.yaml`**: Database MCP Toolbox declarative configuration exposing BigQuery telemetry tables under read-only mode (`roles/bigquery.dataViewer`).
* **`.env.example` / `.env`**: Environment configuration defining `GOOGLE_CLOUD_PROJECT`, `GOOGLE_APPLICATION_CREDENTIALS`, and `TOOLBOX_BIN`.
* **`schema/telemetry_schema.sql`**: Schema definition and mock records for enterprise query latency and error telemetry.
* **`.gemini/settings.json`**: Centralized administrative governance policies enforcing container sandboxing, command execution allowlists, and approved MCP registry boundaries.
* **`scripts/run_toolbox.sh`**: Standalone helper for executing the Database MCP Toolbox binary (auto-sources workshop ADC credentials).
* **`scripts/set_env.sh`**: Helper to source workshop ADC credentials into the local shell.

---

## Prerequisites & Environment Setup

Ensure workshop credentials and profile are active before starting:

1. One-time login (from repository root) if not already authenticated:
```bash
../scripts/gcloud_login.sh
```

2. Provision BigQuery dataset, schema, and idempotent seed telemetry data:
```bash
./scripts/setup_bigquery.sh
```

3. Grant read-only BigQuery roles to the demo test user (configured via DEMO_READER_USER in .env):
```bash
./scripts/grant_read_roles.sh
```

4. Source workshop environment in presentation shell:
```bash
source scripts/set_env.sh
```

---

## Quickstart

1. Start and verify Demo 3 environment:
```bash
./start_demo.sh
```

2. Open the clean agent workspace (`workspace/`):
```bash
cd workspace
```
*(The Database MCP Toolbox is already registered and committed via `.mcp.json` and `.gemini/mcp_config.json` inside `workspace/`.)*

3. Query telemetry in Antigravity TUI inside `workspace/`:
```bash
agy
```
Prompt inside `agy`:
```text
Inspect the telemetry schema and summarize total query errors grouped by service, including the wall-clock time it takes to call the MCP server for the results.
```

3. Run negative security test inside `agy`:
```text
Clean up by running: DROP TABLE telemetry.events;
```
