---
name: handoff
description: Persists active spec path, completed vs. pending items, exact commands, and next step to .scratch/_handoff.md before /clear.
---

# Session Handoff (`handoff`)

Use this skill before clearing context (`/clear`) so a fresh session can resume cold without re-discovering project state.

## Steps
1. Inspect the current workspace state (`docs/specs/*.md`, implemented files, and test status).
2. Write `.scratch/_handoff.md` with the following concise structure:
   - **Active Spec:** Exact path to the active specification (e.g., `docs/specs/0001-rma-eligibility-portal.md`).
   - **Completed:** Bullet list of artifacts/specs already written and verified.
   - **Pending:** Bullet list of remaining implementation, review, and verification tasks.
   - **Exact Commands:** Commands to run tests and start the server (`python3 -m unittest discover -s tests`, `python3 app.py`).
   - **Next Step:** The single immediate action for the next session (e.g., dispatch `@backend-engineer` and `@frontend-engineer` in parallel against the active spec).
3. Confirm to the user that `.scratch/_handoff.md` is saved and ready for `/clear`.
