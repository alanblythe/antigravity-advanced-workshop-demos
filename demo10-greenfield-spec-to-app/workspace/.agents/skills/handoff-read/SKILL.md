---
name: handoff-read
description: Reads .scratch/_handoff.md and docs/specs/*.md on a fresh session start to resume cold.
---

# Resume from Handoff (`handoff-read`)

Use this skill immediately after `/clear` or when starting a fresh session to pick up cold without re-exploring the repository.

## Steps
1. Read `.scratch/_handoff.md` in full.
2. Read the active specification referenced in `.scratch/_handoff.md` (under `docs/specs/*.md`) and `AGENTS.md`.
3. Present a concise 4-line summary to the user:
   - **Active Spec:** `<path>`
   - **Completed:** `<summary>`
   - **Pending:** `<summary>`
   - **Ready for Next Step:** `<immediate action>`
4. Proceed directly to executing the next step if instructed.
