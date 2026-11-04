from __future__ import annotations

from dataclasses import dataclass
from decimal import Decimal, ROUND_HALF_UP
import json
from pathlib import Path
import sqlite3

BASE_DIR = Path(__file__).resolve().parent
SCHEMA_PATH = BASE_DIR / "schema.sql"
SEEDS_PATH = BASE_DIR / "seeds.json"
CENT = Decimal("0.01")


class InsufficientInventoryError(Exception):
    """Raised when requested order quantity exceeds catalog stock."""

    def __init__(self, sku: str, requested: int, available: int) -> None:
        super().__init__(f"Insufficient stock for {sku}: requested={requested}, available={available}")
        self.sku = sku
        self.requested = requested
        self.available = available


@dataclass(frozen=True)
class OrderLineItem:
    sku: str
    quantity: int


@dataclass(frozen=True)
class OrderRequest:
    order_id: str
    customer_id: str
    state_code: str
    currency: str
    items: tuple[OrderLineItem, ...]


@dataclass(frozen=True)
class OrderReceipt:
    order_id: str
    customer_id: str
    currency: str
    subtotal: Decimal
    shipping: Decimal
    tax: Decimal
    total: Decimal
    ledger_id: str
    status: str


@dataclass(frozen=True)
class OrderSummary:
    order_id: str
    customer_id: str
    currency: str
    total: Decimal
    item_count: int
    status: str


class MonolithOrderApp:
    """Tightly coupled monolithic order processor mixing persistence, pricing, and routes.

    Refactor target in @docs/adr/0001-order-service-layered-decomposition.md:
      - src/order_app/models.py
      - src/order_app/repositories.py
      - src/order_app/services.py
      - src/order_app/routes.py
    """

    def __init__(self, db_path: str = ":memory:") -> None:
        self.conn = sqlite3.connect(db_path)
        self.conn.row_factory = sqlite3.Row
        self.seeds = json.loads(SEEDS_PATH.read_text(encoding="utf-8"))
        self._init_database()

    def _init_database(self) -> None:
        schema_sql = SCHEMA_PATH.read_text(encoding="utf-8")
        with self.conn:
            self.conn.executescript(schema_sql)
            for prod in self.seeds["products"]:
                self.conn.execute(
                    "INSERT INTO catalog_products (sku, name, price_usd, weight_kg, stock_qty) "
                    "VALUES (?, ?, ?, ?, ?)",
                    (
                        prod["sku"],
                        prod["name"],
                        prod["price_usd"],
                        prod["weight_kg"],
                        prod["stock_qty"],
                    ),
                )

    @staticmethod
    def _quantize(value: Decimal) -> Decimal:
        return value.quantize(CENT, rounding=ROUND_HALF_UP)

    def convert_from_usd(self, amount_usd: Decimal, currency: str) -> Decimal:
        rates = self.seeds["fx_rates_from_usd"]
        if currency not in rates:
            raise ValueError(f"Unsupported currency: {currency}")
        rate = Decimal(rates[currency])
        return self._quantize(amount_usd * rate)

    def calculate_shipping_usd(self, total_weight_kg: Decimal, subtotal_usd: Decimal) -> Decimal:
        if subtotal_usd >= Decimal("250.00"):
            return Decimal("0.00")
        base_fee = Decimal("5.99")
        per_kg_fee = Decimal("1.50") * total_weight_kg
        return self._quantize(base_fee + per_kg_fee)

    def calculate_tax_usd(self, taxable_usd: Decimal, state_code: str) -> Decimal:
        tax_rates = self.seeds["tax_rates_by_state"]
        rate_str = tax_rates.get(state_code, tax_rates["DEFAULT"])
        return self._quantize(taxable_usd * Decimal(rate_str))

    def place_order(self, request: OrderRequest) -> OrderReceipt:
        if not request.items:
            raise ValueError("Order must contain at least one item")

        subtotal_usd = Decimal("0.00")
        total_weight_kg = Decimal("0.00")
        line_records: list[tuple[str, int, Decimal]] = []

        with self.conn:
            for item in request.items:
                if item.quantity <= 0:
                    raise ValueError(f"Invalid quantity for {item.sku}: {item.quantity}")
                row = self.conn.execute(
                    "SELECT price_usd, weight_kg, stock_qty FROM catalog_products WHERE sku = ?",
                    (item.sku,),
                ).fetchone()
                if row is None:
                    raise KeyError(f"Unknown SKU: {item.sku}")
                available = int(row["stock_qty"])
                if available < item.quantity:
                    raise InsufficientInventoryError(item.sku, item.quantity, available)

                unit_price = Decimal(row["price_usd"])
                weight = Decimal(row["weight_kg"])
                subtotal_usd += unit_price * Decimal(item.quantity)
                total_weight_kg += weight * Decimal(item.quantity)
                line_records.append((item.sku, item.quantity, unit_price))

            subtotal_usd = self._quantize(subtotal_usd)
            shipping_usd = self.calculate_shipping_usd(total_weight_kg, subtotal_usd)
            tax_usd = self.calculate_tax_usd(subtotal_usd, request.state_code)

            subtotal_conv = self.convert_from_usd(subtotal_usd, request.currency)
            shipping_conv = self.convert_from_usd(shipping_usd, request.currency)
            tax_conv = self.convert_from_usd(tax_usd, request.currency)
            total_conv = self._quantize(subtotal_conv + shipping_conv + tax_conv)

            for sku, qty, unit_price in line_records:
                self.conn.execute(
                    "UPDATE catalog_products SET stock_qty = stock_qty - ? WHERE sku = ?",
                    (qty, sku),
                )
                self.conn.execute(
                    "INSERT INTO order_line_items (order_id, sku, quantity, unit_price_usd) "
                    "VALUES (?, ?, ?, ?)",
                    (request.order_id, sku, qty, str(unit_price)),
                )

            self.conn.execute(
                "INSERT INTO customer_orders "
                "(order_id, customer_id, currency, subtotal_amount, shipping_amount, tax_amount, total_amount, status) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'CONFIRMED')",
                (
                    request.order_id,
                    request.customer_id,
                    request.currency,
                    str(subtotal_conv),
                    str(shipping_conv),
                    str(tax_conv),
                    str(total_conv),
                ),
            )
            ledger_id = f"led_{request.order_id}"
            self.conn.execute(
                "INSERT INTO payment_ledger (ledger_id, order_id, charged_currency, charged_amount) "
                "VALUES (?, ?, ?, ?)",
                (ledger_id, request.order_id, request.currency, str(total_conv)),
            )

        return OrderReceipt(
            order_id=request.order_id,
            customer_id=request.customer_id,
            currency=request.currency,
            subtotal=subtotal_conv,
            shipping=shipping_conv,
            tax=tax_conv,
            total=total_conv,
            ledger_id=ledger_id,
            status="CONFIRMED",
        )

    def get_order_summary(self, order_id: str) -> OrderSummary:
        order_row = self.conn.execute(
            "SELECT order_id, customer_id, currency, total_amount, status "
            "FROM customer_orders WHERE order_id = ?",
            (order_id,),
        ).fetchone()
        if order_row is None:
            raise KeyError(f"Order not found: {order_id}")

        count_row = self.conn.execute(
            "SELECT COALESCE(SUM(quantity), 0) AS total_items "
            "FROM order_line_items WHERE order_id = ?",
            (order_id,),
        ).fetchone()
        return OrderSummary(
            order_id=str(order_row["order_id"]),
            customer_id=str(order_row["customer_id"]),
            currency=str(order_row["currency"]),
            total=Decimal(str(order_row["total_amount"])),
            item_count=int(count_row["total_items"]),
            status=str(order_row["status"]),
        )
