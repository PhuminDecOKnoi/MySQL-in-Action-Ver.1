# Module 1 — Setup and MySQL Versioning

## Learning Objectives

ผู้เรียนจะสามารถ:

- อธิบายความต่างระหว่าง LTS และ Innovation releases
- เริ่ม MySQL 8.4 LTS ด้วย Docker Compose
- เชื่อมต่อผ่าน MySQL client
- ตรวจสอบ version, character set, collation และ SQL mode
- แยก development account ออกจาก administrative account

## 1. Release Model ที่ควรรู้

MySQL มี 2 release tracks หลัก:

### LTS

เหมาะกับการสอน ระบบ production และงานที่ต้องการ feature set คงที่ การอัปเดตภายในสาย 8.4.x เน้น bug fix และ security fix

### Innovation

เหมาะกับทีมที่ต้องการ feature ใหม่เร็ว มี automated tests และพร้อมรับ behavior change ระหว่างรุ่น

สำหรับหลักสูตรนี้ใช้ **MySQL 8.4 LTS** เพื่อให้ตัวอย่างและ Lab มีความเสถียร

## 2. เริ่มระบบด้วย Docker

ไฟล์ `docker-compose.yml` กำหนด MySQL Community Server และ health check ไว้แล้ว

```bash
cp .env.example .env
docker compose up -d
docker compose ps
```

ดู log เมื่อ server ยังไม่พร้อม:

```bash
docker compose logs -f mysql
```

## 3. เชื่อมต่อ MySQL

```bash
docker compose exec mysql mysql -uroot -p
```

ตรวจสอบข้อมูลระบบ:

```sql
SELECT VERSION() AS mysql_version;
SELECT CURRENT_USER() AS authenticated_account;
SELECT @@sql_mode AS sql_mode;
SELECT @@character_set_server AS server_charset;
SELECT @@collation_server AS server_collation;
```

## 4. Character Set

หลักสูตรใช้ `utf8mb4` เพราะรองรับ Unicode ได้ครบกว่าการใช้ `utf8mb3`

```sql
CREATE DATABASE mysql_in_action
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
```

## 5. SQL Mode

SQL mode มีผลต่อการตรวจสอบข้อมูลและ behavior ของคำสั่ง SQL

```sql
SELECT @@SESSION.sql_mode;
SELECT @@GLOBAL.sql_mode;
```

หลักสูตรไม่แนะนำให้ปิด strict behavior เพื่อหลบ error เพราะ error มักสะท้อนปัญหาคุณภาพข้อมูลหรือ schema

## 6. สร้างบัญชีสำหรับ Lab

```sql
CREATE USER 'course_user'@'%'
IDENTIFIED BY 'course-password';

GRANT SELECT, INSERT, UPDATE, DELETE,
      CREATE, ALTER, INDEX, REFERENCES,
      CREATE VIEW, SHOW VIEW
ON mysql_in_action.*
TO 'course_user'@'%';
```

ตรวจสอบสิทธิ์:

```sql
SHOW GRANTS FOR 'course_user'@'%';
```

> ในระบบจริงควรแยก migration account, application account และ read-only account

## 7. โหลด Dataset

```bash
docker compose exec -T mysql mysql -uroot -pchange-me < examples/00-schema.sql
docker compose exec -T mysql mysql -uroot -pchange-me < examples/01-seed.sql
```

ตรวจสอบ:

```sql
USE mysql_in_action;
SHOW TABLES;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
```

## Lab 1

1. แสดง MySQL version
2. แสดง character set และ collation ของ database
3. แสดงสิทธิ์ของ `course_user`
4. อธิบายเหตุผลที่ไม่ควรให้ application ใช้ `root`

## Common Mistakes

- ใช้ image tag แบบ `latest` ทำให้ environment เปลี่ยนโดยไม่ตั้งใจ
- commit รหัสผ่านจริงใน `.env`
- ใช้ `root` เชื่อมต่อจาก application
- ปิด strict mode เพื่อให้ข้อมูลผิดผ่านเข้า database
- ใช้ character set ที่ไม่รองรับข้อมูลหลายภาษา

## Checkpoint

- LTS และ Innovation ต่างกันด้านความเสถียรอย่างไร?
- `CURRENT_USER()` บอกอะไร?
- เหตุใด `utf8mb4` จึงเหมาะกับระบบใหม่?
