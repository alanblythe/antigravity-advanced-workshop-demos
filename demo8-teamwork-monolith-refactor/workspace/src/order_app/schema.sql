CREATE TABLE IF NOT EXISTS catalog_products (
    sku TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    price_usd TEXT NOT NULL,
    weight_kg TEXT NOT NULL,
    stock_qty INTEGER NOT NULL CHECK (stock_qty >= 0)
);

CREATE TABLE IF NOT EXISTS customer_orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    currency TEXT NOT NULL,
    subtotal_amount TEXT NOT NULL,
    shipping_amount TEXT NOT NULL,
    tax_amount TEXT NOT NULL,
    total_amount TEXT NOT NULL,
    status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS order_line_items (
    order_id TEXT NOT NULL,
    sku TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price_usd TEXT NOT NULL,
    PRIMARY KEY (order_id, sku),
    FOREIGN KEY (order_id) REFERENCES customer_orders(order_id)
);

CREATE TABLE IF NOT EXISTS payment_ledger (
    ledger_id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    charged_currency TEXT NOT NULL,
    charged_amount TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES customer_orders(order_id)
);
