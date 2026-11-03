from __future__ import annotations

from dataclasses import dataclass


class SignatureVerificationError(Exception):
    """Raised when webhook HMAC-SHA256 signature verification fails."""


class WebhookDeliveryError(Exception):
    """Raised when outbound settlement webhook delivery fails."""


@dataclass(frozen=True)
class SettlementEvent:
    event_id: str
    order_id: str
    amount_cents: int
    currency: str
    payload_json: str
    signature: str


@dataclass(frozen=True)
class SettlementResult:
    event_id: str
    order_id: str
    status: str
    attempts: int
    duplicate_skipped: bool = False
