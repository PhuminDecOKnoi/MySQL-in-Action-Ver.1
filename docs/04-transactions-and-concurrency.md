# Module 4 — Transactions and Concurrency

## Learning Objectives

ผู้เรียนจะสามารถ:

- อธิบายคุณสมบัติ ACID
- ใช้ `START TRANSACTION`, `COMMIT` และ `ROLLBACK`
- ใช้ `SELECT ... FOR UPDATE` อย่างเหมาะสม
- เข้าใจ isolation levels และ concurrency anomalies
- ออกแบบ transaction ให้สั้นและลดความเสี่ยง deadlock

## 1. Transaction คืออะไร

Transaction คือชุดคำสั่งที่ต้องสำเร็จหรือยกเลิกเป็นหน่วยเดียว เหมาะกับงานที่เปลี่ยนข้อมูลหลายจุด เช่น สร้าง order, เพิ่มรายการสินค้า และลด stock

## 2. ACID

- **Atomicity** — สำเร็จทั้งหมดหรือยกเลิกทั้งหมด
- **Consistency** — ข้อมูลยังเป็นไปตาม constraint และ business rule
- **Isolation** — transaction ที่ทำพร้อมกันไม่รบกวนกันเกินระดับที่กำหนด
- **Durability** — เมื่อ commit แล้วข้อมูลต้องคงอยู่

## 3. Basic Transaction

```sql
START TRANSACTION;

UPDATE products
SET stock_qty = stock_qty - 2
WHERE product_id = 1
  AND stock_qty >= 2;

INSERT INTO orders (customer_id, order_status, ordered_at)
VALUES (1, 'pending', CURRENT_TIMESTAMP);

COMMIT;
```

คำสั่งนี้ยังไม่สมบูรณ์สำหรับ production เพราะต้องตรวจสอบว่าการลด stock สำเร็จจริงและเพิ่ม `order_items`

## 4. Lock แถวก่อนเปลี่ยนข้อมูล

```sql
START TRANSACTION;

SELECT stock_qty
FROM products
WHERE product_id = 1
FOR UPDATE;

-- Application ตรวจสอบว่า stock เพียงพอ

UPDATE products
SET stock_qty = stock_qty - 2
WHERE product_id = 1;

COMMIT;
```

`FOR UPDATE` ล็อกแถวที่อ่านเพื่อป้องกัน transaction อื่นแก้ไขก่อนงานปัจจุบันจบ

## 5. Savepoint

```sql
START TRANSACTION;

INSERT INTO orders (customer_id, order_status)
VALUES (1, 'pending');

SAVEPOINT order_created;

-- ทดลองเพิ่มรายการสินค้า
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (LAST_INSERT_ID(), 1, 2, 890.00);

-- ย้อนเฉพาะหลัง savepoint เมื่อจำเป็น
ROLLBACK TO SAVEPOINT order_created;

COMMIT;
```

Savepoint ช่วยย้อนบางส่วน แต่ไม่ควรใช้เพื่อซ่อน workflow ที่ออกแบบไม่ชัดเจน

## 6. Isolation Levels

```sql
SELECT @@transaction_isolation;
```

ระดับที่ควรรู้:

- `READ UNCOMMITTED`
- `READ COMMITTED`
- `REPEATABLE READ`
- `SERIALIZABLE`

MySQL InnoDB ใช้ `REPEATABLE READ` เป็นค่าเริ่มต้นโดยทั่วไป

## 7. Concurrency Problems

### Lost Update

สอง transaction อ่านค่าเดิม แล้วเขียนทับกัน ทำให้ผลของ transaction หนึ่งหายไป

### Non-repeatable Read

อ่านแถวเดิมสองครั้งใน transaction เดียว แต่ได้ค่าต่างกันเพราะอีก transaction commit ระหว่างทาง

### Phantom Read

รันเงื่อนไขเดิมสองครั้ง แต่จำนวนแถวเปลี่ยนเพราะมี transaction อื่นเพิ่มหรือลบแถวที่ตรงเงื่อนไข

### Deadlock

Transaction สองชุดล็อก resource คนละตัวแล้วรอกันเอง MySQL จะยกเลิกหนึ่ง transaction เพื่อคลี่คลายสถานการณ์

## 8. ลดความเสี่ยง Deadlock

- เข้าถึงตารางและแถวในลำดับเดียวกัน
- ทำ transaction ให้สั้น
- อย่ารอ input จากผู้ใช้ระหว่าง transaction
- สร้าง index ให้ query lock เฉพาะแถวที่ต้องใช้
- เตรียม retry logic ใน application

ตรวจสอบ deadlock ล่าสุด:

```sql
SHOW ENGINE INNODB STATUS;
```

## 9. Autocommit

```sql
SELECT @@autocommit;
```

เมื่อ autocommit เปิด คำสั่งแต่ละคำสั่งเป็น transaction ของตัวเอง เว้นแต่เริ่ม transaction ชัดเจน

## Lab 4

1. เปิด session สองหน้าต่าง
2. Session A ใช้ `SELECT ... FOR UPDATE`
3. Session B ทดลองแก้แถวเดียวกัน
4. สังเกตการรอ lock
5. Commit Session A และดูผลใน Session B
6. ทดลอง rollback หลังลด stock

## Common Mistakes

- ลืม commit หรือ rollback
- เปิด transaction นานเกินไป
- เรียก external API ระหว่างถือ lock
- ใช้ transaction กับ storage engine ที่ไม่รองรับ
- ไม่มี retry เมื่อเกิด deadlock
- คิดว่า transaction แทน constraints ได้ทั้งหมด

## Checkpoint

- Atomicity ช่วย workflow สร้าง order อย่างไร?
- `FOR UPDATE` ควรใช้เมื่อใด?
- Deadlock ต่างจาก lock wait ปกติอย่างไร?
