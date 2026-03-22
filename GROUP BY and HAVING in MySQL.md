File Name: GROUP BY and HAVING in MySQL.md

# GROUP BY and HAVING in MySQL

## บทนำ

`GROUP BY` และ `HAVING` เป็นหัวข้อสำคัญของ MySQL สำหรับการสรุปข้อมูลเชิงกลุ่ม เช่น ยอดขายต่อแผนก จำนวนคำสั่งซื้อต่อสถานะ หรือจำนวนพนักงานต่อทีมงาน ซึ่งเป็นรูปแบบที่ใช้จริงบ่อยมากใน report, dashboard และงานวิเคราะห์ข้อมูล

ถ้า `SELECT` คือการดึงข้อมูล และ `WHERE` คือการกรองข้อมูลรายแถว `GROUP BY` คือการรวมแถวที่มีลักษณะเหมือนกันให้เป็นกลุ่ม ส่วน `HAVING` คือการกรองผลลัพธ์ “หลังจากสรุปเป็นกลุ่มแล้ว”

หัวข้อนี้เหมาะสำหรับผู้ที่เริ่มใช้งาน MySQL จริงจัง และต้องการเข้าใจการสรุปข้อมูลให้พร้อมต่อยอดไปสู่รายงานและ query เชิงธุรกิจ

## สิ่งที่ผู้เรียนจะได้เรียน

- ความหมายของ `GROUP BY`
- ความแตกต่างระหว่าง `WHERE` และ `HAVING`
- การใช้ `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()` ร่วมกับ `GROUP BY`
- การสรุปข้อมูลหลายคอลัมน์
- การเรียงผลลัพธ์หลังสรุปข้อมูล
- รูปแบบ query ที่ใช้จริงใน report และ dashboard
- ข้อควรระวังเรื่อง `NULL`, logical order และความถูกต้องของผลลัพธ์

## ตารางตัวอย่างสำหรับบทเรียน

ตัวอย่างนี้ใช้ตาราง `orders` เพื่อสาธิตการสรุปข้อมูลแบบกลุ่ม

```sql
-- สร้างฐานข้อมูลตัวอย่าง
CREATE DATABASE sales_db;

-- เลือกใช้งานฐานข้อมูล
USE sales_db;

-- สร้างตารางคำสั่งซื้อ
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(150) NOT NULL,
    department VARCHAR(100) NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) NULL,
    order_date DATE NOT NULL
);

-- เพิ่มข้อมูลตัวอย่าง
INSERT INTO orders (
    customer_name, department, order_status, total_amount, discount_amount, order_date
) VALUES
    ('Anan Krit', 'IT', 'paid', 2500.00, 100.00, '2026-03-01'),
    ('Mali Suda', 'HR', 'paid', 1800.00, NULL, '2026-03-02'),
    ('Pim Rin', 'IT', 'pending', 3200.00, 200.00, '2026-03-03'),
    ('Korn Dee', 'Finance', 'paid', 4100.00, 150.00, '2026-03-03'),
    ('Jane Moon', 'HR', 'cancelled', 900.00, NULL, '2026-03-04'),
    ('Narin Chai', 'IT', 'paid', 2750.00, 50.00, '2026-03-05'),
    ('Lada Som', 'Finance', 'paid', 1500.00, NULL, '2026-03-05');
```

### สิ่งที่ควรเข้าใจ

- `department` ใช้สำหรับแบ่งกลุ่มตามหน่วยงาน
- `order_status` ใช้สำหรับแบ่งกลุ่มตามสถานะคำสั่งซื้อ
- `total_amount` และ `discount_amount` ใช้สำหรับสรุปเชิงตัวเลข
- มีค่า `NULL` ใน `discount_amount` เพื่อให้เห็นผลต่อ aggregate functions

---

## หัวข้อย่อยที่ 1: GROUP BY คืออะไร

`GROUP BY` ใช้รวมแถวที่มีค่าเหมือนกันในคอลัมน์ที่กำหนด แล้วคำนวณผลสรุปต่อกลุ่มด้วย aggregate functions

```sql
-- นับจำนวนคำสั่งซื้อแยกตาม department
SELECT
    department,
    COUNT(*) AS total_orders
FROM orders
GROUP BY department;
```

### สิ่งที่ควรเข้าใจ

- แถวที่มี `department` เดียวกันจะถูกรวมเป็นกลุ่มเดียว
- `COUNT(*)` จะนับจำนวนแถวในแต่ละกลุ่ม
- ผลลัพธ์จะไม่ใช่ข้อมูลรายแถว แต่เป็นข้อมูลสรุปต่อกลุ่ม

---

## หัวข้อย่อยที่ 2: ใช้ GROUP BY กับ COUNT()

`COUNT()` เป็นฟังก์ชันที่ใช้ร่วมกับ `GROUP BY` บ่อยมาก เช่น นับจำนวน order ต่อแผนก หรือนับจำนวนรายการต่อสถานะ

```sql
-- นับจำนวนคำสั่งซื้อแยกตามสถานะ
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;
```

### สิ่งที่ควรเข้าใจ

- แต่ละค่าใน `order_status` จะกลายเป็น 1 กลุ่ม
- `COUNT(*)` นับจำนวนแถวในแต่ละกลุ่ม
- เหมาะกับรายงานที่ต้องการดูจำนวนรายการในแต่ละหมวด

---

## หัวข้อย่อยที่ 3: ใช้ GROUP BY กับ SUM()

`SUM()` ใช้หาผลรวมต่อกลุ่ม เช่น ยอดขายรวมต่อแผนก หรือยอดขายรวมต่อสถานะ

```sql
-- สรุปยอดขายรวมแยกตาม department
SELECT
    department,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY department;
```

### สิ่งที่ควรเข้าใจ

- แต่ละแผนกจะมียอดรวมของตัวเอง
- เหมาะกับ report ทางธุรกิจ เช่น ยอดขาย, งบประมาณ, ค่าใช้จ่าย

---

## หัวข้อย่อยที่ 4: ใช้ GROUP BY กับ AVG(), MIN(), MAX()

เราสามารถหาค่าเฉลี่ย ค่าต่ำสุด และค่าสูงสุดแยกตามกลุ่มได้เช่นกัน

```sql
-- หาค่าเฉลี่ย ยอดต่ำสุด และยอดสูงสุด แยกตาม department
SELECT
    department,
    AVG(total_amount) AS avg_order_amount,
    MIN(total_amount) AS min_order_amount,
    MAX(total_amount) AS max_order_amount
FROM orders
GROUP BY department;
```

### สิ่งที่ควรเข้าใจ

- `AVG()` ใช้หาค่าเฉลี่ยต่อกลุ่ม
- `MIN()` และ `MAX()` ใช้หาช่วงค่าของแต่ละกลุ่ม
- เหมาะกับการเปรียบเทียบ performance ระหว่างทีมหรือหมวดข้อมูล

---

## หัวข้อย่อยที่ 5: GROUP BY หลายคอลัมน์

ในงานจริง เราอาจต้องการสรุปข้อมูลที่ละเอียดขึ้น เช่น แยกทั้งแผนกและสถานะคำสั่งซื้อพร้อมกัน

```sql
-- สรุปจำนวนคำสั่งซื้อแยกตาม department และ order_status
SELECT
    department,
    order_status,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY department, order_status;
```

### สิ่งที่ควรเข้าใจ

- กลุ่มจะถูกแบ่งตาม “ชุดค่าร่วมกัน” ของทั้งสองคอลัมน์
- ตัวอย่างเช่น `IT + paid` และ `IT + pending` จะเป็นคนละกลุ่ม
- เหมาะกับ report ที่ต้องการมุมมองละเอียดขึ้น

---

## หัวข้อย่อยที่ 6: WHERE กับ GROUP BY

`WHERE` ใช้กรองข้อมูล “ก่อน” การจัดกลุ่ม ซึ่งสำคัญมากในงานจริง

```sql
-- สรุปยอดขายเฉพาะคำสั่งซื้อที่ชำระเงินแล้ว แยกตาม department
SELECT
    department,
    COUNT(*) AS total_paid_orders,
    SUM(total_amount) AS total_paid_sales
FROM orders
WHERE order_status = 'paid'
GROUP BY department;
```

### สิ่งที่ควรเข้าใจ

- `WHERE` จะคัดเฉพาะแถวที่ตรงเงื่อนไขก่อน
- จากนั้น `GROUP BY` จึงนำข้อมูลที่เหลือมาจัดกลุ่ม
- ถ้า logic นี้สลับกัน ความหมายของ report จะเปลี่ยนทันที

---

## หัวข้อย่อยที่ 7: HAVING คืออะไร

`HAVING` ใช้กรองผลลัพธ์ “หลังจากจัดกลุ่มแล้ว” โดยมักใช้กับ aggregate functions

```sql
-- แสดงเฉพาะ department ที่มีจำนวนคำสั่งซื้อมากกว่า 2
SELECT
    department,
    COUNT(*) AS total_orders
FROM orders
GROUP BY department
HAVING COUNT(*) > 2;
```

### สิ่งที่ควรเข้าใจ

- `HAVING` ใช้กับผลสรุปต่อกลุ่ม
- ต่างจาก `WHERE` ที่ใช้กับข้อมูลรายแถวก่อนจัดกลุ่ม
- ถ้าต้องการกรองจากค่าที่เกิดจาก `COUNT()`, `SUM()`, `AVG()` ต้องใช้ `HAVING`

---

## หัวข้อย่อยที่ 8: WHERE กับ HAVING ต่างกันอย่างไร

นี่คือความต่างที่สำคัญมากในการเขียน SQL

```sql
-- WHERE: กรองก่อนจัดกลุ่ม
SELECT
    department,
    SUM(total_amount) AS total_sales
FROM orders
WHERE order_status = 'paid'
GROUP BY department;
```

```sql
-- HAVING: กรองหลังจัดกลุ่ม
SELECT
    department,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY department
HAVING SUM(total_amount) > 3000;
```

### สิ่งที่ควรเข้าใจ

- `WHERE` กรองแถวก่อนรวมกลุ่ม
- `HAVING` กรองกลุ่มหลังรวมแล้ว
- ทั้งสองอาจถูกใช้ร่วมกันใน query เดียว และมักใช้จริงบ่อยมาก

---

## หัวข้อย่อยที่ 9: ใช้ WHERE + GROUP BY + HAVING ร่วมกัน

นี่คือรูปแบบที่ใช้จริงบ่อยที่สุดในงาน report และ dashboard

```sql
-- สรุปยอดขายของคำสั่งซื้อที่จ่ายแล้ว
-- แยกตาม department
-- และแสดงเฉพาะแผนกที่มียอดรวมเกิน 3000
SELECT
    department,
    COUNT(*) AS total_paid_orders,
    SUM(total_amount) AS total_paid_sales,
    AVG(total_amount) AS avg_paid_order
FROM orders
WHERE order_status = 'paid'
GROUP BY department
HAVING SUM(total_amount) > 3000;
```

### สิ่งที่ควรเข้าใจ

- กรองข้อมูลดิบด้วย `WHERE`
- สรุปด้วย `GROUP BY`
- กรองผลสรุปด้วย `HAVING`
- เป็น pattern สำคัญที่ควรจำให้แม่น

---

## หัวข้อย่อยที่ 10: เรียงผลลัพธ์หลัง GROUP BY

หลังจากสรุปข้อมูลแล้ว เรามักต้องเรียงผลลัพธ์เพื่อให้อ่านง่ายขึ้น

```sql
-- สรุปยอดขายแยกตาม department และเรียงจากยอดรวมมากไปน้อย
SELECT
    department,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY department
ORDER BY total_sales DESC;
```

### สิ่งที่ควรเข้าใจ

- `ORDER BY` ใช้เรียงผลลัพธ์หลังจากได้ผลสรุปแล้ว
- สามารถเรียงตาม alias เช่น `total_sales` ได้
- เหมาะกับการทำ dashboard หรือ leaderboard

---

## หัวข้อย่อยที่ 11: GROUP BY กับ NULL

เมื่อใช้ aggregate functions กับคอลัมน์ที่มี `NULL` ต้องเข้าใจว่าฟังก์ชันส่วนใหญ่จะข้ามค่า `NULL`

```sql
-- สรุปจำนวนแถวและสรุปส่วนลดแยกตาม department
SELECT
    department,
    COUNT(*) AS total_rows,
    COUNT(discount_amount) AS rows_with_discount,
    SUM(discount_amount) AS total_discount,
    AVG(discount_amount) AS avg_discount
FROM orders
GROUP BY department;
```

### สิ่งที่ควรเข้าใจ

- `COUNT(*)` นับทุกแถว
- `COUNT(discount_amount)` นับเฉพาะแถวที่ `discount_amount` ไม่เป็น `NULL`
- `SUM()` และ `AVG()` จะข้าม `NULL`
- ถ้าไม่เข้าใจจุดนี้ อาจตีความรายงานผิดได้

---

## หัวข้อย่อยที่ 12: ข้อจำกัดของ SELECT เมื่อใช้ GROUP BY

เมื่อใช้ `GROUP BY` ควรเลือกเฉพาะคอลัมน์ที่อยู่ใน `GROUP BY` หรือคอลัมน์ที่ผ่าน aggregate function เท่านั้น

```sql
-- ดี: ทุกคอลัมน์ใน SELECT มีเหตุผลชัดเจน
SELECT
    department,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY department;
```

```sql
-- ไม่แนะนำ: customer_name ไม่ได้อยู่ใน GROUP BY
-- และไม่ได้ผ่าน aggregate function
SELECT
    department,
    customer_name,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY department;
```

### สิ่งที่ควรเข้าใจ

- การเลือกคอลัมน์ที่ไม่สอดคล้องกับ `GROUP BY` อาจทำให้ผลลัพธ์คลุมเครือ
- ในงานจริงควรเขียนให้ชัดเจนเพื่อให้ query เชื่อถือได้และดูแลง่าย

---

## ตัวอย่างการใช้งานจริงแบบรายงาน

ตัวอย่างนี้สะท้อนรูปแบบ query ที่ใช้จริงในรายงานยอดขาย

```sql
-- รายงานสรุปคำสั่งซื้อที่ชำระเงินแล้ว แยกตาม department
SELECT
    department,
    COUNT(*) AS total_paid_orders,
    SUM(total_amount) AS total_paid_sales,
    AVG(total_amount) AS avg_paid_amount,
    MIN(total_amount) AS min_paid_amount,
    MAX(total_amount) AS max_paid_amount
FROM orders
WHERE order_status = 'paid'
GROUP BY department
HAVING COUNT(*) >= 1
ORDER BY total_paid_sales DESC;
```

### สิ่งที่ควรเข้าใจ

- query นี้พร้อมใช้ใน report หรือ dashboard ได้จริง
- มีทั้งการกรอง การสรุป การคัดเลือกกลุ่ม และการเรียงผล
- เป็นรูปแบบที่ควรฝึกให้คล่องก่อนต่อยอดไปสู่ query ที่ซับซ้อนกว่าเดิม

---

## Best Practices สำหรับงานจริง

### 1) แยกบทบาทของ WHERE และ HAVING ให้ชัด

```sql
-- WHERE ใช้กรองข้อมูลดิบ
-- HAVING ใช้กรองผลสรุป
SELECT
    department,
    SUM(total_amount) AS total_sales
FROM orders
WHERE order_status = 'paid'
GROUP BY department
HAVING SUM(total_amount) > 3000;
```

### 2) ใช้ alias กับค่าที่สรุปเสมอ

```sql
-- ช่วยให้ผลลัพธ์อ่านง่ายขึ้น
SELECT
    department,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY department;
```

### 3) อย่าใช้ SELECT * กับ GROUP BY แบบไม่เข้าใจ

การสรุปข้อมูลควรระบุคอลัมน์ให้ชัด เพื่อให้ผลลัพธ์แน่นอนและอ่านง่าย

### 4) เข้าใจ logical order ของ query

ลำดับความคิดโดยทั่วไปคือ:

- `FROM`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `SELECT`
- `ORDER BY`

เมื่อเข้าใจลำดับนี้ จะเขียน query ได้แม่นขึ้นมาก

### 5) พิจารณา index สำหรับคอลัมน์ที่ใช้กรองและจัดกลุ่มบ่อย

เช่น `order_status`, `department`, `order_date` โดยเฉพาะเมื่อข้อมูลเริ่มมีขนาดใหญ่

---

## ข้อควรระวัง

- อย่าสับสนระหว่าง `WHERE` กับ `HAVING`
- อย่าเลือกคอลัมน์ใน `SELECT` แบบไม่สัมพันธ์กับ `GROUP BY`
- ระวังผลของ `NULL` ต่อ `COUNT()`, `SUM()`, และ `AVG()`
- อย่าใช้ `HAVING` แทน `WHERE` โดยไม่จำเป็น เพราะอาจทำให้ query หนักขึ้น
- ควรตรวจสอบว่ากลุ่มข้อมูลที่สร้างขึ้นมีความหมายทางธุรกิจจริง

## สรุป

`GROUP BY` และ `HAVING` เป็นเครื่องมือหลักในการสรุปข้อมูลเชิงกลุ่มใน MySQL และเป็นทักษะสำคัญมากสำหรับงาน report, analytics และ dashboard

ถ้าเข้าใจว่า `WHERE` กรองก่อน, `GROUP BY` จัดกลุ่ม, และ `HAVING` กรองหลังสรุป คุณจะสามารถเขียน query ที่ตอบโจทย์งานจริงได้ชัดเจนและเชื่อถือได้มากขึ้น

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `Aggregate Functions in MySQL`
- `Date Functions in MySQL`
- `Subqueries in MySQL`
- `MySQL JOIN for Real Projects`
- `Indexes and Query Performance`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน query เพื่อแสดงจำนวนคำสั่งซื้อแยกตาม `department`

### แบบฝึกหัด 2
เขียน query เพื่อแสดงยอดขายรวมแยกตาม `order_status`

### แบบฝึกหัด 3
เขียน query เพื่อแสดงเฉพาะ `department` ที่มีจำนวนคำสั่งซื้อมากกว่า 2

### แบบฝึกหัด 4
เขียน query เพื่อสรุปยอดขายของ order ที่สถานะ `paid` แยกตาม `department`

### แบบฝึกหัด 5
เขียน query เพื่อสรุปยอดขายแยกตาม `department` และแสดงเฉพาะกลุ่มที่มียอดรวมเกิน `3000`

## เฉลยแบบย่อ

```sql
-- ข้อ 1
SELECT department, COUNT(*) AS total_orders
FROM orders
GROUP BY department;

-- ข้อ 2
SELECT order_status, SUM(total_amount) AS total_sales
FROM orders
GROUP BY order_status;

-- ข้อ 3
SELECT department, COUNT(*) AS total_orders
FROM orders
GROUP BY department
HAVING COUNT(*) > 2;

-- ข้อ 4
SELECT department, SUM(total_amount) AS total_paid_sales
FROM orders
WHERE order_status = 'paid'
GROUP BY department;

-- ข้อ 5
SELECT department, SUM(total_amount) AS total_sales
FROM orders
GROUP BY department
HAVING SUM(total_amount) > 3000;
```
