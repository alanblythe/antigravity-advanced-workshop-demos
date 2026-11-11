# Demo 9 Presenter Flight Plan: Clean-Context Adversarial Review Loop

> **Track:** Track B (Antigravity 201)  
> **Total Suggested Timing:** ~12 minutes ("False-Green" demo: ~2m, Clean-context audit: ~5m, Boost remediation: ~5m)  
> **Fast Reset:** Run `./start_demo.sh` in this folder, or run VS Code Task **`Reset & Open: Demo 9`**.

---

## Demo 9: Clean-Context Adversarial Review Loop

* **Suggested Timing:** ~12 minutes
* **Goal:** Demonstrate why passing unit tests (`4 passed` — "False Green") are not enough, and how a clean-context **`@adversarial-reviewer`** subagent catches 3 subtle security, resiliency, and outbox ordering regressions against `docs/adr/0001-payment-webhook-and-settlement-guardrails.md` before human code review.

### Step 1: Show the "False-Green" Test Suite (`4 passed`)
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo9-adversarial-review-loop/workspace/`
* **Prompt inside `agy`:**
```text
Run pytest.
```
* **Expected Result:**
```text
==================== 4 passed in 0.02s ==================== (False Green)
```
* **Highlight:** `pytest` passes 100% (`4 passed`), giving the author a false sense of security.

### Step 2: Run the Clean-Context `@adversarial-reviewer` Subagent
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo9-adversarial-review-loop/workspace/`
* **Prompt inside `agy`:**
```text
Invoke @adversarial-reviewer to audit src/settlement/dispatcher.py and tests/test_dispatcher.py against @docs/adr/0001-payment-webhook-and-settlement-guardrails.md and produce a production guardrail table with file:line proof.
```
* **Expected Result:** Audit outputs production guardrail table with 3 FAIL findings: linear backoff (`dispatcher.py:85`), non-constant-time HMAC compare (`dispatcher.py:55`), and outbox order reversal (`dispatcher.py:78-98`).
* **What to watch on screen:**
  `@adversarial-reviewer` inspects `src/settlement/dispatcher.py` with zero authoring bias and flags **3 `FAIL` rows** in its production guardrail table:
  1. **§1 Resiliency (`FAIL` at `dispatcher.py:85`):** Linear `self.sleep_fn(self.base_delay_sec)` instead of exponential backoff with full randomized jitter.
  2. **§2 Security (`FAIL` at `dispatcher.py:55`):** `provided_signature != expected` instead of constant-time `hmac.compare_digest()`.
  3. **§3 Idempotency / Outbox (`FAIL` at `dispatcher.py:78-98`):** Invokes external `self.webhook_client(event)` *before* recording the idempotency state in `settlement_ledger`.

### Step 3: Remediate All 3 Findings & Re-Verify
* **Where to run:** Antigravity 2.0 / `agy` CLI inside `demo9-adversarial-review-loop/workspace/`
* **Prompt inside `agy`:**
```text
/boost Fix all FAIL findings identified by @adversarial-reviewer in src/settlement/dispatcher.py, add regression tests in tests/test_dispatcher.py, and re-run @adversarial-reviewer to confirm 100% PASS.
```
* **Expected Result:**
```text
Applies fixes to dispatcher.py; adds 3 regression tests in test_dispatcher.py; re-audit reports 100% PASS; pytest passes:
==================== 7 passed in 0.05s ====================
```
