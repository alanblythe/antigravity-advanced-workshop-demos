# Demo 10: Greenfield Spec-to-App (`create-spec` → `handoff` → Parallel Subagents → Browser Async Verification)

> **Focus:** End-to-end greenfield build of a **Hardware Warranty & RMA Eligibility Portal** from an empty workspace (`0` preseeded app or spec files), using spec-first planning (`create-spec`), clean context reset (`handoff` → `/clear` → `handoff-read`), parallel directory-scoped subagents (`@backend-engineer` + `@frontend-engineer`), read-only adversarial audit (`@adversarial-reviewer`), and live `/browser` verification of a **4–5 second 3-step async verification pipeline**.  
> 👉 **[DEMO_STEPS.md](./DEMO_STEPS.md)** — *Step-by-step presenter flight plan & talk tracks (~15 minutes).*

---

## Why This Demo Matters

Most AI coding demos start with an existing codebase. Greenfield builds expose different failure modes:
1. **Prompt-to-Code Drift:** Without a written API & data contract first, frontend and backend diverge on field names, HTTP status codes, and edge-case rules.
2. **Context Bloat:** Spec authoring fills the context window before implementation even starts. `handoff` → `/clear` → `handoff-read` resets to a clean context while preserving the exact spec and next step.
3. **Subagent Collisions:** `@backend-engineer` (`app.py`, `src/**`, `tests/**`) and `@frontend-engineer` (`static/**`) work in parallel with strict directory boundaries, followed by `@adversarial-reviewer` checking boundary date math, serial validation, SQLi, async race conditions, and UI/backend parity.
4. **Live Async UX Proof:** `POST /api/rma` returns `202 Accepted` (`VERIFYING`), and `/browser` watches the 3-step verification progress bar animate live over 4–5 seconds before asserting the final verdict and `0` console errors.

---

## Quick Reset

```bash
./start_demo.sh
```
Restores `workspace/` from `.seed/` (preserving the `workspace/` inode) with only `AGENTS.md`, `.agents/skills/`, and `.agents/agents/` — zero preseeded Python, HTML/JS, or spec files.
