File Name: MySQL JOIN for Real Projects.md

# MySQL JOIN for Real Projects

## บทนำ

`JOIN` คือหนึ่งในหัวข้อที่สำคัญที่สุดของการใช้งาน MySQL ในงานจริง เพราะข้อมูลในระบบที่ออกแบบดีมักไม่ได้เก็บทุกอย่างไว้ในตารางเดียว แต่แยกเป็นหลายตารางตามหน้าที่ เช่น `customers`, `orders`, `order_items`, `products`, `employees`, หรือ `departments` แล้วเชื่อมกันผ่าน `primary key` และ `foreign key`

ถ้าเข้าใจ `JOIN` อย่างถูกต้อง คุณจะสามารถดึงข้อมูลที่มีความหมายทางธุรกิจได้ เช่น รายการคำสั่งซื้อพร้อมชื่อลูกค้า, ยอดขายพร้อมชื่อสินค้า, รายชื่อพนักงานพร้อมแผนก, หรือรายงานที่รวมข้อมูลจากหลายส่วนของระบบได้อย่างเป็นมืออาชีพ

หัวข้อนี้เหมาะสำหรับผู้ที่เริ่มใช้งานฐานข้อมูลจริง และต้องการเข้าใจ `JOIN` ในมุมที่ใช้ได้จริงในโครงการพัฒนาเว็บ ระบบหลังบ้าน และงานรายงานข้อมูล

## สิ่งที่ผู้เรียนจะได้เรียน

- แนวคิดของการเชื่อมตารางด้วย `JOIN`
- ความต่างระหว่าง `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, และ `CROSS JOIN`
- วิธีใช้ `JOIN` กับ `primary key` และ `foreign key`
- การใช้ table alias เพื่อให้ query อ่านง่าย
- การ `JOIN` หลายตารางใน query เดียว
- ตัวอย่างโครงสร้างจริงแบบ customers-orders-products
- ข้อควรระวังเรื่องข้อมูลซ้ำ, `NULL`, และ performance
- แนวคิดที่ควรใช้ในงานจริง เช่น data integrity, indexing, และ query design

## ทำไมงานจริงจึงต้องใช้ JOIN

ในระบบที่ออกแบบฐานข้อมูลอย่างเป็นระเบียบ เรามักแยกข้อมูลออกจากกันเพื่อลดความซ้ำซ้อนและรักษา `data integrity` เช่น

- ข้อมูลลูกค้าเก็บในตาราง `customers`
- ข้อมูลคำสั่งซื้อเก็บในตาราง `orders`
- รายการสินค้าในคำสั่งซื้อเก็บใน `order_items`
- รายละเอียดสินค้าเก็บใน `products`

แนวทางนี้สอดคล้องกับหลัก `normalization` เพราะช่วยลดการเก็บข้อมูลซ้ำ เช่น ไม่ต้องเก็บชื่อสินค้าซ้ำในทุกคำสั่งซื้อ และไม่ต้องเก็บข้อมูลลูกค้าซ้ำในทุกแถวของรายการสินค้า

เมื่อจะสร้างรายงานหรือดึงข้อมูลไปแสดงในระบบ เราจึงใช้ `JOIN` เพื่อเชื่อมข้อมูลจากหลายตารางเข้าด้วยกัน

---

## ตารางตัวอย่างสำหรับบทเรียน

ตัวอย่างนี้จำลองโครงสร้างฐานข้อมูลของระบบขายสินค้าออนไลน์ขนาดเล็ก

```sql
-- สร้างฐานข้อมูลตัวอย่าง
CREATE DATABASE shop_db;

-- เลือกใช้งานฐานข้อมูล
USE shop_db;

-- ตารางลูกค้า
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    customer_status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ตารางสินค้า
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- ตารางคำสั่งซื้อ
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(30) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ตารางรายการสินค้าในคำสั่งซื้อ
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### ข้อมูลตัวอย่าง

```sql
-- เพิ่มข้อมูลลูกค้า
INSERT INTO customers (full_name, email, customer_status)
VALUES
    ('Anan Krit', 'anan@example.com', 'active'),
    ('Mali Suda', 'mali@example.com', 'active'),
    ('Pim Rin', 'pim@example.com', 'inactive');

-- เพิ่มข้อมูลสินค้า
INSERT INTO products (product_name, price, stock)
VALUES
    ('Mechanical Keyboard', 2490.00, 20),
    ('Wireless Mouse', 890.00, 50),
    ('27-inch Monitor', 6990.00, 10),
    ('USB-C Hub', 1290.00, 30);

-- เพิ่มข้อมูลคำสั่งซื้อ
INSERT INTO orders (customer_id, order_date, order_status)
VALUES
    (1, '2026-03-01 10:00:00', 'paid'),
    (1, '2026-03-05 14:30:00', 'shipped'),
    (2, '2026-03-07 09:15:00', 'pending');

-- เพิ่มข้อมูลรายการสินค้าในคำสั่งซื้อ
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 2490.00),
    (1, 2, 2, 890.00),
    (2, 3, 1, 6990.00),
    (3, 4, 3, 1290.00);
```

### สิ่งที่ควรเข้าใจ

- `customers.customer_id` เป็น `primary key` ของลูกค้า
- `orders.customer_id` เป็น `foreign key` ที่ชี้ไปยังลูกค้า
- `order_items.order_id` เชื่อมกับคำสั่งซื้อ
- `order_items.product_id` เชื่อมกับสินค้า
- โครงสร้างนี้เป็นรูปแบบที่ใช้จริงในหลายระบบ เช่น e-commerce, ERP, POS และ back-office tools

---

## หัวข้อย่อยที่ 1: JOIN คืออะไร

`JOIN` คือการเชื่อมข้อมูลจาก 2 ตารางขึ้นไปผ่านคอลัมน์ที่เกี่ยวข้องกัน โดยทั่วไปจะเชื่อมผ่าน `primary key` และ `foreign key`

```sql
-- ดึงข้อมูลคำสั่งซื้อพร้อมชื่อลูกค้า
SELECT o.order_id, o.order_date, c.full_name
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

### สิ่งที่ควรเข้าใจ

- `orders` และ `customers` เชื่อมกันด้วย `customer_id`
- `ON` ใช้ระบุเงื่อนไขการเชื่อม
- ผลลัพธ์คือข้อมูลที่รวมมาจากทั้งสองตาราง

---

## หัวข้อย่อยที่ 2: INNER JOIN

`INNER JOIN` จะคืนเฉพาะแถวที่ “จับคู่กันได้” ในทั้งสองตารางเท่านั้น

```sql
-- แสดงคำสั่งซื้อที่มีลูกค้าเชื่อมอยู่จริง
SELECT
    o.order_id,
    o.order_status,
    o.order_date,
    c.full_name,
    c.email
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

### สิ่งที่ควรเข้าใจ

- ถ้าไม่มีคู่ในอีกตาราง แถวนั้นจะไม่ถูกแสดง
- `INNER JOIN` เหมาะกับกรณีที่ต้องการเฉพาะข้อมูลที่เชื่อมกันครบ
- ใน MySQL คำว่า `JOIN` โดยไม่ระบุชนิด มักหมายถึง `INNER JOIN`

---

## หัวข้อย่อยที่ 3: LEFT JOIN

`LEFT JOIN` จะคืนทุกแถวจากตารางฝั่งซ้าย และจะเติมข้อมูลจากตารางขวาเมื่อจับคู่ได้ ถ้าจับคู่ไม่ได้ ค่าจากฝั่งขวาจะเป็น `NULL`

```sql
-- แสดงลูกค้าทั้งหมด รวมถึงลูกค้าที่อาจยังไม่เคยมีคำสั่งซื้อ
SELECT
    c.customer_id,
    c.full_name,
    o.order_id,
    o.order_status
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id;
```

### สิ่งที่ควรเข้าใจ

- ลูกค้าทุกคนจะถูกแสดง แม้ยังไม่มีคำสั่งซื้อ
- ถ้าลูกค้าไม่มี order ค่า `order_id` และ `order_status` จะเป็น `NULL`
- เหมาะกับรายงานที่ต้องการเห็น “ข้อมูลที่ยังไม่มีความเชื่อมโยง” เช่น ลูกค้าที่ยังไม่เคยซื้อสินค้า

---

## หัวข้อย่อยที่ 4: RIGHT JOIN

`RIGHT JOIN` คล้ายกับ `LEFT JOIN` แต่จะคืนทุกแถวจากตารางฝั่งขวา อย่างไรก็ตาม ในงานจริงหลายทีมมักใช้ `LEFT JOIN` มากกว่า เพราะอ่านง่ายและควบคุมทิศทางการเขียน query ได้ชัดกว่า

```sql
-- แสดงคำสั่งซื้อทั้งหมด โดยอ้างอิงทุกแถวจาก orders
SELECT
    c.full_name,
    o.order_id,
    o.order_status
FROM customers AS c
RIGHT JOIN orders AS o
    ON c.customer_id = o.customer_id;
```

### สิ่งที่ควรเข้าใจ

- ใช้งานได้ แต่ในหลายทีมมัก rewrite เป็น `LEFT JOIN` เพื่อให้อ่านง่ายกว่า
- ถ้าจะใช้จริง ควรใช้เมื่อทีมเข้าใจ logic ตรงกัน

---

## หัวข้อย่อยที่ 5: CROSS JOIN

`CROSS JOIN` คือการจับทุกแถวของตารางแรกกับทุกแถวของตารางที่สอง เกิดเป็นผลลัพธ์แบบ Cartesian product

```sql
-- จับคู่ลูกค้าทุกคนกับสินค้าทุกชิ้น
SELECT
    c.full_name,
    p.product_name
FROM customers AS c
CROSS JOIN products AS p;
```

### สิ่งที่ควรเข้าใจ

- ถ้ามีลูกค้า 3 คน และสินค้า 4 ชิ้น จะได้ 12 แถว
- ไม่ค่อยใช้ตรง ๆ ในระบบงานทั่วไป
- ใช้ในบางกรณีเฉพาะ เช่น สร้าง combination หรือ matrix ของข้อมูล

---

## หัวข้อย่อยที่ 6: ใช้ Table Alias เพื่อให้ query อ่านง่าย

เมื่อ query มีหลายตาราง การใช้ alias เช่น `c`, `o`, `oi`, `p` จะช่วยให้ query สั้นลงและอ่านง่ายขึ้น

```sql
-- ใช้ alias เพื่อให้ query กระชับขึ้น
SELECT
    o.order_id,
    c.full_name,
    o.order_status
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

### สิ่งที่ควรเข้าใจ

- `AS` ใช้ตั้งชื่อย่อให้ตาราง
- แม้ `AS` จะเขียนหรือไม่เขียนก็ได้ แต่การใส่ไว้ช่วยให้อ่านชัดเจนขึ้น
- ใน query ยาว ๆ alias เป็นสิ่งที่แทบขาดไม่ได้

---

## หัวข้อย่อยที่ 7: JOIN หลายตารางในงานจริง

กรณีใช้งานจริงมักไม่ได้เชื่อมแค่ 2 ตาราง แต่เชื่อมหลายตารางพร้อมกัน เช่น ดึงรายการคำสั่งซื้อพร้อมชื่อลูกค้า รายการสินค้า และยอดต่อรายการ

```sql
-- แสดงรายละเอียดรายการสินค้าในแต่ละคำสั่งซื้อ
SELECT
    o.order_id,
    c.full_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
ORDER BY o.order_id ASC;
```

### สิ่งที่ควรเข้าใจ

- Query นี้สะท้อนงานจริงมากกว่า เพราะเชื่อม 4 ตาราง
- เราสามารถคำนวณค่าเพิ่มเติม เช่น `line_total` ได้ใน query
- ต้องระวังความสัมพันธ์แบบ one-to-many เพราะ 1 order อาจมีหลายรายการสินค้า

---

## หัวข้อย่อยที่ 8: JOIN กับ WHERE ในสถานการณ์จริง

หลังจาก `JOIN` แล้ว เรามักกรองข้อมูลต่อด้วย `WHERE` เพื่อให้ได้ผลลัพธ์ที่ตรงตามเงื่อนไขทางธุรกิจ

```sql
-- แสดงเฉพาะคำสั่งซื้อที่ชำระเงินแล้ว พร้อมชื่อลูกค้า
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    c.full_name
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'paid';
```

```sql
-- แสดงรายการสินค้าที่อยู่ในคำสั่งซื้อของลูกค้า Anan Krit
SELECT
    o.order_id,
    c.full_name,
    p.product_name,
    oi.quantity
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
WHERE c.full_name = 'Anan Krit';
```

### สิ่งที่ควรเข้าใจ

- `JOIN` ใช้เชื่อมข้อมูล
- `WHERE` ใช้กรองข้อมูลหลังจากเชื่อมแล้ว
- ทั้งสองส่วนมักใช้ร่วมกันเสมอใน query จริง

---

## หัวข้อย่อยที่ 9: LEFT JOIN เพื่อหาข้อมูลที่ยังไม่เชื่อมกัน

หนึ่งในรูปแบบที่ใช้จริงมากคือใช้ `LEFT JOIN` เพื่อตรวจหาข้อมูลที่ “ยังไม่มีฝั่งตรงข้าม” เช่น ลูกค้าที่ยังไม่เคยสั่งซื้อ หรือสินค้าที่ไม่เคยถูกขาย

```sql
-- หาลูกค้าที่ยังไม่เคยมีคำสั่งซื้อ
SELECT
    c.customer_id,
    c.full_name,
    c.email
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

```sql
-- หาสินค้าที่ไม่เคยอยู่ใน order_items
SELECT
    p.product_id,
    p.product_name,
    p.stock
FROM products AS p
LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
```

### สิ่งที่ควรเข้าใจ

- เทคนิคนี้ใช้บ่อยมากในงาน audit data, cleanup, และ business monitoring
- การตรวจ `IS NULL` หลัง `LEFT JOIN` เป็น pattern สำคัญที่ควรรู้

---

## หัวข้อย่อยที่ 10: ปัญหาข้อมูลซ้ำจากการ JOIN

เมื่อเชื่อมตารางแบบ one-to-many เช่น 1 คำสั่งซื้อมีหลายสินค้า เราจะเห็น `order_id` ซ้ำหลายแถว ซึ่งไม่ใช่ bug แต่เป็นธรรมชาติของข้อมูล

```sql
-- ตัวอย่างที่ order เดียวอาจออกมาหลายแถว เพราะมีหลาย order_items
SELECT
    o.order_id,
    p.product_name,
    oi.quantity
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id;
```

### สิ่งที่ควรเข้าใจ

- ถ้า 1 order มี 3 สินค้า ผลลัพธ์จะมี 3 แถวสำหรับ order นั้น
- ต้องเข้าใจ cardinality ของข้อมูลก่อนสรุปผล
- ถ้าต้องการสรุปยอดต่อ order อาจต้องใช้ `GROUP BY` เพิ่ม

---

## หัวข้อย่อยที่ 11: ใช้ GROUP BY ร่วมกับ JOIN เพื่อทำรายงาน

ในงานจริงเรามัก `JOIN` แล้วสรุปข้อมูล เช่น ยอดซื้อรวมต่อคำสั่งซื้อ หรือนับจำนวน order ต่อ customer

```sql
-- สรุปยอดรวมต่อคำสั่งซื้อ
SELECT
    o.order_id,
    c.full_name,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id, c.full_name
ORDER BY o.order_id ASC;
```

```sql
-- นับจำนวนคำสั่งซื้อต่อลูกค้า
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_orders DESC;
```

### สิ่งที่ควรเข้าใจ

- `JOIN` ทำให้รวมข้อมูลได้
- `GROUP BY` ทำให้สรุปข้อมูลเชิงธุรกิจได้
- ทั้งสองอย่างมักทำงานร่วมกันในรายงานจริง

---

## หัวข้อย่อยที่ 12: Self Join เบื้องต้น

บางครั้งตารางเดียวกันสามารถเชื่อมกับตัวเองได้ เช่น ตารางพนักงานที่มี `manager_id` ชี้ไปยัง `employee_id` ของพนักงานอีกคน

```sql
-- ตัวอย่าง self join ในตาราง employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    manager_id INT NULL,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);
```

```sql
-- แสดงชื่อพนักงานพร้อมชื่อผู้จัดการ
SELECT
    e.full_name AS employee_name,
    m.full_name AS manager_name
FROM employees AS e
LEFT JOIN employees AS m
    ON e.manager_id = m.employee_id;
```

### สิ่งที่ควรเข้าใจ

- แม้เป็นตารางเดียวกัน แต่ใช้ alias คนละชื่อ เช่น `e` และ `m`
- ใช้ได้ดีในข้อมูลที่มีโครงสร้างแบบ hierarchy

---

## ตัวอย่างงานจริง: รายงานคำสั่งซื้อพร้อมลูกค้าและยอดรวม

ตัวอย่างนี้เป็น query ที่ใกล้กับงานในระบบจริงมาก เพราะใช้ทั้ง `JOIN`, `GROUP BY`, `ORDER BY` และ alias

```sql
-- รายงานคำสั่งซื้อพร้อมลูกค้าและยอดรวมต่อ order
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    c.full_name,
    c.email,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_date,
    o.order_status,
    c.full_name,
    c.email
ORDER BY o.order_date DESC;
```

### สิ่งที่ควรเข้าใจ

- Query นี้เหมาะกับหน้า admin หรือ dashboard รายการออเดอร์
- ต้องเข้าใจความสัมพันธ์ของตารางก่อนเขียน
- การออกแบบ schema ที่ดีทำให้ `JOIN` ทำงานได้อย่างชัดเจนและเชื่อถือได้

---

## Best Practices สำหรับงานจริง

### 1) ออกแบบ schema ให้ชัดก่อนเขียน JOIN

ควรมี `primary key` และ `foreign key` ที่ชัดเจน เพื่อให้ความสัมพันธ์ของข้อมูลไม่คลุมเครือ

```sql
-- ตัวอย่าง foreign key ที่ชัดเจน
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
```

### 2) ใช้ชื่อคอลัมน์แบบระบุ table เสมอเมื่อ JOIN หลายตาราง

```sql
-- ดี: ระบุชัดว่าใช้คอลัมน์จากตารางไหน
SELECT o.order_id, c.full_name
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

การระบุชื่อเต็มช่วยลดปัญหา column name ซ้ำ เช่น `id`, `created_at`, `status`

### 3) ใช้ alias อย่างสม่ำเสมอ

เช่น `c` สำหรับ customers, `o` สำหรับ orders, `oi` สำหรับ order_items, `p` สำหรับ products เพื่อให้ทีมอ่าน query ได้ง่าย

### 4) สร้าง index บนคอลัมน์ที่ใช้ JOIN บ่อย

คอลัมน์ที่ใช้เชื่อม เช่น `customer_id`, `order_id`, `product_id` ควรได้รับการออกแบบ index อย่างเหมาะสม โดยเฉพาะในตารางขนาดใหญ่

```sql
-- ตัวอย่าง index บน foreign key
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

### 5) ระวังการ JOIN เกินจำเป็น

ยิ่งเชื่อมหลายตาราง ยิ่งมีภาระต่อ query และอาจได้ข้อมูลเกินจำเป็น ควรเลือกเฉพาะตารางและคอลัมน์ที่ต้องใช้จริง

### 6) เข้าใจ cardinality ก่อนเสมอ

ต้องรู้ว่าความสัมพันธ์เป็นแบบ `one-to-one`, `one-to-many`, หรือ `many-to-many` เพราะส่งผลต่อจำนวนแถวที่ได้

### 7) พิจารณา data integrity

การใช้ `foreign key` ไม่ได้ช่วยแค่เรื่อง `JOIN` แต่ยังช่วยป้องกันข้อมูล orphan เช่น order ที่ไม่มี customer จริง หรือ order_item ที่ชี้ไปยัง product ที่ไม่มีอยู่

---

## ข้อควรระวัง

- อย่า `JOIN` โดยไม่มีเงื่อนไข `ON` ที่ถูกต้อง เพราะอาจได้ผลลัพธ์ผิดหรือเกิดข้อมูลจำนวนมหาศาล
- อย่าเข้าใจข้อมูลซ้ำจากความสัมพันธ์ one-to-many ว่าเป็น bug โดยอัตโนมัติ
- ระวังคอลัมน์ชื่อซ้ำกัน เช่น `id`, `status`, `created_at`
- ระวังใช้ `SELECT *` เมื่อ `JOIN` หลายตาราง เพราะผลลัพธ์จะกว้างเกินจำเป็นและอ่านยาก
- ตรวจสอบ `NULL` ให้ถูกต้อง โดยเฉพาะตอนใช้ `LEFT JOIN`
- อย่ามองข้าม performance เมื่อ query เริ่มเชื่อมหลายตารางและมีข้อมูลจำนวนมาก

## สรุป

`JOIN` คือหัวใจของการทำงานกับฐานข้อมูลเชิงสัมพันธ์ใน MySQL และเป็นทักษะที่จำเป็นมากในงานพัฒนาระบบจริง ไม่ว่าจะเป็นระบบขายสินค้า ระบบพนักงาน ระบบสมาชิก หรือระบบรายงานภายในองค์กร

เมื่อเข้าใจ `INNER JOIN`, `LEFT JOIN`, การใช้ alias, การเชื่อมหลายตาราง, และการสรุปข้อมูลร่วมกับ `GROUP BY` แล้ว คุณจะสามารถเขียน query ที่มีความหมายทางธุรกิจและพร้อมใช้งานในโครงการจริงได้มากขึ้น

หัวข้อที่ควรเรียนต่อจากบทนี้ ได้แก่

- `GROUP BY and Aggregate Functions in MySQL`
- `Indexes for JOIN Performance`
- `Database Design with MySQL`
- `Transactions in MySQL`
- `MySQL Query Optimization Basics`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน query เพื่อแสดง `order_id`, `order_date` และ `full_name` ของลูกค้าจากตาราง `orders` และ `customers`

### แบบฝึกหัด 2
เขียน query เพื่อแสดงลูกค้าทั้งหมด รวมถึงลูกค้าที่ไม่มีคำสั่งซื้อ

### แบบฝึกหัด 3
เขียน query เพื่อแสดง `order_id`, `product_name`, `quantity`, `unit_price` จาก `orders`, `order_items`, และ `products`

### แบบฝึกหัด 4
เขียน query เพื่อหาลูกค้าที่ไม่มีคำสั่งซื้อเลย

### แบบฝึกหัด 5
เขียน query เพื่อสรุปยอดรวมของแต่ละคำสั่งซื้อ

## เฉลยแบบย่อ

```sql
-- ข้อ 1
SELECT o.order_id, o.order_date, c.full_name
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;

-- ข้อ 2
SELECT c.customer_id, c.full_name, o.order_id
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id;

-- ข้อ 3
SELECT o.order_id, p.product_name, oi.quantity, oi.unit_price
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id;

-- ข้อ 4
SELECT c.customer_id, c.full_name
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- ข้อ 5
SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id;
```
