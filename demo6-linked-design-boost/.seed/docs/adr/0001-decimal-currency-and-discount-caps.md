# Architectural Decision Record: Decimal Precision & Discount Cap Guardrails (`0001-decimal-currency-and-discount-caps.md`)

**Component:** Online Boutique — Order Discount & Promo Service (`src/discountservice/`)  
**Scope:** Long-Lived Service Architecture, Domain Invariants & Verification Procedures

---

## 1. Currency & Numeric Invariants
1. **Strict Decimal Precision:** All monetary values (`subtotal`, `discount_amount`, `final_total`, `rule.value`, `rule.min_subtotal`) MUST use Python's `decimal.Decimal` quantized to `Decimal("0.01")` with `ROUND_HALF_UP` (via `quantize_money()`).
2. **Floating-Point Prohibition:** Floating-point (`float`) inputs are strictly prohibited in financial paths. Any public entrypoint receiving a non-`Decimal` monetary input MUST immediately raise `TypeError("Monetary inputs must be Decimal")`.
3. **Non-Negative Subtotals:** Negative order subtotals (`subtotal < Decimal("0.00")`) MUST raise `ValueError("Subtotal cannot be negative")`.

---

## 2. Domain Model & Safety Boundaries
1. **Immutable Data Contracts:** All domain models in `src/discountservice/models.py` (`PromoRule`, `DiscountResult`) MUST remain `@dataclass(frozen=True)` using Python 3.11+ native type annotations (`tuple[str, ...]`, `Literal`).
2. **Service-Wide Maximum Discount Ceiling (50% Cap):**
   - No single promotion or combination of promotions may ever reduce an order by more than **50% of `subtotal`** (`quantize_money(subtotal * Decimal("0.50"))`).
   - Whenever an un-clamped discount exceeds this 50% ceiling, the engine MUST clamp `discount_amount` to the ceiling and set `cap_applied = True` on `DiscountResult`.

---

## 3. Verification & Testing Procedures
1. **Test Runner:** Execute the unit test suite via `.venv/bin/pytest`.
2. **Syntax & Bytecode Gate:** Run `python3 -m py_compile` on all modified source and test files.
3. **Required Coverage:** Every new engine capability must include unit tests verifying:
   - Exact `Decimal("0.01")` quantization and `ROUND_HALF_UP` behavior.
   - Enforcement of the 50% maximum discount ceiling (`cap_applied=True` vs. `False`).
   - Rejection of `float` inputs with `TypeError`.
