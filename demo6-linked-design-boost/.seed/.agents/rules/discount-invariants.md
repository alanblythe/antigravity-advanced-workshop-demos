---
trigger: model_decision
paths:
  - "src/discountservice/**"
description: Enforces docs/adr/0001-decimal-currency-and-discount-caps.md precision, frozen dataclasses, and 50% discount cap guardrails.
---

# Discount Service Path-Scoped Guardrails

- Reject `float` inputs immediately with `TypeError("Monetary inputs must be Decimal")`.
- Use `Decimal("0.01")` and `ROUND_HALF_UP` (via `quantize_money()`) for all currency calculations per `@docs/adr/0001-decimal-currency-and-discount-caps.md`.
- Enforce the `@docs/adr/0001-decimal-currency-and-discount-caps.md` §2.2 service-wide ceiling: total discount must never exceed 50% of `subtotal` (`cap_applied = True` when clamped).
