# Demo 6: Grounding Specs, Linked `@DESIGN.md` & `⚡ Boost`

> **Focus:** Moving beyond single-loop prompts to explicit technical specs (`AGENTS.md` $\rightarrow$ `@DESIGN.md`), path-scoped rules (`.agents/rules/`), and autonomous **`⚡ Boost`** (`/boost`) execution.

---

## Files in This Demo

* **`AGENTS.md`**: Concise repository constitution that delegates domain data contracts and acceptance criteria to `@DESIGN.md`.
* **`DESIGN.md`**: Explicit architectural & data contract specification for the Online Boutique **Order Discount & Promo Engine**, defining `Decimal` rounding, stacking precedence (`PERCENT` before `FIXED`), the 50% maximum discount cap, and 4 executable acceptance criteria (`AC-1` through `AC-4`).
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
pytest
```

3. In Antigravity 2.0 (or `agy` CLI inside `workspace/`), invoke **`/boost`** (`⚡ Boost` mode):
```text
/boost Implement evaluate_stacked_promos in src/discountservice/engine.py and add tests for all acceptance criteria.
```
*Highlight:* Notice the prompt never mentions `Decimal`, `ROUND_HALF_UP`, `PERCENT` before `FIXED` ordering, duplicate code deduplication, or the 50% cap—Antigravity automatically follows `AGENTS.md` $\rightarrow$ `@DESIGN.md` and `.agents/rules/discount-invariants.md`.
