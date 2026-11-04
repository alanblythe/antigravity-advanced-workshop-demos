---
trigger: model_decision
paths:
  - "src/discountservice/**"
description: Enforces DESIGN.md decimal precision, frozen dataclasses, and 50% maximum discount cap invariants for src/discountservice.
---

# Discount Service Path-Scoped Invariants

- Reject `float` inputs immediately with `TypeError("Monetary inputs must be Decimal")`.
- Use `Decimal("0.01")` and `ROUND_HALF_UP` for all currency calculations.
- Enforce the `@DESIGN.md` §2 stacking order: `PERCENT` rules (sorted by code) before `FIXED` rules (sorted by code), capped at 50% of `subtotal`.
