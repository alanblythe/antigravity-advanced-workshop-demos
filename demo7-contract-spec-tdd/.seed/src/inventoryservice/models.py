from __future__ import annotations

from dataclasses import dataclass


class InsufficientStockError(Exception):
    """Raised when a SKU does not have enough available stock to fulfill a reservation."""

    def __init__(self, sku: str, requested: int, available: int) -> None:
        super().__init__(f"Insufficient stock for {sku}: requested={requested}, available={available}")
        self.sku = sku
        self.requested = requested
        self.available = available


@dataclass(frozen=True)
class ReservationItem:
    sku: str
    quantity: int


@dataclass(frozen=True)
class ReservationRequest:
    reservation_id: str
    items: tuple[ReservationItem, ...]
    ttl_seconds: int = 300


@dataclass(frozen=True)
class ReservationResult:
    reservation_id: str
    reserved_skus: tuple[str, ...]
    expires_at: int
    idempotent_replay: bool = False
