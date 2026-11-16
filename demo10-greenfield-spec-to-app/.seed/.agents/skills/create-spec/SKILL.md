---
name: create-spec
description: Authors a contract-complete greenfield feature specification in docs/specs/<slug>.md before any application code is written.
---

# Create Specification (`create-spec`)

Use this skill whenever starting a greenfield feature or application in this repository. Do NOT write `app.py`, `src/`, `static/`, or `tests/` until the specification is written and approved.

## Workflow
1. Read `AGENTS.md` to confirm stack constraints and subagent directory boundaries.
2. Read `references/spec-template.md` in this skill directory.
3. Create `docs/specs/<slug>.md` (e.g., `docs/specs/0001-rma-eligibility-portal.md`) filling every section of the template with concrete, testable details:
   - **§1. Purpose & Goal:** Problem statement and user flow.
   - **§2. Constraints & Guardrails:** Zero external dependencies (Python 3 stdlib + vanilla HTML/CSS/JS), strict subagent directory boundaries (`@backend-engineer` vs `@frontend-engineer`), and server-side validation.
   - **§3. Do's & Don'ts:** Explicit architectural guardrails (parameterized SQLite queries, thread-safe DB access, no client-side-only validation).
   - **§4. API & Data Contract:** Exact SQLite schema, HTTP endpoints, status codes, JSON payloads, and the **~4–5 second 3-step async verification pipeline**:
     - `POST /api/rma` validates input synchronously, persists a `VERIFYING` record, starts a background worker thread, and returns `202 Accepted` with the `rma_id`.
     - `GET /api/rma/<id>` returns current `status`, `current_step` (1–3), `steps` array with per-step status, and final `verdict` (`ELIGIBLE` / `INELIGIBLE`) + `reason` once complete.
   - **§5. Acceptance Criteria:** Checkboxes covering boundary date math, invalid serial rejection, and the 4–5s live async UI progress transition.
4. Summarize the created spec path and key contract decisions for the user.
