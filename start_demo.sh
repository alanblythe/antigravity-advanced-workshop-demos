#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_NUM="${1:-all}"

echo "============================================================"
echo "  Resetting Workshop Demonstration Workbench (Pattern A)    "
echo "============================================================"

reset_demo1() {
    echo "==> Resetting Demo 1: Enterprise Surface & Standards..."
    cd "$ROOT_DIR/demo1-enterprise-surface"
    ./start_demo.sh >/dev/null
    echo "    ✔ Demo 1 clean."
}

reset_demo2() {
    echo "==> Resetting Demo 2: Spec-Driven Coding, Worktrees & Browser..."
    cd "$ROOT_DIR/demo2-spec-driven-sdlc"
    ./start_demo.sh >/dev/null
    echo "    ✔ Demo 2 clean."
}

reset_demo3() {
    echo "==> Resetting Demo 3: Database MCP Toolbox Guardrails..."
    cd "$ROOT_DIR/demo3-database-guardrails"
    ./start_demo.sh >/dev/null
    echo "    ✔ Demo 3 clean."
}

reset_demo4() {
    echo "==> Resetting Demo 4: Cloud Agent Platform (GEAP)..."
    cd "$ROOT_DIR/demo4-cloud-agent-platform"
    ./start_demo.sh >/dev/null
    echo "    ✔ Demo 4 clean."
}

reset_demo5() {
    echo "==> Resetting Demo 5: Elephant-Goldfish Model (EGM) Architecture RFC..."
    cd "$ROOT_DIR/demo5-egm-architecture-rfc"
    ./start_demo.sh >/dev/null
    echo "    ✔ Demo 5 clean."
}

reset_demo6() {
    echo "==> Resetting Demo 6: Grounding Specs, Linked ADRs & Boost..."
    cd "$ROOT_DIR/demo6-linked-design-boost"
    ./start_demo.sh >/dev/null
    echo "    ✔ Demo 6 clean."
}

reset_demo7() {
    echo "==> Resetting Demo 7: Contract-First Spec Clarification & Test-Heal Loop..."
    cd "$ROOT_DIR/demo7-contract-spec-tdd"
    ./start_demo.sh >/dev/null
    echo "    ✔ Demo 7 clean."
}

reset_demo8() {
    echo "==> Resetting Demo 8: Graph Planning & Multi-Agent /teamwork Refactor..."
    cd "$ROOT_DIR/demo8-teamwork-monolith-refactor"
    ./start_demo.sh >/dev/null
    echo "    ✔ Demo 8 clean."
}

reset_demo9() {
    echo "==> Resetting Demo 9: Clean-Context Adversarial Review Loop..."
    cd "$ROOT_DIR/demo9-adversarial-review-loop"
    ./start_demo.sh >/dev/null
    echo "    ✔ Demo 9 clean."
}

case "$DEMO_NUM" in
    1) reset_demo1 ;;
    2) reset_demo2 ;;
    3) reset_demo3 ;;
    4) reset_demo4 ;;
    5) reset_demo5 ;;
    6) reset_demo6 ;;
    7) reset_demo7 ;;
    8) reset_demo8 ;;
    9) reset_demo9 ;;
    201)
        reset_demo6
        reset_demo7
        reset_demo8
        reset_demo9
        ;;
    all)
        reset_demo1
        reset_demo2
        reset_demo3
        reset_demo4
        reset_demo5
        reset_demo6
        reset_demo7
        reset_demo8
        reset_demo9
        ;;
    *)
        echo "Usage: ./start_demo.sh [1|2|3|4|5|6|7|8|9|201|all]"
        exit 1
        ;;
esac

echo "============================================================"
echo "✔ All requested demo environments are pristine & ready!"
echo "============================================================"
