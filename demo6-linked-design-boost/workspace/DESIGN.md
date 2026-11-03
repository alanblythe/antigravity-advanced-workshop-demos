# Architectural & Data Contract Specification (`DESIGN.md`)

**Component:** Online Boutique — Order Discount & Promo Engine (`src/discountservice/`)  
**Status:** Active Architectural Contract

---

## 1. Domain Model & Typing Invariants
1. **Strict Decimal Precision:** All monetary values (`subtotal`, `discount_amount`, `final_total`, `rule_value`) MUST use Python's `decimal.Decimal` quantized to `Decimal("0.01")` with `ROUND_HALF_UP`. Floating-point (`float`) arithmetic is strictly prohibited.
2. **Immutable Data Contracts:** All domain models in `src/discountservice/models.py` MUST be `@dataclass(frozen=True)` using Python 3.11+ native type annotations (`str | None`, `tuple[str, ...]`).

---

## 2. Promo Evaluation & Stacking Rules
When evaluating multiple promo codes against an order `subtotal`:
1. **Deterministic Ordering:**
   - **Step 1 (`PERCENT` rules):** Apply all valid `PERCENT` promo codes first, ordered alphabetically by `code`. Each percentage discount is calculated against the original `subtotal` and rounded to `0.01` via `ROUND_HALF_UP`.
   - **Step 2 (`FIXED` rules):** Apply all valid `FIXED` voucher promo codes second, ordered alphabetically by `code`.
2. **Minimum Spend Gate (`min_subtotal`):** A promo rule is skipped (not applied) if `subtotal < rule.min_subtotal`.
3. **Duplicate Code Deduplication:** If the same promo code is passed multiple times in a single request, evaluate it only once.
4. **Maximum Discount Cap (`50%` Ceiling):**
   - Total combined discount across all stacked codes MUST NOT exceed **50% of `subtotal`** (`(subtotal * Decimal("0.50")).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)`).
   - If stacked discounts exceed the 50% cap, clamp `discount_amount` to the cap and set `cap_applied = True` on `DiscountResult`.

---

## 3. Executable Acceptance Criteria
Any implementation of `evaluate_stacked_promos(subtotal, codes, catalog)` in `src/discountservice/engine.py` must satisfy:
- **AC-1 (Single & Stacked Ordering):** Applying `SAVE10` (`10%`) and `TAKE15` (`$15.00` fixed) on a `$100.00` subtotal yields `discount_amount == Decimal("25.00")`, `final_total == Decimal("75.00")`, `applied_codes == ("SAVE10", "TAKE15")`, and `cap_applied is False`.
- **AC-2 (50% Cap Enforcement):** Applying `VIP40` (`40%`) and `TAKE25` (`$25.00` fixed) on a `$100.00` subtotal clamps `discount_amount` from `$65.00` to `Decimal("50.00")`, `final_total == Decimal("50.00")`, and `cap_applied is True`.
- **AC-3 (Min Subtotal & Deduplication):** Codes below `min_subtotal` are ignored, and duplicate codes in input (`["SAVE10", "SAVE10"]`) are applied at most once.
- **AC-4 (Float Rejection):** Passing a `float` as `subtotal` raises `TypeError`.
