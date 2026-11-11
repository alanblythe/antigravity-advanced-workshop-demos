import random
import time
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
from typing import Any, Callable, Dict, List, Optional, Tuple


class ReconciliationError(Exception):
    """Raised when reconciliation validation, tenant boundary, or idempotency conflict fails."""
    pass


class TransactionReconciler:
    """
    Production financial transaction reconciler supporting legacy payloads,
    strict tenant isolation, per-tenant idempotency, and anti-thundering-herd
    exponential backoff with full randomized jitter.
    """

    def __init__(
        self,
        max_retries: int = 3,
        base_delay: float = 0.1,
        max_delay: float = 2.0,
        default_tenant_id: str = "default",
        ledger_backend: Optional[Callable[..., Any]] = None,
    ):
        self.max_retries = max_retries
        self.base_delay = base_delay
        self.max_delay = max_delay
        self.default_tenant_id = default_tenant_id
        # Optional pluggable remote I/O hook for network/ledger execution & testing
        self._ledger_backend = ledger_backend
        # In-memory idempotency ledger keyed by (tenant_id, tx_id)
        self._ledger: Dict[Tuple[str, str], Dict[str, Any]] = {}

    def _resolve_tx_id(self, record: Dict[str, Any]) -> str:
        """Resolves tx_id, transaction_id, or id with priority ordering."""
        for key in ("tx_id", "transaction_id", "id"):
            if key in record:
                val = record[key]
                if val is not None:
                    val_str = str(val).strip()
                    if val_str:
                        return val_str
        raise ReconciliationError("Missing or empty transaction identifier. Expected 'tx_id', 'transaction_id', or 'id'.")

    def _resolve_tenant_id(self, record: Dict[str, Any], explicit_tenant_id: Optional[str] = None) -> str:
        """Resolves and validates tenant_id with strict non-empty string boundary."""
        if explicit_tenant_id is not None:
            if not isinstance(explicit_tenant_id, str) or not explicit_tenant_id.strip():
                raise ReconciliationError("Explicit tenant_id must be a non-empty string.")
            tenant = explicit_tenant_id.strip()
        elif "tenant_id" in record:
            raw = record["tenant_id"]
            if raw is None or not isinstance(raw, str) or not raw.strip():
                raise ReconciliationError("Invalid tenant_id: record tenant_id cannot be None, empty, or whitespace.")
            tenant = raw.strip()
        else:
            tenant = self.default_tenant_id

        if not tenant:
            raise ReconciliationError("Invalid tenant_id: tenant boundary cannot be resolved.")
        return tenant

    def _parse_amount(self, record: Dict[str, Any]) -> Decimal:
        """Parses and quantizes amount to 2 decimal places with Decimal('0.01') ROUND_HALF_UP."""
        if "amount" not in record or record["amount"] is None:
            raise ReconciliationError("Missing 'amount' field in record.")

        raw_amount = record["amount"]
        try:
            dec = Decimal(str(raw_amount))
        except (InvalidOperation, TypeError, ValueError) as e:
            raise ReconciliationError(f"Invalid numeric amount '{raw_amount}': {e}") from e

        if dec.is_nan() or dec.is_infinite():
            raise ReconciliationError(f"Amount cannot be NaN or Infinite: {raw_amount}")
        if dec < Decimal("0.00"):
            raise ReconciliationError(f"Negative amount is not permitted: {dec}")

        return dec.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)

    def _execute_network_reconciliation(self, tenant_id: str, tx_id: str, amount: Decimal, status: str) -> Dict[str, Any]:
        """
        Executes network ledger settlement with exponential backoff and full randomized jitter (§4.2).
        Fails fast on business/validation errors; retries transient network/ledger exceptions.
        """
        attempts = 0
        while attempts < self.max_retries:
            try:
                attempts += 1
                if self._ledger_backend is not None:
                    self._ledger_backend(tenant_id, tx_id, amount, status)

                settled_status = "SETTLED" if status != "FAILED" else "REFUNDED"
                return {
                    "tx_id": tx_id,
                    "tenant_id": tenant_id,
                    "reconciled": True,
                    "amount": float(amount),
                    "_decimal_amount": amount,
                    "status": settled_status,
                }
            except ReconciliationError:
                raise
            except Exception as e:
                if attempts >= self.max_retries:
                    raise ReconciliationError(f"Failed to reconcile {tx_id} after {attempts} attempts: {e}") from e
                # Anti-thundering-herd: exponential backoff with full randomized jitter (§4.2)
                attempt_idx = attempts - 1
                sleep_seconds = random.uniform(0, min(self.max_delay, self.base_delay * (2 ** attempt_idx)))
                time.sleep(sleep_seconds)

    def reconcile_transaction(self, record: Dict[str, Any], tenant_id: Optional[str] = None) -> Dict[str, Any]:
        """Reconciles a single transaction record with per-tenant idempotency and conflict detection."""
        tx_id = self._resolve_tx_id(record)
        resolved_tenant = self._resolve_tenant_id(record, explicit_tenant_id=tenant_id)
        amount = self._parse_amount(record)
        status = record.get("status", "PENDING")

        ledger_key = (resolved_tenant, tx_id)
        if ledger_key in self._ledger:
            cached = self._ledger[ledger_key]
            if cached["_decimal_amount"] != amount:
                raise ReconciliationError(
                    f"Idempotency conflict for tx_id '{tx_id}' in tenant '{resolved_tenant}': "
                    f"cached amount {cached['_decimal_amount']} != new amount {amount}"
                )
            result = dict(cached)
            result.pop("_decimal_amount", None)
            return result

        result = self._execute_network_reconciliation(resolved_tenant, tx_id, amount, status)
        self._ledger[ledger_key] = dict(result)
        public_result = dict(result)
        public_result.pop("_decimal_amount", None)
        return public_result

    def reconcile_batch(self, batch: List[Dict[str, Any]], tenant_id: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Reconciles a batch atomically with pre-validation:
        Enforces single tenant boundary, detects intra-batch conflicts, and prevents partial writes.
        """
        if not batch:
            return []

        # Pre-validate all records and determine tenant boundary
        validated_items = []
        target_tenant: Optional[str] = tenant_id.strip() if tenant_id and tenant_id.strip() else None

        for item in batch:
            resolved_tx_id = self._resolve_tx_id(item)
            item_tenant = self._resolve_tenant_id(item, explicit_tenant_id=tenant_id)
            if target_tenant is None:
                target_tenant = item_tenant
            elif item_tenant != target_tenant:
                raise ReconciliationError(
                    f"Cross-tenant batch mixing detected: '{item_tenant}' does not match batch tenant '{target_tenant}'."
                )

            amount = self._parse_amount(item)
            status = item.get("status", "PENDING")
            validated_items.append((target_tenant, resolved_tx_id, amount, status, item))

        # Check for intra-batch idempotency conflicts and existing ledger conflicts
        batch_seen: Dict[Tuple[str, str], Decimal] = {}
        for b_tenant, b_tx_id, b_amount, _, _ in validated_items:
            key = (b_tenant, b_tx_id)
            if key in batch_seen:
                if batch_seen[key] != b_amount:
                    raise ReconciliationError(f"Intra-batch idempotency conflict for tx_id '{b_tx_id}'")
            else:
                batch_seen[key] = b_amount

            if key in self._ledger:
                if self._ledger[key]["_decimal_amount"] != b_amount:
                    raise ReconciliationError(f"Batch payload conflicts with existing ledger record for tx_id '{b_tx_id}'")

        # Execute batch reconciliation
        return [self.reconcile_transaction(item, tenant_id=target_tenant) for item in batch]
