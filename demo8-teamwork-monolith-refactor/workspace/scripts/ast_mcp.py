#!/usr/bin/env python3
"""Zero-dependency Pure-Python Model Context Protocol (MCP) Server for AST Analysis.

Provides AST-based static code analysis, symbol extraction, and call graph navigation
over standard stdio JSON-RPC without third-party packages or native compiled binaries.
Compatible with Antigravity, Claude Code, and Cursor.
"""

from __future__ import annotations

import ast
import json
import os
import sys
from typing import Any, Dict, List, Optional


def find_callers(target_func: str, search_dir: str = ".") -> List[Dict[str, Any]]:
    """Recursively search for all callers of a target function or method."""
    callers = []
    abs_search_dir = os.path.abspath(search_dir)

    for root, _, files in os.walk(abs_search_dir):
        for f in files:
            if not f.endswith(".py"):
                continue
            path = os.path.join(root, f)
            try:
                with open(path, "r", encoding="utf-8") as src:
                    tree = ast.parse(src.read(), filename=path)
            except Exception:
                continue

            for node in ast.walk(tree):
                if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
                    for child in ast.walk(node):
                        if isinstance(child, ast.Call):
                            attr = getattr(child.func, "attr", None) or getattr(child.func, "id", None)
                            if attr == target_func:
                                rel_path = os.path.relpath(path, abs_search_dir)
                                callers.append({
                                    "file": rel_path,
                                    "caller_function": node.name,
                                    "line": child.lineno,
                                })
    return callers


def list_symbols(file_path: str) -> List[Dict[str, Any]]:
    """List top-level and nested classes, methods, and functions in a Python file."""
    symbols = []
    try:
        with open(file_path, "r", encoding="utf-8") as src:
            tree = ast.parse(src.read(), filename=file_path)
    except Exception as e:
        return [{"error": f"Failed to parse {file_path}: {e}"}]

    for node in ast.iter_child_nodes(tree):
        if isinstance(node, ast.ClassDef):
            methods = [
                m.name for m in node.body if isinstance(m, (ast.FunctionDef, ast.AsyncFunctionDef))
            ]
            symbols.append({
                "type": "class",
                "name": node.name,
                "line": node.lineno,
                "methods": methods,
            })
        elif isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            symbols.append({
                "type": "function",
                "name": node.name,
                "line": node.lineno,
            })
    return symbols


TOOLS = [
    {
        "name": "find_callers",
        "description": "Searches Python AST call trees to find all functions and methods calling a target function. Returns file paths, enclosing function names, and line numbers without context bloat.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "target_func": {
                    "type": "string",
                    "description": "Name of the function or method to locate calls to (e.g. 'reconcile_transaction').",
                },
                "search_dir": {
                    "type": "string",
                    "description": "Directory to search within (defaults to current directory).",
                },
            },
            "required": ["target_func"],
        },
    },
    {
        "name": "list_symbols",
        "description": "Extracts classes, methods, and function signatures from a Python file using AST parsing without reading full file bodies.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "file_path": {
                    "type": "string",
                    "description": "Relative or absolute path to the Python file to inspect.",
                },
            },
            "required": ["file_path"],
        },
    },
]


def send_response(msg_id: Any, result: Any) -> None:
    resp = {"jsonrpc": "2.0", "id": msg_id, "result": result}
    sys.stdout.write(json.dumps(resp) + "\n")
    sys.stdout.flush()


def send_error(msg_id: Any, code: int, message: str) -> None:
    resp = {"jsonrpc": "2.0", "id": msg_id, "error": {"code": code, "message": message}}
    sys.stdout.write(json.dumps(resp) + "\n")
    sys.stdout.flush()


def handle_request(line: str) -> None:
    try:
        req = json.loads(line)
    except Exception:
        return

    msg_id = req.get("id")
    method = req.get("method")
    params = req.get("params", {})

    if method == "initialize":
        send_response(msg_id, {
            "protocolVersion": "2024-11-05",
            "capabilities": {"tools": {}},
            "serverInfo": {"name": "ast-mcp", "version": "1.0.0"},
        })
    elif method == "notifications/initialized":
        pass
    elif method == "tools/list":
        send_response(msg_id, {"tools": TOOLS})
    elif method == "tools/call":
        tool_name = params.get("name")
        args = params.get("arguments", {})

        if tool_name == "find_callers":
            target = args.get("target_func", "")
            sdir = args.get("search_dir", ".")
            results = find_callers(target, sdir)
            send_response(msg_id, {
                "content": [{"type": "text", "text": json.dumps(results, indent=2)}]
            })
        elif tool_name == "list_symbols":
            fpath = args.get("file_path", "")
            results = list_symbols(fpath)
            send_response(msg_id, {
                "content": [{"type": "text", "text": json.dumps(results, indent=2)}]
            })
        else:
            send_error(msg_id, -32601, f"Tool not found: {tool_name}")
    elif method == "ping":
        send_response(msg_id, {})
    elif msg_id is not None:
        send_error(msg_id, -32601, f"Method not found: {method}")


def main() -> None:
    for line in sys.stdin:
        if line.strip():
            handle_request(line)


if __name__ == "__main__":
    main()
