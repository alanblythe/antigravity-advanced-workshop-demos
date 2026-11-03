# Demo 9: Clean-Context Adversarial Review Loop

> **Focus:** Adversarial review loops (`@adversarial-reviewer`) that stress-test "false-green" code against `@DESIGN.md` security, resiliency, and idempotency invariants and catch regressions before human PR review.

---

## Why This Demo Matters ("The False-Green Trap")

When you run `pytest` in this directory initially, **all 4 unit tests pass (`4 passed`)**.  
However, `src/settlement/dispatcher.py` contains **3 critical production regressions** that violate `@DESIGN.md`:
1. **§1 Resiliency Violation:** Uses fixed linear `self.sleep_fn(self.base_delay_sec)` instead of exponential backoff with full randomized jitter.
2. **§2 Security Violation:** Uses `provided_signature != expected` instead of constant-time `hmac.compare_digest()`, exposing a timing side-channel.
3. **§3 Idempotency / Outbox Violation:** Calls the external `self.webhook_client(event)` *before* recording the idempotency state in `settlement_ledger`.

---

## Live Demo Steps

1. Reset to the seeded "False-Green" state:
```bash
./start_demo.sh
```

2. Open the clean agent workspace (`workspace/`) and verify the "False-Green" test suite passes (`4 passed`):
```bash
cd workspace
pytest
```

3. Inside `workspace/`, invoke the clean-context **`@adversarial-reviewer`** subagent:
```text
Invoke @adversarial-reviewer to audit src/settlement/dispatcher.py and tests/test_dispatcher.py against @DESIGN.md and produce a falsifiable file:line invariant table.
```

4. Remediate all 3 blocking findings and add regression tests:
```text
/boost Fix all FAIL findings identified by @adversarial-reviewer in src/settlement/dispatcher.py, add regression tests in tests/test_dispatcher.py, and re-run @adversarial-reviewer to confirm 100% PASS.
```
