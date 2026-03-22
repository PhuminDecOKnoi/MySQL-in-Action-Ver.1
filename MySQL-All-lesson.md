File Name: readmeX.md

## บทเรียน MySQL รวม

เอกสารนี้เป็นไฟล์รวมบทเรียน MySQL ที่ได้จัดทำไว้ก่อนหน้าในรูปแบบ Markdown เพื่อให้นำไปใช้งานต่อบน GitHub หรือใช้เป็น lesson note เดียวได้สะดวกขึ้น

## สารบัญ

1. [MySQL SELECT Basics](#mysql-select-basics)
2. [Filtering Data with WHERE in MySQL](#filtering-data-with-where-in-mysql)
3. [Sorting and Limiting Results in MySQL](#sorting-and-limiting-results-in-mysql)
4. [MySQL JOIN for Real Projects](#mysql-join-for-real-projects)
5. [Aggregate Functions in MySQL](#aggregate-functions-in-mysql)
6. [GROUP BY and HAVING in MySQL](#group-by-and-having-in-mysql)
7. [Database Design with MySQL](#database-design-with-mysql)
8. [Primary Key and Foreign Key in MySQL](#primary-key-and-foreign-key-in-mysql)
9. [Indexing in MySQL](#indexing-in-mysql)
10. [Transactions in MySQL](#transactions-in-mysql)
11. [MySQL Views and Stored Procedures](#mysql-views-and-stored-procedures)
12. [MySQL Query Optimization Basics](#mysql-query-optimization-basics)

---


---

## 1. MySQL SELECT Basics

> Source File: `MySQL SELECT Basics.md`


File Name: MySQL SELECT Basics.md

# MySQL SELECT Basics

## บทนำ

`SELECT` คือคำสั่งพื้นฐานที่สุดในการดึงข้อมูลจากฐานข้อมูล MySQL และเป็นจุดเริ่มต้นของงานด้าน data querying เกือบทั้งหมด ไม่ว่าจะเป็นการแสดงรายการลูกค้า ดูข้อมูลสินค้า สรุปยอดขาย หรือเตรียมข้อมูลไปใช้ในระบบรายงาน

หัวข้อนี้เหมาะสำหรับผู้เริ่มต้นที่ต้องการเข้าใจการอ่านข้อมูลจากตารางอย่างถูกต้อง และเหมาะกับผู้ที่เริ่มพัฒนาระบบด้วยฐานข้อมูลจริง เพราะการเขียน `SELECT` ที่ดีจะช่วยให้ query อ่านง่าย ดูแลต่อได้ และลดความผิดพลาดในการใช้งานข้อมูล

## สิ่งที่ผู้เรียนจะได้เรียน

- ความหมายและหน้าที่ของคำสั่ง `SELECT`
- การดึงข้อมูลทุกคอลัมน์และบางคอลัมน์
- การใช้ `WHERE` เพื่อกรองข้อมูล
- การเรียงลำดับด้วย `ORDER BY`
- การจำกัดจำนวนผลลัพธ์ด้วย `LIMIT`
- การตั้งชื่อคอลัมน์ด้วย `AS`
- แนวคิดพื้นฐานที่ควรใช้จริงในการเขียน query ให้ชัดเจนและปลอดภัย

## โครงสร้างพื้นฐานของ SELECT

คำสั่ง `SELECT` ใช้สำหรับ “อ่านข้อมูล” จากตาราง โดยรูปแบบพื้นฐานมีลักษณะดังนี้

```sql
-- เลือกคอลัมน์ที่ต้องการจากตาราง
SELECT column_name
FROM table_name;
```

ในงานจริง เรามักใช้ร่วมกับเงื่อนไข การเรียงลำดับ และการจำกัดจำนวนข้อมูล เพื่อให้ได้ผลลัพธ์ที่ตรงความต้องการมากขึ้น

---

## เตรียมตารางตัวอย่าง

เพื่อให้เห็นภาพชัดเจน จะใช้ตาราง `employees` เป็นตัวอย่าง

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
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL
);

-- เพิ่มข้อมูลตัวอย่าง
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES
    ('Anan', 'Krit', 'HR', 35000.00, '2023-01-15'),
    ('Mali', 'Suda', 'IT', 48000.00, '2022-07-01'),
    ('Narin', 'Chai', 'Finance', 42000.00, '2021-11-20'),
    ('Pim', 'Rin', 'IT', 52000.00, '2020-03-10'),
    ('Korn', 'Dee', 'HR', 33000.00, '2024-02-05');
```

### สิ่งที่ควรเข้าใจ

- `id` เป็น `PRIMARY KEY` ใช้ระบุแต่ละแถวไม่ให้ซ้ำ
- `AUTO_INCREMENT` ช่วยให้ MySQL สร้างเลขลำดับให้อัตโนมัติ
- ตารางนี้เหมาะสำหรับฝึก `SELECT` เบื้องต้นก่อนต่อยอดไปสู่ `JOIN`, `GROUP BY`, และ `INDEX`

---

## หัวข้อย่อยที่ 1: ดึงข้อมูลทุกคอลัมน์ด้วย `SELECT *`

การใช้ `SELECT *` คือการดึงทุกคอลัมน์จากตาราง เหมาะกับการทดลองหรือสำรวจข้อมูลเบื้องต้น แต่ในงานจริงไม่ควรใช้พร่ำเพรื่อ เพราะอาจดึงข้อมูลเกินความจำเป็น ทำให้ query ช้าลงและอ่านยากขึ้น

```sql
-- ดึงข้อมูลทุกคอลัมน์จากตาราง employees
SELECT *
FROM employees;
```

### สิ่งที่ควรเข้าใจ

- `*` หมายถึงทุกคอลัมน์
- ใช้ได้สะดวกตอนเริ่มต้นหรือทดสอบ
- ในระบบจริงควรเลือกเฉพาะคอลัมน์ที่ต้องใช้ เพื่อให้ query ชัดเจนและมีประสิทธิภาพมากกว่า

---

## หัวข้อย่อยที่ 2: ดึงเฉพาะคอลัมน์ที่ต้องการ

แนวทางที่ professional กว่าคือเลือกเฉพาะคอลัมน์ที่ต้องใช้งานจริง เพราะช่วยให้ผลลัพธ์อ่านง่าย ลดข้อมูลที่ไม่จำเป็น และเหมาะกับงาน production มากกว่า

```sql
-- ดึงเฉพาะชื่อ นามสกุล และแผนก
SELECT first_name, last_name, department
FROM employees;
```

### สิ่งที่ควรเข้าใจ

- เราไม่จำเป็นต้องดึงทุกคอลัมน์เสมอไป
- การระบุชื่อคอลัมน์ชัดเจนช่วยให้ code maintain ง่าย
- เป็นแนวปฏิบัติที่ดีด้าน query performance และ data minimization

---

## หัวข้อย่อยที่ 3: กรองข้อมูลด้วย `WHERE`

`WHERE` ใช้กำหนดเงื่อนไขเพื่อเลือกเฉพาะแถวที่ต้องการ เป็นหนึ่งในส่วนที่สำคัญมาก เพราะงานจริงมักไม่ต้องการข้อมูลทั้งหมดในตาราง

```sql
-- เลือกเฉพาะพนักงานที่อยู่แผนก IT
SELECT first_name, last_name, department
FROM employees
WHERE department = 'IT';
```

```sql
-- เลือกเฉพาะพนักงานที่มีเงินเดือนมากกว่า 40000
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 40000;
```

### สิ่งที่ควรเข้าใจ

- `=` ใช้เปรียบเทียบค่าเท่ากัน
- `>` ใช้เปรียบเทียบค่ามากกว่า
- `WHERE` ช่วยลดข้อมูลให้เหลือเฉพาะสิ่งที่ต้องการจริง

---

## หัวข้อย่อยที่ 4: ใช้เงื่อนไขหลายตัวด้วย `AND` และ `OR`

ในสถานการณ์จริง เรามักต้องกรองข้อมูลหลายเงื่อนไขพร้อมกัน เช่น ดูพนักงานในแผนกหนึ่งและมีเงินเดือนถึงเกณฑ์ที่กำหนด

```sql
-- เลือกพนักงานแผนก IT ที่มีเงินเดือนมากกว่า 50000
SELECT first_name, last_name, department, salary
FROM employees
WHERE department = 'IT' AND salary > 50000;
```

```sql
-- เลือกพนักงานที่อยู่ในแผนก HR หรือ Finance
SELECT first_name, last_name, department
FROM employees
WHERE department = 'HR' OR department = 'Finance';
```

### สิ่งที่ควรเข้าใจ

- `AND` หมายถึงต้องเป็นจริงทุกเงื่อนไข
- `OR` หมายถึงเป็นจริงอย่างน้อยหนึ่งเงื่อนไข
- ควรระวัง logic ของเงื่อนไขให้ชัด โดยเฉพาะเมื่อ query ซับซ้อนขึ้น

---

## หัวข้อย่อยที่ 5: เรียงลำดับข้อมูลด้วย `ORDER BY`

เมื่อดึงข้อมูลออกมาแล้ว มักต้องจัดลำดับให้อ่านง่าย เช่น เรียงตามเงินเดือน จากน้อยไปมาก หรือจากมากไปน้อย

```sql
-- เรียงพนักงานตามเงินเดือนจากน้อยไปมาก
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary ASC;
```

```sql
-- เรียงพนักงานตามวันที่เริ่มงานจากใหม่ไปเก่า
SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date DESC;
```

### สิ่งที่ควรเข้าใจ

- `ASC` คือเรียงจากน้อยไปมาก หรือ A → Z
- `DESC` คือเรียงจากมากไปน้อย หรือ Z → A
- ถ้าไม่ระบุ MySQL จะถือเป็น `ASC` โดยทั่วไป

---

## หัวข้อย่อยที่ 6: จำกัดจำนวนแถวด้วย `LIMIT`

`LIMIT` ใช้กำหนดจำนวนผลลัพธ์ที่ต้องการแสดง เหมาะกับการดูข้อมูลบางส่วน การทำ dashboard หรือการแบ่งหน้าเบื้องต้น

```sql
-- แสดงข้อมูลพนักงาน 3 แถวแรก
SELECT *
FROM employees
LIMIT 3;
```

```sql
-- แสดงพนักงานที่เงินเดือนสูงสุด 2 คนแรก
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 2;
```

### สิ่งที่ควรเข้าใจ

- `LIMIT` ช่วยลดจำนวนข้อมูลที่แสดง
- มักใช้คู่กับ `ORDER BY` เพื่อให้ผลลัพธ์มีความหมายมากขึ้น
- ในระบบจริงแนวคิดนี้ต่อยอดไปสู่ pagination ได้

---

## หัวข้อย่อยที่ 7: ตั้งชื่อคอลัมน์ใหม่ด้วย `AS`

บางครั้งชื่อคอลัมน์ในฐานข้อมูลอาจยาวหรือไม่เหมาะกับการแสดงผล เราสามารถใช้ `AS` เพื่อตั้งชื่อใหม่ให้อ่านง่ายขึ้น

```sql
-- ตั้งชื่อคอลัมน์ใหม่เพื่อให้อ่านง่ายขึ้น
SELECT
    first_name AS firstName,
    last_name AS lastName,
    salary AS monthlySalary
FROM employees;
```

### สิ่งที่ควรเข้าใจ

- `AS` ใช้สร้าง alias หรือชื่อชั่วคราวของคอลัมน์
- มีประโยชน์มากเมื่อต้องส่งข้อมูลให้ application หรือ report
- ช่วยให้ผลลัพธ์สื่อความหมายชัดเจนขึ้น

---

## หัวข้อย่อยที่ 8: เลือกข้อมูลแบบไม่ซ้ำด้วย `DISTINCT`

ถ้าต้องการดูค่าที่ไม่ซ้ำกัน เช่น รายชื่อแผนกทั้งหมดในบริษัท สามารถใช้ `DISTINCT` ได้

```sql
-- แสดงรายชื่อแผนกแบบไม่ซ้ำ
SELECT DISTINCT department
FROM employees;
```

### สิ่งที่ควรเข้าใจ

- `DISTINCT` ช่วยตัดค่าที่ซ้ำกันออก
- เหมาะกับการดูหมวดหมู่หรือรายการอ้างอิง
- ควรใช้เมื่อมีเหตุผลชัดเจน เพราะมีผลต่อการประมวลผลของ query

---

## ตัวอย่างการใช้งานจริงแบบรวมหลายคำสั่ง

ตัวอย่างนี้เป็น query ที่ใช้งานได้จริงมากขึ้น โดยผสม `SELECT`, `WHERE`, `ORDER BY`, และ `LIMIT` เข้าด้วยกัน

```sql
-- ดึงพนักงานในแผนก IT
-- เรียงจากเงินเดือนมากไปน้อย
-- และแสดงเพียง 2 คนแรก
SELECT first_name, last_name, department, salary
FROM employees
WHERE department = 'IT'
ORDER BY salary DESC
LIMIT 2;
```

### สิ่งที่ควรเข้าใจ

- Query นี้สะท้อนการใช้งานในระบบจริงได้ดี
- เริ่มจากเลือกคอลัมน์ที่ต้องใช้
- กรองข้อมูลให้ตรงเงื่อนไข
- เรียงผลลัพธ์ให้เหมาะกับการอ่าน
- จำกัดจำนวนเพื่อแสดงเฉพาะข้อมูลสำคัญ

---

## Best Practices สำหรับงานจริง

### 1) หลีกเลี่ยง `SELECT *` ใน production

```sql
-- ไม่แนะนำใน production หากไม่จำเป็น
SELECT *
FROM employees;
```

```sql
-- แนะนำ: ระบุเฉพาะคอลัมน์ที่ใช้งานจริง
SELECT id, first_name, last_name, department
FROM employees;
```

เหตุผลคือช่วยให้ query ชัดเจนขึ้น ลดการดึงข้อมูลเกินจำเป็น และลดความเสี่ยงหากโครงสร้างตารางเปลี่ยนในอนาคต

### 2) ใช้ชื่อคอลัมน์ให้ชัดเจน

การตั้งชื่อคอลัมน์และ alias ที่สื่อความหมาย ช่วยให้ทั้ง developer และ analyst อ่าน query ได้ง่ายขึ้น

### 3) กรองข้อมูลตั้งแต่ต้น

การใช้ `WHERE` อย่างเหมาะสมช่วยลดปริมาณข้อมูลที่ต้องประมวลผล และทำให้ผลลัพธ์ตรงกับธุรกิจมากขึ้น

### 4) คิดเรื่อง performance ตั้งแต่ query เล็ก ๆ

แม้ `SELECT` เบื้องต้นจะดูง่าย แต่เมื่อข้อมูลมีจำนวนมาก ควรเริ่มตระหนักถึงเรื่อง indexing, filtering, และการดึงเฉพาะข้อมูลที่จำเป็น

---

## ข้อควรระวัง

- อย่าใช้ `SELECT *` เป็นนิสัยในระบบจริง
- อย่าลืม `WHERE` เมื่อต้องการกรองข้อมูลเฉพาะส่วน
- อย่าเรียงข้อมูลโดยไม่จำเป็น เพราะอาจเพิ่มภาระให้ฐานข้อมูล
- ควรตรวจสอบชนิดข้อมูลให้ตรงกับเงื่อนไขที่ใช้เปรียบเทียบ
- ใน application จริง ควรใช้ parameterized query จากฝั่งภาษาโปรแกรม เพื่อลดความเสี่ยงด้าน SQL Injection

---

## สรุป

`SELECT` คือพื้นฐานของการอ่านข้อมูลใน MySQL และเป็นทักษะที่ต้องใช้แทบทุกวันในการทำงานกับฐานข้อมูล การเข้าใจการเลือกคอลัมน์ การกรองข้อมูล การเรียงลำดับ และการจำกัดผลลัพธ์ จะช่วยให้คุณเขียน query ได้อย่างมั่นใจและใช้งานได้จริงมากขึ้น

เมื่อเข้าใจ `SELECT Basics` แล้ว หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `WHERE` แบบละเอียด
- `ORDER BY` และ `LIMIT`
- `GROUP BY`
- `JOIN`
- `Index Basics`
- `Query Performance Basics`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน query เพื่อแสดง `first_name`, `last_name` และ `salary` ของพนักงานทุกคน

### แบบฝึกหัด 2
เขียน query เพื่อแสดงเฉพาะพนักงานในแผนก `HR`

### แบบฝึกหัด 3
เขียน query เพื่อแสดงพนักงานที่มีเงินเดือนมากกว่า `40000`

### แบบฝึกหัด 4
เขียน query เพื่อเรียงพนักงานตาม `hire_date` จากใหม่ไปเก่า

### แบบฝึกหัด 5
เขียน query เพื่อแสดงชื่อแผนกแบบไม่ซ้ำกัน

## เฉลยแบบย่อ

```sql
-- ข้อ 1
SELECT first_name, last_name, salary
FROM employees;

-- ข้อ 2
SELECT *
FROM employees
WHERE department = 'HR';

-- ข้อ 3
SELECT *
FROM employees
WHERE salary > 40000;

-- ข้อ 4
SELECT *
FROM employees
ORDER BY hire_date DESC;

-- ข้อ 5
SELECT DISTINCT department
FROM employees;
```



---

## 2. Filtering Data with WHERE in MySQL

> Source File: `Filtering Data with WHERE in MySQL.md`


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



---

## 3. Sorting and Limiting Results in MySQL

> Source File: `Sorting and Limiting Results in MySQL.md`


File Name: Sorting and Limiting Results in MySQL.md

# Sorting and Limiting Results in MySQL

## บทนำ

การดึงข้อมูลจากฐานข้อมูลไม่ได้จบแค่การ `SELECT` ข้อมูลออกมาเท่านั้น แต่ในงานจริงเรามักต้อง “จัดลำดับ” และ “จำกัดจำนวน” ของผลลัพธ์ด้วย เพื่อให้ข้อมูลอ่านง่าย ตรงความต้องการ และพร้อมใช้งานต่อได้ทันที เช่น แสดงสินค้าราคาสูงสุด 10 รายการ, แสดงพนักงานที่เข้าทำงานล่าสุด, หรือดึงรายการคำสั่งซื้อล่าสุดสำหรับหน้า dashboard

ใน MySQL เราใช้ `ORDER BY` สำหรับการเรียงลำดับ และใช้ `LIMIT` สำหรับการจำกัดจำนวนแถวที่ต้องการแสดง หัวข้อนี้เหมาะสำหรับผู้เริ่มต้นที่ต้องการใช้งาน query ได้อย่างเป็นมืออาชีพมากขึ้น และเหมาะกับผู้ที่เริ่มทำงานกับข้อมูลจริงในระบบธุรกิจ

## สิ่งที่ผู้เรียนจะได้เรียน

- การเรียงข้อมูลด้วย `ORDER BY`
- ความแตกต่างระหว่าง `ASC` และ `DESC`
- การเรียงหลายคอลัมน์ใน query เดียว
- การจำกัดผลลัพธ์ด้วย `LIMIT`
- การใช้ `LIMIT` ร่วมกับ `OFFSET` สำหรับการแบ่งหน้าเบื้องต้น
- การใช้ `ORDER BY` และ `LIMIT` ร่วมกันในงานจริง
- ข้อควรระวังด้านความถูกต้องและ performance

## ตารางตัวอย่างสำหรับบทเรียน

ตัวอย่างนี้จะใช้ตาราง `products` เพื่อให้เห็นภาพของการเรียงข้อมูลและการจำกัดผลลัพธ์ได้ชัดเจน

```sql
-- สร้างฐานข้อมูลตัวอย่าง
CREATE DATABASE shop_db;

-- เลือกใช้งานฐานข้อมูล
USE shop_db;

-- สร้างตารางสินค้า
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at DATETIME NOT NULL
);

-- เพิ่มข้อมูลตัวอย่าง
INSERT INTO products (product_name, category, price, stock, created_at)
VALUES
    ('Mechanical Keyboard', 'Accessories', 2490.00, 15, '2025-01-10 09:00:00'),
    ('Wireless Mouse', 'Accessories', 890.00, 42, '2025-01-12 10:30:00'),
    ('27-inch Monitor', 'Display', 6990.00, 8, '2025-01-08 14:15:00'),
    ('USB-C Hub', 'Accessories', 1290.00, 25, '2025-01-15 11:00:00'),
    ('Laptop Stand', 'Office', 1590.00, 18, '2025-01-05 08:45:00'),
    ('Webcam HD', 'Camera', 2190.00, 10, '2025-01-14 16:20:00');
```

### สิ่งที่ควรเข้าใจ

- `price` ใช้สำหรับฝึกเรียงลำดับตัวเลข
- `created_at` ใช้สำหรับฝึกเรียงข้อมูลตามวันและเวลา
- `stock` ใช้สำหรับดูตัวอย่างการจัดลำดับข้อมูลเพื่อการบริหารสินค้า

---

## หัวข้อย่อยที่ 1: เรียงข้อมูลด้วย ORDER BY

`ORDER BY` ใช้สำหรับกำหนดลำดับของผลลัพธ์ที่ได้จาก query ถ้าไม่ใส่ `ORDER BY` MySQL อาจคืนข้อมูลตามลำดับที่ไม่ควรนำไปคาดหวังในการใช้งานจริง

```sql
-- เรียงสินค้าตามราคาจากน้อยไปมาก
SELECT product_name, price
FROM products
ORDER BY price;
```

### สิ่งที่ควรเข้าใจ

- `ORDER BY` ใช้กำหนดลำดับของแถวในผลลัพธ์
- ถ้าไม่ระบุทิศทาง MySQL จะถือเป็น `ASC` โดยทั่วไป
- ในงานจริงไม่ควรคาดหวังลำดับข้อมูลถ้าไม่ได้ระบุ `ORDER BY` อย่างชัดเจน

---

## หัวข้อย่อยที่ 2: ใช้ ASC และ DESC

เราสามารถกำหนดทิศทางการเรียงลำดับได้ 2 แบบ คือ `ASC` และ `DESC`

```sql
-- เรียงราคาจากน้อยไปมาก
SELECT product_name, price
FROM products
ORDER BY price ASC;
```

```sql
-- เรียงราคาจากมากไปน้อย
SELECT product_name, price
FROM products
ORDER BY price DESC;
```

### สิ่งที่ควรเข้าใจ

- `ASC` คือเรียงจากน้อยไปมาก หรือ A → Z
- `DESC` คือเรียงจากมากไปน้อย หรือ Z → A
- การเลือกทิศทางขึ้นอยู่กับจุดประสงค์ของงาน เช่น ดูสินค้าราคาแพงสุด หรือดูล่าสุดก่อน

---

## หัวข้อย่อยที่ 3: เรียงข้อมูลตามข้อความ ตัวเลข และวันที่

`ORDER BY` ใช้ได้กับหลายชนิดข้อมูล ไม่ว่าจะเป็นข้อความ ตัวเลข หรือวันเวลา

```sql
-- เรียงตามชื่อสินค้าแบบ A ถึง Z
SELECT product_name, category
FROM products
ORDER BY product_name ASC;
```

```sql
-- เรียงตามจำนวน stock จากมากไปน้อย
SELECT product_name, stock
FROM products
ORDER BY stock DESC;
```

```sql
-- เรียงตามวันที่สร้างจากใหม่ไปเก่า
SELECT product_name, created_at
FROM products
ORDER BY created_at DESC;
```

### สิ่งที่ควรเข้าใจ

- ข้อความจะเรียงตามลำดับตัวอักษร
- ตัวเลขจะเรียงตามค่าจริงของตัวเลข
- วันที่และเวลาเหมาะมากกับการแสดง “ล่าสุด” หรือ “เก่าสุด”

---

## หัวข้อย่อยที่ 4: เรียงหลายคอลัมน์ใน query เดียว

ในงานจริง ข้อมูลอาจมีค่าซ้ำกันในคอลัมน์แรกที่ใช้เรียง จึงต้องมีคอลัมน์ถัดไปช่วยจัดลำดับต่อ

```sql
-- เรียงตาม category ก่อน
-- ถ้าหมวดหมู่ซ้ำกัน ให้เรียงตามราคาแพงไปถูก
SELECT product_name, category, price
FROM products
ORDER BY category ASC, price DESC;
```

### สิ่งที่ควรเข้าใจ

- MySQL จะเรียงตามคอลัมน์แรกก่อน
- ถ้าค่าซ้ำกัน จึงใช้คอลัมน์ถัดไปเป็นตัวตัดสิน
- เทคนิคนี้มีประโยชน์มากในรายงานและหน้ารายการข้อมูล

---

## หัวข้อย่อยที่ 5: จำกัดจำนวนผลลัพธ์ด้วย LIMIT

`LIMIT` ใช้กำหนดจำนวนแถวสูงสุดที่ต้องการให้แสดง เหมาะกับการดึงข้อมูลเฉพาะส่วน เช่น แสดง 5 รายการล่าสุด หรือ 10 รายการขายดี

```sql
-- แสดงสินค้า 3 แถวแรก
SELECT product_name, price
FROM products
LIMIT 3;
```

### สิ่งที่ควรเข้าใจ

- `LIMIT 3` หมายถึงแสดงไม่เกิน 3 แถว
- ถ้าไม่ใช้ `ORDER BY` ร่วมด้วย ผลลัพธ์อาจไม่ใช่ 3 รายการที่ “ต้องการจริง” ในเชิงธุรกิจ

---

## หัวข้อย่อยที่ 6: ใช้ ORDER BY ร่วมกับ LIMIT

นี่คือรูปแบบที่ใช้งานจริงบ่อยมาก เพราะช่วยให้เราเลือก “Top N” หรือ “Latest N” ได้อย่างชัดเจน

```sql
-- แสดงสินค้าแพงที่สุด 3 รายการ
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 3;
```

```sql
-- แสดงสินค้าที่ถูกสร้างล่าสุด 2 รายการ
SELECT product_name, created_at
FROM products
ORDER BY created_at DESC
LIMIT 2;
```

### สิ่งที่ควรเข้าใจ

- `ORDER BY` กำหนดลำดับ
- `LIMIT` ตัดจำนวนผลลัพธ์ตามลำดับที่เรียงแล้ว
- ถ้าต้องการผลลัพธ์ที่มีความหมาย ควรใช้สองส่วนนี้ร่วมกัน

---

## หัวข้อย่อยที่ 7: ใช้ LIMIT กับ OFFSET สำหรับการแบ่งหน้าเบื้องต้น

ในระบบที่มีรายการข้อมูลจำนวนมาก เช่น หน้าสินค้า หรือหน้าประวัติคำสั่งซื้อ เรามักใช้ `LIMIT` ร่วมกับ `OFFSET` เพื่อแบ่งข้อมูลออกเป็นหน้า

```sql
-- แสดงข้อมูล 3 รายการแรก
SELECT id, product_name, price
FROM products
ORDER BY id ASC
LIMIT 3 OFFSET 0;
```

```sql
-- แสดงข้อมูล 3 รายการถัดไป
SELECT id, product_name, price
FROM products
ORDER BY id ASC
LIMIT 3 OFFSET 3;
```

### สิ่งที่ควรเข้าใจ

- `LIMIT 3 OFFSET 0` คือเริ่มจากแถวแรกและเอา 3 แถว
- `LIMIT 3 OFFSET 3` คือข้าม 3 แถวแรก แล้วเอา 3 แถวถัดไป
- แนวคิดนี้เป็นพื้นฐานของ pagination

---

## หัวข้อย่อยที่ 8: รูปแบบย่อของ LIMIT offset, count

MySQL ยังรองรับรูปแบบย่อที่เขียน `LIMIT offset, count` ได้เช่นกัน

```sql
-- ข้าม 2 แถวแรก แล้วดึงมา 2 แถว
SELECT id, product_name, price
FROM products
ORDER BY id ASC
LIMIT 2, 2;
```

### สิ่งที่ควรเข้าใจ

- `LIMIT 2, 2` มีความหมายใกล้กับ `LIMIT 2 OFFSET 2`
- แม้ใช้งานได้ แต่หลายทีมเลือกใช้รูปแบบ `LIMIT ... OFFSET ...` เพราะอ่านง่ายกว่า

---

## หัวข้อย่อยที่ 9: ตัวอย่างการใช้งานจริงในระบบงาน

ตัวอย่างต่อไปนี้สะท้อน query ที่พบได้บ่อยใน dashboard หรือหน้ารายการข้อมูลจริง

```sql
-- แสดงสินค้าในหมวด Accessories
-- เรียงจากราคาสูงไปต่ำ
-- และแสดงเพียง 2 รายการแรก
SELECT product_name, category, price
FROM products
WHERE category = 'Accessories'
ORDER BY price DESC
LIMIT 2;
```

```sql
-- แสดงสินค้าที่ stock ต่ำสุด 3 รายการ
SELECT product_name, stock
FROM products
ORDER BY stock ASC
LIMIT 3;
```

### สิ่งที่ควรเข้าใจ

- ใช้ `WHERE` เพื่อกรองข้อมูลเฉพาะกลุ่ม
- ใช้ `ORDER BY` เพื่อจัดลำดับตามเป้าหมายของธุรกิจ
- ใช้ `LIMIT` เพื่อลดข้อมูลให้เหลือเฉพาะสิ่งที่ต้องการแสดง

---

## Best Practices สำหรับงานจริง

### 1) อย่าใช้ LIMIT โดยไม่มี ORDER BY ถ้าต้องการผลลัพธ์ที่คาดเดาได้

```sql
-- ยังไม่ชัดเจนในเชิงธุรกิจ เพราะไม่ได้ระบุลำดับ
SELECT product_name, price
FROM products
LIMIT 5;
```

```sql
-- ชัดเจนกว่า เพราะบอกว่าต้องการสินค้าล่าสุด 5 รายการ
SELECT product_name, created_at
FROM products
ORDER BY created_at DESC
LIMIT 5;
```

### 2) เรียงข้อมูลตามคอลัมน์ที่มีความหมายต่อธุรกิจ

เช่น รายการล่าสุดใช้ `created_at`, รายการแพงสุดใช้ `price`, รายการที่ควรเติมสต๊อกก่อนใช้ `stock`

### 3) ระวัง OFFSET สูงมากในข้อมูลขนาดใหญ่

การใช้ `OFFSET` มาก ๆ อาจทำให้ query ช้าลงเมื่อข้อมูลมีจำนวนมาก ในระบบขนาดใหญ่บางครั้งจะใช้ keyset pagination หรือ cursor-based pagination แทน

### 4) ดึงเฉพาะคอลัมน์ที่จำเป็น

```sql
-- ดี: ดึงเฉพาะข้อมูลที่ต้องใช้แสดงผล
SELECT product_name, price, stock
FROM products
ORDER BY price DESC
LIMIT 10;
```

### 5) พิจารณา index สำหรับคอลัมน์ที่ใช้เรียงบ่อย

ถ้าระบบต้องเรียงข้อมูลตาม `created_at`, `price`, หรือ `category` เป็นประจำ การออกแบบ index ที่เหมาะสมจะช่วยเรื่อง performance ได้มาก

---

## ข้อควรระวัง

- อย่าคาดหวังลำดับของข้อมูลถ้าไม่ได้ใช้ `ORDER BY`
- อย่าใช้ `LIMIT` เพียงอย่างเดียวถ้าผลลัพธ์ต้องมีความหมายเชิงธุรกิจ
- ระวัง `OFFSET` สูงในตารางขนาดใหญ่
- ตรวจสอบชนิดข้อมูลของคอลัมน์ที่นำมาเรียง เพื่อให้ผลลัพธ์ถูกต้อง
- เมื่อทำ pagination จริง ควรมีลำดับที่แน่นอนและสม่ำเสมอ เช่น `ORDER BY created_at DESC, id DESC`

## สรุป

`ORDER BY` และ `LIMIT` เป็นเครื่องมือสำคัญในการจัดการผลลัพธ์ของ query ใน MySQL ทำให้ข้อมูลที่ดึงออกมามีลำดับที่ชัดเจน อ่านง่าย และพร้อมใช้งานจริง ไม่ว่าจะเป็นหน้าแสดงรายการ รายงาน หรือ dashboard

เมื่อเข้าใจหัวข้อนี้แล้ว หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `Filtering Data with WHERE in MySQL`
- `GROUP BY and Aggregate Functions`
- `MySQL JOIN Basics`
- `Indexes and Query Performance`
- `Pagination Patterns in Real Applications`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน query เพื่อแสดงสินค้าเรียงตาม `price` จากน้อยไปมาก

### แบบฝึกหัด 2
เขียน query เพื่อแสดงสินค้า 3 รายการที่ราคาสูงที่สุด

### แบบฝึกหัด 3
เขียน query เพื่อแสดงสินค้าเรียงตาม `created_at` จากใหม่ไปเก่า

### แบบฝึกหัด 4
เขียน query เพื่อแสดงสินค้า 2 รายการแรกของหน้าที่ 2 โดยให้หน้าละ 2 รายการ

### แบบฝึกหัด 5
เขียน query เพื่อแสดงสินค้าในหมวด `Accessories` โดยเรียงตามราคาแพงไปถูก และแสดงเพียง 2 รายการ

## เฉลยแบบย่อ

```sql
-- ข้อ 1
SELECT product_name, price
FROM products
ORDER BY price ASC;

-- ข้อ 2
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 3;

-- ข้อ 3
SELECT product_name, created_at
FROM products
ORDER BY created_at DESC;

-- ข้อ 4
SELECT id, product_name, price
FROM products
ORDER BY id ASC
LIMIT 2 OFFSET 2;

-- ข้อ 5
SELECT product_name, category, price
FROM products
WHERE category = 'Accessories'
ORDER BY price DESC
LIMIT 2;
```



---

## 4. MySQL JOIN for Real Projects

> Source File: `MySQL JOIN for Real Projects.md`


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



---

## 5. Aggregate Functions in MySQL

> Source File: `Aggregate Functions in MySQL.md`


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



---

## 6. GROUP BY and HAVING in MySQL

> Source File: `GROUP BY and HAVING in MySQL.md`


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



---

## 7. Database Design with MySQL

> Source File: `Database Design with MySQL.md`


File Name: Database Design with MySQL.md

# Database Design with MySQL

## บทนำ

การออกแบบฐานข้อมูล (Database Design) คือรากฐานสำคัญของระบบที่ใช้ MySQL ไม่ว่าจะเป็นเว็บแอปพลิเคชัน ระบบหลังบ้าน ระบบ HR ระบบขายสินค้า หรือระบบรายงานภายในองค์กร หากออกแบบดีตั้งแต่ต้น ระบบจะอ่านข้อมูลง่าย ขยายต่อได้ ป้องกันข้อมูลซ้ำซ้อน และช่วยให้ query ทำงานได้มีประสิทธิภาพมากขึ้น

หัวข้อนี้เหมาะสำหรับผู้เริ่มต้นจนถึงผู้ที่เริ่มพัฒนาระบบจริง เพราะจะช่วยให้เข้าใจวิธีคิดตั้งแต่การแปลง requirement ไปเป็น table, การเลือก `primary key`, `foreign key`, การจัดความสัมพันธ์ของข้อมูล ไปจนถึงแนวคิดเรื่อง `normalization`, `indexing`, และ `data integrity`

## สิ่งที่ผู้เรียนจะได้เรียน

- หลักคิดพื้นฐานของการออกแบบฐานข้อมูล
- วิธีแปลง requirement เป็นตารางและความสัมพันธ์
- การออกแบบ `primary key` และ `foreign key`
- ความแตกต่างของความสัมพันธ์แบบ one-to-one, one-to-many, many-to-many
- แนวคิดเรื่อง `normalization` แบบใช้งานได้จริง
- การใช้ `constraints` เพื่อรักษาคุณภาพข้อมูล
- การออกแบบ `index` เบื้องต้นให้รองรับ query จริง
- แนวปฏิบัติที่เหมาะกับงานพัฒนาในยุคปัจจุบัน

## Database Design คืออะไร และสำคัญอย่างไร

การออกแบบฐานข้อมูลคือการวางโครงสร้างการเก็บข้อมูลให้สอดคล้องกับธุรกิจและการใช้งานจริง ไม่ใช่แค่ “สร้าง table ให้เก็บข้อมูลได้” แต่ต้องตอบคำถามสำคัญ เช่น

- ข้อมูลอะไรควรอยู่ table เดียวกัน
- ข้อมูลอะไรควรแยกออกเป็นอีก table
- ความสัมพันธ์ระหว่างข้อมูลคืออะไร
- จะป้องกันข้อมูลซ้ำหรือข้อมูลผิดพลาดอย่างไร
- query ที่ระบบต้องใช้บ่อยคืออะไร

ถ้าออกแบบไม่ดี อาจเจอปัญหาเช่น:

- ข้อมูลซ้ำหลายจุด
- แก้ข้อมูลครั้งเดียวแต่ต้องไล่แก้หลาย table
- report ผิดเพราะความสัมพันธ์ไม่ชัด
- query ช้าเมื่อข้อมูลเริ่มเยอะ
- เพิ่ม feature ใหม่ได้ยาก

---

## หัวข้อย่อยที่ 1: เริ่มจาก Requirement ก่อนสร้าง Table

การออกแบบฐานข้อมูลที่ดีเริ่มจากการเข้าใจ requirement ทางธุรกิจ ไม่ใช่เริ่มจากการเดาชื่อ table ก่อน ตัวอย่างเช่น ถ้าจะสร้างระบบขายสินค้า เราอาจมี requirement หลักดังนี้

- ลูกค้าสมัครสมาชิกได้
- ลูกค้าสั่งซื้อสินค้าได้หลายรายการต่อ 1 order
- 1 order มีสินค้าได้หลายชิ้น
- ระบบต้องดูยอดรวมต่อ order ได้
- ระบบต้องดูประวัติคำสั่งซื้อของลูกค้าได้

จาก requirement นี้ เราจึงค่อยแยก entity ออกมา เช่น

- `customers`
- `products`
- `orders`
- `order_items`

### สิ่งที่ควรเข้าใจ

- อย่าเริ่มจาก table ถ้ายังไม่เข้าใจกระบวนการธุรกิจ
- entity ควรสะท้อน “ของจริง” ในระบบ เช่น ลูกค้า สินค้า คำสั่งซื้อ
- requirement ที่ชัด จะช่วยลดการ refactor โครงสร้างใหญ่ในภายหลัง

---

## หัวข้อย่อยที่ 2: ระบุ Entity และ Attribute

เมื่อรู้ requirement แล้ว ขั้นต่อไปคือแยกว่าแต่ละ entity ควรมีข้อมูลอะไรบ้าง

ตัวอย่าง:

- `customers` อาจมี `customer_id`, `full_name`, `email`, `phone`
- `products` อาจมี `product_id`, `product_name`, `price`, `stock`
- `orders` อาจมี `order_id`, `customer_id`, `order_date`, `status`

```sql
-- ตารางลูกค้า
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- entity คือสิ่งหลักที่ระบบต้องเก็บ
- attribute คือรายละเอียดของ entity นั้น
- เลือกชนิดข้อมูล (`data type`) ให้เหมาะกับข้อมูลจริงตั้งแต่ต้น

---

## หัวข้อย่อยที่ 3: เลือก Primary Key ให้เหมาะสม

`Primary Key` คือคอลัมน์ที่ใช้ระบุแต่ละแถวไม่ให้ซ้ำกัน ในระบบจริงนิยมใช้คอลัมน์ประเภทตัวเลขที่เพิ่มอัตโนมัติ เช่น `INT` หรือ `BIGINT` พร้อม `AUTO_INCREMENT`

```sql
-- ใช้ customer_id เป็น primary key
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL
);
```

### สิ่งที่ควรเข้าใจ

- `PRIMARY KEY` ต้องไม่ซ้ำ และห้ามเป็น `NULL`
- ควรใช้ key ที่เสถียรและไม่เปลี่ยนตามธุรกิจ
- โดยทั่วไปไม่ควรใช้ข้อมูลที่อาจเปลี่ยนได้ เช่น email หรือ phone เป็น primary key โดยตรง

---

## หัวข้อย่อยที่ 4: ใช้ Foreign Key เพื่อเชื่อมความสัมพันธ์

`Foreign Key` ใช้เชื่อม table เข้าหากัน และช่วยรักษา `data integrity` เช่น order ทุกใบต้องอ้างถึงลูกค้าที่มีอยู่จริง

```sql
-- ตารางคำสั่งซื้อที่เชื่อมกับลูกค้า
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### สิ่งที่ควรเข้าใจ

- `foreign key` ป้องกันข้อมูล orphan เช่น order ที่ไม่มี customer จริง
- ความสัมพันธ์ที่ชัดเจนช่วยให้ `JOIN` ในภายหลังง่ายและปลอดภัยขึ้น
- ควรวางชื่อ constraint ให้สื่อความหมายเมื่อดู schema ภายหลัง

---

## หัวข้อย่อยที่ 5: เข้าใจความสัมพันธ์หลักของข้อมูล

ความสัมพันธ์ที่พบบ่อยมี 3 แบบ

### 1) One-to-One

เช่น 1 user มี 1 profile

```sql
-- ตาราง users
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE
);

-- ตาราง profiles
CREATE TABLE profiles (
    user_id BIGINT PRIMARY KEY,
    display_name VARCHAR(150) NOT NULL,
    birth_date DATE NULL,
    CONSTRAINT fk_profiles_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

### 2) One-to-Many

เช่น 1 customer มีหลาย orders

```sql
-- ลูกค้า 1 คน มีได้หลายคำสั่งซื้อ
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### 3) Many-to-Many

เช่น 1 order มีหลาย products และ 1 product อยู่ได้ในหลาย orders

```sql
-- ตารางกลางสำหรับ many-to-many
CREATE TABLE order_items (
    order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### สิ่งที่ควรเข้าใจ

- ความสัมพันธ์แบบ many-to-many มักต้องมี table กลาง
- table กลางมักเก็บข้อมูลเพิ่มเติม เช่น `quantity`, `unit_price`
- ความสัมพันธ์ที่ถูกต้องมีผลต่อทั้ง query, report, และ data integrity

---

## หัวข้อย่อยที่ 6: Normalization แบบใช้งานจริง

`Normalization` คือแนวคิดในการลดข้อมูลซ้ำและจัดข้อมูลให้เป็นระเบียบมากขึ้น ในงานจริงไม่จำเป็นต้องท่องทฤษฎีลึกก่อน แต่ควรเข้าใจหลักการใช้งาน เช่น

- อย่าเก็บข้อมูลหลายค่าในคอลัมน์เดียว
- อย่าเก็บข้อมูลซ้ำโดยไม่จำเป็น
- แยกข้อมูลที่เป็นคนละเรื่องออกจากกัน

### ตัวอย่างที่ไม่ดี

```sql
-- ไม่แนะนำ: เก็บสินค้าหลายชิ้นในคอลัมน์เดียว
CREATE TABLE bad_orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(150),
    product_list TEXT
);
```

### ตัวอย่างที่ดีกว่า

```sql
-- ดี: แยก order และ order_items ออกจากกัน
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL
);

CREATE TABLE order_items (
    order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL
);
```

### สิ่งที่ควรเข้าใจ

- normalization ช่วยให้ update ง่ายขึ้นและลดความขัดแย้งของข้อมูล
- อย่าเก็บรายการหลายค่าแบบคั่น comma ในคอลัมน์เดียวถ้าระบบต้อง query ต่อ
- การแยก table อย่างเหมาะสมช่วยให้ระบบขยายต่อได้ดี

---

## หัวข้อย่อยที่ 7: เลือก Data Type ให้เหมาะกับข้อมูล

การเลือก `data type` ที่เหมาะสมมีผลต่อทั้งความถูกต้องและ performance

```sql
-- ตัวอย่างการเลือกชนิดข้อมูลที่เหมาะสม
CREATE TABLE products (
    product_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    sku VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### แนวคิดสำคัญ

- ใช้ `VARCHAR` กับข้อความที่ความยาวไม่คงที่
- ใช้ `DECIMAL` กับข้อมูลการเงิน หลีกเลี่ยง `FLOAT` สำหรับราคา
- ใช้ `INT` หรือ `BIGINT` กับเลขจำนวนเต็ม
- ใช้ `DATE` หรือ `DATETIME` กับวันเวลาให้ตรงตามบริบท
- ใช้ `NOT NULL` เมื่อ field นั้นต้องมีเสมอ

---

## หัวข้อย่อยที่ 8: ใช้ Constraints เพื่อควบคุมคุณภาพข้อมูล

constraints ช่วยให้ฐานข้อมูลช่วยตรวจสอบกฎพื้นฐานแทนระบบบางส่วน เช่น บังคับไม่ให้ email ซ้ำ หรือห้าม stock ติดลบ

```sql
-- ตัวอย่าง constraints ที่ใช้จริง
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(30) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    salary DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    CHECK (salary >= 0)
);
```

### สิ่งที่ควรเข้าใจ

- `PRIMARY KEY` ป้องกัน key ซ้ำ
- `UNIQUE` ป้องกันค่าซ้ำในคอลัมน์ที่ต้องไม่ซ้ำ
- `NOT NULL` ป้องกันค่าหาย
- `CHECK` ใช้บังคับเงื่อนไขของข้อมูล
- constraints ช่วยลดความเสี่ยงที่ข้อมูลเสียตั้งแต่ระดับฐานข้อมูล

---

## หัวข้อย่อยที่ 9: ตั้งชื่อ Table และ Column ให้สม่ำเสมอ

ชื่อที่ดีช่วยให้ schema อ่านง่ายและดูแลง่าย โดยเฉพาะเมื่อระบบมีหลาย table

### แนวทางที่นิยม

- ใช้ชื่อ table เป็นพหูพจน์ เช่น `customers`, `orders`, `products`
- ใช้ `snake_case` ให้สม่ำเสมอ
- ตั้งชื่อ key ให้ชัด เช่น `customer_id`, `product_id`
- ตั้งชื่อวันเวลาให้ชัด เช่น `created_at`, `updated_at`, `deleted_at`

```sql
-- ตัวอย่างชื่อที่อ่านง่ายและสม่ำเสมอ
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- ความสม่ำเสมอสำคัญกว่าความแปลกใหม่
- ตั้งชื่อให้คนอื่นในทีมอ่านแล้วเข้าใจทันที
- schema ที่อ่านง่ายช่วยให้ code review และ maintenance ดีขึ้นมาก

---

## หัวข้อย่อยที่ 10: ออกแบบ Index ตาม Query ที่ใช้งานจริง

`Index` ช่วยให้การค้นหาและ join เร็วขึ้น แต่ไม่ควรใส่ทุกคอลัมน์แบบไม่คิด เพราะ index มากเกินไปทำให้ insert/update ช้าลงและใช้พื้นที่เพิ่ม

```sql
-- index สำหรับค้นหาตาม email
CREATE UNIQUE INDEX idx_customers_email
    ON customers(email);

-- index สำหรับ join และ filter คำสั่งซื้อของลูกค้า
CREATE INDEX idx_orders_customer_id
    ON orders(customer_id);

-- index สำหรับค้นหาตาม status และ order_date
CREATE INDEX idx_orders_status_order_date
    ON orders(status, order_date);
```

### สิ่งที่ควรเข้าใจ

- สร้าง index จาก query ที่ใช้จริง ไม่ใช่จากการเดา
- คอลัมน์ที่ใช้ใน `WHERE`, `JOIN`, `ORDER BY` บ่อย มักเป็นตัวเลือกที่ดี
- foreign key หลายกรณีควรมี index รองรับ

---

## หัวข้อย่อยที่ 11: ตัวอย่าง Schema ของระบบขายสินค้า

ด้านล่างคือตัวอย่าง schema ที่เชื่อมกันครบสำหรับระบบขนาดเล็ก

```sql
-- ตารางลูกค้า
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(30) NULL,
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
    status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ตารางรายการสินค้าในคำสั่งซื้อ
CREATE TABLE order_items (
    order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### สิ่งที่ควรเข้าใจ

- `customers` เก็บข้อมูลลูกค้าเพียงครั้งเดียว
- `products` เก็บ master data ของสินค้า
- `orders` เก็บหัวคำสั่งซื้อ
- `order_items` เก็บรายละเอียดสินค้าในแต่ละ order
- โครงสร้างแบบนี้รองรับ `JOIN`, report, และการขยายระบบได้ดี

---

## หัวข้อย่อยที่ 12: ออกแบบเพื่อรองรับ Audit และ Tracking

ในงานจริง ควรคิดเรื่องการติดตามข้อมูลตั้งแต่แรก เช่น วันสร้าง วันแก้ไข ผู้สร้าง หรือสถานะการใช้งาน

```sql
-- ตัวอย่างคอลัมน์สำหรับ tracking
CREATE TABLE documents (
    document_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    document_name VARCHAR(200) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- `created_at` และ `updated_at` มีประโยชน์มากในการ audit และ troubleshooting
- บางระบบอาจเพิ่ม `created_by`, `updated_by` ตามความจำเป็น
- อย่ารอให้ระบบโตแล้วค่อยคิดเรื่อง tracking เพราะแก้ภายหลังมักกระทบหลายส่วน

---

## หัวข้อย่อยที่ 13: Soft Delete vs Hard Delete

ในระบบธุรกิจหลายประเภท การลบข้อมูลทิ้งจริงอาจไม่เหมาะ เพราะกระทบ report หรือ audit trail จึงนิยมใช้ `soft delete`

```sql
-- ตัวอย่าง soft delete
CREATE TABLE categories (
    category_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    deleted_at DATETIME NULL
);
```

```sql
-- ดึงเฉพาะข้อมูลที่ยังไม่ถูกลบแบบ soft delete
SELECT category_id, category_name
FROM categories
WHERE deleted_at IS NULL;
```

### สิ่งที่ควรเข้าใจ

- `hard delete` คือการลบแถวออกจริง
- `soft delete` คือเก็บแถวไว้แต่ทำเครื่องหมายว่าถูกลบแล้ว
- ระบบที่ต้อง audit หรือดูประวัติย้อนหลัง มักได้ประโยชน์จาก soft delete

---

## หัวข้อย่อยที่ 14: Security Basics ในการออกแบบฐานข้อมูล

แม้ database design จะไม่ใช่ security ทั้งหมด แต่มีผลต่อความปลอดภัยโดยตรง เช่น การแยกข้อมูลสำคัญ การจำกัดข้อมูลซ้ำ และการเก็บรหัสผ่านอย่างถูกวิธี

```sql
-- ตัวอย่างตาราง users สำหรับระบบ login
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- ไม่ควรเก็บรหัสผ่านเป็น plain text
- ควรเก็บ `password_hash` แทน
- ข้อมูลสำคัญ เช่น email, phone, salary ควรถูกออกแบบให้เข้าถึงเฉพาะส่วนที่จำเป็น
- design ที่ดีช่วยลดการ expose ข้อมูลเกินจำเป็น

---

## หัวข้อย่อยที่ 15: Backup และ Restore ควรถูกคิดตั้งแต่ต้น

ระบบที่ออกแบบดีควรสามารถ backup และ restore ได้ง่าย โครงสร้างที่ชัดช่วยให้การย้ายข้อมูลและการกู้คืนระบบทำได้ปลอดภัยขึ้น

```sql
-- สำรองฐานข้อมูลด้วย mysqldump (ตัวอย่างคำสั่ง shell)
-- mysqldump -u root -p shop_db > shop_db_backup.sql

-- restore กลับเข้าฐานข้อมูล (ตัวอย่างคำสั่ง shell)
-- mysql -u root -p shop_db < shop_db_backup.sql
```

### สิ่งที่ควรเข้าใจ

- แม้คำสั่ง backup/restore ไม่ใช่ SQL โดยตรง แต่เป็นเรื่องที่ควรนึกถึงตั้งแต่ระยะออกแบบ
- schema ที่ชัดเจนและสัมพันธ์กันดี ช่วยให้ migration และ restore ปลอดภัยขึ้น
- ใน production ควรมีทั้ง backup policy และการทดสอบ restore จริง

---

## ตัวอย่างการใช้งานจริง: Query ที่สะท้อนว่า Design ดีหรือไม่

เมื่อ schema ออกแบบดี เราจะเขียน query ที่ชัดเจนและต่อยอดได้ง่าย เช่น ดึงคำสั่งซื้อพร้อมชื่อลูกค้าและยอดรวม

```sql
-- รายงานคำสั่งซื้อพร้อมชื่อลูกค้าและยอดรวมต่อ order
SELECT
    o.order_id,
    c.full_name,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id, c.full_name, o.order_date, o.status
ORDER BY o.order_date DESC;
```

### สิ่งที่ควรเข้าใจ

- ถ้า schema ดี query จะอ่านง่ายและสรุปข้อมูลได้ตรงธุรกิจ
- ถ้า schema แย่ query มักยาว ซับซ้อน และเสี่ยงต่อข้อมูลผิด
- design ที่ดีช่วยทั้ง developer, analyst, และ DBA

---

## Best Practices สำหรับงานจริง

### 1) ออกแบบจาก use case ไม่ใช่จากความเคยชิน

ถามก่อนเสมอว่าระบบต้องตอบคำถามอะไร และผู้ใช้งานจะ query อะไรบ่อย

### 2) ใช้ primary key และ foreign key ให้ชัดเจน

```sql
-- ตัวอย่างความสัมพันธ์ที่ชัดเจน
CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
```

### 3) อย่าเก็บข้อมูลซ้ำโดยไม่จำเป็น

เช่น อย่าเก็บ `customer_name` ซ้ำในทุก order ถ้าระบบมี `customers` อยู่แล้ว เว้นแต่มีเหตุผลเชิงธุรกิจชัดเจน เช่น ต้อง snapshot ชื่อ ณ เวลาที่สั่งซื้อ

### 4) ใช้ DECIMAL กับข้อมูลการเงิน

```sql
-- ดีสำหรับราคาและยอดเงิน
price DECIMAL(10,2) NOT NULL
```

### 5) ออกแบบ index ตาม query จริง

ดูจาก query ที่ใช้บ่อย เช่น ค้นหาตาม `email`, ดู order ของลูกค้า, filter ตาม `status` และวันที่

### 6) เผื่อการเติบโตของระบบ

เช่น ใช้ `BIGINT` หากคาดว่าข้อมูลจะมีจำนวนมาก และคิดเรื่อง `created_at`, `updated_at` ตั้งแต่ต้น

### 7) อย่ารีบ denormalize โดยไม่มีเหตุผล

การรวมข้อมูลหลายอย่างไว้ table เดียวอาจดูง่ายช่วงแรก แต่ทำให้ระบบโตยากในระยะยาว

---

## ข้อควรระวัง

- อย่าออกแบบ table จากหน้าจอเพียงอย่างเดียว ควรดู process ทั้งระบบ
- อย่าใช้ `VARCHAR` กับทุกอย่างแบบไม่คิดชนิดข้อมูล
- อย่าเก็บหลายค่าในคอลัมน์เดียวถ้าต้อง query แยกในอนาคต
- อย่าลืม constraints และ foreign keys หากข้อมูลต้องสัมพันธ์กันจริง
- อย่าใส่ index มากเกินไปโดยไม่ดู query ที่ใช้จริง
- อย่ามองข้ามเรื่อง audit, security, และ backup ตั้งแต่ช่วงออกแบบ

## สรุป

การออกแบบฐานข้อมูลด้วย MySQL ที่ดีไม่ใช่แค่ทำให้เก็บข้อมูลได้ แต่ต้องทำให้ข้อมูลเชื่อมโยงกันอย่างถูกต้อง ลดความซ้ำซ้อน รองรับ query จริง และขยายระบบได้ในอนาคต

ถ้าเริ่มจาก requirement ที่ชัด แยก entity ได้ถูกต้อง ใช้ `primary key`, `foreign key`, `constraints`, `normalization`, และ `index` อย่างเหมาะสม คุณจะได้ schema ที่แข็งแรงและพร้อมใช้งานในโครงการจริงมากขึ้น

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `MySQL JOIN for Real Projects`
- `Indexes and Query Performance in MySQL`
- `Transactions in MySQL`
- `Constraints and Data Integrity in MySQL`
- `Designing Audit Tables with MySQL`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
อธิบายว่าระบบขายสินค้าออนไลน์ควรมี table หลักอะไรบ้างอย่างน้อย 4 table

### แบบฝึกหัด 2
เขียนคำสั่งสร้าง table `departments` ที่มี `department_id`, `department_name`, `created_at`

### แบบฝึกหัด 3
เขียนคำสั่งสร้าง table `employees` ที่เชื่อมกับ `departments` ผ่าน `department_id`

### แบบฝึกหัด 4
อธิบายความแตกต่างระหว่าง one-to-many และ many-to-many แบบสั้น ๆ

### แบบฝึกหัด 5
เขียนตัวอย่าง index สำหรับคอลัมน์ `email` ใน table `customers`

## เฉลยแบบย่อ

```sql
-- ข้อ 2
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ข้อ 3
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_id BIGINT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ข้อ 5
CREATE UNIQUE INDEX idx_customers_email
    ON customers(email);
```



---

## 8. Primary Key and Foreign Key in MySQL

> Source File: `Primary Key and Foreign Key in MySQL.md`


File Name: Primary Key and Foreign Key in MySQL.md

# Primary Key and Foreign Key in MySQL

## บทนำ

`Primary Key` และ `Foreign Key` คือรากฐานของฐานข้อมูลเชิงสัมพันธ์ใน MySQL เพราะช่วยให้ข้อมูลแต่ละแถวมีตัวตนที่ชัดเจน และช่วยให้ตารางหลายตารางเชื่อมโยงกันได้อย่างถูกต้อง เช่น ลูกค้ากับคำสั่งซื้อ พนักงานกับแผนก หรือสินค้า กับรายการขาย

ถ้าเข้าใจสองเรื่องนี้ดี คุณจะออกแบบฐานข้อมูลได้เป็นระบบมากขึ้น เขียน `JOIN` ได้ถูกต้องขึ้น และลดปัญหาข้อมูลซ้ำ ข้อมูลหลุด หรือข้อมูลที่อ้างอิงกันผิด

หัวข้อนี้เหมาะสำหรับผู้เริ่มต้นที่ต้องการเข้าใจโครงสร้างฐานข้อมูลให้ถูกตั้งแต่ต้น และเหมาะสำหรับผู้ที่เริ่มพัฒนาระบบจริงด้วย MySQL

## สิ่งที่ผู้เรียนจะได้เรียน

- ความหมายของ `Primary Key` และ `Foreign Key`
- เหตุผลที่ต้องใช้ key ในฐานข้อมูลเชิงสัมพันธ์
- วิธีสร้าง `PRIMARY KEY` และ `FOREIGN KEY` ใน MySQL
- ความสัมพันธ์แบบ one-to-many ที่ใช้จริงบ่อยที่สุด
- ความต่างระหว่าง key เชิงธุรกิจกับ key ทางเทคนิค
- การใช้ `AUTO_INCREMENT`
- ข้อควรระวังเรื่อง `NULL`, การลบข้อมูล, และ data integrity
- แนวปฏิบัติที่เหมาะกับงานจริง

## Key คืออะไร และทำไมจึงสำคัญ

ในฐานข้อมูล เราต้องมีวิธีระบุว่า “แถวนี้คือแถวไหน” และ “แถวนี้เกี่ยวข้องกับแถวไหนในอีกตารางหนึ่ง”

- `Primary Key` ใช้ระบุแถวหนึ่งแถวให้ไม่ซ้ำกัน
- `Foreign Key` ใช้เชื่อมความสัมพันธ์ระหว่างตาราง

ถ้าไม่มี key ที่ชัดเจน ฐานข้อมูลจะมีปัญหาเช่น:

- ข้อมูลซ้ำจนแยกไม่ออกว่าแถวไหนคือข้อมูลจริง
- คำสั่งซื้ออาจอ้างถึงลูกค้าที่ไม่มีอยู่จริง
- การ `JOIN` ข้อมูลอาจผิดหรือคลุมเครือ
- การแก้ไขและดูแลข้อมูลในระยะยาวทำได้ยาก

---

## หัวข้อย่อยที่ 1: Primary Key คืออะไร

`Primary Key` คือคอลัมน์ หรือชุดของคอลัมน์ ที่ใช้ระบุแต่ละแถวในตารางแบบไม่ซ้ำกัน และห้ามเป็น `NULL`

ตัวอย่างเช่น ในตาราง `customers` เราอาจใช้ `customer_id` เป็น `PRIMARY KEY`

```sql
-- สร้างตาราง customers พร้อม primary key
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- แต่ละแถวต้องมีค่า `customer_id` ไม่ซ้ำกัน
- `PRIMARY KEY` ห้ามมีค่า `NULL`
- โดยทั่วไปมักมี 1 primary key ต่อ 1 ตาราง
- นิยมใช้คอลัมน์ประเภท `INT` หรือ `BIGINT` ร่วมกับ `AUTO_INCREMENT`

---

## หัวข้อย่อยที่ 2: ทำไม Primary Key จึงสำคัญ

`Primary Key` ทำให้แต่ละแถวมีตัวระบุที่แน่นอน เช่น ลูกค้าคนหนึ่งอาจชื่อซ้ำกับอีกคนได้ แต่ `customer_id` ไม่ควรซ้ำ

```sql
-- เพิ่มข้อมูลลูกค้าหลายคน
INSERT INTO customers (full_name, email)
VALUES
    ('Anan Krit', 'anan@example.com'),
    ('Anan Krit', 'anan.k@example.com'),
    ('Mali Suda', 'mali@example.com');
```

### สิ่งที่ควรเข้าใจ

- แม้ `full_name` จะซ้ำกันได้ แต่ `customer_id` ของแต่ละแถวต้องไม่ซ้ำ
- ระบบจึงอ้างอิงข้อมูลได้แม่นยำกว่าใช้ชื่อหรือข้อความทั่วไป
- key ที่ดีช่วยให้การ update, delete, และ join ปลอดภัยขึ้น

---

## หัวข้อย่อยที่ 3: AUTO_INCREMENT คืออะไร

`AUTO_INCREMENT` คือคุณสมบัติที่ให้ MySQL สร้างเลขลำดับใหม่ให้อัตโนมัติทุกครั้งที่เพิ่มข้อมูลแถวใหม่

```sql
-- customer_id จะเพิ่มให้อัตโนมัติ
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL
);
```

### สิ่งที่ควรเข้าใจ

- ช่วยลดภาระในการกำหนดค่า id เอง
- เหมาะกับตารางส่วนใหญ่ในระบบธุรกิจ
- มักใช้คู่กับ `PRIMARY KEY`

---

## หัวข้อย่อยที่ 4: Foreign Key คืออะไร

`Foreign Key` คือคอลัมน์ในตารางหนึ่ง ที่อ้างอิงไปยัง `PRIMARY KEY` ของอีกตารางหนึ่ง เพื่อบอกความสัมพันธ์ของข้อมูล

ตัวอย่างเช่น ในตาราง `orders` เราใช้ `customer_id` เพื่ออ้างอิงลูกค้าที่เป็นเจ้าของคำสั่งซื้อ

```sql
-- ตาราง orders อ้างอิง customers ผ่าน customer_id
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### สิ่งที่ควรเข้าใจ

- `orders.customer_id` คือ `FOREIGN KEY`
- ค่านี้ต้องอ้างถึง `customers.customer_id` ที่มีอยู่จริง
- ถ้าพยายามใส่ `customer_id` ที่ไม่มีอยู่ MySQL จะปฏิเสธข้อมูล

---

## หัวข้อย่อยที่ 5: ความสัมพันธ์แบบ One-to-Many

รูปแบบที่ใช้จริงบ่อยมากคือ one-to-many เช่น:

- ลูกค้า 1 คน มีคำสั่งซื้อได้หลายรายการ
- แผนก 1 แผนก มีพนักงานได้หลายคน
- หมวดสินค้า 1 หมวด มีสินค้าได้หลายรายการ

```sql
-- ลูกค้า 1 คน มีหลาย orders ได้
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL
);

CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### สิ่งที่ควรเข้าใจ

- ตารางฝั่ง “หนึ่ง” คือ `customers`
- ตารางฝั่ง “หลาย” คือ `orders`
- `FOREIGN KEY` จะอยู่ฝั่งที่เป็น “หลาย”

---

## หัวข้อย่อยที่ 6: ตัวอย่างจริงแบบ customers และ orders

ด้านล่างคือตัวอย่างโครงสร้างที่ใช้จริงในหลายระบบ

```sql
-- ตารางลูกค้า
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

-- ตารางคำสั่งซื้อ
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

```sql
-- เพิ่มข้อมูลลูกค้า
INSERT INTO customers (full_name, email)
VALUES
    ('Anan Krit', 'anan@example.com'),
    ('Mali Suda', 'mali@example.com');

-- เพิ่มข้อมูลคำสั่งซื้อ โดยอ้างอิง customer_id ที่มีอยู่จริง
INSERT INTO orders (customer_id, total_amount)
VALUES
    (1, 2500.00),
    (1, 1800.00),
    (2, 3200.00);
```

### สิ่งที่ควรเข้าใจ

- ลูกค้าหมายเลข 1 มี order ได้หลายรายการ
- order ทุกแถวต้องอ้างถึงลูกค้าที่มีอยู่จริง
- ความสัมพันธ์แบบนี้รองรับการ query และ report ได้ดี

---

## หัวข้อย่อยที่ 7: JOIN กับ Primary Key และ Foreign Key

เมื่อออกแบบ key ถูกต้อง เราจะเขียน `JOIN` ได้ง่ายและชัดเจน

```sql
-- ดึงคำสั่งซื้อพร้อมชื่อลูกค้า
SELECT
    o.order_id,
    o.order_date,
    o.total_amount,
    c.full_name
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

### สิ่งที่ควรเข้าใจ

- `o.customer_id` เชื่อมกับ `c.customer_id`
- นี่คือผลลัพธ์จากการออกแบบ `PRIMARY KEY` และ `FOREIGN KEY` ที่ชัดเจน
- ถ้า key ไม่ถูกต้อง query จะซับซ้อนและเสี่ยงผิดมากขึ้น

---

## หัวข้อย่อยที่ 8: Business Key กับ Surrogate Key

ในงานจริงมักมี 2 แนวคิดที่ควรรู้

### 1) Business Key

คือค่าที่มีความหมายทางธุรกิจ เช่น:

- เลขบัตรประชาชน
- รหัสพนักงาน
- เลขคำสั่งซื้อ
- email

### 2) Surrogate Key

คือ key ที่สร้างขึ้นมาเพื่อใช้ในระบบ เช่น `id`, `customer_id`, `order_id`

```sql
-- ใช้ surrogate key เป็น primary key
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(30) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL
);
```

### สิ่งที่ควรเข้าใจ

- ในหลายระบบนิยมใช้ `surrogate key` เป็น `PRIMARY KEY`
- ส่วน `business key` มักใช้ `UNIQUE` เพิ่มเพื่อป้องกันข้อมูลซ้ำ
- วิธีนี้ยืดหยุ่นกว่าหากข้อมูลทางธุรกิจเปลี่ยนในอนาคต

---

## หัวข้อย่อยที่ 9: Composite Primary Key เบื้องต้น

บางตารางอาจใช้ `PRIMARY KEY` มากกว่า 1 คอลัมน์ร่วมกัน โดยเรียกว่า composite key เช่น ตารางกลางใน many-to-many

```sql
-- ตารางกลางแบบใช้ composite primary key
CREATE TABLE order_items (
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### สิ่งที่ควรเข้าใจ

- คู่ของ `(order_id, product_id)` ต้องไม่ซ้ำกัน
- เหมาะกับตารางที่ต้องการป้องกันความซ้ำในระดับคู่ข้อมูล
- ในบางโครงการอาจเลือกใช้ `order_item_id` แยกอีกแบบหนึ่งแทน ขึ้นกับการออกแบบ

---

## หัวข้อย่อยที่ 10: ข้อผิดพลาดที่ Foreign Key ช่วยป้องกัน

หนึ่งในประโยชน์สำคัญของ `FOREIGN KEY` คือช่วยป้องกันข้อมูลผิดความสัมพันธ์

```sql
-- ตัวอย่างนี้จะผิด ถ้ายังไม่มี customer_id = 99 ใน customers
INSERT INTO orders (customer_id, total_amount)
VALUES (99, 1500.00);
```

### สิ่งที่ควรเข้าใจ

- ถ้าไม่มี `customer_id = 99` จริง ฐานข้อมูลควรไม่ยอมให้ insert
- ช่วยป้องกันข้อมูล orphan
- เป็นการรักษา `data integrity` ที่ระดับฐานข้อมูล

---

## หัวข้อย่อยที่ 11: การลบข้อมูลและผลกระทบของ Foreign Key

เมื่อมีความสัมพันธ์ระหว่างตาราง การลบข้อมูลต้องคิดให้รอบคอบ เช่น ถ้าลบ customer แล้ว order ที่ผูกอยู่จะทำอย่างไร

```sql
-- ตัวอย่าง foreign key พร้อมกำหนดพฤติกรรมตอนลบข้อมูล
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```

### สิ่งที่ควรเข้าใจ

- `ON DELETE RESTRICT` ไม่ให้ลบลูกค้าถ้ายังมี order ผูกอยู่
- `ON UPDATE CASCADE` ช่วยอัปเดตค่าที่อ้างอิงตามกันเมื่อ key ต้นทางเปลี่ยน
- ควรเลือกพฤติกรรมให้สอดคล้องกับธุรกิจ ไม่ใช้แบบเดียวทุกกรณี

---

## หัวข้อย่อยที่ 12: RESTRICT, CASCADE, SET NULL ต่างกันอย่างไร

ค่าที่กำหนดหลัง `ON DELETE` หรือ `ON UPDATE` มีผลต่อความสัมพันธ์ของข้อมูล

```sql
-- ตัวอย่างการใช้ ON DELETE SET NULL
CREATE TABLE tasks (
    task_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    assigned_employee_id BIGINT NULL,
    task_name VARCHAR(200) NOT NULL,
    CONSTRAINT fk_tasks_employee
        FOREIGN KEY (assigned_employee_id) REFERENCES employees(employee_id)
        ON DELETE SET NULL
);
```

### ความหมายโดยย่อ

- `RESTRICT` ไม่ยอมให้ลบหรือแก้ ถ้ายังมีข้อมูลอ้างอิงอยู่
- `CASCADE` ลบหรือแก้ตามกัน
- `SET NULL` ตั้งค่าฝั่งที่อ้างอิงให้เป็น `NULL`

### สิ่งที่ควรเข้าใจ

- อย่าใช้ `CASCADE` โดยไม่คิด เพราะอาจลบข้อมูลต่อเนื่องหลายตาราง
- `SET NULL` ใช้ได้เมื่อคอลัมน์นั้นอนุญาต `NULL`
- งานจริงควรเลือกตามกฎธุรกิจ ไม่ใช่ตามความสะดวกอย่างเดียว

---

## หัวข้อย่อยที่ 13: Primary Key และ Foreign Key กับ Data Integrity

`Data Integrity` คือความถูกต้องและสอดคล้องของข้อมูลในระบบ ซึ่ง key ทั้งสองมีบทบาทมาก

```sql
-- ตัวอย่าง schema ที่ช่วยรักษาความถูกต้องของข้อมูล
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_id BIGINT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
```

### สิ่งที่ควรเข้าใจ

- พนักงานทุกคนต้องอยู่ในแผนกที่มีอยู่จริง
- ลดความเสี่ยงจากข้อมูลสะกดไม่ตรงหรืออ้างอิงกันผิด
- ทำให้รายงานและ `JOIN` เชื่อถือได้มากขึ้น

---

## หัวข้อย่อยที่ 14: ควรสร้าง Index บน Foreign Key หรือไม่

ในงานจริง คอลัมน์ที่เป็น `FOREIGN KEY` มักถูกใช้ใน `JOIN` และ `WHERE` บ่อย จึงควรพิจารณาเรื่อง index ด้วย

```sql
-- index สำหรับ foreign key ที่ใช้ join บ่อย
CREATE INDEX idx_orders_customer_id
    ON orders(customer_id);
```

### สิ่งที่ควรเข้าใจ

- ช่วยให้ query ที่ join หรือ filter เร็วขึ้น
- โดยเฉพาะตารางที่มีข้อมูลจำนวนมาก
- key ที่ดีควรมาพร้อมการออกแบบ performance ที่เหมาะสม

---

## หัวข้อย่อยที่ 15: ตัวอย่างระบบจริงแบบ departments และ employees

ตัวอย่างนี้สะท้อนโครงสร้างที่ใช้จริงในระบบ HR หรือระบบองค์กร

```sql
-- ตารางแผนก
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ตารางพนักงาน
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_id BIGINT NOT NULL,
    employee_code VARCHAR(30) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    hired_at DATE NOT NULL,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
```

```sql
-- ดึงรายชื่อพนักงานพร้อมชื่อแผนก
SELECT
    e.employee_code,
    e.full_name,
    d.department_name
FROM employees AS e
JOIN departments AS d
    ON e.department_id = d.department_id;
```

### สิ่งที่ควรเข้าใจ

- `department_id` เป็นตัวเชื่อมระหว่างพนักงานกับแผนก
- ชื่อแผนกถูกเก็บเพียงครั้งเดียวในตาราง `departments`
- ลดข้อมูลซ้ำและทำให้แก้ไขข้อมูลได้จากจุดเดียว

---

## Best Practices สำหรับงานจริง

### 1) ใช้ surrogate key เป็น primary key ในหลายกรณี

```sql
-- รูปแบบที่นิยมในงานจริง
customer_id BIGINT PRIMARY KEY AUTO_INCREMENT
```

ช่วยให้ schema ยืดหยุ่นและลดผลกระทบเมื่อข้อมูลทางธุรกิจเปลี่ยน

### 2) ใช้ UNIQUE กับ business key ที่ต้องไม่ซ้ำ

```sql
-- email ไม่ควรซ้ำ แม้ไม่ใช้เป็น primary key
email VARCHAR(150) NOT NULL UNIQUE
```

### 3) ตั้งชื่อ foreign key constraint ให้ชัด

```sql
CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
```

### 4) หลีกเลี่ยงการลบแบบ cascade โดยไม่จำเป็น

ต้องแน่ใจว่าผลกระทบต่อข้อมูลปลายทางเป็นไปตามที่ธุรกิจต้องการจริง

### 5) ออกแบบ key ให้สอดคล้องกับ query ที่จะใช้จริง

เช่น ระบบที่ต้อง `JOIN` order กับ customer บ่อย ควรมีทั้ง `FOREIGN KEY` และ index ที่เหมาะสม

### 6) อย่าใช้ข้อมูลที่เปลี่ยนบ่อยเป็น primary key

เช่น email, phone, หรือชื่อ เพราะอาจเปลี่ยนในอนาคตและกระทบหลายตาราง

---

## ข้อควรระวัง

- อย่าใส่ `FOREIGN KEY` แบบไม่เข้าใจผลต่อการลบและแก้ไขข้อมูล
- อย่าใช้ `CASCADE` โดยไม่วิเคราะห์ผลกระทบ
- อย่าคิดว่า `PRIMARY KEY` กับ `UNIQUE` เหมือนกันทั้งหมด เพราะหน้าที่ต่างกัน
- อย่าลืมว่า `PRIMARY KEY` ห้ามเป็น `NULL`
- อย่าปล่อยให้ตารางสำคัญไม่มี key ชัดเจน เพราะจะกระทบทั้ง query และ data quality

## สรุป

`Primary Key` และ `Foreign Key` เป็นแกนหลักของการออกแบบฐานข้อมูลเชิงสัมพันธ์ใน MySQL โดย `Primary Key` ใช้ระบุแต่ละแถวให้ไม่ซ้ำ และ `Foreign Key` ใช้เชื่อมความสัมพันธ์ระหว่างตารางอย่างถูกต้อง

เมื่อเข้าใจสองเรื่องนี้ คุณจะออกแบบ schema ได้ดีขึ้น เขียน `JOIN` ได้แม่นขึ้น และรักษา `data integrity` ได้ตั้งแต่ระดับฐานข้อมูล ซึ่งเป็นพื้นฐานสำคัญของงานพัฒนาระบบจริง

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `Database Design with MySQL`
- `MySQL JOIN for Real Projects`
- `Constraints and Data Integrity in MySQL`
- `Indexes and Query Performance in MySQL`
- `Transactions in MySQL`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียนคำสั่งสร้างตาราง `departments` ที่มี `department_id` เป็น `PRIMARY KEY`

### แบบฝึกหัด 2
เขียนคำสั่งสร้างตาราง `employees` ที่มี `department_id` เป็น `FOREIGN KEY` ไปยัง `departments`

### แบบฝึกหัด 3
อธิบายความแตกต่างระหว่าง `PRIMARY KEY` และ `FOREIGN KEY` แบบสั้น ๆ

### แบบฝึกหัด 4
เขียน query เพื่อแสดงรายชื่อพนักงานพร้อมชื่อแผนก

### แบบฝึกหัด 5
อธิบายว่า `ON DELETE RESTRICT` และ `ON DELETE SET NULL` ต่างกันอย่างไร

## เฉลยแบบย่อ

```sql
-- ข้อ 1
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL
);

-- ข้อ 2
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_id BIGINT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ข้อ 4
SELECT
    e.full_name,
    d.department_name
FROM employees AS e
JOIN departments AS d
    ON e.department_id = d.department_id;
```



---

## 9. Indexing in MySQL

> Source File: `Indexing in MySQL.md`


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



---

## 10. Transactions in MySQL

> Source File: `Transactions in MySQL.md`


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



---

## 11. MySQL Views and Stored Procedures

> Source File: `MySQL Views and Stored Procedures.md`


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



---

## 12. MySQL Query Optimization Basics

> Source File: `MySQL Query Optimization Basics.md`


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

