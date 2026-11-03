from __future__ import annotations

from decimal import Decimal
import pytest
from src.order_app.monolith_order_app import (
    InsufficientInventoryError,
    MonolithOrderApp,
    OrderLineItem,
    OrderRequest,
)


def test_place_order_usd_and_summary() -> None:
    app = MonolithOrderApp()
    req = OrderRequest(
        order_id="ord_1001",
        customer_id="cust_42",
        state_code="CA",
        currency="USD",
        items=(
            OrderLineItem(sku="OLJCESPC7Z", quantity=1),
            OrderLineItem(sku="66VCHSJNUP", quantity=1),
        ),
    )
    receipt = app.place_order(req)
    assert receipt.subtotal == Decimal("133.49")
    assert receipt.shipping == Decimal("17.54")
    assert receipt.tax == Decimal("11.01")
    assert receipt.total == Decimal("162.04")
    assert receipt.status == "CONFIRMED"

    summary = app.get_order_summary("ord_1001")
    assert summary.item_count == 2
    assert summary.total == Decimal("162.04")


def test_place_order_free_shipping_threshold() -> None:
    app = MonolithOrderApp()
    req = OrderRequest(
        order_id="ord_1002",
        customer_id="cust_99",
        state_code="TX",
        currency="USD",
        items=(
            OrderLineItem(sku="1YMWWN1N4O", quantity=2),  # 2 * 124.00 = 248.00
            OrderLineItem(sku="OLJCESPC7Z", quantity=1),  # + 67.99 = 315.99 (>= 250)
        ),
    )
    receipt = app.place_order(req)
    assert receipt.shipping == Decimal("0.00")


def test_place_order_currency_conversion_eur() -> None:
    app = MonolithOrderApp()
    req = OrderRequest(
        order_id="ord_1003",
        customer_id="cust_eu",
        state_code="NY",
        currency="EUR",
        items=(OrderLineItem(sku="OLJCESPC7Z", quantity=1),),
    )
    receipt = app.place_order(req)
    assert receipt.currency == "EUR"
    assert receipt.subtotal == Decimal("62.55")


def test_insufficient_inventory_rolls_back_cleanly() -> None:
    app = MonolithOrderApp()
    req = OrderRequest(
        order_id="ord_1004",
        customer_id="cust_over",
        state_code="CA",
        currency="USD",
        items=(
            OrderLineItem(sku="OLJCESPC7Z", quantity=2),
            OrderLineItem(sku="1YMWWN1N4O", quantity=5),  # Only 2 in stock!
        ),
    )
    with pytest.raises(InsufficientInventoryError) as exc_info:
        app.place_order(req)
    assert exc_info.value.sku == "1YMWWN1N4O"
