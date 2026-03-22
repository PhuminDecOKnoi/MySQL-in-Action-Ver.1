File Name: Aggregate Functions in MySQL.md

# Aggregate Functions in MySQL

## บทนำ

`Aggregate Functions` คือฟังก์ชันใน MySQL ที่ใช้สรุปข้อมูลหลายแถวให้กลายเป็นค่าภาพรวม เช่น นับจำนวนรายการ หาผลรวม ค่าเฉลี่ย ค่าสูงสุด และค่าต่ำสุด ซึ่งเป็นพื้นฐานสำคัญของงานรายงาน (report), dashboard, analytics, และงานสรุปข้อมูลในระบบจริง

ในการทำงานกับฐานข้อมูล เราไม่ได้ต้องการแค่ “ดูข้อมูลทีละแถว” เท่านั้น แต่ยังต้องการตอบคำถามทางธุรกิจ เช่น

- มีคำสั่งซื้อทั้งหมดกี่รายการ
- ยอดขายรวมเท่าไร
- ราคาเฉลี่ยของสินค้าในแต่ละหมวดคือเท่าไร
- พนักงานแผนกใดมีเงินเดือนสูงสุด

หัวข้อนี้เหมาะสำหรับผู้เริ่มต้นที่ต้องการเข้าใจการสรุปข้อมูลใน MySQL และเหมาะสำหรับผู้ที่เริ่มพัฒนาระบบจริงที่ต้องใช้ `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()` ร่วมกับ `GROUP BY` และ `HAVING`

## สิ่งที่ผู้เรียนจะได้เรียน

- ความหมายของ `Aggregate Functions`
- การใช้ `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`
- ความต่างระหว่างการสรุปทั้งตารางและสรุปแบบแยกกลุ่ม
- การใช้ `GROUP BY` ร่วมกับ aggregate
- การใช้ `HAVING` เพื่อกรองผลสรุป
- การจัดการกับ `NULL` ในการสรุปข้อมูล
- แนวคิดที่ใช้จริงในงาน เช่น reporting, dashboard, และ data integrity

## ตารางตัวอย่างสำหรับบทเรียน

ตัวอย่างนี้จะใช้ตาราง `orders` เพื่อให้เห็นภาพการสรุปข้อมูลได้ชัดเจน

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
    ('Narin Chai', 'IT', 'paid', 2750.00, 50.00, '2026-03-05');
```

### สิ่งที่ควรเข้าใจ

- `total_amount` ใช้สำหรับสรุปยอดรวมและค่าเฉลี่ย
- `discount_amount` มีบางแถวเป็น `NULL` เพื่อใช้ฝึกเรื่องผลของ `NULL` ต่อ aggregate
- `department` และ `order_status` ใช้สำหรับแยกกลุ่มข้อมูล

---

## หัวข้อย่อยที่ 1: Aggregate Functions คืออะไร

Aggregate Functions ใช้รวมค่าจากหลายแถวแล้วคืนผลลัพธ์ออกมาเป็น “ค่าหนึ่งค่า” หรือ “ค่าหนึ่งต่อหนึ่งกลุ่ม” เมื่อใช้ร่วมกับ `GROUP BY`

ตัวอย่างเช่น เราสามารถนับจำนวน order ทั้งหมด หรือหายอดขายรวมของทั้งตารางได้

```sql
-- นับจำนวนคำสั่งซื้อทั้งหมด
SELECT COUNT(*) AS total_orders
FROM orders;
```

### สิ่งที่ควรเข้าใจ

- Aggregate functions ไม่ได้แสดงข้อมูลทีละแถวแบบปกติ
- ผลลัพธ์มักเป็นค่าภาพรวม เช่น จำนวนรวม หรือยอดรวม
- เป็นพื้นฐานของงานวิเคราะห์ข้อมูลใน SQL

---

## หัวข้อย่อยที่ 2: COUNT() สำหรับนับจำนวน

`COUNT()` ใช้สำหรับนับจำนวนแถวหรือจำนวนค่าที่ไม่เป็น `NULL`

```sql
-- นับจำนวนคำสั่งซื้อทั้งหมด
SELECT COUNT(*) AS total_orders
FROM orders;
```

```sql
-- นับจำนวนแถวที่ discount_amount มีค่า
SELECT COUNT(discount_amount) AS orders_with_discount
FROM orders;
```

### สิ่งที่ควรเข้าใจ

- `COUNT(*)` นับทุกแถว
- `COUNT(column_name)` นับเฉพาะแถวที่คอลัมน์นั้นไม่เป็น `NULL`
- จึงให้ผลต่างกันได้เมื่อมี `NULL` อยู่ในข้อมูล

---

## หัวข้อย่อยที่ 3: SUM() สำหรับหาผลรวม

`SUM()` ใช้หาผลรวมของค่าตัวเลข เช่น ยอดขายรวม ยอดส่วนลดรวม หรือจำนวนรวม

```sql
-- หายอดรวมของ total_amount ทั้งหมด
SELECT SUM(total_amount) AS total_sales
FROM orders;
```

```sql
-- หาผลรวมของ discount_amount
SELECT SUM(discount_amount) AS total_discount
FROM orders;
```

### สิ่งที่ควรเข้าใจ

- `SUM()` ใช้ได้กับคอลัมน์ตัวเลข
- ค่า `NULL` จะไม่ถูกรวม
- เหมาะกับงานสรุปยอดทางธุรกิจ เช่น ยอดขาย ยอดส่วนลด หรือยอดงบประมาณ

---

## หัวข้อย่อยที่ 4: AVG() สำหรับหาค่าเฉลี่ย

`AVG()` ใช้หาค่าเฉลี่ยของข้อมูลตัวเลข เช่น ยอดสั่งซื้อเฉลี่ย หรือเงินเดือนเฉลี่ย

```sql
-- หาค่าเฉลี่ยของยอดสั่งซื้อ
SELECT AVG(total_amount) AS average_order_amount
FROM orders;
```

```sql
-- หาค่าเฉลี่ยของ discount_amount
SELECT AVG(discount_amount) AS average_discount
FROM orders;
```

### สิ่งที่ควรเข้าใจ

- `AVG()` จะไม่นำค่า `NULL` มาคิด
- ค่าเฉลี่ยที่ได้จึงคำนวณจากเฉพาะแถวที่มีข้อมูลจริง
- ในงานจริงควรรู้ว่าข้อมูลที่หายไปอาจส่งผลต่อการตีความผลลัพธ์

---

## หัวข้อย่อยที่ 5: MIN() และ MAX()

`MIN()` ใช้หาค่าต่ำสุด และ `MAX()` ใช้หาค่าสูงสุด เช่น order ต่ำสุด ยอดขายสูงสุด หรือวันที่ล่าสุด

```sql
-- หายอดสั่งซื้อต่ำสุดและสูงสุด
SELECT
    MIN(total_amount) AS min_order_amount,
    MAX(total_amount) AS max_order_amount
FROM orders;
```

```sql
-- หาวันที่สั่งซื้อแรกสุดและล่าสุด
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS latest_order_date
FROM orders;
```

### สิ่งที่ควรเข้าใจ

- ใช้ได้กับทั้งตัวเลข วันที่ และข้อความบางกรณี
- เหมาะกับงานวิเคราะห์ค่าสูงสุด ค่าต่ำสุด หรือช่วงเวลาของข้อมูล

---

## หัวข้อย่อยที่ 6: ใช้ Aggregate หลายตัวใน query เดียว

ในงานจริงเรามักต้องการสรุปหลายค่าในคำสั่งเดียว เช่น จำนวน order ยอดรวม และค่าเฉลี่ย

```sql
-- สรุปภาพรวมของคำสั่งซื้อทั้งหมด
SELECT
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS average_order_amount,
    MIN(total_amount) AS smallest_order,
    MAX(total_amount) AS largest_order
FROM orders;
```

### สิ่งที่ควรเข้าใจ

- Query เดียวสามารถสรุปหลายมุมมองได้พร้อมกัน
- เหมาะมากกับหน้า dashboard หรือ summary card ในระบบจริง

---

## หัวข้อย่อยที่ 7: GROUP BY เพื่อสรุปเป็นรายกลุ่ม

ถ้าต้องการสรุปข้อมูล “แยกตามหมวด” เช่น แยกตามแผนก หรือสถานะคำสั่งซื้อ ต้องใช้ `GROUP BY`

```sql
-- สรุปจำนวนคำสั่งซื้อแยกตาม department
SELECT
    department,
    COUNT(*) AS total_orders
FROM orders
GROUP BY department;
```

```sql
-- สรุปยอดขายรวมแยกตาม order_status
SELECT
    order_status,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY order_status;
```

### สิ่งที่ควรเข้าใจ

- `GROUP BY` รวมแถวที่มีค่าเหมือนกันให้อยู่ในกลุ่มเดียว
- จากนั้น aggregate function จะคำนวณต่อกลุ่ม
- เป็นเทคนิคหลักของงานรายงานใน SQL

---

## หัวข้อย่อยที่ 8: ใช้ AVG() ร่วมกับ GROUP BY

เราสามารถหาค่าเฉลี่ยรายกลุ่มได้ เช่น ค่า order เฉลี่ยของแต่ละแผนก

```sql
-- หาค่าเฉลี่ยยอดสั่งซื้อแยกตาม department
SELECT
    department,
    AVG(total_amount) AS average_order_amount
FROM orders
GROUP BY department;
```

### สิ่งที่ควรเข้าใจ

- ข้อมูลแต่ละกลุ่มจะมีค่าเฉลี่ยของตัวเอง
- เหมาะกับการเปรียบเทียบผลงานหรือแนวโน้มระหว่างกลุ่ม

---

## หัวข้อย่อยที่ 9: HAVING สำหรับกรองผลสรุป

`WHERE` ใช้กรอง “ก่อน” การสรุปข้อมูล ส่วน `HAVING` ใช้กรอง “หลัง” จากที่สรุปแล้ว

```sql
-- แสดงเฉพาะ department ที่มีจำนวนคำสั่งซื้อมากกว่า 1 รายการ
SELECT
    department,
    COUNT(*) AS total_orders
FROM orders
GROUP BY department
HAVING COUNT(*) > 1;
```

```sql
-- แสดงเฉพาะสถานะที่มียอดขายรวมเกิน 3000
SELECT
    order_status,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY order_status
HAVING SUM(total_amount) > 3000;
```

### สิ่งที่ควรเข้าใจ

- `HAVING` ใช้กับ aggregate result
- ถ้าจะกรองกลุ่มจากค่าที่สรุปแล้ว ต้องใช้ `HAVING` ไม่ใช่ `WHERE`

---

## หัวข้อย่อยที่ 10: WHERE + GROUP BY + HAVING

ในงานจริง เรามักใช้ทั้งสามอย่างร่วมกัน โดยกรองข้อมูลก่อน แล้วค่อยสรุป แล้วจึงกรองผลสรุปอีกที

```sql
-- สรุปยอดขายของ order ที่สถานะ paid
-- แล้วแสดงเฉพาะ department ที่มียอดรวมเกิน 2000
SELECT
    department,
    COUNT(*) AS total_paid_orders,
    SUM(total_amount) AS total_paid_sales
FROM orders
WHERE order_status = 'paid'
GROUP BY department
HAVING SUM(total_amount) > 2000;
```

### สิ่งที่ควรเข้าใจ

- `WHERE` ลดข้อมูลก่อนสรุป
- `GROUP BY` แบ่งกลุ่ม
- `HAVING` กรองผลลัพธ์หลังสรุป
- ลำดับความคิดนี้สำคัญมากใน SQL ที่ใช้จริง

---

## หัวข้อย่อยที่ 11: ผลของ NULL ต่อ Aggregate Functions

`NULL` มีผลต่อ aggregate functions ต่างกัน และเป็นเรื่องที่ต้องเข้าใจให้ชัด

```sql
-- เปรียบเทียบการนับแบบต่าง ๆ
SELECT
    COUNT(*) AS total_rows,
    COUNT(discount_amount) AS rows_with_discount,
    SUM(discount_amount) AS total_discount,
    AVG(discount_amount) AS average_discount
FROM orders;
```

### สิ่งที่ควรเข้าใจ

- `COUNT(*)` นับทุกแถว
- `COUNT(discount_amount)` นับเฉพาะแถวที่มีค่า
- `SUM()` และ `AVG()` จะข้ามค่า `NULL`
- ถ้าตีความไม่ถูก อาจทำให้สรุปผลธุรกิจคลาดเคลื่อนได้

---

## หัวข้อย่อยที่ 12: ตั้งชื่อผลลัพธ์ด้วย AS

การใช้ `AS` ช่วยให้ชื่อคอลัมน์ในผลลัพธ์อ่านง่ายและเหมาะกับ report หรือ application มากขึ้น

```sql
-- ตั้งชื่อผลลัพธ์ให้ชัดเจน
SELECT
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS avg_sales
FROM orders;
```

### สิ่งที่ควรเข้าใจ

- alias ช่วยให้ผลลัพธ์สื่อความหมายชัดขึ้น
- เหมาะกับ dashboard, export report, และ API response

---

## ตัวอย่างการใช้งานจริงแบบรายงาน

ตัวอย่างนี้สะท้อนรูปแบบ query ที่ใช้จริงใน dashboard รายงานยอดขาย

```sql
-- รายงานสรุปยอดขายแยกตาม department
SELECT
    department,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS avg_order_amount,
    MAX(total_amount) AS highest_order,
    MIN(total_amount) AS lowest_order
FROM orders
WHERE order_status = 'paid'
GROUP BY department
ORDER BY total_sales DESC;
```

### สิ่งที่ควรเข้าใจ

- query นี้ใช้งานได้จริงในหน้า summary report
- มีทั้งการกรองข้อมูล การสรุป และการเรียงผลลัพธ์
- เป็นรูปแบบที่ควรรู้ก่อนต่อยอดไปยัง reporting ที่ซับซ้อนขึ้น

---

## Best Practices สำหรับงานจริง

### 1) แยกให้ชัดระหว่าง WHERE และ HAVING

```sql
-- ดี: กรองก่อนสรุปด้วย WHERE
SELECT department, SUM(total_amount) AS total_sales
FROM orders
WHERE order_status = 'paid'
GROUP BY department;
```

ใช้ `WHERE` เมื่อต้องการกรองข้อมูลดิบ และใช้ `HAVING` เมื่อต้องการกรองผลสรุป

### 2) ใช้ alias กับค่าที่สรุปเสมอ

```sql
-- ดี: ตั้งชื่อผลลัพธ์ให้พร้อมใช้งาน
SELECT SUM(total_amount) AS total_sales
FROM orders;
```

### 3) เข้าใจผลของ NULL

โดยเฉพาะเมื่อต้องใช้ `COUNT(column)` หรือ `AVG(column)` เพราะค่าที่หายไปจะไม่ถูกนำมาคิด

### 4) เลือกคอลัมน์ใน SELECT ให้สอดคล้องกับ GROUP BY

เมื่อใช้ `GROUP BY` ควรเลือกเฉพาะคอลัมน์ที่เป็นคีย์ของกลุ่ม หรือคอลัมน์ที่ผ่าน aggregate function เพื่อให้ query ถูกต้องและชัดเจน

### 5) พิจารณา index เมื่อข้อมูลเริ่มใหญ่

ถ้ามีการสรุปข้อมูลตาม `department`, `order_status`, หรือ `order_date` บ่อย ๆ การวาง index ที่เหมาะสมจะช่วย performance ได้มาก

---

## ข้อควรระวัง

- อย่าสับสนระหว่าง `WHERE` กับ `HAVING`
- อย่าลืมว่า `COUNT(column)` จะไม่นับ `NULL`
- ระวังการตีความค่าเฉลี่ยเมื่อข้อมูลบางส่วนหายไป
- อย่าใช้ `SELECT *` ร่วมกับ `GROUP BY` แบบไม่เข้าใจโครงสร้างข้อมูล
- ควรตรวจสอบว่ากลุ่มที่สรุปมีความหมายทางธุรกิจจริง

## สรุป

`Aggregate Functions` เป็นเครื่องมือสำคัญสำหรับการสรุปข้อมูลใน MySQL และเป็นพื้นฐานของงานรายงานและ dashboard ในระบบจริง ฟังก์ชันหลักอย่าง `COUNT()`, `SUM()`, `AVG()`, `MIN()`, และ `MAX()` ช่วยให้เราตอบคำถามทางธุรกิจได้อย่างกระชับและชัดเจน

เมื่อใช้ร่วมกับ `GROUP BY` และ `HAVING` คุณจะสามารถสรุปข้อมูลเป็นรายกลุ่ม กรองผลลัพธ์ที่มีความหมาย และต่อยอดไปสู่การทำ analytics หรือ reporting ที่ซับซ้อนขึ้นได้

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `GROUP BY and HAVING in MySQL`
- `MySQL JOIN for Real Projects`
- `Date Functions in MySQL`
- `Subqueries in MySQL`
- `Indexes and Query Performance`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน query เพื่อหาจำนวนคำสั่งซื้อทั้งหมด

### แบบฝึกหัด 2
เขียน query เพื่อหายอดขายรวมทั้งหมดจาก `total_amount`

### แบบฝึกหัด 3
เขียน query เพื่อหาค่าเฉลี่ยยอดสั่งซื้อแยกตาม `department`

### แบบฝึกหัด 4
เขียน query เพื่อแสดงเฉพาะ `department` ที่มีจำนวนคำสั่งซื้อมากกว่า 1

### แบบฝึกหัด 5
เขียน query เพื่อหายอดขายสูงสุดและต่ำสุดของ order ที่สถานะ `paid`

## เฉลยแบบย่อ

```sql
-- ข้อ 1
SELECT COUNT(*) AS total_orders
FROM orders;

-- ข้อ 2
SELECT SUM(total_amount) AS total_sales
FROM orders;

-- ข้อ 3
SELECT department, AVG(total_amount) AS average_order_amount
FROM orders
GROUP BY department;

-- ข้อ 4
SELECT department, COUNT(*) AS total_orders
FROM orders
GROUP BY department
HAVING COUNT(*) > 1;

-- ข้อ 5
SELECT
    MAX(total_amount) AS highest_paid_order,
    MIN(total_amount) AS lowest_paid_order
FROM orders
WHERE order_status = 'paid';
```
