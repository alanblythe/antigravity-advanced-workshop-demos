# Architecture Decision Record: Inventory Reservation Holds & Expirations

**Component:** Online Boutique — Cart Inventory Reservation Service (`src/inventoryservice/`)  
**Status:** Accepted & Enforced  
**Date:** 2026-11-04  

---

## 1. Context & Business Problem
During peak shopping events, carts hold inventory items. If inventory holds are indefinite or non-atomic, cart abandonment causes inventory starvation, and race conditions allow over-selling.

---

## 2. Decision & Production Guardrails
1. **Durable Hold Expiration (`§1 Resiliency`):**
   - Active holds must carry an explicit expiration timestamp (`expires_at`).
   - Expired holds must be lazily or actively reclaimed back into available stock.
2. **Atomic Multi-SKU Transactions (`§2 Data Integrity`):**
   - Reservations spanning multiple items must succeed entirely or roll back completely. Partial holds are strictly prohibited.
3. **Idempotent Reservation Keys (`§3 Idempotency`):**
   - Replaying a reservation request with an identical `reservation_id` must return the existing reservation without decrementing stock a second time.
4. **Strict Input Validation (`§4 Boundary Safety`):**
   - Non-positive quantities (`quantity <= 0`) must be rejected immediately with `ValueError`.
