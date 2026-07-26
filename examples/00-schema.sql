-- MySQL in Action — Free Learning Edition
-- Teaching baseline: MySQL Community Server 8.4 LTS

DROP DATABASE IF EXISTS mysql_in_action;

CREATE DATABASE mysql_in_action
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE mysql_in_action;

CREATE TABLE customers (
    customer_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    customer_status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_customers_email UNIQUE (email),
    CONSTRAINT chk_customers_status
        CHECK (customer_status IN ('active', 'inactive', 'blocked'))
) ENGINE = InnoDB;

CREATE TABLE products (
    product_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    sku VARCHAR(50) NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    stock_qty INT NOT NULL DEFAULT 0,
    attributes JSON NULL,
    product_status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_products_sku UNIQUE (sku),
    CONSTRAINT chk_products_price CHECK (unit_price >= 0),
    CONSTRAINT chk_products_stock CHECK (stock_qty >= 0),
    CONSTRAINT chk_products_status
        CHECK (product_status IN ('active', 'inactive', 'discontinued'))
) ENGINE = InnoDB;

CREATE TABLE orders (
    order_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT UNSIGNED NOT NULL,
    order_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    ordered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes VARCHAR(500) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_orders_status
        CHECK (order_status IN (
            'pending', 'paid', 'shipped', 'completed', 'cancelled'
        )),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE order_items (
    order_item_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    line_total DECIMAL(14,2)
        GENERATED ALWAYS AS (quantity * unit_price) STORED,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_order_items_order_product
        UNIQUE (order_id, product_id),
    CONSTRAINT chk_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT chk_order_items_price CHECK (unit_price >= 0),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE payments (
    payment_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT UNSIGNED NOT NULL,
    payment_reference VARCHAR(100) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    paid_amount DECIMAL(12,2) NOT NULL,
    paid_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_payments_reference UNIQUE (payment_reference),
    CONSTRAINT chk_payments_amount CHECK (paid_amount >= 0),
    CONSTRAINT chk_payments_status
        CHECK (payment_status IN ('pending', 'successful', 'failed', 'refunded')),
    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Indexes are selected from the teaching query patterns.
CREATE INDEX idx_orders_customer_date
    ON orders (customer_id, ordered_at);

CREATE INDEX idx_orders_status_date
    ON orders (order_status, ordered_at);

CREATE INDEX idx_order_items_product
    ON order_items (product_id);

CREATE INDEX idx_payments_order_status
    ON payments (order_id, payment_status);

-- View for recurring order-total queries.
CREATE OR REPLACE VIEW v_order_totals AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.ordered_at,
    COALESCE(SUM(oi.line_total), 0.00) AS order_total
FROM orders AS o
LEFT JOIN order_items AS oi
    ON oi.order_id = o.order_id
GROUP BY
    o.order_id,
    o.customer_id,
    o.order_status,
    o.ordered_at;
