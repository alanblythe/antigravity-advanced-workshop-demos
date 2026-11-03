"""Nightly settlement batch job across payment gateways."""

from __future__ import annotations

import logging
from typing import Any, Dict, List

from src.services.reconciler import reconcile_transactions

logger = logging.getLogger(__name__)


class NightlySettlementJob:
    """Cron-triggered batch settlement worker."""

    def __init__(self, region: str = "us-central1"):
        self.region = region

    def run_settlement(self, date_str: str) -> List[Dict[str, Any]]:
        """Collect daily batches and execute ledger reconciliation."""
        logger.info("Starting nightly settlement job for region=%s, date=%s", self.region, date_str)
        batches = [f"BATCH-{date_str}-001", f"BATCH-{date_str}-002"]
        results = []

        for batch_id in batches:
            # Reconcile transactions against banking network
            summary = reconcile_transactions(batch_id=batch_id, dry_run=False, max_retries=5)
            results.append(summary)

        return results
