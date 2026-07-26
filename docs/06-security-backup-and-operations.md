# Module 6 — Security, Backup and Operations

## Learning Objectives

ผู้เรียนจะสามารถ:

- แยก administrative, application และ read-only accounts
- ใช้ Role และหลัก Least Privilege
- หลีกเลี่ยง SQL Injection ด้วย prepared statements ที่ชั้น application
- สำรองและกู้คืนข้อมูลด้วย `mysqldump`
- อธิบาย RPO, RTO และการทดสอบ restore
- ตรวจสอบ metadata และสถานะพื้นฐานของ MySQL

## 1. Least Privilege

บัญชีแต่ละประเภทควรมีสิทธิ์เท่าที่จำเป็น:

| Account | หน้าที่ | สิทธิ์โดยประมาณ |
|---|---|---|
| DBA/Admin | ดูแล instance | Administrative privileges |
| Migration | เปลี่ยน schema | CREATE, ALTER, INDEX |
| Application | อ่านและเขียนข้อมูล | SELECT, INSERT, UPDATE, DELETE |
| Reporting | อ่านข้อมูล | SELECT |

ไม่ควรใช้ `root` เป็น application account

## 2. Roles

```sql
CREATE ROLE
    'app_read',
    'app_write';

GRANT SELECT
ON mysql_in_action.*
TO 'app_read';

GRANT SELECT, INSERT, UPDATE, DELETE
ON mysql_in_action.*
TO 'app_write';
```

สร้างผู้ใช้และกำหนด role:

```sql
CREATE USER 'report_user'@'%'
IDENTIFIED BY 'replace-with-strong-secret';

GRANT 'app_read' TO 'report_user'@'%';
SET DEFAULT ROLE 'app_read' TO 'report_user'@'%';

SHOW GRANTS FOR 'report_user'@'%';
```

Role ช่วยจัดกลุ่มสิทธิ์และลดการ grant ทีละสิทธิ์ให้ผู้ใช้จำนวนมาก

## 3. SQL Injection

การป้องกันหลักอยู่ที่ application layer ด้วย parameterized query หรือ prepared statement

ตัวอย่างแนวคิดด้วย PHP PDO:

```php
$stmt = $pdo->prepare(
    'SELECT order_id, order_status
     FROM orders
     WHERE customer_id = :customer_id'
);

$stmt->execute([
    'customer_id' => $customerId,
]);
```

ห้ามนำ input ต่อเป็น SQL string โดยตรง

## 4. Secret Management

- ไม่ commit `.env`
- ไม่ใส่ password ใน source code
- เปลี่ยน default password ก่อนใช้งานจริง
- แยก secret ตาม environment
- จำกัด host ที่ account สามารถเชื่อมต่อ
- rotate credentials ตามความเสี่ยง

## 5. Backup ด้วย mysqldump

สำรอง database:

```bash
mysqldump \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  -u backup_user -p \
  mysql_in_action > mysql_in_action.sql
```

`--single-transaction` เหมาะกับ InnoDB เพื่อให้ logical backup สอดคล้องโดยลดการ lock แบบเต็มตาราง

## 6. Restore

สร้าง database เป้าหมายและกู้คืน:

```bash
mysql -uroot -p -e \
  "CREATE DATABASE mysql_in_action_restore CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;"

mysql -uroot -p mysql_in_action_restore < mysql_in_action.sql
```

หลัง restore ต้องตรวจสอบ:

```sql
USE mysql_in_action_restore;
SHOW TABLES;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
CHECK TABLE customers, products, orders, order_items, payments;
```

## 7. RPO และ RTO

- **RPO**: ยอมเสียข้อมูลย้อนหลังได้มากเท่าไร
- **RTO**: ระบบต้องกลับมาใช้งานได้ภายในเวลาเท่าไร

Backup schedule ต้องออกแบบจาก RPO/RTO ไม่ใช่จากความสะดวกเพียงอย่างเดียว

## 8. Backup Strategy

อย่างน้อยควรตอบให้ได้ว่า:

- สำรองอะไร
- สำรองบ่อยแค่ไหน
- เก็บที่ใด
- เข้ารหัสหรือไม่
- ใครเข้าถึงได้
- เก็บนานเท่าไร
- ทดสอบ restore ครั้งล่าสุดเมื่อใด

## 9. Metadata และ Health Checks

```sql
SHOW DATABASES;
SHOW TABLE STATUS FROM mysql_in_action;
SHOW INDEX FROM mysql_in_action.orders;
SHOW PROCESSLIST;
SELECT NOW(), @@hostname, @@version;
```

สำหรับการสอน ให้เน้นการอ่านผลลัพธ์และไม่ใช้คำสั่ง administrative ที่มีผลกระทบโดยไม่จำเป็น

## 10. Upgrade Readiness

ก่อน upgrade:

1. อ่าน release notes
2. ตรวจ supported platform
3. สำรองข้อมูล
4. ทดสอบ restore
5. ทดสอบ application และ query สำคัญ
6. ตรวจ deprecated/removed features
7. วาง rollback หรือ recovery plan

## Lab 6

1. สร้าง `app_read` และ `app_write`
2. สร้าง reporting user และกำหนด default role
3. ยืนยันว่า reporting user แก้ข้อมูลไม่ได้
4. ทำ logical backup
5. Restore ไป database ใหม่
6. เปรียบเทียบ row count ระหว่างต้นทางและปลายทาง

## Common Mistakes

- ให้สิทธิ์ `ALL PRIVILEGES` โดยไม่จำเป็น
- ใช้ account เดียวทุก environment
- เก็บ password ใน Git
- สำรองข้อมูลแต่ไม่เคย restore
- ไม่รวม routines, triggers หรือ events ใน backup ที่ต้องการ
- upgrade production โดยไม่ทดสอบ application

## Checkpoint

- Role ช่วย governance ด้านสิทธิ์อย่างไร?
- Backup กับ replication ต่างกันอย่างไร?
- เหตุใด restore test จึงเป็นส่วนหนึ่งของ backup process?
