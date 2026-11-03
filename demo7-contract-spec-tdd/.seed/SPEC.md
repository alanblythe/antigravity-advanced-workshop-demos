# Product Requirement Specification: Cart Inventory Reservation (`SPEC.md`)

**Service:** Online Boutique — Inventory Hold & Reservation Service (`src/inventoryservice/`)  
**Target Function:** `InventoryReservator.reserve_cart(request: ReservationRequest, now_epoch: int) -> ReservationResult`

---

## 1. Problem Statement
During flash sales, concurrent checkouts oversell limited inventory unless cart items are atomically placed on a temporary hold (`ttl_seconds = 300`) before payment settlement.

## 2. Core Functional Requirements
1. **Input Validation:** Every item in `request.items` must have `quantity > 0`. If any item has `quantity <= 0` or if `request.items` is empty, raise `ValueError`.
2. **Expired Hold Reclamation:** Before checking available stock for requested SKUs, reclaim any existing `ACTIVE` holds in `inventory_holds` where `expires_at <= now_epoch` by marking their status `EXPIRED` and returning their `quantity` back to `products.available_qty`.
3. **All-or-Nothing Atomic Cart Reservation:**
   - A cart can contain multiple SKUs.
   - If *any* requested SKU has `available_qty < item.quantity` (after reclaiming expired holds) or does not exist, the **entire cart reservation must fail atomically** with `InsufficientStockError(sku)`—no partial holds may be committed for other items in the cart.
4. **Idempotent Replay (`reservation_id`):**
   - If `reserve_cart` is called again with an existing `ACTIVE` `reservation_id`, return the existing reservation result (`idempotent_replay=True`) without deducting stock a second time.

## 3. Open Questions for `/grill-me` Alignment
- Confirm whether duplicate SKU lines within the same `ReservationRequest` should be aggregated before checking stock.
- Confirm exact `expires_at` calculation (`now_epoch + request.ttl_seconds`).
