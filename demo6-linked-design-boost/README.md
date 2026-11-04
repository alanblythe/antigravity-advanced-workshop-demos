# Demo 6: Grounding Specs, Linked ADRs & `⚡ Boost`

> **Focus:** Separating long-lived architectural decision records (`AGENTS.md` $\rightarrow$ `docs/adr/` + `.agents/rules/`) from single-conversation feature specifications (`docs/specs/`), and executing via autonomous **`⚡ Boost`** (`/boost`).

---

## Files in This Demo

* **`AGENTS.md`**: Concise repository constitution that links to `docs/adr/` for standing architectural guardrails and testing procedures.
* **`docs/adr/0001-decimal-currency-and-discount-caps.md`**: Long-lived service architecture & testing standards for `src/discountservice/`—defining `Decimal("0.01")` (`ROUND_HALF_UP`) currency invariants, `float` rejection (`TypeError`), `@dataclass(frozen=True)` contracts, the service-wide 50% maximum discount ceiling, and `pytest` verification gates.
* **`docs/specs/0001-stacked-promo-engine.md`**: Single-conversation feature specification for `evaluate_stacked_promos()`, defining `PERCENT`-before-`FIXED` stacking precedence, `min_subtotal` filtering, duplicate code deduplication, and 4 executable acceptance criteria (`AC-1` through `AC-4`).
* **`.agents/rules/discount-invariants.md`**: Path-scoped rule (`paths: ["src/discountservice/**"]`) automatically injected when editing discount service files.
* **`src/discountservice/models.py`**: Immutable `@dataclass(frozen=True)` domain models (`PromoRule`, `DiscountResult`).
* **`src/discountservice/engine.py`**: Baseline implementation containing `apply_single_promo()`, ready for `evaluate_stacked_promos()` implementation.
* **`tests/test_engine.py`**: Baseline unit test suite (`2 passed`).

---

## Live Demo Steps

1. In Antigravity (`agy` inside `workspace/`, launched via VS Code Task **`Reset & Open: Demo 6`**), verify the baseline test suite:
```text
Run pytest.
```

2. Invoke **`/boost`** (`⚡ Boost` mode) referencing the feature specification:
```text
/boost Implement @docs/specs/0001-stacked-promo-engine.md in src/discountservice/engine.py and add unit tests for all acceptance criteria.
```
*Highlight:* Notice the clean separation of concerns: `@docs/specs/0001-stacked-promo-engine.md` defines the task-specific feature behavior (`evaluate_stacked_promos` stacking order and deduplication), while the standing architectural guardrails (`Decimal` rounding, `float` rejection `TypeError`, `@dataclass(frozen=True)`, the 50% service-wide discount cap, and `pytest` verification) are automatically inherited from `AGENTS.md` $\rightarrow$ `@docs/adr/0001-decimal-currency-and-discount-caps.md` and `.agents/rules/discount-invariants.md`.
