# Online Boutique — Order Discount & Promo Service Guidelines

## §1. Core Engineering Mandate
- All architectural contracts, domain data models, currency rounding rules, and executable acceptance criteria are defined in `@DESIGN.md`.
- Always read and enforce `@DESIGN.md` and `.agents/rules/discount-invariants.md` before proposing or modifying any code in `src/discountservice/`.

## §2. Verification Gate
- Every change must include unit tests covering all acceptance criteria in `@DESIGN.md`.
- Run `pytest` and `python3 -m py_compile` before marking any task complete.
