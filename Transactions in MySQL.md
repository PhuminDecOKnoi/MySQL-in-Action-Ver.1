File Name: Transactions in MySQL.md

# Transactions in MySQL

## บทนำ

`Transaction` ใน MySQL คือการจัดกลุ่มหลายคำสั่ง SQL ให้ทำงานเป็น “ชุดเดียวกัน” เพื่อให้ข้อมูลคงความถูกต้องและสอดคล้องกัน ถ้าทุกขั้นตอนสำเร็จ เราจึงค่อยยืนยันผลด้วย `COMMIT` แต่ถ้ามีขั้นตอนใดผิดพลาด เราสามารถย้อนกลับทั้งหมดด้วย `ROLLBACK` ได้

หัวข้อนี้สำคัญมากในงานจริง เช่น การโอนเงิน การตัดสต๊อก การสร้างคำสั่งซื้อ การบันทึกเอกสารหลายตาราง หรือการอัปเดตข้อมูลที่ต้องสำเร็จพร้อมกัน เพราะถ้าไม่มี transaction ระบบอาจเกิดข้อมูลค้างครึ่งทาง เช่น ตัดเงินแล้วแต่ไม่สร้าง order หรือหักสต๊อกแล้วแต่ไม่บันทึกประวัติ

## สิ่งที่ผู้เรียนจะได้เรียน

- ความหมายของ `Transaction` และเหตุผลที่ต้องใช้
- หลักการ `ACID` แบบเข้าใจง่าย
- การใช้ `START TRANSACTION`, `COMMIT`, `ROLLBACK`
- การใช้ `SAVEPOINT` และ `ROLLBACK TO SAVEPOINT`
- ความสัมพันธ์ระหว่าง transaction กับ `InnoDB`
- แนวคิดเรื่อง `autocommit` และการล็อกข้อมูลเบื้องต้น
- ตัวอย่างการใช้งานจริงในระบบธุรกิจ
- ข้อควรระวังด้าน data integrity และ performance

## Transaction คืออะไร

Transaction คือชุดของคำสั่ง SQL ที่ต้องถูกมองเป็นงานเดียวกัน เช่น

- เพิ่มข้อมูล order
- เพิ่มข้อมูล order items
- หัก stock ของสินค้า
- บันทึกยอดชำระเงิน

ถ้าทำครบทุกขั้นตอนจึงถือว่าสำเร็จ แต่ถ้าขั้นตอนใดขั้นตอนหนึ่งล้มเหลว ระบบควรย้อนกลับทั้งหมด เพื่อไม่ให้ข้อมูลค้างครึ่งทาง

---

## หัวข้อย่อยที่ 1: ทำไมงานจริงจึงต้องใช้ Transaction

สมมติว่าระบบขายสินค้าออนไลน์ต้องทำ 3 อย่างพร้อมกัน

1. สร้างคำสั่งซื้อ
2. เพิ่มรายการสินค้าในคำสั่งซื้อ
3. หักจำนวน stock

ถ้าไม่มี transaction อาจเกิดกรณีนี้ได้

- สร้าง order สำเร็จ
- เพิ่ม order item สำเร็จ
- หัก stock ไม่สำเร็จ

ผลคือฐานข้อมูลจะอยู่ในสภาพไม่สมบูรณ์ และอาจทำให้รายงานผิดหรือระบบทำงานต่อยาก

### สิ่งที่ควรเข้าใจ

- transaction ใช้ป้องกันข้อมูลไม่สมบูรณ์
- เหมาะกับงานที่มีหลายคำสั่งและต้องสำเร็จพร้อมกัน
- เป็นเรื่องสำคัญมากในระบบการเงิน ระบบสต๊อก และระบบ workflow

---

## หัวข้อย่อยที่ 2: ACID คือหัวใจของ Transaction

แนวคิด `ACID` เป็นหลักพื้นฐานของ transaction

### 1) Atomicity
ทุกคำสั่งใน transaction ต้องสำเร็จทั้งหมด หรือไม่ก็ไม่สำเร็จเลย

### 2) Consistency
ข้อมูลต้องอยู่ในสถานะที่ถูกต้องก่อนและหลัง transaction

### 3) Isolation
transaction แต่ละชุดไม่ควรรบกวนกันจนทำให้ข้อมูลผิด

### 4) Durability
เมื่อ `COMMIT` แล้ว ข้อมูลต้องถูกบันทึกอย่างคงทน

### สิ่งที่ควรเข้าใจ

- ไม่จำเป็นต้องจำคำจำกัดความแบบท่องสอบอย่างเดียว
- ให้เข้าใจในเชิงงานจริงว่า transaction มีไว้เพื่อคุมความถูกต้องของข้อมูล
- MySQL ที่ใช้ `InnoDB` รองรับ transaction ได้ดี

---

## หัวข้อย่อยที่ 3: Storage Engine ที่รองรับ Transaction

ใน MySQL การใช้ transaction เกี่ยวข้องกับ storage engine ของตาราง โดยทั่วไป `InnoDB` คือ engine หลักที่รองรับ transaction, foreign key, และ row-level locking

```sql
-- สร้างตารางด้วย InnoDB
CREATE TABLE accounts (
    account_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    account_name VARCHAR(150) NOT NULL,
    balance DECIMAL(12,2) NOT NULL
) ENGINE=InnoDB;
```

### สิ่งที่ควรเข้าใจ

- ถ้าตารางไม่ใช้ `InnoDB` ความสามารถด้าน transaction อาจไม่ครบ
- ในระบบปัจจุบัน โดยทั่วไปควรใช้ `InnoDB` เป็นค่าเริ่มต้น
- ก่อนใช้งานจริงควรตรวจสอบ storage engine ของตารางสำคัญ

---

## หัวข้อย่อยที่ 4: คำสั่งพื้นฐานของ Transaction

คำสั่งหลักมี 3 ตัวที่ต้องรู้

- `START TRANSACTION` เริ่ม transaction
- `COMMIT` ยืนยันการเปลี่ยนแปลง
- `ROLLBACK` ย้อนกลับการเปลี่ยนแปลง

```sql
-- เริ่ม transaction
START TRANSACTION;

-- ตัวอย่างการอัปเดตข้อมูล
UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

-- ยืนยันผลทั้งหมด
COMMIT;
```

### สิ่งที่ควรเข้าใจ

- ถ้าทุกคำสั่งทำงานถูกต้อง จึงค่อย `COMMIT`
- ถ้ามีปัญหา ควร `ROLLBACK`
- แนวคิดนี้ใช้ได้กับทั้ง `INSERT`, `UPDATE`, และ `DELETE`

---

## หัวข้อย่อยที่ 5: ตัวอย่างจริงแบบโอนเงิน

กรณีโอนเงินเป็นตัวอย่างคลาสสิกของ transaction เพราะมีอย่างน้อย 2 ขั้นตอนที่ต้องสำเร็จพร้อมกัน

```sql
-- เริ่ม transaction
START TRANSACTION;

-- หักเงินจากบัญชีต้นทาง
UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

-- เพิ่มเงินให้บัญชีปลายทาง
UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 2;

-- ยืนยันการทำรายการ
COMMIT;
```

### สิ่งที่ควรเข้าใจ

- ถ้าหักบัญชีต้นทางแล้ว แต่เพิ่มบัญชีปลายทางไม่สำเร็จ ต้องย้อนกลับทั้งหมด
- transaction ทำให้ยอดรวมของระบบไม่เพี้ยน
- งานด้านการเงินไม่ควรทำหลายขั้นตอนแบบแยกอิสระกันโดยไม่มี transaction

---

## หัวข้อย่อยที่ 6: ใช้ ROLLBACK เมื่อเกิดข้อผิดพลาด

ถ้าระหว่าง transaction พบปัญหา เราควรยกเลิกทั้งหมด

```sql
-- เริ่ม transaction
START TRANSACTION;

-- หักเงินจากบัญชีต้นทาง
UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

-- สมมติว่าขั้นตอนต่อไปเกิดปัญหา
-- จึงยกเลิกทั้งหมด
ROLLBACK;
```

### สิ่งที่ควรเข้าใจ

- `ROLLBACK` ทำให้ข้อมูลกลับสู่สถานะก่อนเริ่ม transaction
- ช่วยลดความเสียหายจากงานที่สำเร็จเพียงบางส่วน
- application ควรจับ error และสั่ง rollback ให้ชัดเจน

---

## หัวข้อย่อยที่ 7: ตัวอย่างงานจริงแบบ Order และ Stock

ตัวอย่างนี้สะท้อนงานในระบบขายสินค้าที่ใช้ transaction จริงบ่อยมาก

```sql
-- ตารางสินค้า
CREATE TABLE products (
    product_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    stock INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- ตารางคำสั่งซื้อ
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

-- ตารางรายการสินค้าในคำสั่งซื้อ
CREATE TABLE order_items (
    order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB;
```

```sql
-- เริ่ม transaction สำหรับสร้าง order
START TRANSACTION;

-- 1) สร้างคำสั่งซื้อ
INSERT INTO orders (customer_id, status)
VALUES (101, 'pending');

-- 2) สมมติว่า order_id ล่าสุดคือ 1
-- ในงานจริงควรใช้ LAST_INSERT_ID()
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (LAST_INSERT_ID(), 5, 2, 890.00);

-- 3) หัก stock
UPDATE products
SET stock = stock - 2
WHERE product_id = 5;

-- ยืนยันทั้งหมด
COMMIT;
```

### สิ่งที่ควรเข้าใจ

- ทั้ง 3 ขั้นตอนควรถูกมองเป็นงานเดียวกัน
- ถ้าหัก stock ไม่สำเร็จ ควร rollback การสร้าง order ด้วย
- transaction ช่วยให้ข้อมูล order และ stock สอดคล้องกัน

---

## หัวข้อย่อยที่ 8: ตรวจสอบเงื่อนไขก่อน COMMIT

ในงานจริง เรามักต้องตรวจสอบก่อนว่าเงื่อนไขทางธุรกิจผ่านหรือไม่ เช่น stock ต้องพอ และยอดเงินต้องไม่ติดลบ

```sql
-- หัก stock เฉพาะเมื่อ stock เพียงพอ
UPDATE products
SET stock = stock - 2
WHERE product_id = 5
  AND stock >= 2;
```

### สิ่งที่ควรเข้าใจ

- transaction ไม่ได้แทนที่ business rule
- ต้องมีทั้ง transaction และเงื่อนไขที่ถูกต้องใน query
- หลัง update ควรตรวจสอบจำนวนแถวที่ได้รับผลกระทบด้วยใน application

---

## หัวข้อย่อยที่ 9: SAVEPOINT สำหรับย้อนกลับบางส่วน

บางครั้งเราไม่ต้องการ rollback ทั้ง transaction แต่ต้องการย้อนกลับเฉพาะบางจุด สามารถใช้ `SAVEPOINT` ได้

```sql
-- เริ่ม transaction
START TRANSACTION;

-- ขั้นตอนที่ 1
INSERT INTO orders (customer_id, status)
VALUES (102, 'pending');

-- สร้างจุดพัก
SAVEPOINT after_create_order;

-- ขั้นตอนที่ 2
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (LAST_INSERT_ID(), 8, 1, 1290.00);

-- ถ้าขั้นตอนหลังจากนี้มีปัญหา
ROLLBACK TO SAVEPOINT after_create_order;

-- หรือถ้าต้องการยืนยันทั้งหมดในภายหลัง
COMMIT;
```

### สิ่งที่ควรเข้าใจ

- `SAVEPOINT` ช่วยให้ rollback เฉพาะส่วนได้
- เหมาะกับ workflow ที่มีหลายขั้นตอนและซับซ้อนขึ้น
- แม้ไม่ใช้บ่อยเท่า `COMMIT` และ `ROLLBACK` แต่ควรรู้ไว้

---

## หัวข้อย่อยที่ 10: Autocommit คืออะไร

โดยปกติ MySQL มักทำงานในโหมด `autocommit = ON` ซึ่งหมายความว่าแต่ละคำสั่งจะถูก commit ทันทีถ้าไม่อยู่ใน transaction

```sql
-- ปิด autocommit ชั่วคราวใน session ปัจจุบัน
SET autocommit = 0;

-- หรือใช้แบบชัดเจนกว่า
START TRANSACTION;
```

### สิ่งที่ควรเข้าใจ

- ในงานจริงนิยมใช้ `START TRANSACTION` แบบชัดเจนมากกว่า
- การพึ่งพาการปิด autocommit โดยไม่ควบคุมให้ดี อาจทำให้ logic สับสน
- ควรเขียน transaction ให้ชัดในระดับ application code

---

## หัวข้อย่อยที่ 11: Transaction และ Locking เบื้องต้น

เมื่อ transaction ทำงาน MySQL อาจมีการล็อกข้อมูลบางส่วนเพื่อป้องกันไม่ให้ transaction อื่นเข้ามาแก้ไขพร้อมกันจนเกิดข้อมูลผิด

```sql
-- ล็อกแถวเพื่อเตรียมอัปเดตข้อมูล
START TRANSACTION;

SELECT account_id, balance
FROM accounts
WHERE account_id = 1
FOR UPDATE;

-- จากนั้นค่อยอัปเดตอย่างปลอดภัย
UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

COMMIT;
```

### สิ่งที่ควรเข้าใจ

- `FOR UPDATE` ใช้เมื่อต้องการอ่านแล้วเตรียมแก้ไขข้อมูลใน transaction เดียวกัน
- ช่วยลดปัญหาการแก้ข้อมูลชนกันในงานที่มีหลายผู้ใช้พร้อมกัน
- ควรใช้เท่าที่จำเป็น เพราะ lock นานเกินไปจะกระทบ performance

---

## หัวข้อย่อยที่ 12: Isolation Level เบื้องต้น

MySQL มีระดับการแยกของ transaction หรือ `Isolation Level` เพื่อควบคุมการมองเห็นข้อมูลระหว่าง transaction

ระดับที่พบบ่อย เช่น

- `READ UNCOMMITTED`
- `READ COMMITTED`
- `REPEATABLE READ`
- `SERIALIZABLE`

```sql
-- ตัวอย่างการกำหนด isolation level สำหรับ session ปัจจุบัน
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

### สิ่งที่ควรเข้าใจ

- ระดับการแยกสูงขึ้นมักปลอดภัยขึ้น แต่ก็อาจมีต้นทุนด้าน performance
- ใน MySQL โดยทั่วไป `InnoDB` มักใช้ `REPEATABLE READ` เป็นค่าเริ่มต้น
- ในหลายระบบ ผู้พัฒนาควรเข้าใจพื้นฐาน แม้ยังไม่ต้องปรับทุกโปรเจกต์

---

## หัวข้อย่อยที่ 13: ตัวอย่างปัญหาที่ Transaction ช่วยป้องกัน

### 1) Partial Update
อัปเดตสำเร็จแค่บางตาราง

### 2) Dirty Data Flow
อ่านหรือใช้ข้อมูลระหว่างที่อีก transaction ยังทำไม่เสร็จ

### 3) Lost Update
ผู้ใช้หลายคนแก้ข้อมูลเดียวกันจนค่าทับกันผิด

### สิ่งที่ควรเข้าใจ

- transaction ไม่ใช่แค่เรื่อง syntax แต่เป็นเรื่องความน่าเชื่อถือของระบบ
- ระบบที่มีผู้ใช้หลายคนพร้อมกันยิ่งต้องให้ความสำคัญ
- งานที่เกี่ยวกับยอดเงิน stock และ approval flow มักต้องออกแบบ transaction อย่างชัดเจน

---

## หัวข้อย่อยที่ 14: Best Practices สำหรับงานจริง

### 1) ทำ transaction ให้สั้นที่สุดเท่าที่เหมาะสม

อย่าเปิด transaction ค้างไว้นาน เพราะจะเพิ่มโอกาส lock ชนกันและทำให้ระบบช้าลง

### 2) ใส่เฉพาะคำสั่งที่ต้องอยู่ด้วยกันจริง

```sql
-- ดี: ใส่เฉพาะงานที่ต้องสำเร็จพร้อมกัน
START TRANSACTION;

INSERT INTO orders (customer_id, status)
VALUES (101, 'pending');

UPDATE products
SET stock = stock - 1
WHERE product_id = 5 AND stock >= 1;

COMMIT;
```

### 3) ตรวจสอบ error และ rollback ทุกครั้ง

application ควรมี error handling ชัดเจน ไม่ควรปล่อย transaction ค้าง

### 4) ใช้ InnoDB กับตารางธุรกรรม

ตารางที่เกี่ยวกับการเงิน order stock หรือ workflow สำคัญ ควรใช้ `InnoDB`

### 5) ระวังคำสั่งที่ทำ implicit commit

คำสั่งบางประเภท โดยเฉพาะ DDL เช่น `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE` อาจทำให้เกิด commit โดยอัตโนมัติ จึงไม่ควรเอามาปนกับธุรกรรมของข้อมูลประจำวัน

```sql
-- ไม่ควรผสม DDL ใน transaction งานธุรกิจทั่วไป
ALTER TABLE orders ADD COLUMN note VARCHAR(255) NULL;
```

### 6) ใช้ index ให้เหมาะกับ query ใน transaction

ถ้า transaction ต้องค้นหาและอัปเดตข้อมูลบ่อย ควรมี index ที่เหมาะสมเพื่อให้ทำงานเร็วและลดเวลาถือล็อก

---

## ข้อควรระวัง

- อย่าคิดว่า transaction ใช้เฉพาะระบบการเงินเท่านั้น
- อย่าเปิด transaction แล้วค้างไว้นานเกินจำเป็น
- อย่า `COMMIT` เร็วเกินไปก่อนตรวจสอบว่าทุกขั้นตอนสำเร็จ
- อย่าใช้ `ROLLBACK` เป็นข้ออ้างให้ละเลย business rule
- อย่าผสมงาน schema change กับ transaction ของข้อมูลปกติโดยไม่เข้าใจผลกระทบ

## สรุป

`Transaction` ใน MySQL คือเครื่องมือสำคัญสำหรับทำให้ข้อมูลถูกต้องครบถ้วนเมื่อมีหลายคำสั่งที่ต้องสำเร็จร่วมกัน โดยแกนหลักคือ `START TRANSACTION`, `COMMIT`, และ `ROLLBACK` ภายใต้แนวคิด `ACID`

ถ้าเข้าใจ transaction ดี คุณจะสามารถออกแบบระบบที่เชื่อถือได้มากขึ้น ลดปัญหาข้อมูลค้างครึ่งทาง และรองรับงานจริงที่มีความซับซ้อน เช่น การโอนเงิน การตัดสต๊อก การสร้างคำสั่งซื้อ และการอัปเดตหลายตารางพร้อมกัน

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `Isolation Levels in MySQL`
- `Locking and Concurrency in MySQL`
- `MySQL JOIN for Real Projects`
- `Indexing in MySQL`
- `Error Handling with PHP and MySQL`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน transaction สำหรับโอนเงิน 500 จากบัญชี `account_id = 1` ไปยัง `account_id = 2`

### แบบฝึกหัด 2
เขียน transaction สำหรับสร้าง order 1 รายการและหัก stock ของสินค้า 1 ชิ้น

### แบบฝึกหัด 3
อธิบายความแตกต่างระหว่าง `COMMIT` และ `ROLLBACK` แบบสั้น ๆ

### แบบฝึกหัด 4
เขียนตัวอย่าง `SAVEPOINT` และ `ROLLBACK TO SAVEPOINT`

### แบบฝึกหัด 5
อธิบายว่าเหตุใด transaction ควรสั้นและชัดเจนในงานจริง

## เฉลยแบบย่อ

```sql
-- ข้อ 1
START TRANSACTION;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 500
WHERE account_id = 2;

COMMIT;
```

```sql
-- ข้อ 2
START TRANSACTION;

INSERT INTO orders (customer_id, status)
VALUES (101, 'pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (LAST_INSERT_ID(), 5, 1, 890.00);

UPDATE products
SET stock = stock - 1
WHERE product_id = 5 AND stock >= 1;

COMMIT;
```

```sql
-- ข้อ 4
START TRANSACTION;

INSERT INTO orders (customer_id, status)
VALUES (102, 'pending');

SAVEPOINT after_order;

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (LAST_INSERT_ID(), 8, 1, 1290.00);

ROLLBACK TO SAVEPOINT after_order;
COMMIT;
```
