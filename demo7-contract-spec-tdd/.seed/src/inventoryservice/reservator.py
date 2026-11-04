from __future__ import annotations

import json
import sqlite3
from pathlib import Path
from src.inventoryservice.models import (
    InsufficientStockError,
    ReservationRequest,
    ReservationResult,
)

BASE_DIR = Path(__file__).resolve().parent
SCHEMA_PATH = BASE_DIR / "schema.sql"
SEEDS_PATH = BASE_DIR / "seeds.json"


class InventoryReservator:
    """Manages atomic cart inventory reservations backed by SQLite."""

    def __init__(self, db_path: str = ":memory:") -> None:
        self.conn = sqlite3.connect(db_path)
        self.conn.row_factory = sqlite3.Row
        self._init_db()

    def _init_db(self) -> None:
        schema_sql = SCHEMA_PATH.read_text(encoding="utf-8")
        seeds = json.loads(SEEDS_PATH.read_text(encoding="utf-8"))
        with self.conn:
            self.conn.executescript(schema_sql)
            for prod in seeds["products"]:
                self.conn.execute(
                    "INSERT INTO products (sku, name, available_qty) VALUES (?, ?, ?)",
                    (prod["sku"], prod["name"], prod["available_qty"]),
                )
            for hold in seeds["active_holds"]:
                self.conn.execute(
                    "INSERT INTO inventory_holds (reservation_id, sku, quantity, status, expires_at) "
                    "VALUES (?, ?, ?, ?, ?)",
                    (
                        hold["reservation_id"],
                        hold["sku"],
                        hold["quantity"],
                        hold["status"],
                        hold["expires_at"],
                    ),
                )

    def get_available_qty(self, sku: str) -> int:
        row = self.conn.execute(
            "SELECT available_qty FROM products WHERE sku = ?",
            (sku,),
        ).fetchone()
        if row is None:
            raise KeyError(f"Unknown SKU: {sku}")
        return int(row["available_qty"])

    def reserve_cart(self, request: ReservationRequest, now_epoch: int) -> ReservationResult:
        """Reserve inventory items for the given cart request."""
        expires_at = now_epoch + request.ttl_seconds
        reserved: list[str] = []
        for item in request.items:
            avail = self.get_available_qty(item.sku)
            if avail < item.quantity:
                raise InsufficientStockError(item.sku, item.quantity, avail)
            self.conn.execute(
                "UPDATE products SET available_qty = available_qty - ? WHERE sku = ?",
                (item.quantity, item.sku),
            )
            self.conn.execute(
                "INSERT INTO inventory_holds (reservation_id, sku, quantity, status, expires_at) "
                "VALUES (?, ?, ?, 'ACTIVE', ?)",
                (request.reservation_id, item.sku, item.quantity, expires_at),
            )
            self.conn.commit()
            reserved.append(item.sku)

        return ReservationResult(
            reservation_id=request.reservation_id,
            reserved_skus=tuple(reserved),
            expires_at=expires_at,
            idempotent_replay=False,
        )
