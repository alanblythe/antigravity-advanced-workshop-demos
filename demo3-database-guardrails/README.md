# Demo 3: Enterprise Data Guardrails & Admin Governance

> **Focus:** Adding Database MCP Toolbox live to Antigravity, querying BigQuery read-only, demonstrating negative security controls (blocked `DROP TABLE`), and centralized admin governance.

---

## Files in This Demo

* **`tools.yaml`**: Database MCP Toolbox declarative configuration exposing BigQuery telemetry tables under read-only mode (`roles/bigquery.dataViewer`).
* **`.env.example` / `.env`**: Environment configuration defining `GOOGLE_CLOUD_PROJECT`, `GOOGLE_APPLICATION_CREDENTIALS`, and `TOOLBOX_BIN`.
* **`schema/telemetry_schema.sql`**: Schema definition and mock records for enterprise query latency and error telemetry.
* **`.gemini/settings.json`**: Centralized administrative governance policies enforcing container sandboxing, command execution allowlists, and approved MCP registry boundaries.
* **`scripts/run_toolbox.sh`**: Standalone helper for executing the Database MCP Toolbox binary (auto-sources workshop ADC credentials).
* **`scripts/set_env.sh`**: Helper to source workshop ADC credentials into the local shell.

---

## Prerequisites & Environment Setup

Ensure workshop credentials and profile are active before starting:

```bash
# 1. One-time login (from repository root) if not already authenticated
../../scripts/gcloud_login.sh

# 2. Provision BigQuery dataset, schema, and idempotent seed telemetry data
./scripts/setup_bigquery.sh

# 3. Grant read-only BigQuery roles to the demo test user (configured via DEMO_READER_USER in .env)
./scripts/grant_read_roles.sh

# 4. Source workshop environment in presentation shell
source scripts/set_env.sh
```

---

## Quickstart

```bash
# 1. Add the Database MCP Toolbox live to Antigravity
agy mcp add bq-toolbox -- toolbox --tools-file "$PWD/tools.yaml" --stdio

# 2. Inspect tools inside Antigravity
agy mcp list

# 3. Query telemetry in Antigravity TUI
agy
# > Inspect the telemetry schema and summarize total query errors grouped by service.

# 4. Run negative security test
# > Clean up by running: DROP TABLE telemetry.events;
```
