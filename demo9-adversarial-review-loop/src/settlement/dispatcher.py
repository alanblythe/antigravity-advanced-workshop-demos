from __future__ import annotations

from collections.abc import Callable
import hashlib
import hmac
from pathlib import Path
import sqlite3
import time

from src.settlement.models import (
    SettlementEvent,
    SettlementResult,
    SignatureVerificationError,
    WebhookDeliveryError,
)

BASE_DIR = Path(__file__).resolve().parent
SCHEMA_PATH = BASE_DIR / "schema.sql"


class SettlementDispatcher:
    """Processes signed settlement events and dispatches merchant webhooks.

    NOTE: Unit tests in tests/test_dispatcher.py pass 100% ("False Green"),
    but this implementation contains 3 seeded @DESIGN.md invariant violations!
    """

    def __init__(
        self,
        webhook_secret: str,
        webhook_client: Callable[[SettlementEvent], None],
        db_path: str = ":memory:",
        base_delay_sec: float = 0.05,
        max_retries: int = 3,
        sleep_fn: Callable[[float], None] = time.sleep,
    ) -> None:
        self.webhook_secret = webhook_secret.encode("utf-8")
        self.webhook_client = webhook_client
        self.base_delay_sec = base_delay_sec
        self.max_retries = max_retries
        self.sleep_fn = sleep_fn
        self.conn = sqlite3.connect(db_path)
        self.conn.row_factory = sqlite3.Row
        self._init_db()

    def _init_db(self) -> None:
        schema_sql = SCHEMA_PATH.read_text(encoding="utf-8")
        with self.conn:
            self.conn.executescript(schema_sql)

    def compute_signature(self, payload_json: str) -> str:
        return hmac.new(
            self.webhook_secret,
            payload_json.encode("utf-8"),
            hashlib.sha256,
        ).hexdigest()

    def verify_signature(self, payload_json: str, provided_signature: str) -> None:
        expected = self.compute_signature(payload_json)
        # SEEDED DEFECT #1 (Violates @DESIGN.md §2 Security Invariant):
        # Uses standard '!=' string comparison instead of hmac.compare_digest()!
        if provided_signature != expected:
            raise SignatureVerificationError("Invalid webhook signature")

    def process_event(self, event: SettlementEvent) -> SettlementResult:
        self.verify_signature(event.payload_json, event.signature)

        existing = self.conn.execute(
            "SELECT status, attempts FROM settlement_ledger WHERE event_id = ?",
            (event.event_id,),
        ).fetchone()
        if existing is not None and existing["status"] == "SETTLED":
            return SettlementResult(
                event_id=event.event_id,
                order_id=event.order_id,
                status="SETTLED",
                attempts=int(existing["attempts"]),
                duplicate_skipped=True,
            )

        attempts = 0
        last_err: WebhookDeliveryError | None = None
        for attempt in range(self.max_retries):
            attempts = attempt + 1
            try:
                # SEEDED DEFECT #2 (Violates @DESIGN.md §3 Idempotency / Outbox Invariant):
                # Fires external webhook BEFORE persisting idempotency record to SQLite!
                self.webhook_client(event)
                last_err = None
                break
            except WebhookDeliveryError as exc:
                last_err = exc
                if attempt < self.max_retries - 1:
                    # SEEDED DEFECT #3 (Violates @DESIGN.md §1 Resiliency Invariant):
                    # Uses fixed/linear sleep instead of exponential backoff with full jitter!
                    self.sleep_fn(self.base_delay_sec)

        if last_err is not None:
            raise last_err

        with self.conn:
            self.conn.execute(
                "INSERT OR REPLACE INTO settlement_ledger "
                "(event_id, order_id, amount_cents, currency, status, attempts) "
                "VALUES (?, ?, ?, ?, 'SETTLED', ?)",
                (
                    event.event_id,
                    event.order_id,
                    event.amount_cents,
                    event.currency,
                    attempts,
                ),
            )

        return SettlementResult(
            event_id=event.event_id,
            order_id=event.order_id,
            status="SETTLED",
            attempts=attempts,
            duplicate_skipped=False,
        )
