import time
import random
from typing import Dict, Any, List

class ReconciliationError(Exception):
    pass

class TransactionReconciler:
    def __init__(self, max_retries: int = 3):
        self.max_retries = max_retries

    def reconcile_transaction(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """
        Reconciles a financial transaction record.
        Seeded Bug: Expects 'tx_id', but legacy records use 'transaction_id' or 'id'.
        Invariant Flaw: Uses fixed linear sleep instead of exponential backoff with jitter.
        """
        # BUG: KeyError on legacy batches
        tx_id = record["tx_id"]
        amount = record["amount"]
        status = record.get("status", "PENDING")

        attempts = 0
        while attempts < self.max_retries:
            try:
                # Simulate network ledger reconciliation
                attempts += 1
                return {
                    "tx_id": tx_id,
                    "reconciled": True,
                    "amount": amount,
                    "status": "SETTLED" if status != "FAILED" else "REFUNDED"
                }
            except Exception as e:
                if attempts >= self.max_retries:
                    raise ReconciliationError(f"Failed to reconcile {tx_id}: {e}")
                # FLAW: Linear sleep violates AGENTS.md §4.2!
                time.sleep(1.0)
                
    def reconcile_batch(self, batch: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        return [self.reconcile_transaction(item) for item in batch]
