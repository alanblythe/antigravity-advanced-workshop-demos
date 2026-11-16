# Hardware Warranty & RMA Eligibility Portal — Greenfield Guidelines

## §1. Zero-Dependency Stack
- **Backend:** Python 3 standard library only (`http.server`, `sqlite3`, `threading`, `json`, `datetime`, `re`, `uuid`, `unittest`). Do NOT install or import third-party packages (`flask`, `fastapi`, `pytest`, `requests`, etc.).
- **Frontend:** Vanilla HTML5, CSS3, and ES6+ JavaScript served from `static/`. No Node, npm, or external CDN scripts.
- **Entrypoint:** `python3 app.py` serving `http://localhost:8000`.

## §2. Spec-Driven Greenfield Workflow
- **Spec First:** Before writing any application code, follow `.agents/skills/create-spec/SKILL.md` to author `docs/specs/<slug>.md` (e.g., `docs/specs/0001-rma-eligibility-portal.md`).
- **Context Handoff:** Before clearing context (`/clear`), follow `.agents/skills/handoff/SKILL.md` to persist `.scratch/_handoff.md`. On a fresh session, follow `.agents/skills/handoff-read/SKILL.md` to resume cold.

## §3. Subagent Directory Boundaries
- **`@backend-engineer`:** Owns `app.py`, `src/**`, and `tests/**`. Strictly forbidden from creating or editing `static/**`.
- **`@frontend-engineer`:** Owns `static/**`. Strictly forbidden from creating or editing `app.py`, `src/**`, or `tests/**`.
- **`@adversarial-reviewer`:** Read-only auditor. Verifies implementation parity against `docs/specs/*.md` without editing files.

## §4. Verification Gate
- Run `python3 -m py_compile app.py` (and any `src/**/*.py` files) plus `python3 -m unittest discover -s tests` to verify backend logic.
- Verify the live UI at `http://localhost:8000` with zero uncaught browser console errors.
