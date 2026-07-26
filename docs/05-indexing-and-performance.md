# Module 5 — Indexing and Performance

## Learning Objectives

ผู้เรียนจะสามารถ:

- อธิบายหน้าที่และต้นทุนของ index
- ออกแบบ single-column และ composite index จาก query pattern
- ใช้หลัก leftmost prefix
- อ่าน `EXPLAIN` และ `EXPLAIN ANALYZE`
- ระบุ anti-pattern ที่ทำให้ query ใช้ index ได้ยาก
- วัดผลก่อนและหลังการปรับปรุง

## 1. Index คืออะไร

Index เป็นโครงสร้างข้อมูลที่ช่วยให้ MySQL ค้นหาแถวได้เร็วขึ้น แต่มีต้นทุนด้านพื้นที่และการเขียนข้อมูล ทุก `INSERT`, `UPDATE` และ `DELETE` อาจต้องปรับ index ที่เกี่ยวข้อง

## 2. สร้าง Index จาก Query จริง

```sql
CREATE INDEX idx_orders_customer
ON orders(customer_id);
```

รองรับ query เช่น:

```sql
SELECT order_id, ordered_at, order_status
FROM orders
WHERE customer_id = 1001;
```

## 3. Composite Index

```sql
CREATE INDEX idx_orders_status_date
ON orders(order_status, ordered_at);
```

เหมาะกับ:

```sql
SELECT order_id, ordered_at
FROM orders
WHERE order_status = 'paid'
ORDER BY ordered_at DESC
LIMIT 50;
```

ลำดับคอลัมน์ควรสอดคล้องกับ filter, sort และ selectivity ของ workload

## 4. Leftmost Prefix

Index `(order_status, ordered_at)` มักช่วย query ที่ใช้:

- `order_status`
- `order_status` และ `ordered_at`

แต่ไม่จำเป็นต้องช่วย query ที่กรองเฉพาะ `ordered_at` ได้เต็มประสิทธิภาพ

## 5. EXPLAIN

```sql
EXPLAIN FORMAT=TREE
SELECT
    o.order_id,
    c.full_name,
    o.ordered_at
FROM orders AS o
JOIN customers AS c
  ON c.customer_id = o.customer_id
WHERE o.order_status = 'paid'
ORDER BY o.ordered_at DESC
LIMIT 20;
```

สิ่งที่ควรดู:

- access method
- index ที่ถูกเลือก
- estimated rows
- join order
- sort และ temporary work

## 6. EXPLAIN ANALYZE

```sql
EXPLAIN ANALYZE
SELECT order_id, ordered_at
FROM orders
WHERE order_status = 'paid'
ORDER BY ordered_at DESC
LIMIT 20;
```

`EXPLAIN ANALYZE` รัน query จริงและแสดงเวลาพร้อมจำนวนแถวจริง จึงไม่ควรใช้กับคำสั่งที่มีผลกระทบโดยไม่เข้าใจ behavior

เปรียบเทียบ:

- estimated rows
- actual rows
- actual time
- loops

ถ้าค่าประมาณต่างจากค่าจริงมาก อาจต้องตรวจ statistics, data distribution หรือ query design

## 7. Sargable Predicates

### แบบที่ใช้ index ได้ยาก

```sql
SELECT order_id
FROM orders
WHERE DATE(ordered_at) = '2026-07-01';
```

### แบบที่เหมาะกว่า

```sql
SELECT order_id
FROM orders
WHERE ordered_at >= '2026-07-01 00:00:00'
  AND ordered_at <  '2026-07-02 00:00:00';
```

หลีกเลี่ยงการครอบ indexed column ด้วย function เมื่อสามารถเขียนเป็นช่วงได้

## 8. Covering Index

```sql
CREATE INDEX idx_orders_status_date_id
ON orders(order_status, ordered_at, order_id);
```

Index อาจครอบคลุม query ที่เลือกเฉพาะคอลัมน์เหล่านี้ แต่ไม่ควรขยาย index ให้ใหญ่เพื่อทุก query โดยไม่มีการวัดผล

## 9. Duplicate และ Redundant Indexes

ตรวจสอบ index:

```sql
SHOW INDEX FROM orders;
```

Index `(customer_id)` อาจซ้ำซ้อนหากมี `(customer_id, ordered_at)` และ workload ใช้รูปแบบสอดคล้องกัน ต้องวิเคราะห์ก่อนลบ

## 10. Invisible Index สำหรับการทดสอบ

```sql
ALTER TABLE orders
ALTER INDEX idx_orders_status_date INVISIBLE;

ALTER TABLE orders
ALTER INDEX idx_orders_status_date VISIBLE;
```

Invisible index ช่วยทดสอบผลกระทบจากการไม่ใช้ index โดยยังไม่ต้อง drop ทันที

## Performance Workflow

1. ระบุ query ที่ช้าจริง
2. เก็บ query และ parameter ตัวอย่าง
3. รัน `EXPLAIN`
4. รัน `EXPLAIN ANALYZE` ใน environment ที่ปลอดภัย
5. ปรับ query หรือ index ทีละจุด
6. วัดผลซ้ำ
7. ตรวจผลกระทบต่อ write workload

## Lab 5

1. รัน query รายการ order ตาม status และ date
2. เก็บ `EXPLAIN ANALYZE`
3. เพิ่ม composite index
4. เปรียบเทียบ estimated/actual rows และเวลา
5. ทำ index เป็น invisible แล้วทดสอบอีกครั้ง
6. สรุปว่าควรเก็บ index หรือไม่

## Common Mistakes

- เพิ่ม index ทุกคอลัมน์
- ดูเฉพาะเวลา query ครั้งเดียว
- ไม่ทดสอบกับข้อมูลใกล้เคียง production
- ใช้ `SELECT *` จน covering index ไม่มีประโยชน์
- ใช้ function บน indexed column โดยไม่จำเป็น
- ลบ index โดยไม่ตรวจ Foreign Key และ workload

## Checkpoint

- Composite index ต่างจาก index แยกหลายตัวอย่างไร?
- `EXPLAIN` ต่างจาก `EXPLAIN ANALYZE` อย่างไร?
- เหตุใด index จึงทำให้ write ช้าลงได้?
