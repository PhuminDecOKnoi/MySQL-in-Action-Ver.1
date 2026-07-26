# MySQL in Action — Free Learning Edition

> เวอร์ชันปรับปรุงสำหรับการสอนและการเรียนรู้ด้วย **MySQL Community Server 8.4 LTS**

[![MySQL](https://img.shields.io/badge/MySQL-8.4%20LTS-4479A1?logo=mysql&logoColor=white)](https://dev.mysql.com/doc/refman/8.4/en/)
[![Edition](https://img.shields.io/badge/Edition-Free%20Learning-success)](#ขอบเขตของ-free-learning-edition)
[![Language](https://img.shields.io/badge/Language-Thai%20%2B%20SQL-blue)](#รูปแบบการเรียน)

Repository นี้เป็นชุดบทเรียน MySQL ภาษาไทยแบบลงมือทำ เหมาะสำหรับผู้เริ่มต้น ผู้สอน และผู้ที่ต้องการทบทวน SQL อย่างเป็นระบบ โดยปรับจากเอกสารรวมเดิมให้เป็นหลักสูตรแบบโมดูล พร้อมฐานข้อมูลตัวอย่าง แบบฝึกหัด และ Capstone Project

## เวอร์ชันอ้างอิง

ปรับปรุงล่าสุด: **26 กรกฎาคม 2026**

| รายการ | เวอร์ชันที่ใช้ |
|---|---|
| Teaching baseline | MySQL Community Server **8.4 LTS** |
| Patch ที่ตรวจสอบล่าสุด | **8.4.10** — 16 มิถุนายน 2026 |
| Release track สำหรับผู้เรียน | LTS เพื่อความเสถียรและใช้สอนได้ต่อเนื่อง |
| Innovation track | ใช้ศึกษาเพิ่มเติม ไม่ใช้เป็นฐานหลักของ Lab |
| Early Access | ไม่ใช้ในหลักสูตรพื้นฐาน |

เหตุผลที่เลือก 8.4 LTS: เหมาะกับการเรียนและระบบที่ต้องการ feature set คงที่ มีระยะสนับสนุนยาว และลดความเสี่ยงจาก behavior change ระหว่างการสอน

## ขอบเขตของ Free Learning Edition

- ใช้ MySQL Community Server และเครื่องมือที่ใช้งานได้โดยไม่ต้องซื้อ MySQL Enterprise Edition
- เนื้อหาและตัวอย่างเขียนขึ้นใหม่สำหรับการเรียนรู้ ไม่คัดลอกข้อความจากหนังสืออ้างอิง
- มีทั้ง SQL พื้นฐาน การออกแบบฐานข้อมูล การวิเคราะห์ข้อมูล Transaction, Index, Security และ Backup
- ใช้ฐานข้อมูลตัวอย่างเดียวต่อเนื่อง เพื่อให้ผู้เรียนเห็นภาพตั้งแต่ schema จนถึง performance tuning
- รองรับการเรียนผ่าน Docker หรือ MySQL ที่ติดตั้งในเครื่อง

## ผลลัพธ์การเรียนรู้

เมื่อเรียนครบ ผู้เรียนควรสามารถ:

1. สร้างฐานข้อมูลและตารางด้วยชนิดข้อมูลที่เหมาะสม
2. ใช้ `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `JOIN`, `GROUP BY` และ `HAVING`
3. ใช้ CTE, Window Functions, Views และ JSON เบื้องต้น
4. ออกแบบ Primary Key, Foreign Key, `UNIQUE` และ `CHECK` constraints
5. ใช้ Transaction และอธิบายปัญหา concurrency พื้นฐานได้
6. ออกแบบ Index จาก query จริง และอ่าน `EXPLAIN ANALYZE`
7. จัดการบัญชีผู้ใช้ด้วย Role และหลัก Least Privilege
8. สำรองและกู้คืนข้อมูลด้วย `mysqldump`
9. ทำ Capstone Project ด้าน Sales Analytics ได้ครบวงจร

## โครงสร้าง Repository

```text
MySQL-in-Action-Ver.1/
├── README.md
├── CHANGELOG.md
├── REFERENCES.md
├── docker-compose.yml
├── .env.example
├── docs/
│   ├── 00-instructor-guide.md
│   ├── 01-setup-and-versioning.md
│   ├── 02-foundations-and-data-modeling.md
│   ├── 03-querying-and-analytics.md
│   ├── 04-transactions-and-concurrency.md
│   ├── 05-indexing-and-performance.md
│   ├── 06-security-backup-and-operations.md
│   └── 07-capstone-project.md
├── examples/
│   ├── 00-schema.sql
│   ├── 01-seed.sql
│   └── 02-labs.sql
└── MySQL-All-lesson.md
```

`MySQL-All-lesson.md` ยังคงเก็บไว้เป็น **Legacy Combined Notes** สำหรับอ้างอิงบทเรียนเดิม ส่วนผู้เรียนใหม่ควรเริ่มจาก `docs/`

## เส้นทางเรียน

| Module | หัวข้อ | เวลาแนะนำ |
|---|---|---:|
| 0 | Instructor Guide และ Course Setup | 30 นาที |
| 1 | Setup, Versioning และ MySQL Release Model | 1.5 ชม. |
| 2 | SQL Foundations, Schema และ Constraints | 3 ชม. |
| 3 | Querying, JOIN, CTE และ Analytics | 4 ชม. |
| 4 | Transactions, Locking และ Isolation | 2.5 ชม. |
| 5 | Indexing, EXPLAIN ANALYZE และ Optimization | 3 ชม. |
| 6 | Security, Roles, Backup และ Operations | 2.5 ชม. |
| 7 | Capstone Project | 3–6 ชม. |

## เริ่มใช้งานด้วย Docker

1. คัดลอกไฟล์ environment

```bash
cp .env.example .env
```

2. เริ่ม MySQL

```bash
docker compose up -d
```

3. โหลด schema และข้อมูลตัวอย่าง

```bash
docker compose exec -T mysql mysql -uroot -pchange-me < examples/00-schema.sql
docker compose exec -T mysql mysql -uroot -pchange-me < examples/01-seed.sql
```

4. ตรวจสอบเวอร์ชัน

```sql
SELECT VERSION();
```

> เปลี่ยนรหัสผ่านใน `.env` ก่อนใช้งานนอกเครื่องส่วนตัว และอย่า commit `.env` ขึ้น repository

## รูปแบบการเรียน

แต่ละโมดูลประกอบด้วย:

- Learning Objectives
- แนวคิดสำคัญ
- SQL ตัวอย่างพร้อม comment
- Lab แบบลงมือทำ
- จุดผิดพลาดที่พบบ่อย
- Checkpoint Questions
- เฉลยหรือแนวทางตรวจสอบผลลัพธ์

## แนวทางสำหรับผู้สอน

เปิดจาก [`docs/00-instructor-guide.md`](docs/00-instructor-guide.md) เพื่อดูแผนสอน 12 ชั่วโมง, 18 ชั่วโมง และ Workshop แบบ 1 วัน พร้อมเกณฑ์ประเมิน Capstone

## หลักการสำคัญของหลักสูตร

- **Correctness before cleverness** — ผลลัพธ์ต้องถูกต้องก่อนทำให้ query ซับซ้อน
- **Measure before optimize** — ใช้ `EXPLAIN` และ `EXPLAIN ANALYZE` ก่อนตัดสินใจเพิ่ม index
- **Data integrity by design** — ใช้ constraints ป้องกันข้อมูลผิดตั้งแต่ schema
- **Least privilege** — ไม่ใช้ `root` เป็นบัญชีของ application
- **Backup is incomplete until restore is tested** — สำรองข้อมูลอย่างเดียวไม่พอ ต้องทดลองกู้คืน

## แหล่งอ้างอิง

ดู [`REFERENCES.md`](REFERENCES.md) โดยให้ MySQL 8.4 Reference Manual และ Release Notes ของ Oracle เป็น version authority หลัก

---

**MySQL in Action — Free Learning Edition**  
เรียนจาก query จริง ออกแบบจากปัญหาจริง และวัดผลด้วย execution plan จริง
