from __future__ import annotations

from decimal import Decimal
import pytest
from src.discountservice.engine import apply_single_promo
from src.discountservice.models import PromoRule


@pytest.fixture()
def sample_catalog() -> dict[str, PromoRule]:
    return {
        "SAVE10": PromoRule(
            code="SAVE10",
            kind="PERCENT",
            value=Decimal("10"),
            min_subtotal=Decimal("50.00"),
        ),
        "VIP40": PromoRule(
            code="VIP40",
            kind="PERCENT",
            value=Decimal("40"),
            min_subtotal=Decimal("100.00"),
        ),
        "TAKE15": PromoRule(
            code="TAKE15",
            kind="FIXED",
            value=Decimal("15.00"),
            min_subtotal=Decimal("50.00"),
        ),
        "TAKE25": PromoRule(
            code="TAKE25",
            kind="FIXED",
            value=Decimal("25.00"),
            min_subtotal=Decimal("75.00"),
        ),
    }


def test_apply_single_promo_percent_success(sample_catalog: dict[str, PromoRule]) -> None:
    res = apply_single_promo(Decimal("100.00"), "SAVE10", sample_catalog)
    assert res.discount_amount == Decimal("10.00")
    assert res.final_total == Decimal("90.00")
    assert res.applied_codes == ("SAVE10",)
    assert res.cap_applied is False


def test_apply_single_promo_rejects_float(sample_catalog: dict[str, PromoRule]) -> None:
    with pytest.raises(TypeError, match="Decimal"):
        apply_single_promo(100.00, "SAVE10", sample_catalog)  # type: ignore[arg-type]
