# MySQL All Lessons — Current Consolidated Course Guide

> **Teaching baseline:** MySQL Community Server 8.4 LTS  
> **Validated patch:** MySQL 8.4.10  
> **Last reviewed:** 26 July 2026  
> **License:** MIT

ไฟล์นี้เป็นคู่มือรวมสำหรับหลักสูตร **MySQL in Action — Free Learning Edition** โดยเนื้อหาเต็มที่ดูแลเป็นปัจจุบันอยู่ใน [`docs/`](docs/) และ SQL ที่ใช้รันจริงอยู่ใน [`examples/`](examples/)

โครงเดิมรวมบทเรียน 12 หัวข้อไว้ในไฟล์เดียว ทำให้เกิดเนื้อหาซ้ำและ version drift จึงปรับใหม่ตามหลัก **One Source of Truth**:

- `docs/` = เนื้อหาหลัก
- `examples/` = schema, seed data และ labs
- ไฟล์นี้ = course overview, navigation และ teaching checklist

## Course Map

| Module | เนื้อหา | เอกสาร |
|---|---|---|
| 0 | Instructor Guide, course formats และ assessment | [`docs/00-instructor-guide.md`](docs/00-instructor-guide.md) |
| 1 | Setup, Docker, version policy และ release model | [`docs/01-setup-and-versioning.md`](docs/01-setup-and-versioning.md) |
| 2 | Database design, data types, keys และ constraints | [`docs/02-foundations-and-data-modeling.md`](docs/02-foundations-and-data-modeling.md) |
| 3 | SELECT, JOIN, aggregation, CTE, window functions, views และ JSON | [`docs/03-querying-and-analytics.md`](docs/03-querying-and-analytics.md) |
| 4 | Transactions, locking, isolation, savepoint และ deadlock | [`docs/04-transactions-and-concurrency.md`](docs/04-transactions-and-concurrency.md) |
| 5 | Indexing, execution plans, optimization และ pagination | [`docs/05-indexing-and-performance.md`](docs/05-indexing-and-performance.md) |
| 6 | Users, roles, least privilege, backup, restore และ operations | [`docs/06-security-backup-and-operations.md`](docs/06-security-backup-and-operations.md) |
| 7 | Sales Analytics Capstone Project | [`docs/07-capstone-project.md`](docs/07-capstone-project.md) |
| 8 | Mapping จากบทเรียนเดิม 12 หัวข้อ | [`docs/08-legacy-topic-mapping.md`](docs/08-legacy-topic-mapping.md) |

---

## 1. Environment and Version Check

```sql
SELECT VERSION();
SELECT @@SESSION.sql_mode;
SELECT @@character_set_server, @@collation_server;
```

แนวทางของหลักสูตร:

- ใช้ MySQL Community Server 8.4 LTS เป็นฐาน
- pin Docker image เป็น patch ที่ผ่านการตรวจ
- ตรวจ Release Notes ก่อนเปลี่ยน patch
- ไม่ใช้ตัวอย่าง MySQL 5.x โดยไม่ตรวจ compatibility

---

## 2. Database Design and Integrity

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

- ใช้ constraints ป้องกันข้อมูลผิดตั้งแต่ database layer
- ใช้ `DECIMAL` กับข้อมูลการเงิน
- หลีกเลี่ยงหลายค่าในคอลัมน์เดียว
- ออกแบบ referential actions อย่างตั้งใจ

---

## 3. Querying and Analytics

### SELECT, WHERE, ORDER BY และ LIMIT

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

### JOIN

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

### Aggregate Functions, GROUP BY และ HAVING

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

### Common Table Expression

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
    ON d.department_id = s.department_id;
```

### Window Function

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

---

## 4. Transactions and Concurrency

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

แนวปฏิบัติ:

- เปิด transaction ให้สั้น
- เข้าถึง resource ตามลำดับเดียวกันเพื่อลด deadlock
- จับ error แล้ว `ROLLBACK`
- ทดสอบด้วยหลาย sessions

---

## 5. Indexing and Query Optimization

```sql
CREATE INDEX idx_orders_status_created
    ON orders (order_status, created_at DESC);
```

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

Sargable date filter:

```sql
WHERE created_at >= '2026-07-01 00:00:00'
  AND created_at <  '2026-07-02 00:00:00';
```

Keyset pagination:

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

---

## 6. Security, Backup and Operations

```sql
CREATE USER 'sales_app'@'%'
IDENTIFIED BY 'replace-with-a-secret';

CREATE ROLE 'sales_reader';
GRANT SELECT ON sales_training.* TO 'sales_reader';
GRANT 'sales_reader' TO 'sales_app'@'%';
SET DEFAULT ROLE 'sales_reader' TO 'sales_app'@'%';
```

Backup:

```bash
mysqldump \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --databases sales_training \
  > sales_training.sql
```

Restore:

```bash
mysql < sales_training.sql
```

Backup ยังไม่ถือว่าสมบูรณ์จนกว่าจะ restore และตรวจ critical queries ได้จริง

---

## 7. Capstone Project

ผู้เรียนต้องส่ง:

- ERD หรือ schema explanation
- SQL schema พร้อม constraints
- seed data
- operational และ analytical queries
- CTE หรือ window function
- transaction workflow
- index proposal พร้อม `EXPLAIN ANALYZE`
- user/role design
- backup และ restore checklist
- README สำหรับการรันโครงการ

รายละเอียด: [`docs/07-capstone-project.md`](docs/07-capstone-project.md)

---

## Lab Files

| File | หน้าที่ |
|---|---|
| [`examples/00-schema.sql`](examples/00-schema.sql) | schema, constraints และ indexes |
| [`examples/01-seed.sql`](examples/01-seed.sql) | sample data |
| [`examples/02-labs.sql`](examples/02-labs.sql) | guided labs |

## Teaching Checklist

### ก่อนสอน

- [ ] ตรวจ `SELECT VERSION()`
- [ ] ตรวจ schema และ seed scripts
- [ ] เตรียม SQL client
- [ ] ยืนยันว่าไม่มี secret หรือข้อมูลจริง

### ระหว่างสอน

- [ ] ให้ผู้เรียนคาดการณ์ผลก่อนรัน query
- [ ] สาธิต error cases
- [ ] อ่าน execution plan ก่อนเพิ่ม index
- [ ] ใช้สอง sessions ใน transaction lab

### หลังสอน

- [ ] ตรวจ Capstone ตาม rubric
- [ ] ให้ผู้เรียนอธิบาย trade-offs
- [ ] ทดลอง restore backup

## License

เนื้อหาและตัวอย่างของ repository นี้เผยแพร่ภายใต้ [MIT License](LICENSE)

External books, manuals, websites, trademarks และ linked resources ยังคงอยู่ภายใต้สิทธิของเจ้าของเดิม และไม่ถูกรวมอยู่ใน MIT grant ของ repository นี้

---

**Status:** Maintained  
**Source of truth:** `docs/` และ `examples/`  
**Version authority:** MySQL 8.4 Reference Manual และ MySQL 8.4 Release Notes
