# MySQL All Lessons — Current Consolidated Course Guide

> **Teaching baseline:** MySQL Community Server 8.4 LTS  
> **Validated patch:** MySQL 8.4.10  
> **Last reviewed:** 26 July 2026  
> **License:** MIT

ไฟล์นี้เป็นคู่มือรวมสำหรับหลักสูตร **MySQL in Action — Free Learning Edition** ทำหน้าที่เป็นสารบัญและเส้นทางเรียนฉบับเดียว โดยเนื้อหาเต็มและ Lab ที่ดูแลเป็นปัจจุบันอยู่ในโฟลเดอร์ [`docs/`](docs/) และ [`examples/`](examples/)

ไฟล์รวมรุ่นเดิมมีบทเรียน 12 หัวข้อซ้ำอยู่ในไฟล์เดียว ทำให้แก้ไข version และตรวจความสอดคล้องได้ยาก จึงปรับใหม่ให้ใช้หลัก **One Source of Truth** ดังนี้:

- เนื้อหาหลักอยู่ใน `docs/`
- SQL ที่ใช้รันจริงอยู่ใน `examples/`
- ไฟล์นี้ใช้สำหรับ navigation, overview และ teaching checklist
- หัวข้อเก่าถูก map เข้ากับโมดูลใหม่ทั้งหมด

---

## Course Map

| Module | เนื้อหาหลัก | เอกสาร |
|---|---|---|
| 0 | Instructor Guide, course formats และ assessment | [`docs/00-instructor-guide.md`](docs/00-instructor-guide.md) |
| 1 | Setup, Docker, version policy และ release model | [`docs/01-setup-and-versioning.md`](docs/01-setup-and-versioning.md) |
| 2 | Database design, data types, keys และ constraints | [`docs/02-foundations-and-data-modeling.md`](docs/02-foundations-and-data-modeling.md) |
| 3 | SELECT, filtering, JOIN, aggregation, CTE, window functions, views และ JSON | [`docs/03-querying-and-analytics.md`](docs/03-querying-and-analytics.md) |
| 4 | Transactions, locking, isolation, savepoint และ deadlock | [`docs/04-transactions-and-concurrency.md`](docs/04-transactions-and-concurrency.md) |
| 5 | Indexing, execution plans, optimization และ pagination | [`docs/05-indexing-and-performance.md`](docs/05-indexing-and-performance.md) |
| 6 | Users, roles, least privilege, backup, restore และ operations | [`docs/06-security-backup-and-operations.md`](docs/06-security-backup-and-operations.md) |
| 7 | Sales Analytics Capstone Project | [`docs/07-capstone-project.md`](docs/07-capstone-project.md) |
| 8 | Mapping จากบทเรียนเดิม 12 หัวข้อไปยังหลักสูตรใหม่ | [`docs/08-legacy-topic-mapping.md`](docs/08-legacy-topic-mapping.md) |

---

# Part 1 — Setup and Version Control

## เป้าหมาย

ผู้เรียนต้องสามารถตรวจสอบ environment และยืนยันได้ว่ากำลังใช้ MySQL รุ่นใดก่อนเริ่ม Lab

```sql
-- ตรวจสอบ MySQL Server version
SELECT VERSION();

-- ตรวจสอบ SQL mode ของ session
SELECT @@SESSION.sql_mode;

-- ตรวจสอบ character set และ collation
SELECT
    @@character_set_server AS character_set_server,
    @@collation_server AS collation_server;
```

แนวทางของหลักสูตร:

- ใช้ MySQL Community Server 8.4 LTS เป็นฐาน
- pin Docker image เป็น patch ที่ผ่านการตรวจ
- ไม่ใช้คำสั่งจาก MySQL 5.x โดยไม่ตรวจ compatibility
- ตรวจ Release Notes ก่อนเปลี่ยน patch

รายละเอียด: [`docs/01-setup-and-versioning.md`](docs/01-setup-and-versioning.md)

---

# Part 2 — Database Design and Data Integrity

## หัวข้อสำคัญ

- Relational model
- Table, row, column และ schema
- Primary Key และ Foreign Key
- One-to-many และ many-to-many relationships
- Normalization เบื้องต้น
- `NOT NULL`, `UNIQUE`, `CHECK` และ referential integrity
- ชนิดข้อมูลที่เหมาะสม

```sql
CREATE TABLE departments (
    department_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    department_code VARCHAR(20) NOT NULL UNIQUE,
    department_name VARCHAR(120) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE employees (
    employee_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    department_id BIGINT UNSIGNED NOT NULL,
    employee_code VARCHAR(30) NOT NULL UNIQUE,
    full_name VARCHAR(160) NOT NULL,
    salary DECIMAL(12, 2) NOT NULL,
    hired_at DATE NOT NULL,
    CONSTRAINT chk_employees_salary CHECK (salary >= 0),
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE = InnoDB;
```

หลักคิด:

- ใช้ constraint ป้องกันข้อมูลผิดตั้งแต่ database layer
- หลีกเลี่ยงการเก็บหลายค่าในคอลัมน์เดียว
- ไม่ใช้ `FLOAT` กับข้อมูลการเงิน
- Foreign Key ต้องมี index รองรับตามรูปแบบการใช้งาน

รายละเอียด: [`docs/02-foundations-and-data-modeling.md`](docs/02-foundations-and-data-modeling.md)

---

# Part 3 — Querying and Analytics

## SELECT, WHERE, ORDER BY และ LIMIT

```sql
SELECT
    employee_id,
    full_name,
    salary,
    hired_at
FROM employees
WHERE salary >= 40000
ORDER BY salary DESC, employee_id ASC
LIMIT 20;
```

แนวปฏิบัติ:

- ระบุชื่อคอลัมน์แทน `SELECT *` ใน production-style queries
- ใช้ deterministic ordering เมื่อมี `LIMIT`
- ใช้วงเล็บเมื่อผสม `AND` และ `OR`
- ระวัง `NULL`; ใช้ `IS NULL` และ `IS NOT NULL`

## JOIN

```sql
SELECT
    e.employee_code,
    e.full_name,
    d.department_name
FROM employees AS e
INNER JOIN departments AS d
    ON d.department_id = e.department_id
ORDER BY e.employee_code;
```

## Aggregate Functions, GROUP BY และ HAVING

```sql
SELECT
    d.department_name,
    COUNT(*) AS employee_count,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS average_salary
FROM employees AS e
INNER JOIN departments AS d
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(*) >= 2
ORDER BY total_salary DESC;
```

## Common Table Expression

```sql
WITH department_summary AS (
    SELECT
        department_id,
        COUNT(*) AS employee_count,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department_id
)
SELECT
    d.department_name,
    s.employee_count,
    s.average_salary
FROM department_summary AS s
INNER JOIN departments AS d
    ON d.department_id = s.department_id
ORDER BY s.average_salary DESC;
```

## Window Function

```sql
SELECT
    department_id,
    employee_code,
    full_name,
    salary,
    DENSE_RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;
```

## View

```sql
CREATE OR REPLACE VIEW active_employee_directory AS
SELECT
    e.employee_code,
    e.full_name,
    d.department_name,
    e.hired_at
FROM employees AS e
INNER JOIN departments AS d
    ON d.department_id = e.department_id;
```

รายละเอียด: [`docs/03-querying-and-analytics.md`](docs/03-querying-and-analytics.md)

---

# Part 4 — Transactions and Concurrency

## ACID

- **Atomicity:** สำเร็จทั้งหมดหรือยกเลิกทั้งหมด
- **Consistency:** constraints และ business rules ยังคงถูกต้อง
- **Isolation:** transaction ที่ทำพร้อมกันไม่ควรเห็นสถานะที่ไม่เหมาะสม
- **Durability:** ข้อมูลที่ commit แล้วต้องคงอยู่

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 1000.00
WHERE account_id = 1
  AND balance >= 1000.00;

UPDATE accounts
SET balance = balance + 1000.00
WHERE account_id = 2;

COMMIT;
```

กรณีมีข้อผิดพลาด:

```sql
ROLLBACK;
```

ล็อกแถวก่อนแก้ไข:

```sql
START TRANSACTION;

SELECT account_id, balance
FROM accounts
WHERE account_id = 1
FOR UPDATE;

-- ตรวจสอบเงื่อนไขและ UPDATE ภายใน transaction เดียวกัน

COMMIT;
```

หลักคิด:

- เปิด transaction ให้สั้น
- เข้าถึง resource ตามลำดับเดียวกันเพื่อลด deadlock
- จับ error แล้ว rollback ใน application
- ทดสอบ concurrent sessions ไม่ใช่ทดสอบเพียง connection เดียว

รายละเอียด: [`docs/04-transactions-and-concurrency.md`](docs/04-transactions-and-concurrency.md)

---

# Part 5 — Indexing and Query Optimization

## Composite Index

```sql
CREATE INDEX idx_orders_status_created
    ON orders (order_status, created_at DESC);
```

Query ที่สอดคล้อง:

```sql
SELECT
    order_id,
    customer_id,
    created_at,
    total_amount
FROM orders
WHERE order_status = 'PAID'
ORDER BY created_at DESC
LIMIT 20;
```

## EXPLAIN ANALYZE

```sql
EXPLAIN ANALYZE
SELECT
    order_id,
    customer_id,
    total_amount
FROM orders
WHERE customer_id = 1001
ORDER BY created_at DESC
LIMIT 20;
```

สิ่งที่ต้องดู:

- จำนวนแถวที่คาดการณ์และจำนวนแถวจริง
- access method
- index ที่ถูกเลือก
- loop count
- sort และ temporary operation
- elapsed time ของแต่ละ iterator

## Sargable Date Filter

หลีกเลี่ยง:

```sql
WHERE DATE(created_at) = '2026-07-01';
```

ใช้ range predicate:

```sql
WHERE created_at >= '2026-07-01 00:00:00'
  AND created_at <  '2026-07-02 00:00:00';
```

## Keyset Pagination

```sql
SELECT
    order_id,
    created_at,
    total_amount
FROM orders
WHERE (created_at, order_id) < ('2026-07-20 12:00:00', 9500)
ORDER BY created_at DESC, order_id DESC
LIMIT 20;
```

รายละเอียด: [`docs/05-indexing-and-performance.md`](docs/05-indexing-and-performance.md)

---

# Part 6 — Security, Backup and Operations

## Application User and Least Privilege

```sql
CREATE USER 'sales_app'@'%'
IDENTIFIED BY 'replace-with-a-secret';

CREATE ROLE 'sales_reader';

GRANT SELECT
ON sales_training.*
TO 'sales_reader';

GRANT 'sales_reader'
TO 'sales_app'@'%';

SET DEFAULT ROLE 'sales_reader'
TO 'sales_app'@'%';
```

แนวปฏิบัติ:

- application ห้ามเชื่อมด้วย `root`
- แยก read, write และ administrative duties
- ไม่ commit secret ลง Git
- review privileges เป็นระยะ

## Backup

```bash
mysqldump \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --databases sales_training \
  > sales_training.sql
```

## Restore Drill

```bash
mysql < sales_training.sql
```

Backup ถือว่ายังไม่สมบูรณ์จนกว่าจะ:

1. restore ลง environment แยก
2. ตรวจ table count และ row count
3. ตรวจ critical queries
4. บันทึกเวลาที่ใช้จริงเพื่อเทียบ RTO

รายละเอียด: [`docs/06-security-backup-and-operations.md`](docs/06-security-backup-and-operations.md)

---

# Part 7 — Capstone Project

Capstone ใช้โจทย์ **Sales Analytics and Order Governance** โดยผู้เรียนต้องส่ง:

- ERD หรือ schema explanation
- SQL schema ที่มี constraints
- seed data
- operational queries
- analytical queries ที่มี CTE หรือ window function
- transaction workflow
- index proposal พร้อม `EXPLAIN ANALYZE`
- user/role design
- backup และ restore checklist
- README สำหรับการรันโครงการ

รายละเอียดและเกณฑ์คะแนน: [`docs/07-capstone-project.md`](docs/07-capstone-project.md)

---

# Lab Files

| File | หน้าที่ |
|---|---|
| [`examples/00-schema.sql`](examples/00-schema.sql) | สร้างฐานข้อมูล ตาราง constraints และ indexes เริ่มต้น |
| [`examples/01-seed.sql`](examples/01-seed.sql) | เพิ่มข้อมูลตัวอย่างสำหรับการเรียน |
| [`examples/02-labs.sql`](examples/02-labs.sql) | Guided exercises ตั้งแต่ SELECT จนถึง performance analysis |

ลำดับการรัน:

```bash
mysql -uroot -p < examples/00-schema.sql
mysql -uroot -p < examples/01-seed.sql
mysql -uroot -p < examples/02-labs.sql
```

---

# Teaching Checklist

## ก่อนสอน

- [ ] ตรวจ `SELECT VERSION()`
- [ ] ตรวจว่า schema และ seed scripts รันผ่าน
- [ ] เตรียม SQL client ให้ผู้เรียน
- [ ] อธิบายว่า Community Edition ต่างจาก Enterprise features อย่างไร
- [ ] ยืนยันว่าไม่มีข้อมูลจริงหรือ secret ใน Lab

## ระหว่างสอน

- [ ] ให้ผู้เรียนคาดการณ์ผลก่อนรัน query
- [ ] ใช้ query เดียวกันอธิบาย correctness และ performance
- [ ] สาธิต error case ไม่ใช่เฉพาะ happy path
- [ ] ให้ผู้เรียนอ่าน execution plan ก่อนเพิ่ม index
- [ ] ใช้สอง sessions ใน transaction lab

## หลังสอน

- [ ] ตรวจ Capstone ตาม rubric
- [ ] ให้ผู้เรียนอธิบาย trade-off ด้วยตนเอง
- [ ] ตรวจ restore drill
- [ ] บันทึก issue ที่พบเพื่อปรับหลักสูตรรุ่นถัดไป

---

# License

เนื้อหาและตัวอย่างของ repository นี้เผยแพร่ภายใต้ [MIT License](LICENSE)

สามารถใช้ คัดลอก แก้ไข รวม เผยแพร่ แจกจ่าย ให้สิทธิช่วงต่อ และใช้เพื่อการค้าได้ โดยต้องคงข้อความลิขสิทธิ์และข้อความอนุญาตของ MIT ไว้ในสำเนาหรือส่วนสำคัญของงาน

---

**สถานะเอกสาร:** Maintained  
**Source of truth:** `docs/` และ `examples/`  
**Version authority:** MySQL 8.4 Reference Manual และ MySQL 8.4 Release Notes
