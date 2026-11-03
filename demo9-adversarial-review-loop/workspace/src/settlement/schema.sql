CREATE TABLE IF NOT EXISTS settlement_ledger (
    event_id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    amount_cents INTEGER NOT NULL CHECK (amount_cents > 0),
    currency TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('PENDING', 'SETTLED', 'FAILED')),
    attempts INTEGER NOT NULL DEFAULT 0
);
