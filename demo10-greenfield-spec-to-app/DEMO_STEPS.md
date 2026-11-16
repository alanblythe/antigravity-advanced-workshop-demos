# Demo 10 Presenter Flight Plan: Greenfield Spec-to-App

> **Track:** Track B (Antigravity 201)  
> **Total Suggested Timing:** ~15 minutes (Spec: 3m, Handoff + `/clear`: 2m, Parallel Build + Adversarial Review: 5m, Live Server + `/browser` Async Verification: 5m)  
> **Fast Reset:** Run `./start_demo.sh` in `demo10-greenfield-spec-to-app/`.

---

## Demo 10: Hardware Warranty & RMA Eligibility Portal (Greenfield)

* **Suggested Timing:** ~15 minutes
* **Starting State:** `workspace/` contains **only** `AGENTS.md`, `.agents/skills/` (`create-spec`, `handoff`, `handoff-read`), and `.agents/agents/` (`backend-engineer`, `frontend-engineer`, `adversarial-reviewer`). Zero preseeded code or specs.

---

### Step 1: Author the Greenfield Specification (3 min)
* **Where to run:** Antigravity (`agy` / IDE) inside `demo10-greenfield-spec-to-app/workspace/`
* **Prompt:**
```text
Use the create-spec skill to write docs/specs/0001-rma-eligibility-portal.md for a Hardware Warranty & RMA Eligibility Portal. Include a 365-day warranty window (inclusive of the boundary day), strict serial format validation (e.g. HW-YYYY-XXXXXX), zero external dependencies (Python 3 stdlib + SQLite + vanilla HTML/CSS/JS), and a 4–5 second 3-step async verification pipeline (POST /api/rma returns 202 VERIFYING, GET /api/rma/<id> polls live progress). Do not write any app code yet.
```
* **Expected Result:**
  `docs/specs/0001-rma-eligibility-portal.md` is created with all 5 required sections (Purpose & Goal, Constraints & Guardrails, Do's & Don'ts, API & Data Contract, Acceptance Criteria). Zero `.py` or `.html` files exist yet.

---

### Step 2: Persist Handoff, Clear Context, & Resume Cold (2 min)
* **Where to run:** Same session inside `demo10-greenfield-spec-to-app/workspace/`
* **Prompt A (before `/clear`):**
```text
Use the handoff skill to save .scratch/_handoff.md so we can clear context before implementation.
```
* **Action:** Run `/clear` in the chat.
* **Prompt B (fresh session):**
```text
Use the handoff-read skill to resume from .scratch/_handoff.md.
```
* **Expected Result:**
  Fresh session reads `.scratch/_handoff.md` and `docs/specs/0001-rma-eligibility-portal.md` and immediately reports the active spec, completed state, and ready next step without re-exploring.

---

### Step 3: Parallel Scoped Build + Adversarial Review (5 min)
* **Where to run:** Fresh session inside `demo10-greenfield-spec-to-app/workspace/`
* **Prompt A (Parallel Build):**
```text
Dispatch @backend-engineer and @frontend-engineer in parallel to implement @docs/specs/0001-rma-eligibility-portal.md within their directory boundaries.
```
* **Expected Result:**
  - `@backend-engineer` creates `app.py`, `src/` modules, and `tests/` (`python3 -m unittest discover -s tests` passes).
  - `@frontend-engineer` creates `static/index.html`, `static/styles.css`, and `static/app.js` with the 3-step live progress bar.
* **Prompt B (Adversarial Review & Fix):**
```text
Invoke @adversarial-reviewer to audit app.py, src/, static/, and tests/ against @docs/specs/0001-rma-eligibility-portal.md. Fix any FAIL findings and re-run unit tests.
```
* **Expected Result:**
  `@adversarial-reviewer` checks boundary date math, serial validation, SQLi (`?` placeholders), async thread safety, and UI/backend contract parity. Any findings are patched and `python3 -m unittest discover -s tests` passes 100%.

---

### Step 4: Live Server & `/browser` 5-Second Async Pipeline Verification (5 min)
* **Where to run:** Same session inside `demo10-greenfield-spec-to-app/workspace/`
* **Prompt:**
```text
Start the server with `python3 app.py` on http://localhost:8000, then use /browser to open http://localhost:8000, submit a valid RMA request, wait 5 seconds while watching the 3-step verification progress bar animate live on screen, and confirm the final ELIGIBLE verdict and 0 browser console errors.
```
* **What to watch on screen:**
  1. Form submits `POST /api/rma` → receives `202 Accepted` (`VERIFYING`).
  2. Over the next **4–5 seconds**, the UI polls `GET /api/rma/<id>` and animates Steps 1 → 2 → 3 live on screen.
  3. Final `ELIGIBLE` verdict and explanation appear cleanly with **0 console errors**.
