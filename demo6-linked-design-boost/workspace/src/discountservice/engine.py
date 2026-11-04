from __future__ import annotations

from decimal import Decimal, ROUND_HALF_UP
from src.discountservice.models import DiscountResult, PromoRule

CENT = Decimal("0.01")


def quantize_money(amount: Decimal) -> Decimal:
    """Quantize a Decimal amount to 2 decimal places using ROUND_HALF_UP."""
    return amount.quantize(CENT, rounding=ROUND_HALF_UP)


def apply_single_promo(
    subtotal: Decimal,
    code: str,
    catalog: dict[str, PromoRule],
) -> DiscountResult:
    """Apply a single promotional code to an order subtotal."""
    if not isinstance(subtotal, Decimal):
        raise TypeError("Monetary inputs must be Decimal")
    if subtotal < Decimal("0.00"):
        raise ValueError("Subtotal cannot be negative")

    clean_subtotal = quantize_money(subtotal)
    rule = catalog.get(code)
    if rule is None or clean_subtotal < rule.min_subtotal:
        return DiscountResult(
            subtotal=clean_subtotal,
            discount_amount=Decimal("0.00"),
            final_total=clean_subtotal,
            applied_codes=(),
            cap_applied=False,
        )

    if rule.kind == "PERCENT":
        raw_discount = quantize_money(clean_subtotal * (rule.value / Decimal("100")))
    else:
        raw_discount = quantize_money(rule.value)

    max_cap = quantize_money(clean_subtotal * Decimal("0.50"))
    cap_applied = raw_discount > max_cap
    discount = min(raw_discount, max_cap)

    return DiscountResult(
        subtotal=clean_subtotal,
        discount_amount=discount,
        final_total=clean_subtotal - discount,
        applied_codes=(rule.code,),
        cap_applied=cap_applied,
    )
