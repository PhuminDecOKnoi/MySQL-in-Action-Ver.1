# MySQL in Action — Free Learning Edition

> หลักสูตร MySQL ภาษาไทยแบบลงมือทำ สำหรับผู้เรียน ผู้สอน และผู้พัฒนาที่ต้องการพื้นฐาน SQL ที่ถูกต้องและนำไปใช้กับงานจริงได้

[![MySQL](https://img.shields.io/badge/MySQL-8.4%20LTS-4479A1?logo=mysql&logoColor=white)](https://dev.mysql.com/doc/refman/8.4/en/)
[![Patch](https://img.shields.io/badge/Tested%20Baseline-8.4.10-blue)](https://dev.mysql.com/doc/relnotes/mysql/8.4/en/news-8-4-10.html)
[![Edition](https://img.shields.io/badge/Edition-Free%20Learning-success)](#ขอบเขตของ-free-learning-edition)
[![Language](https://img.shields.io/badge/Language-Thai%20%2B%20SQL-blue)](#รูปแบบการเรียน)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Repository นี้ได้รับการปรับโครงสร้างใหม่จากเอกสารรวมเดิมให้เป็นหลักสูตรแบบโมดูล พร้อม Instructor Guide, ฐานข้อมูลตัวอย่าง, Guided Labs, Performance Lab, Security Lab และ Capstone Project โดยเนื้อหาหลักเขียนขึ้นใหม่สำหรับ MySQL Community Server รุ่นปัจจุบันที่ใช้เป็นฐานการสอน

## เวอร์ชันอ้างอิง

ปรับปรุงล่าสุด: **26 กรกฎาคม 2026**

| รายการ | เวอร์ชันที่ใช้ |
|---|---|
| Teaching baseline | MySQL Community Server **8.4 LTS** |
| Patch ที่ตรวจสอบล่าสุด | **8.4.10** — 16 มิถุนายน 2026 |
| Release track สำหรับผู้เรียน | LTS เพื่อความเสถียรและใช้สอนได้ต่อเนื่อง |
| Innovation track | ใช้ศึกษา feature ใหม่เพิ่มเติม ไม่ใช้เป็นฐานหลักของ Lab |
| Early Access | ไม่ใช้ในหลักสูตรพื้นฐาน |

MySQL 8.4 LTS ถูกเลือกเป็นฐานหลักเพื่อให้ตัวอย่าง SQL, Docker environment และแบบฝึกหัดมีพฤติกรรมคงที่ตลอดการเรียน ขณะเดียวกันผู้ดูแล repository ต้องตรวจ Release Notes ก่อนเปลี่ยน patch หรือ baseline ทุกครั้ง

## ขอบเขตของ Free Learning Edition

- ใช้ **MySQL Community Server** และเครื่องมือที่ใช้งานได้โดยไม่ต้องซื้อ MySQL Enterprise Edition
- เนื้อหา เอกสาร และตัวอย่าง SQL ของโครงการเผยแพร่ภายใต้ **MIT License**
- เนื้อหาเขียนขึ้นใหม่เพื่อการเรียนรู้ ไม่คัดลอกข้อความจากหนังสือหรือเอกสารที่มีลิขสิทธิ์
- ครอบคลุม SQL พื้นฐาน การออกแบบฐานข้อมูล Analytics, Transactions, Indexing, Security, Backup และ Operations
- ใช้ฐานข้อมูลตัวอย่างเดียวต่อเนื่องตั้งแต่ schema design จนถึง performance tuning
- รองรับการเรียนผ่าน Docker หรือ MySQL ที่ติดตั้งในเครื่อง

## ผลลัพธ์การเรียนรู้

เมื่อเรียนครบ ผู้เรียนควรสามารถ:

1. สร้างฐานข้อมูลและตารางด้วยชนิดข้อมูลที่เหมาะสม
2. ใช้ `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `JOIN`, `GROUP BY` และ `HAVING`
3. ใช้ CTE, Window Functions, Views, Stored Procedures และ JSON เบื้องต้น
4. ออกแบบ Primary Key, Foreign Key, `UNIQUE` และ `CHECK` constraints
5. ใช้ Transaction และอธิบายปัญหา concurrency พื้นฐานได้
6. ออกแบบ Index จาก query จริง และอ่าน `EXPLAIN ANALYZE`
7. จัดการบัญชีผู้ใช้ด้วย Roles และหลัก Least Privilege
8. สำรองและกู้คืนข้อมูลด้วย `mysqldump`
9. ทำ Capstone Project ด้าน Sales Analytics ได้ครบวงจร

## โครงสร้าง Repository

```text
MySQL-in-Action-Ver.1/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── REFERENCES.md
├── MySQL-All-lesson.md
├── docker-compose.yml
├── .env.example
├── docs/
│   ├── README.md
│   ├── 00-instructor-guide.md
│   ├── 01-setup-and-versioning.md
│   ├── 02-foundations-and-data-modeling.md
│   ├── 03-querying-and-analytics.md
│   ├── 04-transactions-and-concurrency.md
│   ├── 05-indexing-and-performance.md
│   ├── 06-security-backup-and-operations.md
│   ├── 07-capstone-project.md
│   └── 08-legacy-topic-mapping.md
└── examples/
    ├── 00-schema.sql
    ├── 01-seed.sql
    └── 02-labs.sql
```

`MySQL-All-lesson.md` ได้รับการปรับจาก Legacy Combined Notes ให้เป็น **Current Consolidated Course Guide** ซึ่งเชื่อมไปยังเนื้อหาโมดูลล่าสุดและไม่ทำหน้าที่เป็นสำเนาซ้ำของบทเรียนเก่าอีกต่อไป

## เส้นทางเรียน

| Module | หัวข้อ | เวลาแนะนำ |
|---|---|---:|
| 0 | Instructor Guide และ Course Setup | 30 นาที |
| 1 | Setup, Versioning และ MySQL Release Model | 1.5 ชม. |
| 2 | SQL Foundations, Schema และ Constraints | 3 ชม. |
| 3 | Querying, JOIN, CTE และ Analytics | 4 ชม. |
| 4 | Transactions, Locking และ Isolation | 2.5 ชม. |
| 5 | Indexing, `EXPLAIN ANALYZE` และ Optimization | 3 ชม. |
| 6 | Security, Roles, Backup และ Operations | 2.5 ชม. |
| 7 | Capstone Project | 3–6 ชม. |

## เริ่มใช้งานด้วย Docker

1. สร้างไฟล์ environment จากตัวอย่าง

```bash
cp .env.example .env
```

2. แก้รหัสผ่านใน `.env` แล้วเริ่ม MySQL

```bash
docker compose up -d
```

3. โหลด schema และข้อมูลตัวอย่าง

```bash
docker compose exec -T mysql mysql -uroot -p"$MYSQL_ROOT_PASSWORD" < examples/00-schema.sql
docker compose exec -T mysql mysql -uroot -p"$MYSQL_ROOT_PASSWORD" < examples/01-seed.sql
```

4. ตรวจสอบเวอร์ชัน

```sql
SELECT VERSION();
```

> อย่า commit `.env`, password, token หรือข้อมูลจริงขององค์กรขึ้น repository

## รูปแบบการเรียน

แต่ละโมดูลประกอบด้วย:

- Learning Objectives
- Business Context
- แนวคิดและ trade-offs
- SQL ตัวอย่างพร้อม comment
- Guided Lab
- Common Mistakes
- Checkpoint Questions
- แนวทางตรวจสอบผลลัพธ์

## แนวทางสำหรับผู้สอน

เปิดจาก [`docs/00-instructor-guide.md`](docs/00-instructor-guide.md) เพื่อดูแผนสอน 12 ชั่วโมง, 18 ชั่วโมง และ Workshop แบบ 1 วัน พร้อมเกณฑ์ประเมิน Capstone

สำหรับสารบัญทุกโมดูลให้เปิด [`docs/README.md`](docs/README.md) และสำหรับผู้ที่เคยใช้บทเรียนรวม 12 หัวข้อเดิม ให้ดูแผนเทียบหัวข้อที่ [`docs/08-legacy-topic-mapping.md`](docs/08-legacy-topic-mapping.md)

## หลักการสำคัญของหลักสูตร

- **Correctness before cleverness** — ผลลัพธ์ต้องถูกต้องก่อนทำให้ query ซับซ้อน
- **Measure before optimize** — ใช้ `EXPLAIN` และ `EXPLAIN ANALYZE` ก่อนเพิ่ม index
- **Data integrity by design** — ใช้ constraints ป้องกันข้อมูลผิดตั้งแต่ schema
- **Least privilege** — ไม่ใช้ `root` เป็นบัญชีของ application
- **Backup is incomplete until restore is tested** — สำรองข้อมูลอย่างเดียวไม่พอ ต้องทดลองกู้คืน
- **One source of truth** — เนื้อหาหลักอยู่ใน `docs/`; ไฟล์รวมทำหน้าที่เป็น navigation guide

## License

โครงการนี้เผยแพร่ภายใต้ [MIT License](LICENSE) สามารถนำไปใช้ แก้ไข ดัดแปลง แจกจ่าย และใช้เพื่อการค้าได้ โดยต้องคงข้อความลิขสิทธิ์และข้อความอนุญาตของ MIT ไว้ในสำเนาหรือส่วนสำคัญของงาน

ชื่อและเครื่องหมายการค้า **MySQL** เป็นทรัพย์สินของเจ้าของเครื่องหมายการค้าที่เกี่ยวข้อง การใช้ชื่อใน repository นี้มีวัตถุประสงค์เพื่อการศึกษาและการอ้างอิงทางเทคนิค

## แหล่งอ้างอิง

ดู [`REFERENCES.md`](REFERENCES.md) โดยให้ MySQL 8.4 Reference Manual และ MySQL 8.4 Release Notes เป็น version authority หลัก

---

**MySQL in Action — Free Learning Edition**  
เรียนจาก query จริง ออกแบบจากปัญหาจริง และวัดผลด้วย execution plan จริง
