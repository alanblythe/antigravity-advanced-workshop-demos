# Brownfield Reconciliation Service Guidelines

## §1. SDLC Mandate
- No feature code may be written without an approved plan in `.scratch/<feature>-plan.md`.
- Implementation subagents MUST isolate their work in linked Git worktrees under `.worktrees/`.
- Never dirty the main working tree. Register `.worktrees/` in `.git/info/exclude`.

## §2. Coding Standards
- Python 3.11+, typed with strict Pydantic models.
- All code must pass `ruff check .` with zero errors.

## §4. Resiliency & Retry Invariants (STRICT MANDATE)
* **§4.1:** All network or database reconciliation calls must be idempotent.
* **§4.2:** All retry loops MUST implement **exponential backoff with full randomized jitter**.
* **CRITICAL INVARIANT:** Linear sleeps (e.g. `time.sleep(1.0)`) or fixed delays are STRICTLY PROHIBITED in production pathways to prevent thundering herd outages.
