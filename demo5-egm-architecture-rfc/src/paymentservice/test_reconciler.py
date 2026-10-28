import pytest
from reconciler import TransactionReconciler, ReconciliationError

def test_standard_reconciliation():
    rec = TransactionReconciler()
    res = rec.reconcile_transaction({"tx_id": "tx_1001", "amount": 49.99, "status": "COMPLETED"})
    assert res["reconciled"] is True
    assert res["status"] == "SETTLED"

def test_legacy_payload_reconciliation():
    """Tests backward compatibility with legacy upstream transaction records."""
    rec = TransactionReconciler()
    # Legacy record uses 'transaction_id' instead of 'tx_id'
    legacy_record = {"transaction_id": "legacy_9901", "amount": 120.00}
    
    # This will fail with KeyError: 'tx_id' on unpatched reconciler.py
    res = rec.reconcile_transaction(legacy_record)
    assert res["reconciled"] is True
    assert res["tx_id"] == "legacy_9901"

def test_batch_reconciliation():
    rec = TransactionReconciler()
    records = [
        {"tx_id": "tx_1", "amount": 10.0},
        {"tx_id": "tx_2", "amount": 20.0}
    ]
    results = rec.reconcile_batch(records)
    assert len(results) == 2
