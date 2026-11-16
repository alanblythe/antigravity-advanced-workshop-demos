# Spec <NNNN>: <Feature Title>

## 1. Purpose & Goal
- **Problem:** <What problem this solves and who uses it>
- **Primary User Flow:** <End-to-end flow from form submission to final result>

## 2. Constraints & Guardrails
- **Zero External Dependencies:** Python 3 stdlib (`http.server`, `sqlite3`, `threading`, `json`, `datetime`) and vanilla HTML/CSS/JS only.
- **Directory Boundaries:**
  - `@backend-engineer`: `app.py`, `src/**`, `tests/**` only.
  - `@frontend-engineer`: `static/**` only.
- **Server-Side Validation:** All serial format checks, purchase date bounds, and warranty eligibility math MUST execute on the server.

## 3. Do's & Don'ts
- **Do:** Use parameterized SQLite queries (`?` placeholders) and thread-safe DB connections/locks.
- **Do:** Return `202 Accepted` immediately from `POST /api/rma` and execute the 3-step verification asynchronously over ~4–5 seconds so the UI can animate live progress.
- **Don't:** Use `pip`, `npm`, external CDNs, or string-interpolated SQL.
- **Don't:** Trust client-supplied eligibility verdicts or block the HTTP request thread for 5 seconds.

## 4. API & Data Contract

### 4.1 SQLite Schema (`rma_requests`)
| Column | Type | Notes |
| --- | --- | --- |
| `id` | `TEXT PRIMARY KEY` | UUID or `RMA-<hex>` |
| `serial_number` | `TEXT NOT NULL` | Normalized uppercase serial |
| `product_sku` | `TEXT NOT NULL` | Hardware SKU / model |
| `purchase_date` | `TEXT NOT NULL` | ISO-8601 `YYYY-MM-DD` |
| `issue_description` | `TEXT NOT NULL` | Customer issue summary |
| `status` | `TEXT NOT NULL` | `VERIFYING` \| `COMPLETED` |
| `current_step` | `INTEGER NOT NULL` | `1`, `2`, or `3` |
| `steps_json` | `TEXT NOT NULL` | JSON array of 3 pipeline step states |
| `verdict` | `TEXT` | `ELIGIBLE` \| `INELIGIBLE` \| `NULL` while verifying |
| `reason` | `TEXT` | Human-readable eligibility explanation |
| `created_at` | `TEXT NOT NULL` | UTC ISO-8601 timestamp |

### 4.2 Endpoints
- `GET /` — Serves `static/index.html` (plus `static/*` assets).
- `POST /api/rma` — Validates `serial_number`, `product_sku`, `purchase_date`, `issue_description`.
  - Invalid input → `400 Bad Request` (`{"error": "..."}`).
  - Valid input → Inserts `VERIFYING` row, launches ~4.5s background 3-step pipeline, returns `202 Accepted`:
    ```json
    {
      "id": "RMA-...",
      "status": "VERIFYING",
      "current_step": 1,
      "steps": [
        {"step": 1, "name": "Serial Registry Check", "state": "in_progress"},
        {"step": 2, "name": "Warranty Window Calculation", "state": "pending"},
        {"step": 3, "name": "RMA Eligibility Verdict", "state": "pending"}
      ]
    }
    ```
- `GET /api/rma/<id>` — Polls current pipeline state (`200 OK`, or `404 Not Found` if unknown ID).

### 4.3 3-Step Async Verification Pipeline (~4.5s total)
1. **Step 1 (~1.5s):** Serial Registry & Format Verification
2. **Step 2 (~1.5s):** Purchase Date & Warranty Window Boundary Calculation (e.g., 365-day standard warranty inclusive of boundary day)
3. **Step 3 (~1.5s):** Final RMA Eligibility Verdict (`ELIGIBLE` or `INELIGIBLE`) + persisted reason

## 5. Acceptance Criteria
- [ ] **Boundary Date Math:** Purchase date exactly at warranty boundary (e.g., 365 days ago) is handled deterministically and consistently; future purchase dates or dates beyond the warranty window are rejected/marked `INELIGIBLE`.
- [ ] **Invalid Serial Rejection:** Malformed or empty serial numbers return `400 Bad Request` from `POST /api/rma` without creating a DB row.
- [ ] **4–5s Async UI Transition:** Submitting a valid RMA returns `202` immediately; the UI renders a 3-step progress bar that animates live across all 3 steps over ~4–5 seconds via `GET /api/rma/<id>` polling before displaying the final `ELIGIBLE` / `INELIGIBLE` verdict with `0` console errors.
- [ ] **Directory & Dependency Compliance:** Zero external packages; `@backend-engineer` touches only `app.py`/`src/`/`tests/`, `@frontend-engineer` touches only `static/`.
