from __future__ import annotations

import pytest
from src.inventoryservice.models import (
    InsufficientStockError,
    ReservationItem,
    ReservationRequest,
)
from src.inventoryservice.reservator import InventoryReservator


def test_reserve_single_available_sku_succeeds() -> None:
    svc = InventoryReservator()
    req = ReservationRequest(
        reservation_id="res_100",
        items=(ReservationItem(sku="OLJCESPC7Z", quantity=2),),
        ttl_seconds=300,
    )
    res = svc.reserve_cart(req, now_epoch=1700000000)
    assert res.reserved_skus == ("OLJCESPC7Z",)
    assert res.expires_at == 1700000300
    assert res.idempotent_replay is False
    assert svc.get_available_qty("OLJCESPC7Z") == 3


def test_reclaims_expired_holds_before_checking_stock() -> None:
    """Contract AC-1: Expired hold on 1YMWWN1N4O (expires_at=1700000100, qty=3)
    must be reclaimed when now_epoch >= 1700000100.
    """
    svc = InventoryReservator()
    req = ReservationRequest(
        reservation_id="res_101",
        items=(ReservationItem(sku="1YMWWN1N4O", quantity=2),),
    )
    res = svc.reserve_cart(req, now_epoch=1700000200)
    assert res.reserved_skus == ("1YMWWN1N4O",)
    assert svc.get_available_qty("1YMWWN1N4O") == 1


def test_atomic_rollback_when_second_sku_insufficient() -> None:
    """Contract AC-2: If the 2nd item in a cart fails stock check, the 1st item
    must NOT have its stock deducted.
    """
    svc = InventoryReservator()
    req = ReservationRequest(
        reservation_id="res_102",
        items=(
            ReservationItem(sku="OLJCESPC7Z", quantity=2),
            ReservationItem(sku="66VCHSJNUP", quantity=10),  # Only 2 in stock!
        ),
    )
    with pytest.raises(InsufficientStockError) as exc_info:
        svc.reserve_cart(req, now_epoch=1700000000)
    assert exc_info.value.sku == "66VCHSJNUP"
    # First SKU must remain untouched at 5!
    assert svc.get_available_qty("OLJCESPC7Z") == 5


def test_idempotent_replay_does_not_double_deduct_stock() -> None:
    """Contract AC-3: Repeating the same reservation_id returns idempotent_replay=True
    without deducting inventory twice.
    """
    svc = InventoryReservator()
    req = ReservationRequest(
        reservation_id="res_103",
        items=(ReservationItem(sku="66VCHSJNUP", quantity=1),),
    )
    first = svc.reserve_cart(req, now_epoch=1700000000)
    second = svc.reserve_cart(req, now_epoch=1700000010)
    assert first.idempotent_replay is False
    assert second.idempotent_replay is True
    assert svc.get_available_qty("66VCHSJNUP") == 1


def test_rejects_non_positive_quantity_or_empty_cart() -> None:
    """Contract AC-4: Empty carts or quantities <= 0 raise ValueError."""
    svc = InventoryReservator()
    with pytest.raises(ValueError):
        svc.reserve_cart(
            ReservationRequest(reservation_id="res_bad1", items=()),
            now_epoch=1700000000,
        )
    with pytest.raises(ValueError):
        svc.reserve_cart(
            ReservationRequest(
                reservation_id="res_bad2",
                items=(ReservationItem(sku="OLJCESPC7Z", quantity=0),),
            ),
            now_epoch=1700000000,
        )
