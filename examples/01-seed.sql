-- Sample data for MySQL in Action — Free Learning Edition

USE mysql_in_action;

INSERT INTO customers (full_name, email, customer_status, created_at)
VALUES
    ('Anan Krit', 'anan@example.com', 'active', '2026-01-05 09:00:00'),
    ('Mali Suda', 'mali@example.com', 'active', '2026-01-08 10:15:00'),
    ('Narin Chai', 'narin@example.com', 'active', '2026-01-10 11:30:00'),
    ('Pim Rin', 'pim@example.com', 'active', '2026-01-12 13:00:00'),
    ('Korn Dee', 'korn@example.com', 'inactive', '2026-01-15 14:20:00'),
    ('Jane Moon', 'jane@example.com', 'active', '2026-02-01 08:45:00'),
    ('Somchai Jai', 'somchai@example.com', 'active', '2026-02-04 15:10:00'),
    ('Nok Dao', 'nok@example.com', 'blocked', '2026-02-08 16:25:00'),
    ('Tawan Sri', 'tawan@example.com', 'active', '2026-02-12 10:40:00'),
    ('Kanya Ploy', 'kanya@example.com', 'active', '2026-02-15 12:00:00');

INSERT INTO products (
    sku, product_name, unit_price, stock_qty, attributes, product_status
)
VALUES
    ('KB-001', 'Mechanical Keyboard', 2490.00, 25,
     JSON_OBJECT('color', 'black', 'features', JSON_ARRAY('wired', 'rgb')), 'active'),
    ('MS-001', 'Wireless Mouse', 890.00, 60,
     JSON_OBJECT('color', 'white', 'features', JSON_ARRAY('wireless', 'silent')), 'active'),
    ('MN-027', '27-inch Monitor', 6990.00, 15,
     JSON_OBJECT('resolution', '2560x1440', 'features', JSON_ARRAY('ips', 'usb-c')), 'active'),
    ('HB-001', 'USB-C Hub', 1290.00, 40,
     JSON_OBJECT('ports', 7, 'features', JSON_ARRAY('usb-c', 'hdmi')), 'active'),
    ('HD-001', 'External SSD 1TB', 3290.00, 30,
     JSON_OBJECT('capacity', '1TB', 'features', JSON_ARRAY('usb-c', 'portable')), 'active'),
    ('WC-001', 'Webcam Full HD', 1590.00, 22,
     JSON_OBJECT('resolution', '1080p', 'features', JSON_ARRAY('autofocus')), 'active'),
    ('HP-001', 'Noise-Cancelling Headphones', 4590.00, 18,
     JSON_OBJECT('color', 'gray', 'features', JSON_ARRAY('wireless', 'anc')), 'active'),
    ('ST-001', 'Laptop Stand', 1190.00, 35,
     JSON_OBJECT('material', 'aluminum', 'features', JSON_ARRAY('adjustable')), 'active'),
    ('MC-001', 'USB Microphone', 2890.00, 16,
     JSON_OBJECT('pattern', 'cardioid', 'features', JSON_ARRAY('usb-c')), 'active'),
    ('CB-001', 'USB-C Cable 2m', 390.00, 100,
     JSON_OBJECT('length', '2m', 'features', JSON_ARRAY('100w')), 'active'),
    ('PD-001', 'Power Delivery Charger 65W', 1490.00, 45,
     JSON_OBJECT('power', '65W', 'features', JSON_ARRAY('gan', 'usb-c')), 'active'),
    ('BG-001', 'Laptop Backpack', 1890.00, 28,
     JSON_OBJECT('size', '15-inch', 'features', JSON_ARRAY('water-resistant')), 'active');

INSERT INTO orders (customer_id, order_status, ordered_at, notes)
VALUES
    (1, 'paid',      '2026-03-01 10:00:00', NULL),
    (1, 'shipped',   '2026-03-05 14:30:00', 'Deliver after 17:00'),
    (2, 'pending',   '2026-03-07 09:15:00', NULL),
    (3, 'completed', '2026-03-10 11:20:00', NULL),
    (4, 'cancelled', '2026-03-12 16:10:00', 'Customer changed mind'),
    (6, 'paid',      '2026-04-02 10:45:00', NULL),
    (7, 'shipped',   '2026-04-08 13:25:00', NULL),
    (9, 'completed', '2026-04-15 15:40:00', NULL),
    (10, 'paid',     '2026-05-01 09:05:00', NULL),
    (2, 'paid',      '2026-05-04 12:35:00', NULL),
    (3, 'pending',   '2026-05-10 14:50:00', NULL),
    (1, 'completed', '2026-06-01 08:30:00', NULL),
    (6, 'paid',      '2026-06-12 10:10:00', NULL),
    (7, 'shipped',   '2026-07-03 11:45:00', NULL),
    (9, 'paid',      '2026-07-15 16:20:00', NULL);

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 2490.00),
    (1, 2, 2, 890.00),
    (2, 3, 1, 6990.00),
    (2, 4, 1, 1290.00),
    (3, 4, 3, 1290.00),
    (4, 5, 1, 3290.00),
    (4, 10, 2, 390.00),
    (5, 7, 1, 4590.00),
    (6, 6, 1, 1590.00),
    (6, 8, 1, 1190.00),
    (7, 7, 1, 4590.00),
    (7, 11, 1, 1490.00),
    (8, 3, 2, 6990.00),
    (9, 9, 1, 2890.00),
    (9, 10, 3, 390.00),
    (10, 2, 1, 890.00),
    (10, 12, 1, 1890.00),
    (11, 1, 1, 2490.00),
    (12, 5, 1, 3290.00),
    (12, 11, 2, 1490.00),
    (13, 4, 1, 1290.00),
    (13, 10, 2, 390.00),
    (14, 6, 2, 1590.00),
    (14, 8, 2, 1190.00),
    (15, 3, 1, 6990.00),
    (15, 7, 1, 4590.00);

INSERT INTO payments (
    order_id, payment_reference, payment_status, paid_amount, paid_at
)
VALUES
    (1,  'PAY-20260301-001', 'successful', 4270.00,  '2026-03-01 10:05:00'),
    (2,  'PAY-20260305-002', 'successful', 8280.00,  '2026-03-05 14:35:00'),
    (3,  'PAY-20260307-003', 'pending',    3870.00,  NULL),
    (4,  'PAY-20260310-004', 'successful', 4070.00,  '2026-03-10 11:25:00'),
    (5,  'PAY-20260312-005', 'failed',     4590.00,  NULL),
    (6,  'PAY-20260402-006', 'successful', 2780.00,  '2026-04-02 10:50:00'),
    (7,  'PAY-20260408-007', 'successful', 6080.00,  '2026-04-08 13:30:00'),
    (8,  'PAY-20260415-008', 'successful', 13980.00, '2026-04-15 15:45:00'),
    (9,  'PAY-20260501-009', 'successful', 4060.00,  '2026-05-01 09:10:00'),
    (10, 'PAY-20260504-010', 'successful', 2780.00,  '2026-05-04 12:40:00'),
    (12, 'PAY-20260601-012', 'successful', 6270.00,  '2026-06-01 08:35:00'),
    (13, 'PAY-20260612-013', 'successful', 2070.00,  '2026-06-12 10:15:00'),
    (14, 'PAY-20260703-014', 'successful', 5560.00,  '2026-07-03 11:50:00'),
    (15, 'PAY-20260715-015', 'successful', 11580.00, '2026-07-15 16:25:00');

-- Sanity checks
SELECT COUNT(*) AS customer_count FROM customers;
SELECT COUNT(*) AS product_count FROM products;
SELECT COUNT(*) AS order_count FROM orders;
SELECT COUNT(*) AS order_item_count FROM order_items;
SELECT COUNT(*) AS payment_count FROM payments;
