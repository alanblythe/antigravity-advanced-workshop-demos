import json
import pytest
from decimal import Decimal
from reconciler import TransactionReconciler, ReconciliationError


def test_standard_reconciliation():
    rec = TransactionReconciler()
    res = rec.reconcile_transaction({"tx_id": "tx_1001", "amount": 49.99, "status": "COMPLETED"})
    assert res["reconciled"] is True
    assert res["status"] == "SETTLED"
    assert res["amount"] == 49.99
    assert res["tenant_id"] == "default"


def test_legacy_payload_reconciliation():
    """Tests backward compatibility with legacy upstream transaction records."""
    rec = TransactionReconciler()
    legacy_record = {"transaction_id": "legacy_9901", "amount": 120.00}
    res = rec.reconcile_transaction(legacy_record)
    assert res["reconciled"] is True
    assert res["tx_id"] == "legacy_9901"

    # Also test 'id' key fallback
    legacy_id_record = {"id": "legacy_id_42", "amount": 15.50}
    res2 = rec.reconcile_transaction(legacy_id_record)
    assert res2["tx_id"] == "legacy_id_42"


def test_legacy_id_priority():
    """Verify priority: tx_id > transaction_id > id."""
    rec = TransactionReconciler()
    record = {"tx_id": "primary_id", "transaction_id": "second_id", "id": "third_id", "amount": 10.0}
    assert rec.reconcile_transaction(record)["tx_id"] == "primary_id"

    record_no_tx = {"transaction_id": "second_id", "id": "third_id", "amount": 10.0}
    assert rec.reconcile_transaction(record_no_tx)["tx_id"] == "second_id"


def test_missing_or_empty_id_raises():
    rec = TransactionReconciler()
    with pytest.raises(ReconciliationError, match="Missing or empty transaction identifier"):
        rec.reconcile_transaction({"amount": 10.0})

    with pytest.raises(ReconciliationError, match="Missing or empty transaction identifier"):
        rec.reconcile_transaction({"tx_id": "   ", "amount": 10.0})


def test_batch_reconciliation():
    rec = TransactionReconciler()
    records = [
        {"tx_id": "tx_1", "amount": 10.0},
        {"tx_id": "tx_2", "amount": 20.0}
    ]
    results = rec.reconcile_batch(records)
    assert len(results) == 2
    assert results[0]["tx_id"] == "tx_1"
    assert results[1]["tx_id"] == "tx_2"


def test_tenant_isolation_and_cross_tenant_rejection():
    rec = TransactionReconciler()
    # Batch mixing two different tenants must be rejected with 0 writes
    mixed_batch = [
        {"tx_id": "tx_a1", "amount": 10.0, "tenant_id": "tenant-alpha"},
        {"tx_id": "tx_b1", "amount": 20.0, "tenant_id": "tenant-beta"}
    ]
    with pytest.raises(ReconciliationError, match="Cross-tenant batch mixing detected"):
        rec.reconcile_batch(mixed_batch)
    assert len(rec._ledger) == 0

    # Blank tenant_id raises ReconciliationError
    with pytest.raises(ReconciliationError, match="Invalid tenant_id"):
        rec.reconcile_transaction({"tx_id": "tx_blank", "amount": 10.0, "tenant_id": "  "})


def test_idempotency_and_conflict_detection():
    rec = TransactionReconciler()
    tx = {"tx_id": "tx_idem_1", "amount": 100.00, "status": "COMPLETED"}

    # First execution settles transaction
    first_res = rec.reconcile_transaction(tx)
    assert first_res["status"] == "SETTLED"

    # Replay of identical payload returns cached copy
    replay_res = rec.reconcile_transaction(tx)
    assert replay_res == first_res

    # Conflicting amount on same (tenant, tx_id) raises ReconciliationError
    conflicting_tx = {"tx_id": "tx_idem_1", "amount": 150.00, "status": "COMPLETED"}
    with pytest.raises(ReconciliationError, match="Idempotency conflict"):
        rec.reconcile_transaction(conflicting_tx)

    # Same tx_id under different tenant does NOT conflict
    diff_tenant_tx = {"tx_id": "tx_idem_1", "amount": 150.00, "tenant_id": "tenant-corp", "status": "COMPLETED"}
    diff_res = rec.reconcile_transaction(diff_tenant_tx)
    assert diff_res["status"] == "SETTLED"
    assert diff_res["amount"] == 150.00


def test_decimal_precision_and_json_serialization():
    rec = TransactionReconciler()
    res = rec.reconcile_transaction({"tx_id": "tx_dec_1", "amount": "49.995"})
    assert res["amount"] == 50.00  # Quantized ROUND_HALF_UP

    # Verify JSON serializability
    json_str = json.dumps(res)
    assert "50.0" in json_str

    # Invalid and negative amounts fail
    with pytest.raises(ReconciliationError, match="Negative amount"):
        rec.reconcile_transaction({"tx_id": "tx_neg", "amount": -10.0})

    with pytest.raises(ReconciliationError, match="Invalid numeric amount"):
        rec.reconcile_transaction({"tx_id": "tx_invalid", "amount": "not-a-number"})


def test_exponential_backoff_with_full_jitter_distribution(monkeypatch):
    """
    Verifies retry loop applies exponential backoff with full randomized jitter (§4.2)
    and verifies zero linear time.sleep(1.0) calls occur.
    """
    recorded_sleeps = []
    monkeypatch.setattr("time.sleep", lambda s: recorded_sleeps.append(s))

    call_count = 0
    def flaky_backend(tenant_id, tx_id, amount, status):
        nonlocal call_count
        call_count += 1
        if call_count < 3:
            raise ConnectionError("Transient network glitch")

    rec = TransactionReconciler(max_retries=3, base_delay=0.1, max_delay=2.0, ledger_backend=flaky_backend)
    res = rec.reconcile_transaction({"tx_id": "tx_flaky_1", "amount": 25.00})
    assert res["reconciled"] is True
    assert call_count == 3
    assert len(recorded_sleeps) == 2

    # Attempt 0: random.uniform(0, min(2.0, 0.1 * 1)) -> [0.0, 0.1]
    assert 0.0 <= recorded_sleeps[0] <= 0.1
    # Attempt 1: random.uniform(0, min(2.0, 0.1 * 2)) -> [0.0, 0.2]
    assert 0.0 <= recorded_sleeps[1] <= 0.2
    # Verify no fixed linear sleeps
    assert not any(s == 1.0 for s in recorded_sleeps)
