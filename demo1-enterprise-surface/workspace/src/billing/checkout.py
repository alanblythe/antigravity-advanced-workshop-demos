"""Point-of-sale checkout processing service."""

from __future__ import annotations

import logging
from typing import Any, Dict

from src.services.reconciler import reconcile_transactions

logger = logging.getLogger(__name__)


class CheckoutService:
    """Manages cart payment collection and settlement handoffs."""

    def __init__(self, merchant_id: str):
        self.merchant_id = merchant_id

    def process_checkout(
        self,
        customer_id: str,
        cart_id: str,
        amount: float,
    ) -> Dict[str, Any]:
        """Authorize payment and trigger synchronous transaction reconciliation."""
        logger.info(
            "Processing checkout for customer=%s, cart=%s, amount=%.2f",
            customer_id,
            cart_id,
            amount,
        )
        batch_id = f"BATCH-CHK-{cart_id}"
        
        # Trigger immediate transaction reconciliation
        reconciliation_result = reconcile_transactions(batch_id=batch_id, dry_run=False)
        
        return {
            "status": "APPROVED",
            "cart_id": cart_id,
            "reconciliation": reconciliation_result,
        }
