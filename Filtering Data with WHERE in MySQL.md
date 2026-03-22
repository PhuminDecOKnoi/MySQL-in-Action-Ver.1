File Name: Filtering Data with WHERE in MySQL.md

# Filtering Data with WHERE in MySQL

## บทนำ

`WHERE` คือส่วนสำคัญของคำสั่ง SQL ที่ใช้สำหรับ “กรองข้อมูล” ให้เหลือเฉพาะแถวที่ตรงกับเงื่อนไขที่เราต้องการ ในงานจริง เราแทบไม่ดึงข้อมูลทั้งหมดจากตารางออกมาเสมอ แต่จะเลือกเฉพาะข้อมูลที่เกี่ยวข้อง เช่น พนักงานในแผนก IT, สินค้าที่มีสต๊อกน้อย, หรือคำสั่งซื้อที่ยังไม่ชำระเงิน

การใช้ `WHERE` ให้ถูกต้องช่วยให้ query แม่นยำ อ่านง่าย และมีประสิทธิภาพมากขึ้น หัวข้อนี้เหมาะสำหรับผู้เริ่มต้นและผู้ที่ต้องการวางพื้นฐานการเขียน SQL แบบใช้งานได้จริงในระบบปัจจุบัน

## สิ่งที่ผู้เรียนจะได้เรียน

- หน้าที่ของ `WHERE` และรูปแบบการใช้งานพื้นฐาน
- การกรองข้อมูลด้วยตัวดำเนินการเปรียบเทียบ
- การใช้ `AND`, `OR`, `NOT`
- การใช้ `IN`, `BETWEEN`, `LIKE`, `IS NULL`
- การจัดลำดับเงื่อนไขด้วยวงเล็บ
- แนวคิดการเขียน query ที่อ่านง่ายและเหมาะกับงานจริง
- ข้อควรระวังด้าน performance และ data accuracy

## ตารางตัวอย่างสำหรับบทเรียน

ตัวอย่างนี้จะใช้ตาราง `employees` เพื่อให้เห็นการกรองข้อมูลในหลายรูปแบบ

```sql
-- สร้างฐานข้อมูลตัวอย่าง
CREATE DATABASE company_db;

-- เลือกใช้งานฐานข้อมูล
USE company_db;

-- สร้างตารางพนักงาน
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    hire_date DATE NOT NULL,
    manager_id INT NULL
);

-- เพิ่มข้อมูลตัวอย่าง
INSERT INTO employees (
    first_name, last_name, department, job_title, salary, status, hire_date, manager_id
) VALUES
    ('Anan', 'Krit', 'HR', 'HR Officer', 35000.00, 'active', '2023-01-15', 1),
    ('Mali', 'Suda', 'IT', 'Backend Developer', 48000.00, 'active', '2022-07-01', 4),
    ('Narin', 'Chai', 'Finance', 'Accountant', 42000.00, 'inactive', '2021-11-20', 3),
    ('Pim', 'Rin', 'IT', 'Tech Lead', 62000.00, 'active', '2020-03-10', NULL),
    ('Korn', 'Dee', 'HR', 'Recruiter', 33000.00, 'active', '2024-02-05', 1),
    ('Jane', 'Moon', 'Sales', 'Sales Executive', 39000.00, 'probation', '2025-01-10', 6);
```

### สิ่งที่ควรเข้าใจ

- `status` ใช้บอกสถานะการทำงาน เช่น `active`, `inactive`, `probation`
- `manager_id` อาจเป็น `NULL` ถ้ายังไม่ได้ระบุผู้จัดการ
- ตารางนี้ช่วยให้ทดลองเงื่อนไขหลายรูปแบบได้ครบขึ้น

---

## หัวข้อย่อยที่ 1: โครงสร้างพื้นฐานของ WHERE

`WHERE` จะทำงานหลังจาก `FROM` เพื่อกรองแถวที่ตรงกับเงื่อนไขที่กำหนด

```sql
-- เลือกพนักงานทั้งหมดที่อยู่ในแผนก IT
SELECT id, first_name, last_name, department
FROM employees
WHERE department = 'IT';
```

### สิ่งที่ควรเข้าใจ

- `WHERE` ใช้คัดเลือกเฉพาะแถวที่ตรงเงื่อนไข
- ถ้าไม่มี `WHERE` ระบบจะดึงทุกแถวจากตาราง
- ควรเขียนเงื่อนไขให้ชัดเจนและตรงกับชนิดข้อมูล

---

## หัวข้อย่อยที่ 2: ตัวดำเนินการเปรียบเทียบพื้นฐาน

เราสามารถใช้ตัวดำเนินการเช่น `=`, `>`, `<`, `>=`, `<=`, `<>` เพื่อกรองข้อมูลตามค่าที่ต้องการ

```sql
-- เลือกพนักงานที่มีเงินเดือนมากกว่า 40000
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 40000;
```

```sql
-- เลือกพนักงานที่ไม่ได้อยู่แผนก HR
SELECT first_name, last_name, department
FROM employees
WHERE department <> 'HR';
```

### สิ่งที่ควรเข้าใจ

- `=` เท่ากับ
- `<>` ไม่เท่ากับ
- ตัวเลข วันที่ และข้อความ สามารถใช้เปรียบเทียบได้ แต่ต้องใช้ให้ตรงชนิดข้อมูล

---

## หัวข้อย่อยที่ 3: ใช้ AND เพื่อให้ครบทุกเงื่อนไข

`AND` ใช้เมื่อข้อมูลต้องตรง “ทุก” เงื่อนไขพร้อมกัน

```sql
-- เลือกพนักงานแผนก IT ที่สถานะ active
SELECT first_name, last_name, department, status
FROM employees
WHERE department = 'IT' AND status = 'active';
```

```sql
-- เลือกพนักงานที่เงินเดือนมากกว่า 40000 และเริ่มงานก่อนปี 2024
SELECT first_name, last_name, salary, hire_date
FROM employees
WHERE salary > 40000 AND hire_date < '2024-01-01';
```

### สิ่งที่ควรเข้าใจ

- `AND` จะคืนผลลัพธ์เมื่อทุกเงื่อนไขเป็นจริง
- เหมาะกับกรณีที่ต้องการคัดกรองแบบเฉพาะเจาะจงมากขึ้น

---

## หัวข้อย่อยที่ 4: ใช้ OR เพื่อยอมรับได้หลายเงื่อนไข

`OR` ใช้เมื่อข้อมูลตรงเพียง “อย่างใดอย่างหนึ่ง” ก็เพียงพอ

```sql
-- เลือกพนักงานที่อยู่แผนก HR หรือ Finance
SELECT first_name, last_name, department
FROM employees
WHERE department = 'HR' OR department = 'Finance';
```

```sql
-- เลือกพนักงานที่มีสถานะ inactive หรือ probation
SELECT first_name, last_name, status
FROM employees
WHERE status = 'inactive' OR status = 'probation';
```

### สิ่งที่ควรเข้าใจ

- `OR` ช่วยให้ query รองรับหลายเงื่อนไขทางเลือก
- ถ้า query ซับซ้อน ควรใช้วงเล็บเพื่อให้ logic ชัดเจน

---

## หัวข้อย่อยที่ 5: ใช้ NOT เพื่อกลับเงื่อนไข

`NOT` ใช้สำหรับ “ปฏิเสธ” เงื่อนไขที่กำหนด

```sql
-- เลือกพนักงานที่ไม่ใช่สถานะ inactive
SELECT first_name, last_name, status
FROM employees
WHERE NOT status = 'inactive';
```

```sql
-- เลือกพนักงานที่ไม่ได้อยู่ในแผนก Sales
SELECT first_name, last_name, department
FROM employees
WHERE NOT department = 'Sales';
```

### สิ่งที่ควรเข้าใจ

- `NOT` ใช้ได้ แต่บางครั้งการเขียนตรง ๆ เช่น `<>` อาจอ่านง่ายกว่า
- ในงานจริงควรเลือก style ที่ทีมอ่านแล้วเข้าใจตรงกัน

---

## หัวข้อย่อยที่ 6: ใช้ IN เมื่อต้องตรวจหลายค่า

ถ้ามีหลายค่าที่ต้องเปรียบเทียบในคอลัมน์เดียว `IN` จะอ่านง่ายกว่าเขียน `OR` ยาว ๆ

```sql
-- เลือกพนักงานที่อยู่ในแผนก HR, IT หรือ Finance
SELECT first_name, last_name, department
FROM employees
WHERE department IN ('HR', 'IT', 'Finance');
```

```sql
-- เลือกพนักงานที่มีสถานะ active หรือ probation
SELECT first_name, last_name, status
FROM employees
WHERE status IN ('active', 'probation');
```

### สิ่งที่ควรเข้าใจ

- `IN` เหมาะกับการเทียบหลายค่าที่เป็นไปได้ในคอลัมน์เดียวกัน
- ช่วยให้ query สั้นลงและอ่านง่ายขึ้น

---

## หัวข้อย่อยที่ 7: ใช้ BETWEEN สำหรับช่วงข้อมูล

`BETWEEN` เหมาะกับการกรองค่าที่อยู่ในช่วง เช่น เงินเดือน วันที่ หรือคะแนน

```sql
-- เลือกพนักงานที่มีเงินเดือนอยู่ระหว่าง 35000 ถึง 50000
SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 35000 AND 50000;
```

```sql
-- เลือกพนักงานที่เริ่มงานในปี 2023 ถึง 2024
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2023-01-01' AND '2024-12-31';
```

### สิ่งที่ควรเข้าใจ

- `BETWEEN` รวมค่าต้นทางและปลายทางด้วย
- ใช้ได้ดีกับตัวเลขและวันที่
- ในบางระบบ งานจริงอาจใช้รูปแบบ `>=` และ `<` เพื่อควบคุมขอบเขตเวลาให้ชัดขึ้น

---

## หัวข้อย่อยที่ 8: ใช้ LIKE สำหรับค้นหาข้อความบางส่วน

`LIKE` ใช้กรองข้อความที่ตรงตามรูปแบบ โดยมักใช้ร่วมกับ wildcard เช่น `%`

```sql
-- เลือกพนักงานที่ชื่อขึ้นต้นด้วยตัว J
SELECT first_name, last_name
FROM employees
WHERE first_name LIKE 'J%';
```

```sql
-- เลือกตำแหน่งงานที่มีคำว่า Developer อยู่ในชื่อ
SELECT first_name, last_name, job_title
FROM employees
WHERE job_title LIKE '%Developer%';
```

### สิ่งที่ควรเข้าใจ

- `%` หมายถึงอักขระใด ๆ กี่ตัวก็ได้
- `J%` คือขึ้นต้นด้วย J
- `%Developer%` คือมีคำว่า Developer อยู่ตรงไหนก็ได้
- การใช้ `LIKE` บางรูปแบบอาจกระทบ performance เมื่อข้อมูลมีจำนวนมาก

---

## หัวข้อย่อยที่ 9: ใช้ IS NULL และ IS NOT NULL

`NULL` หมายถึงไม่มีค่า ดังนั้นห้ามใช้ `= NULL` หรือ `<> NULL` แต่ต้องใช้ `IS NULL` และ `IS NOT NULL`

```sql
-- เลือกพนักงานที่ยังไม่มี manager_id
SELECT first_name, last_name, manager_id
FROM employees
WHERE manager_id IS NULL;
```

```sql
-- เลือกพนักงานที่มี manager_id แล้ว
SELECT first_name, last_name, manager_id
FROM employees
WHERE manager_id IS NOT NULL;
```

### สิ่งที่ควรเข้าใจ

- `NULL` ไม่ใช่ค่าว่างธรรมดา แต่หมายถึง “ไม่มีข้อมูล”
- การตรวจ `NULL` ต้องใช้ syntax เฉพาะ

---

## หัวข้อย่อยที่ 10: ใช้วงเล็บเพื่อควบคุมลำดับเงื่อนไข

เมื่อมีทั้ง `AND` และ `OR` ใน query เดียว ควรใช้วงเล็บเพื่อให้ตรรกะชัดเจนและลดความผิดพลาด

```sql
-- เลือกพนักงานที่อยู่แผนก HR หรือ IT
-- และต้องมีสถานะ active เท่านั้น
SELECT first_name, last_name, department, status
FROM employees
WHERE (department = 'HR' OR department = 'IT')
  AND status = 'active';
```

### สิ่งที่ควรเข้าใจ

- วงเล็บช่วยบอกลำดับการประเมินเงื่อนไข
- ทำให้ query อ่านง่ายขึ้น โดยเฉพาะเมื่อต้องดูแลต่อในทีม

---

## ตัวอย่างการใช้งานจริงแบบรวมหลายเงื่อนไข

ตัวอย่างนี้สะท้อนรูปแบบ query ที่พบได้บ่อยในระบบงานจริง

```sql
-- ดึงพนักงาน active ในแผนก IT หรือ HR
-- ที่มีเงินเดือนตั้งแต่ 35000 ขึ้นไป
-- และเรียงจากเงินเดือนมากไปน้อย
SELECT first_name, last_name, department, salary, status
FROM employees
WHERE status = 'active'
  AND department IN ('IT', 'HR')
  AND salary >= 35000
ORDER BY salary DESC;
```

### สิ่งที่ควรเข้าใจ

- ใช้ `IN` แทน `OR` เพื่อให้อ่านง่าย
- ใช้ `AND` เพื่อบังคับทุกเงื่อนไขที่ต้องเป็นจริง
- ต่อด้วย `ORDER BY` เพื่อให้ผลลัพธ์พร้อมใช้งานมากขึ้น

---

## Best Practices สำหรับงานจริง

### 1) ระบุเงื่อนไขให้ชัดเจน

```sql
-- ดี: ระบุเงื่อนไขตรงประเด็น
SELECT id, first_name, last_name
FROM employees
WHERE status = 'active';
```

ควรหลีกเลี่ยง query ที่กว้างเกินไป เพราะทำให้ได้ข้อมูลมากเกินจำเป็น

### 2) ใช้ IN แทน OR เมื่อเหมาะสม

```sql
-- อ่านง่ายกว่าเมื่อมีหลายค่า
SELECT first_name, department
FROM employees
WHERE department IN ('HR', 'IT', 'Finance');
```

### 3) ระวัง LIKE ที่ขึ้นต้นด้วย %

```sql
-- ค้นหาได้ แต่บางกรณีอาจใช้ index ได้ไม่เต็มประสิทธิภาพ
SELECT job_title
FROM employees
WHERE job_title LIKE '%Developer%';
```

### 4) ใช้ชนิดข้อมูลให้ตรง

การเปรียบเทียบวันที่ควรใช้รูปแบบวันที่ และการเปรียบเทียบตัวเลขควรใช้ค่าตัวเลขโดยตรง เพื่อให้ผลลัพธ์แม่นยำและลดความสับสน

### 5) ใช้ prepared statements ใน application

แม้ตัวอย่างในบทเรียนจะเขียน SQL ตรง ๆ เพื่อการเรียนรู้ แต่ในการพัฒนาแอปพลิเคชันจริง ควรใช้ parameterized queries หรือ prepared statements เพื่อลดความเสี่ยงจาก SQL Injection

---

## ข้อควรระวัง

- ห้ามใช้ `= NULL` ในการตรวจค่า `NULL`
- อย่าลืมใส่วงเล็บเมื่อมีทั้ง `AND` และ `OR`
- อย่าใช้ `LIKE` มากเกินจำเป็น ถ้าค้นหาด้วยค่าตรงได้จะดีกว่า
- ควรดึงเฉพาะคอลัมน์ที่จำเป็น ไม่ควรใช้ `SELECT *` เป็นนิสัย
- ควรทดสอบ query กับข้อมูลจริงหรือข้อมูลจำลองที่ใกล้เคียงงานจริง

## สรุป

`WHERE` เป็นหัวใจของการคัดกรองข้อมูลใน MySQL การเข้าใจวิธีใช้เงื่อนไขพื้นฐาน รวมถึง `AND`, `OR`, `IN`, `BETWEEN`, `LIKE`, และ `IS NULL` จะช่วยให้คุณเขียน query ได้แม่นยำมากขึ้น และพร้อมต่อยอดไปยังการทำ report, dashboard, API, หรือระบบธุรกิจจริง

เมื่อเข้าใจหัวข้อนี้แล้ว หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `ORDER BY and LIMIT in MySQL`
- `GROUP BY Basics`
- `JOIN in MySQL`
- `Indexes and Query Performance`
- `Prepared Statements with PHP and MySQL`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน query เพื่อแสดงพนักงานที่อยู่แผนก `IT`

### แบบฝึกหัด 2
เขียน query เพื่อแสดงพนักงานที่เงินเดือนมากกว่า `45000`

### แบบฝึกหัด 3
เขียน query เพื่อแสดงพนักงานที่มีสถานะ `active` หรือ `probation`

### แบบฝึกหัด 4
เขียน query เพื่อแสดงพนักงานที่เริ่มงานในช่วงปี `2023` ถึง `2024`

### แบบฝึกหัด 5
เขียน query เพื่อแสดงพนักงานที่ยังไม่มี `manager_id`

## เฉลยแบบย่อ

```sql
-- ข้อ 1
SELECT first_name, last_name, department
FROM employees
WHERE department = 'IT';

-- ข้อ 2
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 45000;

-- ข้อ 3
SELECT first_name, last_name, status
FROM employees
WHERE status IN ('active', 'probation');

-- ข้อ 4
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2023-01-01' AND '2024-12-31';

-- ข้อ 5
SELECT first_name, last_name, manager_id
FROM employees
WHERE manager_id IS NULL;
```
