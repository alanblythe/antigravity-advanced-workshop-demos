from __future__ import annotations

from dataclasses import dataclass
from decimal import Decimal
from typing import Literal

PromoKind = Literal["PERCENT", "FIXED"]


@dataclass(frozen=True)
class PromoRule:
    """Immutable promotional discount definition."""

    code: str
    kind: PromoKind
    value: Decimal
    min_subtotal: Decimal = Decimal("0.00")


@dataclass(frozen=True)
class DiscountResult:
    """Immutable result of evaluating promotional codes against an order subtotal."""

    subtotal: Decimal
    discount_amount: Decimal
    final_total: Decimal
    applied_codes: tuple[str, ...]
    cap_applied: bool = False
