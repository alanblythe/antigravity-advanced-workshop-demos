# Feature Specification: Stacked Promotional Code Evaluation (`SPEC.md`)

**Target Module:** `src/discountservice/engine.py`  
**Function Signature:**
```python
def evaluate_stacked_promos(
    subtotal: Decimal,
    codes: Sequence[str],
    catalog: dict[str, PromoRule],
) -> DiscountResult:
```

---

## 1. Functional Requirements
Implement `evaluate_stacked_promos(subtotal, codes, catalog)` to evaluate multiple promotional codes against an order `subtotal`:

1. **Deterministic Stacking Precedence:**
   - **Step 1 (`PERCENT` rules):** Evaluate all valid `PERCENT` promo codes first, ordered alphabetically by `code`. Each percentage discount is calculated against the original quantized `subtotal`.
   - **Step 2 (`FIXED` rules):** Evaluate all valid `FIXED` voucher promo codes second, ordered alphabetically by `code`.
2. **Minimum Spend Gate (`min_subtotal`):**
   - Skip any promo rule that is missing from `catalog` or where the quantized `subtotal < rule.min_subtotal`.
3. **Duplicate Code Deduplication:**
   - If the same promo code appears multiple times in `codes`, evaluate and record it in `applied_codes` at most once.
4. **Architectural Guardrail Compliance:**
   - Enforce all currency quantization, `float` rejection, and 50% maximum discount cap invariants defined in `@DESIGN.md`.

---

## 2. Acceptance Criteria
- **AC-1 (Stacked Precedence — `PERCENT` before `FIXED`):** Applying `["TAKE15", "SAVE10"]` (`SAVE10` = `10%`, `TAKE15` = `$15.00` fixed) on a `$100.00` subtotal evaluates `SAVE10` before `TAKE15`, yielding `discount_amount == Decimal("25.00")`, `final_total == Decimal("75.00")`, `applied_codes == ("SAVE10", "TAKE15")`, and `cap_applied is False`.
- **AC-2 (50% Ceiling Clamp):** Applying `["VIP40", "TAKE25"]` (`VIP40` = `40%`, `TAKE25` = `$25.00` fixed) on a `$100.00` subtotal clamps the `$65.00` combined discount to `discount_amount == Decimal("50.00")`, `final_total == Decimal("50.00")`, `applied_codes == ("VIP40", "TAKE25")`, and `cap_applied is True`.
- **AC-3 (Minimum Subtotal & Deduplication):** Codes whose `min_subtotal` exceeds `subtotal` are skipped, and duplicate codes in input (e.g., `["SAVE10", "SAVE10"]`) are applied only once.
- **AC-4 (Input Guardrails):** Passing a `float` (e.g., `100.00`) as `subtotal` raises `TypeError`, and passing a negative `Decimal` raises `ValueError` per `@DESIGN.md`.
