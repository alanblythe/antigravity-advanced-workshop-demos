# Architectural Decision Record: Order Service Layered Decomposition (`0001-order-service-layered-decomposition.md`)

**Component:** Online Boutique — Order Checkout Processor (`src/order_app/`)  
**Current State:** Single tightly-coupled `src/order_app/monolith_order_app.py` mixing dataclasses, raw SQLite queries, currency/shipping business rules, and route façade methods.

---

## 1. Target Modular Architecture
Decompose `src/order_app/monolith_order_app.py` into 4 clean, single-responsibility modules under `src/order_app/`:

1. **`src/order_app/models.py` (Domain Data Contracts):**
   - `@dataclass(frozen=True)` models: `OrderLineItem`, `OrderRequest`, `OrderReceipt`, `OrderSummary`, and `InsufficientInventoryError`.
2. **`src/order_app/repositories.py` (SQLite Persistence Layer):**
   - `OrderRepository`: encapsulates SQLite connection initialization (`schema.sql`, `seeds.json`), product lookup/stock deduction, and order/ledger persistence using atomic `with self.conn:` context managers.
3. **`src/order_app/services.py` (Pure Business Logic Layer):**
   - `PricingAndShippingService`: pure `Decimal` currency conversion (`convert_from_usd`), tiered shipping calculation (`calculate_shipping_usd`), and tax computation (`calculate_tax_usd`).
4. **`src/order_app/routes.py` (Application Façade):**
   - `OrderAppFacade`: wires `OrderRepository` and `PricingAndShippingService` to expose `place_order(request)` and `get_order_summary(order_id)`.
   - **Backward Compatibility Mandate:** `src/order_app/monolith_order_app.py` must re-export `OrderLineItem`, `OrderRequest`, `OrderReceipt`, `OrderSummary`, `InsufficientInventoryError`, and `MonolithOrderApp` (aliased to `OrderAppFacade`) so existing callers and `tests/test_order_flow.py` continue to pass without modification.

---

## 2. Mandatory 3-Stage Execution Dependency Graph (DAG)
To prevent merge conflicts during `/teamwork` parallel execution, subagents MUST follow this 3-stage DAG:

```
[Stage 0: Scout]      @fast-scout (ast-graph: list_symbols & find_callers on monolith_order_app.py)
                                   │
                                   ▼
[Stage 1: Contracts]  @coder-models -> extracts src/order_app/models.py
                                   │
                     ┌─────────────┴─────────────┐
                     ▼                           ▼
[Stage 2: Parallel]  @coder-repo                 @coder-services
                     (owns repositories.py)      (owns services.py)
                     └─────────────┬─────────────┘
                                   ▼
[Stage 3: Rewire]     @coder-routes -> extracts src/order_app/routes.py,
                      updates monolith_order_app.py re-exports, runs pytest
```
