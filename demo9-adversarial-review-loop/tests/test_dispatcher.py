from __future__ import annotations

import pytest
from src.settlement.dispatcher import SettlementDispatcher
from src.settlement.models import (
    SettlementEvent,
    SignatureVerificationError,
    WebhookDeliveryError,
)

SECRET = "whsec_test_secret_key"


def _make_signed_event(
    dispatcher: SettlementDispatcher,
    event_id: str = "evt_001",
    order_id: str = "ord_500",
) -> SettlementEvent:
    payload = f'{{"event_id":"{event_id}","order_id":"{order_id}","amount_cents":4500}}'
    sig = dispatcher.compute_signature(payload)
    return SettlementEvent(
        event_id=event_id,
        order_id=order_id,
        amount_cents=4500,
        currency="USD",
        payload_json=payload,
        signature=sig,
    )


def test_happy_path_settlement_succeeds() -> None:
    delivered: list[str] = []
    dispatcher = SettlementDispatcher(
        webhook_secret=SECRET,
        webhook_client=lambda ev: delivered.append(ev.event_id),
        sleep_fn=lambda _: None,
    )
    event = _make_signed_event(dispatcher)
    res = dispatcher.process_event(event)
    assert res.status == "SETTLED"
    assert res.attempts == 1
    assert res.duplicate_skipped is False
    assert delivered == ["evt_001"]


def test_rejects_tampered_signature() -> None:
    dispatcher = SettlementDispatcher(
        webhook_secret=SECRET,
        webhook_client=lambda _: None,
        sleep_fn=lambda _: None,
    )
    bad_event = SettlementEvent(
        event_id="evt_bad",
        order_id="ord_501",
        amount_cents=4500,
        currency="USD",
        payload_json='{"event_id":"evt_bad"}',
        signature="0000deadbeef",
    )
    with pytest.raises(SignatureVerificationError):
        dispatcher.process_event(bad_event)


def test_retries_transient_webhook_failure_and_recovers() -> None:
    call_count = 0

    def flaky_webhook(_: SettlementEvent) -> None:
        nonlocal call_count
        call_count += 1
        if call_count < 3:
            raise WebhookDeliveryError("503 Service Unavailable")

    dispatcher = SettlementDispatcher(
        webhook_secret=SECRET,
        webhook_client=flaky_webhook,
        sleep_fn=lambda _: None,
    )
    event = _make_signed_event(dispatcher, event_id="evt_flaky")
    res = dispatcher.process_event(event)
    assert res.status == "SETTLED"
    assert res.attempts == 3


def test_skips_already_settled_duplicate_event() -> None:
    delivered: list[str] = []
    dispatcher = SettlementDispatcher(
        webhook_secret=SECRET,
        webhook_client=lambda ev: delivered.append(ev.event_id),
        sleep_fn=lambda _: None,
    )
    event = _make_signed_event(dispatcher, event_id="evt_dup")
    first = dispatcher.process_event(event)
    second = dispatcher.process_event(event)
    assert first.duplicate_skipped is False
    assert second.duplicate_skipped is True
    assert len(delivered) == 1
