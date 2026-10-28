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
    if [[ -d ".worktrees/feat-reconcile" ]]; then
        git worktree remove -f .worktrees/feat-reconcile 2>/dev/null || rm -rf .worktrees/feat-reconcile
    fi
    git branch -D feat/reconcile 2>/dev/null || true
    rm -rf .worktrees .scratch/browser-verification.png
    if [[ -f "$ROOT_DIR/.git/info/exclude" ]]; then
        grep -v '\.worktrees' "$ROOT_DIR/.git/info/exclude" > "$ROOT_DIR/.git/info/exclude.tmp" 2>/dev/null && mv "$ROOT_DIR/.git/info/exclude.tmp" "$ROOT_DIR/.git/info/exclude" || true
    fi
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

case "$DEMO_NUM" in
    1) reset_demo1 ;;
    2) reset_demo2 ;;
    3) reset_demo3 ;;
    4) reset_demo4 ;;
    5) reset_demo5 ;;
    all)
        reset_demo1
        reset_demo2
        reset_demo3
        reset_demo4
        reset_demo5
        ;;
    *)
        echo "Usage: ./start_demo.sh [1|2|3|4|5|all]"
        exit 1
        ;;
esac

echo "============================================================"
echo "✔ All requested demo environments are pristine & ready!"
echo "============================================================"
