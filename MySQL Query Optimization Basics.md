File Name: MySQL Query Optimization Basics.md

# MySQL Query Optimization Basics

## บทนำ

การเขียน SQL ให้ “ทำงานได้” กับการเขียน SQL ให้ “ทำงานได้ดี” เป็นคนละเรื่องกัน ในระบบจริง query ที่ช้าอาจทำให้หน้าเว็บโหลดนาน รายงานใช้เวลานานเกินไป ระบบหลังบ้านค้าง หรือฐานข้อมูลรับภาระสูงโดยไม่จำเป็น

`Query Optimization` คือการปรับปรุงคำสั่ง SQL และโครงสร้างที่เกี่ยวข้อง เพื่อให้ MySQL อ่านข้อมูลน้อยลง ใช้ index ได้เหมาะสมขึ้น และตอบผลลัพธ์ได้เร็วขึ้นโดยยังคงความถูกต้องของข้อมูล

หัวข้อนี้เหมาะสำหรับผู้ที่เริ่มใช้งาน MySQL กับข้อมูลจริง และต้องการเข้าใจพื้นฐานของการทำให้ query เร็วขึ้นอย่างเป็นระบบ โดยไม่ต้องเริ่มจากเรื่องลึกเกินไปในทันที

## สิ่งที่ผู้เรียนจะได้เรียน

- ความหมายของการ optimize query
- สาเหตุที่ query ช้าในงานจริง
- การใช้ `EXPLAIN` เพื่อดูแผนการทำงานของ query
- การเลือกคอลัมน์เท่าที่จำเป็น
- การใช้ `WHERE`, `JOIN`, `ORDER BY`, `LIMIT` อย่างมีประสิทธิภาพ
- การใช้ `INDEX` ให้สอดคล้องกับ query
- การหลีกเลี่ยง pattern ที่ทำให้ MySQL ทำงานหนักเกินจำเป็น
- แนวคิดพื้นฐานในการวิเคราะห์ query ก่อนปรับปรุง

## Query Optimization คืออะไร

Query Optimization คือการทำให้ query ใช้ทรัพยากรน้อยลงและตอบเร็วขึ้น เช่น

- อ่านข้อมูลน้อยลง
- scan ตารางน้อยลง
- ใช้ `index` ได้ดีขึ้น
- ลดการ sort หรือ temporary work ที่ไม่จำเป็น
- ลดจำนวนแถวที่ถูก `JOIN` หรือคำนวณเกินความจำเป็น

จุดสำคัญคือ **ไม่ใช่การเดา** แต่เป็นการดูว่า query ทำอะไรอยู่ แล้วค่อยปรับอย่างมีเหตุผล

---

## ตารางตัวอย่างสำหรับบทเรียน

ตัวอย่างนี้ใช้โครงสร้างระบบขายสินค้าแบบย่อ เพื่อให้เห็นรูปแบบ query ที่พบได้จริง

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
    sku VARCHAR(50) NOT NULL UNIQUE,
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
    total_amount DECIMAL(10,2) NOT NULL,
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
-- สร้าง index ที่มักใช้ในงานจริง
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status_date ON orders(order_status, order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_products_created_at ON products(created_at);
```

### สิ่งที่ควรเข้าใจ

- `PRIMARY KEY` มี index ให้อัตโนมัติ
- คอลัมน์ที่ใช้ `JOIN`, `WHERE`, และ `ORDER BY` บ่อยมักเป็นตัวเลือกที่ดีสำหรับ index
- การ optimize query ต้องมองทั้ง SQL และ schema ไปพร้อมกัน

---

## หัวข้อย่อยที่ 1: ทำไม Query จึงช้า

สาเหตุที่พบบ่อยในงานจริง ได้แก่

- ใช้ `SELECT *` ดึงข้อมูลเกินจำเป็น
- ไม่มี index ในคอลัมน์ที่ใช้ค้นหาหรือ join
- ใช้เงื่อนไขที่ทำให้ index ใช้งานได้ยาก
- `JOIN` หลายตารางโดยไม่กรองข้อมูลให้เหมาะสม
- sort ข้อมูลจำนวนมากด้วย `ORDER BY`
- ดึงข้อมูลจำนวนมากแต่ใช้จริงเพียงเล็กน้อย
- ใช้ subquery หรือ function กับคอลัมน์แบบไม่จำเป็น

### สิ่งที่ควรเข้าใจ

- query ช้าไม่ได้แปลว่าฐานข้อมูลแย่เสมอไป
- หลายครั้งปัญหาอยู่ที่รูปแบบ query เอง
- การ optimize ที่ดีเริ่มจากการมอง “ต้นเหตุ” ก่อนแก้

---

## หัวข้อย่อยที่ 2: เริ่มจาก EXPLAIN

`EXPLAIN` คือเครื่องมือพื้นฐานที่ช่วยให้เราเห็นว่า MySQL วางแผนอ่านข้อมูลอย่างไร เช่น ใช้ index หรือไม่ อ่านกี่แถว และมีความเสี่ยงต้อง sort หรือสร้าง temporary result หรือไม่

```sql
-- ตรวจสอบแผนการทำงานของ query
EXPLAIN
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_status = 'paid'
ORDER BY order_date DESC;
```

### สิ่งที่ควรดูเบื้องต้น

- `type` บอกลักษณะการเข้าถึงข้อมูล
- `key` บอกว่าใช้ index ตัวไหน
- `rows` บอกจำนวนแถวที่คาดว่าจะอ่าน
- `Extra` อาจมีข้อมูลเช่น `Using where`, `Using index`, `Using filesort`

### สิ่งที่ควรเข้าใจ

- `EXPLAIN` ไม่ได้แก้ปัญหาแทนเรา แต่ช่วยให้เห็นภาพ
- ถ้า query อ่านแถวจำนวนมากเกินจำเป็น มักมีโอกาสปรับปรุงได้
- ในงานจริงควรใช้ `EXPLAIN` ก่อนและหลังปรับ เพื่อยืนยันผล

---

## หัวข้อย่อยที่ 3: หลีกเลี่ยง SELECT *

การใช้ `SELECT *` ทำให้ MySQL ดึงทุกคอลัมน์ แม้ระบบต้องใช้เพียงไม่กี่คอลัมน์

```sql
-- ไม่แนะนำในงานจริง หากไม่ได้ต้องใช้ทุกคอลัมน์
SELECT *
FROM orders
WHERE order_status = 'paid';
```

```sql
-- แนะนำ: ดึงเฉพาะคอลัมน์ที่ใช้งานจริง
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_status = 'paid';
```

### สิ่งที่ควรเข้าใจ

- ดึงข้อมูลให้น้อยที่สุดเท่าที่จำเป็น
- ช่วยลด I/O และขนาดข้อมูลที่ต้องส่งกลับไปยัง application
- ทำให้ query ชัดเจนและ maintain ง่ายกว่า

---

## หัวข้อย่อยที่ 4: กรองข้อมูลให้เร็วและตรงจุดด้วย WHERE

การใช้ `WHERE` อย่างเหมาะสมช่วยลดจำนวนแถวที่ MySQL ต้องทำงานต่อในขั้นถัดไป

```sql
-- ดึงเฉพาะ order ที่จ่ายเงินแล้ว
SELECT order_id, order_date, total_amount
FROM orders
WHERE order_status = 'paid';
```

```sql
-- ดึงเฉพาะ order ของลูกค้าหนึ่งคน และเฉพาะสถานะที่สนใจ
SELECT order_id, order_date, total_amount
FROM orders
WHERE customer_id = 101
  AND order_status = 'paid';
```

### สิ่งที่ควรเข้าใจ

- ควรกรองข้อมูลตั้งแต่ต้นให้แคบที่สุด
- ถ้าคอลัมน์ใน `WHERE` มี index ที่เหมาะสม query มักเร็วขึ้นมาก
- Query ที่ดีไม่ใช่ดึงทุกอย่างแล้วค่อยกรองใน application

---

## หัวข้อย่อยที่ 5: Index ต้องสอดคล้องกับ Query

index ที่ดีไม่ใช่ index ที่มีเยอะที่สุด แต่เป็น index ที่สอดคล้องกับรูปแบบ query จริง

```sql
-- index ที่เหมาะกับการค้นหา order ของลูกค้า
CREATE INDEX idx_orders_customer_id
ON orders(customer_id);
```

```sql
-- query ที่ได้ประโยชน์จาก index ข้างบน
SELECT order_id, order_date, total_amount
FROM orders
WHERE customer_id = 101;
```

### สิ่งที่ควรเข้าใจ

- คอลัมน์ที่ใช้ใน `WHERE`, `JOIN`, และ `ORDER BY` บ่อยมักเหมาะกับ index
- อย่าสร้าง index แบบเดาไปทุกคอลัมน์
- index ทุกตัวมีต้นทุนต่อ `INSERT`, `UPDATE`, และ `DELETE`

---

## หัวข้อย่อยที่ 6: Composite Index เบื้องต้น

ถ้า query ใช้หลายคอลัมน์ร่วมกันบ่อย การใช้ composite index อาจเหมาะกว่า index แยกหลายตัว

```sql
-- index ที่เหมาะกับ query ที่กรองด้วยสถานะ และเรียงตามวัน
CREATE INDEX idx_orders_status_date
ON orders(order_status, order_date);
```

```sql
-- query ที่สอดคล้องกับ composite index
SELECT order_id, order_date, total_amount
FROM orders
WHERE order_status = 'paid'
ORDER BY order_date DESC;
```

### สิ่งที่ควรเข้าใจ

- ลำดับคอลัมน์ใน composite index สำคัญมาก
- ควรออกแบบจาก query จริง ไม่ใช่รวมหลายคอลัมน์แบบสุ่ม
- index แบบนี้มักช่วยได้กับ query ที่กรองและเรียงข้อมูลร่วมกัน

---

## หัวข้อย่อยที่ 7: อย่าใช้ฟังก์ชันกับคอลัมน์ที่ต้องการใช้ Index โดยไม่จำเป็น

เมื่อครอบคอลัมน์ด้วยฟังก์ชัน MySQL อาจใช้ index ได้ไม่เต็มประสิทธิภาพ

```sql
-- ไม่ค่อยดีสำหรับการใช้ index บน order_date
SELECT order_id, order_date
FROM orders
WHERE DATE(order_date) = '2026-03-05';
```

```sql
-- ดีกว่า เพราะเปรียบเทียบเป็นช่วงเวลาโดยตรง
SELECT order_id, order_date
FROM orders
WHERE order_date >= '2026-03-05 00:00:00'
  AND order_date < '2026-03-06 00:00:00';
```

### สิ่งที่ควรเข้าใจ

- เขียนเงื่อนไขให้คอลัมน์ยังอยู่ในรูปที่ index ใช้ได้ง่าย
- เรื่องนี้พบบ่อยมากใน query ด้านวันเวลา
- เปลี่ยนรูปแบบ query เล็กน้อย บางครั้งให้ผลต่างชัดเจน

---

## หัวข้อย่อยที่ 8: ใช้ ORDER BY อย่างมีเหตุผล

`ORDER BY` มีประโยชน์มาก แต่ก็มีต้นทุน โดยเฉพาะเมื่อข้อมูลที่ต้อง sort มีจำนวนมาก

```sql
-- เรียงข้อมูลตามวันสั่งซื้อ
SELECT order_id, order_date, total_amount
FROM orders
WHERE order_status = 'paid'
ORDER BY order_date DESC;
```

```sql
-- ใช้ร่วมกับ LIMIT เพื่อดึงเฉพาะข้อมูลที่ต้องการจริง
SELECT order_id, order_date, total_amount
FROM orders
WHERE order_status = 'paid'
ORDER BY order_date DESC
LIMIT 20;
```

### สิ่งที่ควรเข้าใจ

- ถ้าต้อง sort ข้อมูลจำนวนมาก query อาจช้า
- ถ้ามี index ที่เหมาะกับเงื่อนไขและลำดับ sort จะช่วยได้มาก
- `ORDER BY` ที่ใช้ร่วมกับ `LIMIT` มักพบได้บ่อยใน dashboard และหน้ารายการ

---

## หัวข้อย่อยที่ 9: LIMIT ช่วยลดภาระของการดึงข้อมูล

ถ้าระบบต้องการแค่บางส่วนของข้อมูล เช่น 20 รายการล่าสุด ควรบอก MySQL ให้ชัด

```sql
-- ดึง 20 order ล่าสุด
SELECT order_id, order_date, total_amount
FROM orders
ORDER BY order_date DESC
LIMIT 20;
```

### สิ่งที่ควรเข้าใจ

- อย่าดึงข้อมูลเป็นพันแถวถ้าหน้าจอแสดงเพียง 20 แถว
- การใช้ `LIMIT` อย่างเหมาะสมช่วยลดงานทั้งฝั่งฐานข้อมูลและฝั่ง application
- แต่การใช้ `LIMIT` อย่างเดียวโดยไม่มี `ORDER BY` อาจทำให้ผลลัพธ์ไม่คงที่ในเชิงธุรกิจ

---

## หัวข้อย่อยที่ 10: JOIN ให้ถูกตารางและถูกจังหวะ

`JOIN` เป็นเรื่องปกติในงานจริง แต่ถ้า join มากเกินจำเป็นหรือไม่มี index รองรับ query จะหนักขึ้นมาก

```sql
-- ดึงรายการ order พร้อมชื่อลูกค้า
SELECT
    o.order_id,
    o.order_date,
    o.total_amount,
    c.full_name
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'paid';
```

### สิ่งที่ควรเข้าใจ

- คอลัมน์ที่ใช้ join ควรมี index ที่เหมาะสม
- ควรกรองข้อมูลให้เร็วที่สุดเท่าที่เหมาะสม
- อย่า join ตารางที่ไม่ได้ใช้จริงในผลลัพธ์หรือเงื่อนไข

---

## หัวข้อย่อยที่ 11: JOIN หลายตารางอย่างระมัดระวัง

เมื่อ query เริ่มเชื่อมหลายตาราง ต้องคิดเรื่อง cardinality และจำนวนแถวที่ถูกขยายด้วย

```sql
-- รายงาน order พร้อมสินค้าในแต่ละรายการ
SELECT
    o.order_id,
    c.full_name,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'paid'
ORDER BY o.order_date DESC;
```

### สิ่งที่ควรเข้าใจ

- 1 order อาจมีหลาย order_items ทำให้จำนวนแถวเพิ่มขึ้น
- ถ้าต้องการข้อมูลสรุป อาจใช้ `GROUP BY` แทนการดึงรายละเอียดทั้งหมด
- query ที่ join หลายตารางควรดู `EXPLAIN` เป็นพิเศษ

---

## หัวข้อย่อยที่ 12: หลีกเลี่ยงการคำนวณหรือกรองหลังจากดึงข้อมูลเกินจำเป็น

ตัวอย่างเช่น บางระบบดึงข้อมูลทั้งหมดแล้วค่อยรวมยอดใน application ทั้งที่ MySQL ทำให้ได้โดยตรง

```sql
-- ให้ฐานข้อมูลช่วยสรุปยอดต่อ order
SELECT
    oi.order_id,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM order_items AS oi
GROUP BY oi.order_id;
```

### สิ่งที่ควรเข้าใจ

- งานที่เป็นการสรุปข้อมูลควรพิจารณาให้ฐานข้อมูลทำ
- จะช่วยลดข้อมูลที่ต้องส่งกลับและลดงานฝั่ง application
- แต่ต้องระวังไม่ให้ query ซับซ้อนเกินความจำเป็น

---

## หัวข้อย่อยที่ 13: ระวัง OFFSET สูงมากใน Pagination

การแบ่งหน้าแบบ `LIMIT ... OFFSET ...` ใช้ง่าย แต่เมื่อ `OFFSET` สูงมาก Query อาจเริ่มช้าลง

```sql
-- หน้าถัด ๆ ไปอาจช้าลงเมื่อ offset สูงมาก
SELECT order_id, order_date, total_amount
FROM orders
ORDER BY order_date DESC
LIMIT 20 OFFSET 10000;
```

### สิ่งที่ควรเข้าใจ

- MySQL ยังต้องอ่านหรือข้ามข้อมูลจำนวนมากก่อนถึงแถวที่ต้องการ
- ในระบบใหญ่ อาจพิจารณา keyset pagination แทน
- ระดับพื้นฐานให้เริ่มจากเข้าใจข้อจำกัดของ OFFSET ก่อน

---

## หัวข้อย่อยที่ 14: ใช้ EXISTS แทนบางกรณีของการเช็กว่ามีข้อมูลหรือไม่

ถ้าต้องการเพียงตรวจว่ามีความสัมพันธ์อยู่หรือไม่ `EXISTS` อาจเหมาะกว่าการ join ดึงข้อมูลจำนวนมาก

```sql
-- หาลูกค้าที่มี order อย่างน้อยหนึ่งรายการ
SELECT c.customer_id, c.full_name
FROM customers AS c
WHERE EXISTS (
    SELECT 1
    FROM orders AS o
    WHERE o.customer_id = c.customer_id
);
```

### สิ่งที่ควรเข้าใจ

- `EXISTS` เหมาะกับคำถามเชิง “มีหรือไม่มี”
- ในบางกรณีอ่านง่ายและมีประสิทธิภาพกว่าการ join แล้วค่อยตัดข้อมูลซ้ำ
- ควรเลือกตามเป้าหมายของ query

---

## หัวข้อย่อยที่ 15: ใช้ Aggregate และ GROUP BY อย่างพอดี

การสรุปข้อมูลมีประโยชน์มาก แต่ถ้าสรุปบนข้อมูลปริมาณมากโดยไม่กรองเลย query อาจหนัก

```sql
-- สรุปยอดขายต่อสถานะ
SELECT
    order_status,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY order_status;
```

```sql
-- กรองก่อนสรุป เพื่อให้ทำงานแคบลง
SELECT
    order_status,
    SUM(total_amount) AS total_sales
FROM orders
WHERE order_date >= '2026-03-01'
GROUP BY order_status;
```

### สิ่งที่ควรเข้าใจ

- ควรใช้ `WHERE` เพื่อลดข้อมูลก่อนสรุปเมื่อเหมาะสม
- query รายงานควรคิดเรื่องช่วงเวลาและขอบเขตของข้อมูลเสมอ
- การ optimize report มักเริ่มจากการลดข้อมูลตั้งแต่ต้น

---

## หัวข้อย่อยที่ 16: ใช้ Covering Index เมื่อเหมาะสม

บางครั้ง query สามารถอ่านข้อมูลจาก index ได้เลยโดยไม่ต้องกลับไปอ่านแถวเต็มจากตาราง หาก index ครอบคลุมคอลัมน์ที่ใช้

```sql
-- ตัวอย่าง index ที่อาจช่วย query ลักษณะนี้
CREATE INDEX idx_orders_status_date_total
ON orders(order_status, order_date, total_amount);
```

```sql
-- query ที่ดึงเฉพาะคอลัมน์ที่อยู่ใน index
SELECT order_status, order_date, total_amount
FROM orders
WHERE order_status = 'paid'
ORDER BY order_date DESC;
```

### สิ่งที่ควรเข้าใจ

- ไม่จำเป็นต้องทำ covering index ทุก query
- ใช้เฉพาะกรณีที่มี query สำคัญและใช้บ่อย
- ต้องชั่งน้ำหนักระหว่าง performance กับต้นทุนของ index ที่เพิ่มขึ้น

---

## หัวข้อย่อยที่ 17: Query ที่ดีต้องเหมาะกับข้อมูลจริง

query ที่เร็วบนข้อมูล 100 แถว อาจช้าบนข้อมูล 10 ล้านแถวได้ทันที

### สิ่งที่ควรทำในงานจริง

- ทดสอบกับข้อมูลที่ใกล้เคียง production
- ดู `EXPLAIN` เสมอใน query สำคัญ
- ตรวจสอบ query ที่ช้าที่สุดจากระบบก่อน
- ปรับทีละจุด และวัดผลทุกครั้ง

---

## ตัวอย่างการปรับปรุง Query แบบง่าย

### แบบที่ยังไม่ดี

```sql
-- ดึงทุกคอลัมน์ ใช้ฟังก์ชันกับวันที่ และไม่จำกัดผลลัพธ์
SELECT *
FROM orders
WHERE DATE(order_date) = '2026-03-05'
ORDER BY order_date DESC;
```

### แบบที่ดีกว่า

```sql
-- ดึงเฉพาะคอลัมน์ที่ใช้จริง
-- ใช้ช่วงเวลาแทน DATE()
-- จำกัดจำนวนผลลัพธ์
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date >= '2026-03-05 00:00:00'
  AND order_date < '2026-03-06 00:00:00'
ORDER BY order_date DESC
LIMIT 50;
```

### สิ่งที่ควรเข้าใจ

- การ optimize ไม่จำเป็นต้องเริ่มจากเรื่องยากเสมอไป
- แค่ลดคอลัมน์ ลดแถว และเขียนเงื่อนไขให้ใช้ index ได้ง่ายขึ้น ก็ช่วยได้มากแล้ว

---

## แนวทางคิดเวลาเจอ Query ช้า

ให้ลองถามทีละข้อดังนี้

1. Query นี้ดึงคอลัมน์มากเกินไปหรือไม่  
2. Query นี้ดึงแถวมากเกินไปหรือไม่  
3. มี `WHERE` ที่ชัดเจนหรือยัง  
4. คอลัมน์ใน `WHERE` หรือ `JOIN` มี index หรือไม่  
5. มีการใช้ function กับคอลัมน์ที่ควรใช้ index หรือไม่  
6. `ORDER BY` หรือ `GROUP BY` ทำงานบนข้อมูลมากเกินไปหรือไม่  
7. `EXPLAIN` บอกว่าอ่านแถวเยอะเกินไปหรือไม่  

---

## Best Practices สำหรับงานจริง

### 1) Optimize จาก query ที่มีผลจริงก่อน

อย่ารีบปรับทุก query แบบหว่าน ควรเริ่มจาก query ที่ช้าและมีผลกับผู้ใช้จริง

### 2) ใช้ EXPLAIN เป็นนิสัย

```sql
-- ดูแผนการทำงานก่อนปรับ
EXPLAIN
SELECT order_id, order_date
FROM orders
WHERE customer_id = 101;
```

### 3) ดึงข้อมูลเท่าที่จำเป็น

```sql
-- ดี: ดึงเฉพาะข้อมูลที่ใช้
SELECT order_id, total_amount
FROM orders
WHERE order_status = 'paid';
```

### 4) ออกแบบ index จาก query จริง

อย่าออกแบบ index จากความรู้สึกเพียงอย่างเดียว

### 5) หลีกเลี่ยง query pattern ที่ทำให้ใช้ index ยาก

เช่น `DATE(column)`, `LOWER(column)` หรือการใช้ wildcard แบบขึ้นต้นด้วย `%` โดยไม่จำเป็น

### 6) ระวัง query รายงานที่โตตามข้อมูล

report ที่เคยเร็วในช่วงแรก อาจช้าลงมากเมื่อข้อมูลสะสมหลายปี

### 7) วัดผลทุกครั้งหลังปรับ

ปรับแล้วควรดูทั้งเวลา query, execution plan, และผลกระทบต่อการเขียนข้อมูล

---

## ข้อควรระวัง

- อย่าคิดว่าใส่ index แล้วทุก query จะเร็วขึ้นเสมอ
- อย่าปรับ query โดยไม่ดู `EXPLAIN`
- อย่า optimize เร็วเกินไปก่อนรู้ว่าคอขวดอยู่ตรงไหน
- อย่ามอง query แยกจาก schema และรูปแบบการใช้งานจริง
- อย่าลืมว่าความถูกต้องของผลลัพธ์สำคัญกว่าความเร็วเสมอ

## สรุป

`MySQL Query Optimization Basics` คือการทำให้ query ทำงานเร็วขึ้นอย่างมีเหตุผล โดยเริ่มจากการดูว่า query อ่านข้อมูลอย่างไร ดึงมากเกินไปหรือไม่ ใช้ index ได้ดีหรือไม่ และมีขั้นตอนใดที่ทำให้ฐานข้อมูลทำงานหนักเกินความจำเป็น

ถ้าคุณเริ่มจากการใช้ `EXPLAIN`, เลือกคอลัมน์เท่าที่จำเป็น, ใช้ `WHERE` ให้เหมาะ, ออกแบบ index ตาม query จริง, และหลีกเลี่ยง pattern ที่ขัดกับการใช้ index คุณจะสามารถปรับปรุง performance ของระบบ MySQL ได้อย่างเป็นรูปธรรมมากขึ้น

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `Indexing in MySQL`
- `EXPLAIN and Execution Plans in MySQL`
- `Transactions in MySQL`
- `MySQL JOIN for Real Projects`
- `Database Design with MySQL`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน query เพื่อดึง `order_id`, `order_date`, `total_amount` ของ order ที่สถานะ `paid` โดยไม่ใช้ `SELECT *`

### แบบฝึกหัด 2
เขียนคำสั่ง `EXPLAIN` สำหรับ query ที่ค้นหา order ของ `customer_id = 101`

### แบบฝึกหัด 3
เขียน `CREATE INDEX` สำหรับคอลัมน์ `customer_id` ในตาราง `orders`

### แบบฝึกหัด 4
อธิบายสั้น ๆ ว่าทำไม `DATE(order_date)` อาจทำให้ query ช้าลง

### แบบฝึกหัด 5
เขียน query เพื่อดึง 20 order ล่าสุดของสถานะ `paid`

## เฉลยแบบย่อ

```sql
-- ข้อ 1
SELECT order_id, order_date, total_amount
FROM orders
WHERE order_status = 'paid';
```

```sql
-- ข้อ 2
EXPLAIN
SELECT order_id, order_date, total_amount
FROM orders
WHERE customer_id = 101;
```

```sql
-- ข้อ 3
CREATE INDEX idx_orders_customer_id
ON orders(customer_id);
```

```sql
-- ข้อ 5
SELECT order_id, order_date, total_amount
FROM orders
WHERE order_status = 'paid'
ORDER BY order_date DESC
LIMIT 20;
```
