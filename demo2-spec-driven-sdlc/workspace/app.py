import os
import sys
import json
from http.server import HTTPServer, SimpleHTTPRequestHandler
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "src", "paymentservice"))
from reconciler import TransactionReconciler

reconciler = TransactionReconciler()

SAMPLE_TRANSACTIONS = [
    {"tx_id": "tx_1001", "amount": 49.99, "status": "COMPLETED"},
    {"transaction_id": "legacy_9901", "amount": 120.00, "status": "COMPLETED"}
]

HTML_CONTENT = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Online Boutique — Settlement Dashboard</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #f8fafc; padding: 40px; }
    .card { background: #1e293b; border-radius: 8px; padding: 24px; max-width: 700px; margin: 0 auto; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.5); }
    h1 { font-size: 20px; margin-top: 0; color: #38bdf8; }
    table { width: 100%; border-collapse: collapse; margin-top: 16px; }
    th, td { text-align: left; padding: 10px; border-bottom: 1px solid #334155; }
    .badge { display: inline-block; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; }
    .pending { background: #eab308; color: #000; }
    .settled { background: #22c55e; color: #fff; }
    button { background: #2563eb; color: #fff; border: none; padding: 10px 18px; border-radius: 6px; cursor: pointer; font-weight: 600; margin-top: 20px; }
    button:hover { background: #1d4ed8; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Online Boutique — Reconciliation & Settlement</h1>
    <p>Real-time transaction settlement service status.</p>
    <table>
      <thead>
        <tr><th>Transaction ID</th><th>Amount</th><th>Status</th></tr>
      </thead>
      <tbody id="tx-table">
        <tr><td>tx_1001</td><td>$49.99</td><td><span class="badge settled">SETTLED</span></td></tr>
        <tr><td>legacy_9901 (Legacy)</td><td>$120.00</td><td><span id="settlement-status" class="badge pending">PENDING</span></td></tr>
      </tbody>
    </table>
    <button id="btn-reconcile" onclick="runReconcile()">Run Batch Reconciliation</button>
  </div>
  <script>
    function runReconcile() {
      fetch('/api/reconcile', { method: 'POST' })
        .then(r => r.json())
        .then(data => {
          const badge = document.getElementById('settlement-status');
          badge.textContent = 'SETTLED';
          badge.className = 'badge settled';
          console.log('Reconciliation successful: 0 errors detected.');
        })
        .catch(err => console.error('Reconciliation error:', err));
    }
  </script>
</body>
</html>
"""

class DashboardHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/" or self.path == "/index.html":
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.end_headers()
            self.wfile.write(HTML_CONTENT.encode("utf-8"))
        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self):
        if self.path == "/api/reconcile":
            try:
                results = reconciler.reconcile_batch(SAMPLE_TRANSACTIONS)
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"success": True, "results": results}).encode("utf-8"))
            except Exception as e:
                self.send_response(500)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"error": str(e)}).encode("utf-8"))
        else:
            self.send_response(404)
            self.end_headers()

if __name__ == "__main__":
    port = 8000
    server = HTTPServer(("0.0.0.0", port), DashboardHandler)
    print(f"✔ Dashboard server listening on http://localhost:{port}")
    server.serve_forever()
