---
trigger: model_decision
paths:
  - "src/discountservice/**"
description: Enforces DESIGN.md decimal precision, frozen dataclasses, and 50% maximum discount cap invariants for src/discountservice.
---

# Discount Service Path-Scoped Invariants

- Reject `float` inputs immediately with `TypeError("Monetary inputs must be Decimal")`.
- Use `Decimal("0.01")` and `ROUND_HALF_UP` (via `quantize_money()`) for all currency calculations per `@DESIGN.md`.
- Enforce the `@DESIGN.md` §2.2 service-wide ceiling: total discount must never exceed 50% of `subtotal` (`cap_applied = True` when clamped).
