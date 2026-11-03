CREATE TABLE IF NOT EXISTS products (
    sku TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    available_qty INTEGER NOT NULL CHECK (available_qty >= 0)
);

CREATE TABLE IF NOT EXISTS inventory_holds (
    reservation_id TEXT NOT NULL,
    sku TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    status TEXT NOT NULL CHECK (status IN ('ACTIVE', 'EXPIRED', 'RELEASED')),
    expires_at INTEGER NOT NULL,
    PRIMARY KEY (reservation_id, sku),
    FOREIGN KEY (sku) REFERENCES products(sku)
);
