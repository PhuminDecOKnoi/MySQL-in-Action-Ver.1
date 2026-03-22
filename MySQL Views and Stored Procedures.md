File Name: MySQL Views and Stored Procedures.md

# MySQL Views and Stored Procedures

## บทนำ

`Views` และ `Stored Procedures` เป็นเครื่องมือสำคัญของ MySQL ที่ช่วยให้การจัดการข้อมูลเป็นระบบมากขึ้น ลดการเขียน SQL ซ้ำ และทำให้ logic บางส่วนถูกย้ายมาอยู่ใกล้ฐานข้อมูลมากขึ้น

- `View` เหมาะกับการสร้าง “ตารางเสมือน” จาก query ที่ใช้ซ้ำบ่อย เช่น รายงานพนักงานพร้อมชื่อแผนก รายการ order ที่ชำระเงินแล้ว หรือข้อมูลสรุปที่ใช้ใน dashboard
- `Stored Procedure` เหมาะกับการรวมหลายคำสั่ง SQL เป็นขั้นตอนการทำงานที่เรียกใช้ซ้ำได้ เช่น การเพิ่มข้อมูลแบบมีเงื่อนไข การอัปเดตหลายตาราง หรือการทำงานที่ต้องควบคุมด้วย transaction

หัวข้อนี้เหมาะสำหรับผู้ที่เริ่มทำระบบจริงด้วย MySQL และต้องการจัดระเบียบ query กับ business logic ให้ชัดขึ้น อ่านง่ายขึ้น และดูแลต่อได้ดีขึ้น

## สิ่งที่ผู้เรียนจะได้เรียน

- ความหมายของ `View` และ `Stored Procedure`
- ความต่างระหว่างสองแนวคิดนี้
- วิธีสร้างและใช้งาน `CREATE VIEW`
- วิธีสร้างและเรียกใช้ `CREATE PROCEDURE`
- การใช้ parameter ใน stored procedure
- การใช้ procedure ร่วมกับ `INSERT`, `UPDATE`, และ `TRANSACTION`
- ข้อดี ข้อจำกัด และ use case ที่เหมาะสมในงานจริง
- แนวปฏิบัติที่ช่วยให้ schema และ SQL maintain ง่ายขึ้น

## มองภาพรวมก่อน: Views และ Stored Procedures ต่างกันอย่างไร

แม้ทั้งสองอย่างจะช่วยลดการเขียน SQL ซ้ำ แต่หน้าที่ต่างกันชัดเจน

### View

- เป็น query ที่ถูกตั้งชื่อไว้
- ใช้งานเหมือนอ่านจากตารางหนึ่งตาราง
- เหมาะกับการอ่านข้อมูล หรือจัดรูปแบบข้อมูลสำหรับ report และ application

### Stored Procedure

- เป็นชุดคำสั่ง SQL ที่ถูกตั้งชื่อไว้
- รองรับ parameter ได้
- เหมาะกับงานที่มีหลายขั้นตอน หรือมี logic การทำงาน

### สิ่งที่ควรเข้าใจ

- ถ้าต้องการ “มุมมองข้อมูล” ใช้ `View`
- ถ้าต้องการ “ขั้นตอนการทำงาน” ใช้ `Stored Procedure`
- งานจริงอาจใช้ทั้งสองอย่างร่วมกันได้

---

## ตารางตัวอย่างสำหรับบทเรียน

ตัวอย่างนี้จะใช้ระบบขายสินค้าแบบย่อ เพื่อสาธิตทั้ง `View` และ `Stored Procedure`

```sql
-- สร้างฐานข้อมูลตัวอย่าง
CREATE DATABASE shop_db;

-- เลือกใช้งานฐานข้อมูล
USE shop_db;

-- ตารางลูกค้า
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    customer_status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ตารางสินค้า
CREATE TABLE products (
    product_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ตารางคำสั่งซื้อ
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(30) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ตารางรายการสินค้าในคำสั่งซื้อ
CREATE TABLE order_items (
    order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

```sql
-- เพิ่มข้อมูลตัวอย่าง
INSERT INTO customers (full_name, email, customer_status)
VALUES
    ('Anan Krit', 'anan@example.com', 'active'),
    ('Mali Suda', 'mali@example.com', 'active'),
    ('Pim Rin', 'pim@example.com', 'inactive');

INSERT INTO products (product_name, price, stock)
VALUES
    ('Mechanical Keyboard', 2490.00, 20),
    ('Wireless Mouse', 890.00, 50),
    ('27-inch Monitor', 6990.00, 10),
    ('USB-C Hub', 1290.00, 30);

INSERT INTO orders (customer_id, order_date, order_status)
VALUES
    (1, '2026-03-01 10:00:00', 'paid'),
    (1, '2026-03-05 14:30:00', 'shipped'),
    (2, '2026-03-07 09:15:00', 'pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 2490.00),
    (1, 2, 2, 890.00),
    (2, 3, 1, 6990.00),
    (3, 4, 3, 1290.00);
```

### สิ่งที่ควรเข้าใจ

- โครงสร้างนี้เหมาะกับการทดลอง `JOIN`, `VIEW`, และ `PROCEDURE`
- ตารางแยกตามหน้าที่ชัดเจน ทำให้ต่อยอด query ได้ง่าย
- ใช้ `InnoDB` เป็นแนวทางที่เหมาะกับงานจริง โดยเฉพาะเมื่อมี transaction

---

# Part 1: Views in MySQL

## หัวข้อย่อยที่ 1: View คืออะไร

`View` คือผลลัพธ์ของ query ที่ถูกตั้งชื่อไว้ ทำให้เราเรียกใช้งาน query ซ้ำ ๆ ได้ง่ายขึ้น โดยไม่ต้องเขียน SQL ยาวทุกครั้ง

```sql
-- สร้าง view สำหรับรายชื่อ order พร้อมชื่อลูกค้า
CREATE VIEW view_orders_with_customers AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    c.customer_id,
    c.full_name,
    c.email
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

### สิ่งที่ควรเข้าใจ

- `View` ไม่ได้เก็บข้อมูลซ้ำแบบตารางปกติ
- มันเก็บ “คำสั่ง query” ไว้ แล้วดึงผลลัพธ์ตอนเรียกใช้
- เหมาะกับ query ที่ใช้ซ้ำบ่อยและต้องการชื่อที่สื่อความหมาย

---

## หัวข้อย่อยที่ 2: เรียกใช้งาน View

เมื่อสร้าง `View` แล้ว เราสามารถ query ได้เหมือนตารางหนึ่งตาราง

```sql
-- เรียกดูข้อมูลจาก view
SELECT *
FROM view_orders_with_customers;
```

```sql
-- กรองข้อมูลต่อจาก view ได้เหมือนตารางปกติ
SELECT order_id, full_name, order_status
FROM view_orders_with_customers
WHERE order_status = 'paid';
```

### สิ่งที่ควรเข้าใจ

- application มักใช้ `View` เพื่อให้อ่านข้อมูลได้ง่ายขึ้น
- ช่วยซ่อนความซับซ้อนของ `JOIN` จาก query หลักบางส่วน
- ใช้ต่อกับ `WHERE`, `ORDER BY`, และ `LIMIT` ได้

---

## หัวข้อย่อยที่ 3: View เหมาะกับงานแบบไหน

`View` เหมาะกับกรณีเช่น

- รายงานที่ใช้ `JOIN` เดิมซ้ำ ๆ
- dashboard ที่ต้องการข้อมูลรูปแบบคงที่
- การซ่อนคอลัมน์บางส่วนจากตารางจริง
- การทำ abstraction ให้ query อ่านง่ายขึ้น

```sql
-- view สำหรับรายการ order ที่ชำระเงินแล้ว
CREATE VIEW view_paid_orders AS
SELECT
    o.order_id,
    o.order_date,
    c.full_name,
    o.order_status
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'paid';
```

### สิ่งที่ควรเข้าใจ

- ช่วยให้ query ฝั่ง application สั้นลง
- ลดโอกาส copy-paste SQL ยาว ๆ หลายจุด
- เหมาะมากกับ query อ่านข้อมูลที่นิยามไว้ชัดเจนแล้ว

---

## หัวข้อย่อยที่ 4: View สำหรับรายงานสรุป

เราสามารถใช้ `View` กับ `GROUP BY` และ aggregate functions ได้เช่นกัน

```sql
-- view สำหรับสรุปยอดรวมต่อ order
CREATE VIEW view_order_totals AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status;
```

```sql
-- เรียกดูยอดรวมของแต่ละ order
SELECT *
FROM view_order_totals
ORDER BY order_date DESC;
```

### สิ่งที่ควรเข้าใจ

- `View` ช่วยทำให้ report query ใช้งานง่ายขึ้น
- ถ้า logic การสรุปข้อมูลใช้ซ้ำหลายจุด การทำเป็น view ช่วยลดความซ้ำซ้อน
- ควรตั้งชื่อให้สื่อว่ามันเป็นข้อมูลมุมมองแบบไหน

---

## หัวข้อย่อยที่ 5: ใช้ CREATE OR REPLACE VIEW

เวลาต้องปรับปรุงนิยามของ view เราสามารถ replace ได้

```sql
-- ปรับปรุง view เดิม
CREATE OR REPLACE VIEW view_orders_with_customers AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    c.customer_id,
    c.full_name,
    c.email,
    c.customer_status
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

### สิ่งที่ควรเข้าใจ

- มีประโยชน์มากเมื่อ schema หรือ requirement เปลี่ยน
- ช่วยให้ maintenance ง่ายกว่าการ drop แล้ว create ใหม่แยกขั้นตอน
- แต่ควรระวังผลกระทบต่อ application ที่เรียกใช้อยู่

---

## หัวข้อย่อยที่ 6: ลบ View

ถ้าไม่ต้องการใช้งานแล้ว สามารถลบได้ด้วย `DROP VIEW`

```sql
-- ลบ view เมื่อไม่ใช้งานแล้ว
DROP VIEW IF EXISTS view_paid_orders;
```

### สิ่งที่ควรเข้าใจ

- ใช้ `IF EXISTS` เพื่อลด error กรณี view ไม่มีอยู่
- ควรตรวจสอบก่อนว่าไม่มีระบบอื่นพึ่งพา view นี้อยู่

---

## หัวข้อย่อยที่ 7: ข้อดีของ View

### ข้อดีหลัก

- ลดการเขียน query ซ้ำ
- ช่วยให้อ่าน SQL ฝั่ง application ง่ายขึ้น
- ซ่อนความซับซ้อนของ `JOIN` และ `GROUP BY`
- ช่วยกำหนดมุมมองข้อมูลมาตรฐานให้ทีมใช้ร่วมกัน

```sql
-- ฝั่ง application เรียกได้สั้นลงมาก
SELECT order_id, full_name, order_total
FROM view_order_totals;
```

### สิ่งที่ควรเข้าใจ

- view เหมาะกับการจัดระเบียบ query มากกว่าการแทนทุกอย่าง
- ควรใช้กับ query ที่ stable และมีความหมายชัดเจน

---

## หัวข้อย่อยที่ 8: ข้อจำกัดของ View

แม้ `View` จะสะดวก แต่ก็มีข้อควรระวัง

- บาง view อาจ update ไม่ได้ โดยเฉพาะเมื่อมี `JOIN`, `GROUP BY`, หรือ aggregate
- ถ้า view ซับซ้อนมาก performance อาจไม่ดีตามที่หวัง
- ถ้า view ซ้อนหลายชั้นเกินไป maintenance อาจยาก

```sql
-- ตัวอย่าง view ที่เน้นการอ่านรายงานมากกว่าการแก้ไขข้อมูล
CREATE VIEW view_product_sales_summary AS
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_qty_sold
FROM products AS p
LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;
```

### สิ่งที่ควรเข้าใจ

- ไม่ใช่ทุก view จะเหมาะกับการใช้แทน table ในทุกบริบท
- ควรใช้ view เพื่อ “ช่วยอ่าน” มากกว่า “ซ่อนทุกอย่าง”

---

# Part 2: Stored Procedures in MySQL

## หัวข้อย่อยที่ 9: Stored Procedure คืออะไร

`Stored Procedure` คือชุดคำสั่ง SQL ที่ถูกเก็บไว้ในฐานข้อมูล และสามารถเรียกใช้ซ้ำได้ด้วยชื่อเดียว เหมาะกับงานที่มีหลายขั้นตอนหรือมี parameter

```sql
-- เปลี่ยน delimiter ชั่วคราว เพื่อให้เขียน procedure หลายบรรทัดได้
DELIMITER //

CREATE PROCEDURE get_all_customers()
BEGIN
    -- ดึงข้อมูลลูกค้าทั้งหมด
    SELECT customer_id, full_name, email, customer_status
    FROM customers
    ORDER BY customer_id ASC;
END //

DELIMITER ;
```

### สิ่งที่ควรเข้าใจ

- procedure คือ “ฟังก์ชันฝั่งฐานข้อมูล” ในเชิงแนวคิด
- เหมาะกับ logic ที่ต้องเรียกใช้ซ้ำบ่อย
- ใช้ `CALL procedure_name()` เพื่อเรียกใช้งาน

---

## หัวข้อย่อยที่ 10: การเรียกใช้ Stored Procedure

```sql
-- เรียกใช้ procedure
CALL get_all_customers();
```

### สิ่งที่ควรเข้าใจ

- การเรียก procedure ช่วยลดการเขียน SQL ยาวซ้ำในหลายจุด
- application สามารถเรียก procedure ได้เหมือนเรียกคำสั่งหนึ่งคำสั่ง

---

## หัวข้อย่อยที่ 11: Procedure ที่รับ Parameter

จุดแข็งสำคัญของ stored procedure คือการรับ parameter ได้

```sql
DELIMITER //

CREATE PROCEDURE get_orders_by_status(IN p_status VARCHAR(30))
BEGIN
    -- ดึง order ตามสถานะที่ส่งเข้ามา
    SELECT order_id, customer_id, order_date, order_status
    FROM orders
    WHERE order_status = p_status
    ORDER BY order_date DESC;
END //

DELIMITER ;
```

```sql
-- เรียกดูเฉพาะ order ที่ paid
CALL get_orders_by_status('paid');
```

### สิ่งที่ควรเข้าใจ

- `IN` หมายถึง parameter ที่ส่งค่าเข้าไป
- ทำให้ procedure ยืดหยุ่นขึ้นและใช้ซ้ำได้หลายกรณี
- ชื่อ parameter ควรสื่อความหมาย เช่น `p_status`, `p_customer_id`

---

## หัวข้อย่อยที่ 12: Procedure สำหรับค้นหาข้อมูลเฉพาะลูกค้า

```sql
DELIMITER //

CREATE PROCEDURE get_orders_by_customer(IN p_customer_id BIGINT)
BEGIN
    -- ดึง order ของลูกค้าคนหนึ่ง
    SELECT order_id, order_date, order_status
    FROM orders
    WHERE customer_id = p_customer_id
    ORDER BY order_date DESC;
END //

DELIMITER ;
```

```sql
-- เรียกดู order ของ customer_id = 1
CALL get_orders_by_customer(1);
```

### สิ่งที่ควรเข้าใจ

- procedure แบบนี้เหมาะกับการห่อ query ที่ระบบเรียกบ่อย
- ช่วยให้ logic ฝั่ง application ง่ายขึ้นในบางกรณี

---

## หัวข้อย่อยที่ 13: Procedure สำหรับเพิ่มข้อมูล

stored procedure ไม่ได้ใช้แค่อ่านข้อมูล แต่ใช้เพิ่ม แก้ไข และลบข้อมูลได้ด้วย

```sql
DELIMITER //

CREATE PROCEDURE create_customer(
    IN p_full_name VARCHAR(150),
    IN p_email VARCHAR(150),
    IN p_customer_status VARCHAR(20)
)
BEGIN
    -- เพิ่มข้อมูลลูกค้าใหม่
    INSERT INTO customers (full_name, email, customer_status)
    VALUES (p_full_name, p_email, p_customer_status);
END //

DELIMITER ;
```

```sql
-- เพิ่มลูกค้าใหม่ผ่าน procedure
CALL create_customer('Jane Moon', 'jane@example.com', 'active');
```

### สิ่งที่ควรเข้าใจ

- ช่วยรวมกฎพื้นฐานของการ insert ไว้จุดเดียวได้
- เหมาะกับกรณีที่ต้องการมาตรฐานการเพิ่มข้อมูลแบบเดียวกันทุกจุด

---

## หัวข้อย่อยที่ 14: Procedure สำหรับอัปเดตข้อมูล

```sql
DELIMITER //

CREATE PROCEDURE update_customer_status(
    IN p_customer_id BIGINT,
    IN p_new_status VARCHAR(20)
)
BEGIN
    -- อัปเดตสถานะลูกค้า
    UPDATE customers
    SET customer_status = p_new_status
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;
```

```sql
-- เปลี่ยนสถานะลูกค้า
CALL update_customer_status(3, 'active');
```

### สิ่งที่ควรเข้าใจ

- procedure ช่วย encapsulate การเปลี่ยนแปลงข้อมูลบางอย่าง
- ควรระวังเรื่องสิทธิ์และผลกระทบของการ update ผ่าน procedure

---

## หัวข้อย่อยที่ 15: Procedure ร่วมกับ Transaction

นี่คือหนึ่งใน use case ที่สำคัญมาก เพราะ stored procedure ช่วยรวมหลายขั้นตอนให้อยู่ในจุดเดียว

```sql
DELIMITER //

CREATE PROCEDURE create_simple_order(
    IN p_customer_id BIGINT,
    IN p_product_id BIGINT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_order_id BIGINT;

    -- เริ่ม transaction
    START TRANSACTION;

    -- อ่านราคากับ stock ปัจจุบัน
    SELECT price, stock
    INTO v_price, v_stock
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;

    -- ตรวจสอบว่า stock เพียงพอหรือไม่
    IF v_stock >= p_quantity THEN
        -- สร้าง order
        INSERT INTO orders (customer_id, order_status)
        VALUES (p_customer_id, 'pending');

        -- เก็บ order_id ล่าสุด
        SET v_order_id = LAST_INSERT_ID();

        -- เพิ่มรายการสินค้าใน order
        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (v_order_id, p_product_id, p_quantity, v_price);

        -- หัก stock
        UPDATE products
        SET stock = stock - p_quantity
        WHERE product_id = p_product_id;

        -- ยืนยันทั้งหมด
        COMMIT;
    ELSE
        -- stock ไม่พอ ย้อนกลับทั้งหมด
        ROLLBACK;
    END IF;
END //

DELIMITER ;
```

```sql
-- สร้าง order แบบง่ายผ่าน procedure
CALL create_simple_order(1, 2, 3);
```

### สิ่งที่ควรเข้าใจ

- procedure แบบนี้เหมาะกับ logic หลายขั้นตอน
- transaction ช่วยให้ข้อมูล order, order_items, และ stock สอดคล้องกัน
- ควรทดสอบ error case ให้ครบเมื่อใช้ procedure ทำงานจริง

---

## หัวข้อย่อยที่ 16: Procedure กับ OUT Parameter เบื้องต้น

stored procedure สามารถส่งค่ากลับผ่าน `OUT` parameter ได้

```sql
DELIMITER //

CREATE PROCEDURE count_orders_by_customer(
    IN p_customer_id BIGINT,
    OUT p_total_orders INT
)
BEGIN
    -- นับจำนวน order ของลูกค้า
    SELECT COUNT(*)
    INTO p_total_orders
    FROM orders
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;
```

```sql
-- รับค่ากลับผ่านตัวแปร session
CALL count_orders_by_customer(1, @total_orders);
SELECT @total_orders;
```

### สิ่งที่ควรเข้าใจ

- `OUT` เหมาะกับกรณีที่ต้องการค่าผลลัพธ์เฉพาะจุด
- ในงานจริงบางทีมานิยมให้ procedure คืน result set แทน ขึ้นกับ style ของระบบ

---

## หัวข้อย่อยที่ 17: ลบ Stored Procedure

```sql
-- ลบ procedure เมื่อไม่ใช้งานแล้ว
DROP PROCEDURE IF EXISTS get_all_customers;
```

### สิ่งที่ควรเข้าใจ

- ควรมี version control สำหรับ script การสร้าง procedure
- การแก้ procedure ใน production ควรทำอย่างระมัดระวัง

---

## หัวข้อย่อยที่ 18: View หรือ Stored Procedure ควรใช้เมื่อไร

### ใช้ View เมื่อ

- ต้องการ query อ่านข้อมูลซ้ำ ๆ
- ต้องการซ่อน `JOIN` หรือ `GROUP BY`
- ต้องการมุมมองข้อมูลแบบ standardized

### ใช้ Stored Procedure เมื่อ

- ต้องการหลายขั้นตอนในคำสั่งเดียว
- ต้องการรับ parameter
- ต้องการ transaction หรือ business logic ระดับฐานข้อมูล
- ต้องการ encapsulate การ insert/update/delete บางงาน

### สิ่งที่ควรเข้าใจ

- ไม่ใช่เรื่องว่าอะไรดีกว่าเสมอไป
- ต้องเลือกตามลักษณะงานและทีมที่ดูแลระบบ

---

## ตัวอย่างการใช้งานจริง

ด้านล่างคือตัวอย่างการใช้ทั้ง `View` และ `Stored Procedure` ร่วมกัน

```sql
-- ใช้ view สำหรับหน้ารายงาน order
SELECT order_id, order_total
FROM view_order_totals
WHERE order_status = 'paid';
```

```sql
-- ใช้ procedure สำหรับ workflow การสร้าง order
CALL create_simple_order(2, 4, 1);
```

### สิ่งที่ควรเข้าใจ

- `View` เหมาะกับชั้นอ่านข้อมูล
- `Stored Procedure` เหมาะกับชั้นการทำงานหลายขั้นตอน
- ถ้าออกแบบดี ทั้งสองอย่างช่วยให้ระบบชัดและลดความซ้ำได้มาก

---

## Best Practices สำหรับงานจริง

### 1) ตั้งชื่อให้สื่อความหมาย

```sql
-- ตัวอย่างชื่อที่อ่านง่าย
view_order_totals
get_orders_by_customer
create_simple_order
```

ชื่อควรบอกหน้าที่ชัดเจน ไม่ควรใช้ชื่อกำกวม

### 2) อย่าทำ View ซ้อนหลายชั้นเกินจำเป็น

view ซ้อน view มากเกินไปทำให้ debug และวิเคราะห์ performance ยากขึ้น

### 3) ใช้ Procedure กับ logic ที่มีเหตุผลจริง

ถ้าเป็น query ง่ายมากและใช้ครั้งเดียว อาจไม่จำเป็นต้องทำเป็น procedure

### 4) ระวังเรื่อง performance

- view ที่ซับซ้อนอาจช้าได้
- procedure ที่มี logic มากเกินไปอาจดูแลยาก
- ควรออกแบบ index ให้สอดคล้องกับ query ภายใน view หรือ procedure

### 5) เก็บ script ไว้ใน version control

```sql
-- ตัวอย่างสคริปต์ควรเก็บไว้เป็นไฟล์ deployment
CREATE OR REPLACE VIEW view_orders_with_customers AS
SELECT ...;
```

อย่าแก้ของจริงใน production โดยไม่มี script ที่ติดตามย้อนกลับได้

### 6) ทดสอบเรื่องสิทธิ์และผลกระทบ

โดยเฉพาะ procedure ที่แก้ไขข้อมูล หรือทำงานหลายขั้นตอน ควรทดสอบทั้งกรณีสำเร็จและกรณีผิดพลาด

---

## ข้อควรระวัง

- อย่าใช้ view เพื่อซ่อน query ที่ซับซ้อนจนทีมตาม logic ไม่ทัน
- อย่าเอา business logic ทุกอย่างไปไว้ใน stored procedure โดยไม่จำเป็น
- อย่าลืมว่า procedure ต้องมีการจัดการ error และ transaction ให้ดีในงานสำคัญ
- อย่ามองข้ามเรื่อง index เพราะทั้ง view และ procedure ยังพึ่งพา performance ของ query จริง
- ควรตั้งชื่อและแยกความรับผิดชอบให้ชัด เพื่อให้ดูแลง่ายระยะยาว

## สรุป

`Views` และ `Stored Procedures` เป็นเครื่องมือที่ช่วยให้ MySQL มีโครงสร้างมากขึ้น โดย `View` เหมาะกับการจัดระเบียบ query สำหรับการอ่านข้อมูล ส่วน `Stored Procedure` เหมาะกับการรวมขั้นตอนการทำงานที่เรียกใช้ซ้ำได้และรองรับ parameter รวมถึง transaction

ถ้าเลือกใช้ให้เหมาะกับงาน คุณจะได้ระบบที่อ่านง่ายขึ้น ลด SQL ซ้ำ และควบคุม logic บางส่วนได้เป็นระบบมากขึ้น โดยเฉพาะในโครงการจริงที่มี query ซับซ้อนหรือ workflow หลายขั้นตอน

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `Triggers in MySQL`
- `Transactions in MySQL`
- `Indexing in MySQL`
- `MySQL Security Basics`
- `MySQL Query Optimization`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน `View` เพื่อแสดง `order_id`, `order_date`, `full_name`, `order_status` จาก `orders` และ `customers`

### แบบฝึกหัด 2
เขียน `View` เพื่อสรุปยอดรวมต่อ order จาก `orders` และ `order_items`

### แบบฝึกหัด 3
เขียน `Stored Procedure` ที่รับ `customer_id` แล้วแสดงรายการ order ของลูกค้าคนนั้น

### แบบฝึกหัด 4
เขียน `Stored Procedure` สำหรับอัปเดต `customer_status` ของลูกค้า 1 คน

### แบบฝึกหัด 5
อธิบายสั้น ๆ ว่า `View` กับ `Stored Procedure` ต่างกันอย่างไร

## เฉลยแบบย่อ

```sql
-- ข้อ 1
CREATE VIEW view_orders_with_customers AS
SELECT
    o.order_id,
    o.order_date,
    c.full_name,
    o.order_status
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

```sql
-- ข้อ 2
CREATE VIEW view_order_totals AS
SELECT
    o.order_id,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id;
```

```sql
-- ข้อ 3
DELIMITER //

CREATE PROCEDURE get_orders_by_customer(IN p_customer_id BIGINT)
BEGIN
    SELECT order_id, order_date, order_status
    FROM orders
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;
```

```sql
-- ข้อ 4
DELIMITER //

CREATE PROCEDURE update_customer_status(
    IN p_customer_id BIGINT,
    IN p_new_status VARCHAR(20)
)
BEGIN
    UPDATE customers
    SET customer_status = p_new_status
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;
```
