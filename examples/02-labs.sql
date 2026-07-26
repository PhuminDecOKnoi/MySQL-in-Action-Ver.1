-- MySQL in Action — Guided Labs
-- Run after 00-schema.sql and 01-seed.sql

USE mysql_in_action;

-- =========================================================
-- LAB 1: Basic SELECT, filtering, sorting and limiting
-- =========================================================

-- 1.1 Active customers created from February 2026 onward
SELECT
    customer_id,
    full_name,
    email,
    created_at
FROM customers
WHERE customer_status = 'active'
  AND created_at >= '2026-02-01 00:00:00'
ORDER BY created_at DESC;

-- 1.2 Five most recent orders with deterministic ordering
SELECT
    order_id,
    customer_id,
    order_status,
    ordered_at
FROM orders
ORDER BY ordered_at DESC, order_id DESC
LIMIT 5;

-- =========================================================
-- LAB 2: JOIN and aggregation
-- =========================================================

-- 2.1 Include customers with no orders
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY order_count DESC, c.customer_id;

-- 2.2 Order totals with customer names
SELECT
    o.order_id,
    c.full_name,
    o.order_status,
    SUM(oi.line_total) AS order_total
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON oi.order_id = o.order_id
GROUP BY
    o.order_id,
    c.full_name,
    o.order_status
ORDER BY order_total DESC;

-- =========================================================
-- LAB 3: CTE and window functions
-- =========================================================

-- 3.1 Rank products by units sold
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS units_sold
    FROM products AS p
    JOIN order_items AS oi
        ON oi.product_id = p.product_id
    JOIN orders AS o
        ON o.order_id = oi.order_id
    WHERE o.order_status IN ('paid', 'shipped', 'completed')
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    units_sold,
    DENSE_RANK() OVER (ORDER BY units_sold DESC) AS sales_rank
FROM product_sales
ORDER BY sales_rank, product_id;

-- 3.2 Daily sales and running total
WITH daily_sales AS (
    SELECT
        DATE(o.ordered_at) AS sale_date,
        SUM(oi.line_total) AS daily_total
    FROM orders AS o
    JOIN order_items AS oi
        ON oi.order_id = o.order_id
    WHERE o.order_status IN ('paid', 'shipped', 'completed')
    GROUP BY DATE(o.ordered_at)
)
SELECT
    sale_date,
    daily_total,
    SUM(daily_total) OVER (
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM daily_sales
ORDER BY sale_date;

-- 3.3 Customers whose total spending is above the customer average
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.full_name,
        COALESCE(SUM(oi.line_total), 0.00) AS total_spending
    FROM customers AS c
    LEFT JOIN orders AS o
        ON o.customer_id = c.customer_id
       AND o.order_status IN ('paid', 'shipped', 'completed')
    LEFT JOIN order_items AS oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.full_name
),
average_spending AS (
    SELECT AVG(total_spending) AS avg_spending
    FROM customer_totals
)
SELECT
    ct.customer_id,
    ct.full_name,
    ct.total_spending
FROM customer_totals AS ct
CROSS JOIN average_spending AS a
WHERE ct.total_spending > a.avg_spending
ORDER BY ct.total_spending DESC;

-- =========================================================
-- LAB 4: Payment and exception reporting
-- =========================================================

-- 4.1 Orders without a successful payment
SELECT
    o.order_id,
    c.full_name,
    o.order_status,
    o.ordered_at
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
WHERE NOT EXISTS (
    SELECT 1
    FROM payments AS p
    WHERE p.order_id = o.order_id
      AND p.payment_status = 'successful'
)
ORDER BY o.ordered_at;

-- 4.2 Compare expected order total with successful payment amount
SELECT
    v.order_id,
    v.order_total,
    COALESCE(SUM(p.paid_amount), 0.00) AS successful_payment_total,
    v.order_total - COALESCE(SUM(p.paid_amount), 0.00) AS difference
FROM v_order_totals AS v
LEFT JOIN payments AS p
    ON p.order_id = v.order_id
   AND p.payment_status = 'successful'
GROUP BY v.order_id, v.order_total
HAVING difference <> 0
ORDER BY ABS(difference) DESC;

-- =========================================================
-- LAB 5: JSON queries
-- =========================================================

SELECT
    product_id,
    product_name,
    attributes ->> '$.color' AS color
FROM products
WHERE JSON_CONTAINS(attributes, '"wireless"', '$.features');

-- =========================================================
-- LAB 6: Performance analysis
-- =========================================================

EXPLAIN FORMAT=TREE
SELECT
    order_id,
    customer_id,
    order_status,
    ordered_at
FROM orders
WHERE order_status = 'paid'
ORDER BY ordered_at DESC
LIMIT 20;

EXPLAIN ANALYZE
SELECT
    order_id,
    customer_id,
    order_status,
    ordered_at
FROM orders
WHERE order_status = 'paid'
ORDER BY ordered_at DESC
LIMIT 20;

-- Avoid wrapping the indexed column in DATE() when a range works.
EXPLAIN ANALYZE
SELECT
    order_id,
    ordered_at
FROM orders
WHERE ordered_at >= '2026-07-01 00:00:00'
  AND ordered_at <  '2026-08-01 00:00:00';

-- =========================================================
-- LAB 7: Transaction exercise template
-- Run interactively and replace the IDs as needed.
-- =========================================================

START TRANSACTION;

SELECT product_id, stock_qty
FROM products
WHERE product_id = 2
FOR UPDATE;

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 2
  AND stock_qty >= 1;

-- Confirm ROW_COUNT() = 1 before continuing in an application workflow.
SELECT ROW_COUNT() AS affected_rows;

-- Use ROLLBACK during practice to preserve the seed dataset.
ROLLBACK;

-- =========================================================
-- CHALLENGES — no complete answer supplied here
-- =========================================================

-- A. Show monthly revenue and month-over-month difference.
-- B. Return the latest order for each customer.
-- C. Find products that have never been ordered.
-- D. Build keyset pagination using (ordered_at, order_id).
-- E. Propose an index for each challenge and verify with EXPLAIN.
