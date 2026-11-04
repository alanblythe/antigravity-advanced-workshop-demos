# Demo 6: Grounding Specs, Linked `@DESIGN.md` & `⚡ Boost`

> **Focus:** Separating long-lived architectural guardrails (`AGENTS.md` $\rightarrow$ `@DESIGN.md` + `.agents/rules/`) from single-conversation feature specifications (`@SPEC.md`), and executing via autonomous **`⚡ Boost`** (`/boost`).

---

## Files in This Demo

* **`AGENTS.md`**: Concise repository constitution that links to `@DESIGN.md` for standing architectural guardrails and testing procedures.
* **`DESIGN.md`**: Long-lived service architecture & testing standards for `src/discountservice/`—defining `Decimal("0.01")` (`ROUND_HALF_UP`) currency invariants, `float` rejection (`TypeError`), `@dataclass(frozen=True)` contracts, the service-wide 50% maximum discount ceiling, and `pytest` verification gates.
* **`SPEC.md`**: Single-conversation feature specification for `evaluate_stacked_promos()`, defining `PERCENT`-before-`FIXED` stacking precedence, `min_subtotal` filtering, duplicate code deduplication, and 4 executable acceptance criteria (`AC-1` through `AC-4`).
* **`.agents/rules/discount-invariants.md`**: Path-scoped rule (`paths: ["src/discountservice/**"]`) automatically injected when editing discount service files.
* **`src/discountservice/models.py`**: Immutable `@dataclass(frozen=True)` domain models (`PromoRule`, `DiscountResult`).
* **`src/discountservice/engine.py`**: Baseline implementation containing `apply_single_promo()`, ready for `evaluate_stacked_promos()` implementation.
* **`tests/test_engine.py`**: Baseline unit test suite (`2 passed`).

---

## Live Demo Steps

1. Reset to initial state:
```bash
./start_demo.sh
```

2. Open the clean agent workspace (`workspace/`) and verify baseline tests:
```bash
cd workspace
uv run pytest
```

3. In Antigravity 2.0 (or `agy` CLI inside `workspace/`), invoke **`/boost`** (`⚡ Boost` mode) referencing `@SPEC.md`:
```text
/boost Implement @SPEC.md in src/discountservice/engine.py and add unit tests for all acceptance criteria.
```
*Highlight:* Notice the clean separation of concerns: `@SPEC.md` defines the task-specific feature behavior (`evaluate_stacked_promos` stacking order and deduplication), while the standing architectural guardrails (`Decimal` rounding, `float` rejection `TypeError`, `@dataclass(frozen=True)`, the 50% service-wide discount cap, and `pytest` verification) are automatically inherited from `AGENTS.md` $\rightarrow$ `@DESIGN.md` and `.agents/rules/discount-invariants.md`.
