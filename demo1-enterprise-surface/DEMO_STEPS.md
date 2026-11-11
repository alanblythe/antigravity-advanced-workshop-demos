# Demo 1 Presenter Flight Plan: Enterprise Surface, Open Standards & Context Hygiene

> **Track:** Track A (Module 1)  
> **Total Suggested Timing:** ~15 minutes (Demo 1A: ~8m, Demo 1B: ~7m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 1`**.

---

## Demo 1A: Enterprise Auth & Workspace Standardization

* **Suggested Timing:** ~8 minutes (2m Enterprise SSO, 2m CLI auth, 4m multi-tool rule harmonization)
* **Goal:** Resolve consumer IDE confusion by demonstrating enterprise login and establishing open standards (`AGENTS.md` and `.agents/rules/`).

### Step 1: Enterprise Login in VS Code
* **Where to run:** VS Code GUI (Accounts icon in lower left)
* **Action:** Click **Accounts** $\rightarrow$ **Antigravity: Sign In** $\rightarrow$ Select **"Use business or organization account"**.
* **Highlight:** Point out that enterprise SSO uses corporate Google Cloud credentials, not consumer Google accounts.

### Step 2: Enterprise CLI Login & Token Check
* **Where to run:** Workstation Terminal (`demo1-enterprise-surface/workspace/`)
* **Commands:**
```bash
agy login --enterprise
agy auth status
```
* **Expected Result:**
```text
Authenticated: user@enterprise.com (Enterprise SSO) | Project: workshop-demo-prj
```
* **Highlight:** Show verified corporate identity and active project binding.

### Step 3: Run Workspace Standardization
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo1-enterprise-surface/workspace/`
* **Prompt inside `agy`:**
```text
Run scripts/standardize.py in dry-run mode to audit existing Cursor and Claude rules, then apply the merge strategy to generate a canonical AGENTS.md and backward-compatible symlinks.
```
* **Expected Result:** Prints dry-run audit of `.cursorrules` and `CLAUDE.md`, generates canonical `AGENTS.md`, and creates backward-compatible symlinks (`.cursorrules -> AGENTS.md`, `CLAUDE.md -> AGENTS.md`, `GEMINI.md -> AGENTS.md`).
* **Highlight:** Point out how Antigravity detects existing **Cursor** (`.cursorrules`) and **Claude Code** (`CLAUDE.md`) configurations, merges them into the open Linux Foundation **`AGENTS.md`**, and generates backward-compatible symlinks (`.cursorrules -> AGENTS.md`, `CLAUDE.md -> AGENTS.md`, `GEMINI.md -> AGENTS.md`).

---

## Demo 1B: AST Code Graph & Model Routing

* **Suggested Timing:** ~7 minutes (4m AST symbol graph query, 3m model tier switching)
* **Goal:** Demonstrate navigating a multi-thousand-line codebase without sending massive token payloads to the model.

### Step 1: Query Function Callers via AST / MCP
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo1-enterprise-surface/workspace/`
* **Prompt inside `agy`:**
```text
Trace all callers of reconcile_transactions across the codebase using the code graph. Do not read the entire files.
```
* **Expected Result:** AST graph query returns 3 callers (`audit/dispute_handler.py:35`, `batch/nightly_sync.py:27`, `billing/checkout.py:35`) in <2k tokens without reading full files.
* **Highlight:** Antigravity calls the symbol graph tool (`ast-graph` / LSP), returning callers in <2k tokens instead of reading 50k tokens of whole files.

### Step 2: Switch Model Tier for Fast vs. Complex Tasks
* **Where to run:** Interactive Antigravity TUI (`agy`) inside `demo1-enterprise-surface/workspace/`
* **Command inside `agy`:**
```text
/models
```
* **Expected Result:** Interactive selector opens showing active model (`gemini-2.5-flash`) and available tiers (`gemini-2.5-pro`).
* **Action:** Toggle between `gemini-2.5-flash` (sub-second navigation) and `gemini-2.5-pro` (deep architectural synthesis).
