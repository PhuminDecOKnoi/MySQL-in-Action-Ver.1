File Name: Indexing in MySQL.md

# Indexing in MySQL

## บทนำ

`Index` ใน MySQL คือโครงสร้างข้อมูลที่ช่วยให้ฐานข้อมูลค้นหา กรอง เรียงลำดับ และเชื่อมข้อมูลได้เร็วขึ้น โดยเฉพาะเมื่อข้อมูลมีจำนวนมากขึ้นจากหลักพันไปสู่หลักแสนหรือหลักล้านแถว ความต่างระหว่างการมี index ที่เหมาะสมกับไม่มี index อาจทำให้ query เร็วขึ้นอย่างชัดเจน

หัวข้อนี้สำคัญมากสำหรับผู้ที่เริ่มทำระบบจริง เพราะหลายครั้งปัญหา “ระบบช้า” ไม่ได้เกิดจาก MySQL อย่างเดียว แต่เกิดจากการออกแบบ query และ index ที่ไม่สอดคล้องกัน

## สิ่งที่ผู้เรียนจะได้เรียน

- ความหมายของ `Index` และเหตุผลที่ต้องใช้
- ความต่างระหว่างการค้นหาแบบมี index และไม่มี index
- การสร้าง `PRIMARY KEY`, `UNIQUE INDEX`, และ `INDEX`
- หลักการเลือกคอลัมน์ที่จะสร้าง index
- การใช้ composite index
- ความสัมพันธ์ระหว่าง `WHERE`, `JOIN`, `ORDER BY` กับ index
- ข้อควรระวังเรื่องการใส่ index มากเกินไป
- แนวคิดพื้นฐานของ `EXPLAIN` สำหรับดู execution plan

## Index คืออะไร

ให้มองว่า index คล้าย “สารบัญ” หรือ “ดัชนีท้ายหนังสือ” ถ้าไม่มีสารบัญ ระบบต้องไล่อ่านทุกแถวเพื่อหาข้อมูลที่ต้องการ แต่ถ้ามี index ที่เหมาะสม MySQL จะหาตำแหน่งข้อมูลได้เร็วขึ้นมาก

ในเชิงปฏิบัติ index มักมีประโยชน์กับ query ที่ใช้บ่อย เช่น

- ค้นหาตาม `email`
- ดึง order ของลูกค้าคนหนึ่ง
- กรองข้อมูลตาม `status`
- เรียงข้อมูลตาม `created_at`
- เชื่อมตารางด้วย `foreign key`

---

## ตารางตัวอย่างสำหรับบทเรียน

ตัวอย่างนี้ใช้ตาราง `orders` เพื่อให้เห็นภาพการค้นหาและการสร้าง index ได้ชัดขึ้น

```sql
-- สร้างฐานข้อมูลตัวอย่าง
CREATE DATABASE shop_db;

-- เลือกใช้งานฐานข้อมูล
USE shop_db;

-- สร้างตารางคำสั่งซื้อ
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_number VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

```sql
-- เพิ่มข้อมูลตัวอย่าง
INSERT INTO orders (customer_id, order_number, status, total_amount, created_at)
VALUES
    (101, 'ORD-2026-0001', 'paid', 2500.00, '2026-03-01 09:00:00'),
    (102, 'ORD-2026-0002', 'pending', 1800.00, '2026-03-01 10:30:00'),
    (101, 'ORD-2026-0003', 'shipped', 4200.00, '2026-03-02 11:00:00'),
    (103, 'ORD-2026-0004', 'paid', 900.00, '2026-03-02 14:15:00'),
    (104, 'ORD-2026-0005', 'cancelled', 1500.00, '2026-03-03 08:45:00'),
    (102, 'ORD-2026-0006', 'paid', 3100.00, '2026-03-03 16:20:00');
```

### สิ่งที่ควรเข้าใจ

- `order_id` เป็น `PRIMARY KEY` และมี index โดยอัตโนมัติ
- `order_number` มักใช้ค้นหา order รายการเดียว
- `customer_id`, `status`, และ `created_at` เป็นคอลัมน์ที่มักเกี่ยวข้องกับ query จริง

---

## หัวข้อย่อยที่ 1: MySQL ค้นหาข้อมูลอย่างไรเมื่อไม่มี Index

ถ้าไม่มี index ที่เหมาะสม MySQL อาจต้องทำ `full table scan` คือไล่อ่านแทบทุกแถวในตาราง

```sql
-- ค้นหา order ของลูกค้า customer_id = 101
SELECT order_id, order_number, total_amount
FROM orders
WHERE customer_id = 101;
```

### สิ่งที่ควรเข้าใจ

- ถ้า `customer_id` ไม่มี index และตารางมีข้อมูลจำนวนมาก query นี้อาจช้าลงมาก
- ปัญหานี้เริ่มเห็นชัดเมื่อข้อมูลโตขึ้น ไม่ใช่ตอนมีแค่ไม่กี่แถว

---

## หัวข้อย่อยที่ 2: Primary Key มี Index อัตโนมัติ

เมื่อกำหนด `PRIMARY KEY` MySQL จะสร้าง index ให้โดยอัตโนมัติ

```sql
-- order_id เป็น primary key
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_number VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

```sql
-- การค้นหาด้วย primary key มักเร็วมาก
SELECT *
FROM orders
WHERE order_id = 3;
```

### สิ่งที่ควรเข้าใจ

- `PRIMARY KEY` ไม่ได้ช่วยแค่เรื่องความไม่ซ้ำ แต่ยังช่วย performance ด้วย
- การ lookup ตาม primary key เป็นกรณีพื้นฐานที่มีประสิทธิภาพมาก

---

## หัวข้อย่อยที่ 3: UNIQUE INDEX

ถ้าคอลัมน์ต้องไม่ซ้ำ เช่น `email`, `username`, `order_number` เราสามารถใช้ `UNIQUE` หรือ `UNIQUE INDEX`

```sql
-- เพิ่ม unique index ให้ order_number
ALTER TABLE orders
ADD CONSTRAINT uq_orders_order_number UNIQUE (order_number);
```

```sql
-- ค้นหา order ตามเลขคำสั่งซื้อ
SELECT order_id, order_number, status
FROM orders
WHERE order_number = 'ORD-2026-0003';
```

### สิ่งที่ควรเข้าใจ

- `UNIQUE INDEX` ทำสองหน้าที่ คือป้องกันข้อมูลซ้ำและช่วยให้ค้นหาเร็วขึ้น
- เหมาะกับคอลัมน์ที่มีความเฉพาะตัวทางธุรกิจ

---

## หัวข้อย่อยที่ 4: สร้าง Index ปกติด้วย CREATE INDEX

ถ้าคอลัมน์หนึ่งถูกใช้ใน `WHERE`, `JOIN`, หรือ `ORDER BY` บ่อย เรามักสร้าง index แบบปกติ

```sql
-- สร้าง index สำหรับค้นหา order ตาม customer_id
CREATE INDEX idx_orders_customer_id
ON orders(customer_id);
```

```sql
-- Query นี้จะได้ประโยชน์จาก index บน customer_id
SELECT order_id, order_number, total_amount
FROM orders
WHERE customer_id = 102;
```

### สิ่งที่ควรเข้าใจ

- ไม่ใช่ทุกคอลัมน์ต้องมี index
- ควรสร้างจาก query ที่ใช้จริง ไม่ใช่สร้างแบบเดาไปก่อนทั้งหมด

---

## หัวข้อย่อยที่ 5: Index ช่วยกับ WHERE อย่างไร

คอลัมน์ที่ถูกใช้กรองข้อมูลบ่อยคือเป้าหมายหลักของการทำ index

```sql
-- สร้าง index บน status
CREATE INDEX idx_orders_status
ON orders(status);
```

```sql
-- ดึงเฉพาะ order ที่จ่ายเงินแล้ว
SELECT order_id, order_number, total_amount
FROM orders
WHERE status = 'paid';
```

### สิ่งที่ควรเข้าใจ

- ถ้ามีการกรองตาม `status` บ่อย index นี้อาจช่วยได้
- แต่ถ้าคอลัมน์มีค่าซ้ำเยอะมากและเลือกข้อมูลออกมาจำนวนมาก ประโยชน์อาจไม่เด่นเสมอไป

---

## หัวข้อย่อยที่ 6: Index ช่วยกับ JOIN อย่างไร

คอลัมน์ที่ใช้เชื่อมตารางกันมักควรมี index โดยเฉพาะ `foreign key`

```sql
-- ตารางลูกค้า
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);
```

```sql
-- query join ระหว่าง orders และ customers
SELECT o.order_id, o.order_number, c.full_name
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

### สิ่งที่ควรเข้าใจ

- `customers.customer_id` มี index จาก primary key อยู่แล้ว
- `orders.customer_id` ก็ควรมี index เพื่อให้ join มีประสิทธิภาพขึ้น
- งานจริงที่ query หลายตารางบ่อยจะเห็นผลชัดมาก

---

## หัวข้อย่อยที่ 7: Index ช่วยกับ ORDER BY

ถ้า query ต้องเรียงลำดับบ่อย คอลัมน์ที่ใช้เรียงอาจเหมาะกับ index

```sql
-- สร้าง index บน created_at
CREATE INDEX idx_orders_created_at
ON orders(created_at);
```

```sql
-- แสดง order ล่าสุด
SELECT order_id, order_number, created_at
FROM orders
ORDER BY created_at DESC
LIMIT 10;
```

### สิ่งที่ควรเข้าใจ

- `ORDER BY` อาจได้ประโยชน์จาก index โดยเฉพาะเมื่อใช้ร่วมกับ `LIMIT`
- แต่การใช้ index จริงหรือไม่ขึ้นกับรูปแบบ query ด้วย

---

## หัวข้อย่อยที่ 8: Composite Index คืออะไร

บางครั้ง query ใช้หลายคอลัมน์ร่วมกัน เช่น กรองด้วย `status` และเรียงตาม `created_at` แบบนี้อาจเหมาะกับ composite index

```sql
-- สร้าง composite index สำหรับ status และ created_at
CREATE INDEX idx_orders_status_created_at
ON orders(status, created_at);
```

```sql
-- ดึง order ที่ paid แล้ว โดยเรียงตามวันล่าสุด
SELECT order_id, order_number, created_at
FROM orders
WHERE status = 'paid'
ORDER BY created_at DESC;
```

### สิ่งที่ควรเข้าใจ

- composite index คือ index ที่มีหลายคอลัมน์
- ลำดับคอลัมน์ใน index สำคัญมาก
- ควรออกแบบตาม query ที่ใช้จริง ไม่ใช่เอาหลายคอลัมน์มารวมแบบสุ่ม

---

## หัวข้อย่อยที่ 9: Leftmost Prefix Rule เบื้องต้น

ถ้ามี composite index เช่น `(status, created_at)` MySQL มักใช้ index ได้ดีเมื่อ query เริ่มจากคอลัมน์ซ้ายสุดก่อน

```sql
-- ใช้คอลัมน์ซ้ายสุดของ composite index
SELECT order_id, order_number
FROM orders
WHERE status = 'paid';
```

```sql
-- ใช้ทั้งสองคอลัมน์ร่วมกัน
SELECT order_id, order_number
FROM orders
WHERE status = 'paid'
  AND created_at >= '2026-03-01 00:00:00';
```

### สิ่งที่ควรเข้าใจ

- index `(status, created_at)` มักเหมาะกับ query ที่เริ่มจาก `status`
- แต่ query ที่ค้นหาเฉพาะ `created_at` อย่างเดียวอาจไม่ได้ใช้ index นี้อย่างเต็มประสิทธิภาพ

---

## หัวข้อย่อยที่ 10: คอลัมน์แบบไหนเหมาะกับการทำ Index

คอลัมน์ที่มักเหมาะกับ index ได้แก่

- `PRIMARY KEY`
- `FOREIGN KEY`
- คอลัมน์ที่ใช้ `WHERE` บ่อย
- คอลัมน์ที่ใช้ `JOIN` บ่อย
- คอลัมน์ที่ใช้ `ORDER BY` บ่อย
- คอลัมน์ที่ใช้ค้นหาแบบเจาะจง เช่น `email`, `order_number`, `username`

```sql
-- ตัวอย่าง index ที่ใช้จริงบ่อย
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status_created_at ON orders(status, created_at);
```

### สิ่งที่ควรเข้าใจ

- index ที่ดีเกิดจากพฤติกรรมการใช้งานจริงของระบบ
- อย่ามอง index แยกจาก query pattern

---

## หัวข้อย่อยที่ 11: คอลัมน์แบบไหนไม่ควรรีบทำ Index

บางคอลัมน์ไม่ค่อยเหมาะหรือไม่ได้ประโยชน์มาก เช่น

- คอลัมน์ที่แทบไม่ถูกค้นหาเลย
- คอลัมน์ที่มีความซ้ำสูงมากและไม่ได้ช่วยคัดข้อมูลมากนัก
- คอลัมน์ที่ถูก update บ่อยมากโดยไม่มีความจำเป็นต้องค้นหาจากคอลัมน์นั้น

```sql
-- ไม่ควรสร้าง index แบบไม่คิดเพียงเพราะมีคอลัมน์อยู่
-- ตัวอย่างนี้อาจไม่จำเป็นถ้าระบบไม่เคยค้นหาตาม total_amount
CREATE INDEX idx_orders_total_amount
ON orders(total_amount);
```

### สิ่งที่ควรเข้าใจ

- index ทุกตัวมีต้นทุนทั้งด้านพื้นที่และการบำรุงรักษา
- ยิ่งมี index มาก การ `INSERT`, `UPDATE`, `DELETE` ยิ่งต้องอัปเดต index ตาม

---

## หัวข้อย่อยที่ 12: Index ไม่ได้ทำให้ทุก Query เร็วขึ้นเสมอไป

หลายคนเข้าใจว่าใส่ index แล้วทุกอย่างจะเร็วขึ้น แต่ความจริงขึ้นกับรูปแบบ query ด้วย

```sql
-- ตัวอย่างที่ index อาจช่วยได้ไม่มาก ถ้าดึงข้อมูลจำนวนมากอยู่แล้ว
SELECT *
FROM orders
WHERE status = 'paid';
```

### สิ่งที่ควรเข้าใจ

- ถ้า query คืนผลลัพธ์จำนวนมาก MySQL อาจมองว่าการ scan ตารางยังคุ้มกว่า
- ต้องดู execution plan ไม่ใช่เดาอย่างเดียว

---

## หัวข้อย่อยที่ 13: ระวังการใช้ฟังก์ชันกับคอลัมน์ที่มี Index

การครอบคอลัมน์ด้วยฟังก์ชันอาจทำให้ MySQL ใช้ index ได้ไม่เต็มที่

```sql
-- อาจทำให้ใช้ index บน created_at ได้ไม่ดี
SELECT order_id, order_number
FROM orders
WHERE DATE(created_at) = '2026-03-03';
```

```sql
-- มักดีกว่า เพราะเปรียบเทียบเป็นช่วงตรง ๆ
SELECT order_id, order_number
FROM orders
WHERE created_at >= '2026-03-03 00:00:00'
  AND created_at < '2026-03-04 00:00:00';
```

### สิ่งที่ควรเข้าใจ

- ควรเขียนเงื่อนไขให้คอลัมน์ยังอยู่ในรูปที่ index ใช้งานได้ง่าย
- เรื่องนี้สำคัญมากใน query ด้านวันที่และเวลา

---

## หัวข้อย่อยที่ 14: ใช้ EXPLAIN ดู Query Plan เบื้องต้น

`EXPLAIN` ช่วยให้เราเห็นว่า MySQL วางแผนอ่านข้อมูลอย่างไร และมีแนวโน้มใช้ index หรือไม่

```sql
-- ดู execution plan ของ query
EXPLAIN
SELECT order_id, order_number, total_amount
FROM orders
WHERE customer_id = 101;
```

### สิ่งที่ควรเข้าใจ

- `EXPLAIN` เป็นเครื่องมือสำคัญในการวิเคราะห์ performance
- ช่วยตรวจสอบว่าการสร้าง index ที่ทำไปส่งผลจริงหรือไม่
- ในงานจริงควรใช้คู่กับข้อมูลขนาดใกล้เคียง production

---

## หัวข้อย่อยที่ 15: ลบ Index ที่ไม่ใช้

ถ้ามี index ที่ไม่จำเป็น ควรลบเพื่อลดภาระของระบบ

```sql
-- ลบ index ที่ไม่ต้องการ
DROP INDEX idx_orders_total_amount ON orders;
```

### สิ่งที่ควรเข้าใจ

- schema ที่ดีไม่ใช่ schema ที่มี index เยอะที่สุด
- แต่เป็น schema ที่มี index เท่าที่จำเป็นและสอดคล้องกับงานจริง

---

## ตัวอย่างการใช้งานจริง

ตัวอย่างนี้สะท้อน query ที่พบได้บ่อยในระบบจริง เช่น หน้า admin ที่ดู order ล่าสุดตามสถานะ

```sql
-- ดึง order ที่จ่ายเงินแล้ว โดยเรียงจากล่าสุดไปเก่าสุด
SELECT order_id, order_number, customer_id, total_amount, created_at
FROM orders
WHERE status = 'paid'
ORDER BY created_at DESC
LIMIT 20;
```

index ที่เหมาะกับ query นี้อาจเป็นแบบ composite

```sql
-- index ที่สอดคล้องกับ query ข้างบน
CREATE INDEX idx_orders_status_created_at
ON orders(status, created_at);
```

### สิ่งที่ควรเข้าใจ

- อย่าคิดเรื่อง index แยกจาก query
- query จริงเป็นตัวกำหนดว่าควรออกแบบ index แบบใด

---

## Best Practices สำหรับงานจริง

### 1) เริ่มจาก query ที่ช้าจริง

อย่ารีบใส่ index ทุกคอลัมน์ตั้งแต่ต้น ควรเริ่มจาก query ที่ระบบใช้งานจริงและมีผลต่อผู้ใช้

### 2) ให้ความสำคัญกับ primary key และ foreign key

```sql
-- primary key และ foreign key มักเป็นพื้นฐานของ performance ที่ดี
CREATE INDEX idx_orders_customer_id
ON orders(customer_id);
```

### 3) ออกแบบ composite index ตามลำดับการใช้งานจริง

```sql
-- ตัวอย่าง composite index
CREATE INDEX idx_orders_status_created_at
ON orders(status, created_at);
```

### 4) ระวัง index มากเกินไป

ทุก index มีต้นทุนต่อการเขียนข้อมูล เช่น `INSERT`, `UPDATE`, `DELETE`

### 5) ใช้ EXPLAIN ก่อนและหลังปรับปรุง

เพื่อยืนยันว่าการเปลี่ยนแปลงให้ผลจริง ไม่ใช่แค่คาดเดา

### 6) หลีกเลี่ยงการเขียนเงื่อนไขที่ทำให้ใช้ index ยาก

เช่นการครอบคอลัมน์ด้วยฟังก์ชันโดยไม่จำเป็น

---

## ข้อควรระวัง

- อย่าสร้าง index ทุกคอลัมน์แบบไม่วิเคราะห์
- อย่าคิดว่า index แก้ปัญหา performance ได้ทุกอย่าง
- อย่าลืมว่าการเพิ่ม index ทำให้การเขียนข้อมูลมีต้นทุนเพิ่ม
- อย่ามองเฉพาะ query เดี่ยว ต้องดูภาพรวมของระบบ
- อย่าปรับ index โดยไม่มีการตรวจสอบด้วย `EXPLAIN` หรือข้อมูลจริง

## สรุป

`Index` เป็นเครื่องมือสำคัญในการทำให้ MySQL ทำงานได้เร็วขึ้น โดยเฉพาะกับ query ที่ค้นหา กรอง เชื่อม และเรียงข้อมูลเป็นประจำ แต่การทำ index ที่ดีต้องอิงกับรูปแบบการใช้งานจริง ไม่ใช่ใส่ทุกอย่างแบบหว่าน

ถ้าเข้าใจความสัมพันธ์ระหว่าง `WHERE`, `JOIN`, `ORDER BY`, composite index, และการใช้ `EXPLAIN` คุณจะสามารถออกแบบฐานข้อมูลและ query ที่เหมาะกับงานจริงได้ดีขึ้นมาก

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `EXPLAIN and Query Analysis in MySQL`
- `Query Performance Optimization in MySQL`
- `Database Design with MySQL`
- `MySQL JOIN for Real Projects`
- `Transactions in MySQL`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียนคำสั่งสร้าง index สำหรับคอลัมน์ `customer_id` ในตาราง `orders`

### แบบฝึกหัด 2
เขียนคำสั่งสร้าง unique index สำหรับ `order_number`

### แบบฝึกหัด 3
เขียน query เพื่อดึง order ที่มีสถานะ `paid` และเรียงตาม `created_at` จากใหม่ไปเก่า

### แบบฝึกหัด 4
อธิบายสั้น ๆ ว่า composite index คืออะไร

### แบบฝึกหัด 5
เขียนคำสั่ง `EXPLAIN` สำหรับ query ที่ค้นหา order ของ `customer_id = 101`

## เฉลยแบบย่อ

```sql
-- ข้อ 1
CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

-- ข้อ 2
CREATE UNIQUE INDEX uq_orders_order_number
ON orders(order_number);

-- ข้อ 3
SELECT order_id, order_number, created_at
FROM orders
WHERE status = 'paid'
ORDER BY created_at DESC;

-- ข้อ 5
EXPLAIN
SELECT order_id, order_number, total_amount
FROM orders
WHERE customer_id = 101;
```
