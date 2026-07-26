# MySQL in Action — Course Modules

> **Teaching baseline:** MySQL Community Server 8.4 LTS  
> **Validated patch:** 8.4.10  
> **License:** MIT

เอกสารนี้เป็นสารบัญหลักของโฟลเดอร์ `docs/` และเป็นจุดเริ่มต้นสำหรับผู้เรียนที่ต้องการเรียนตามลำดับ

## Recommended Learning Path

| ลำดับ | Module | เป้าหมาย |
|---:|---|---|
| 0 | [Instructor Guide](00-instructor-guide.md) | รูปแบบหลักสูตร เวลา การประเมิน และแนวทางสอน |
| 1 | [Setup and Versioning](01-setup-and-versioning.md) | ติดตั้ง ตรวจ version และเข้าใจ LTS/Innovation tracks |
| 2 | [Foundations and Data Modeling](02-foundations-and-data-modeling.md) | ออกแบบ schema, data types, keys และ constraints |
| 3 | [Querying and Analytics](03-querying-and-analytics.md) | SELECT, JOIN, aggregation, CTE, window functions และ views |
| 4 | [Transactions and Concurrency](04-transactions-and-concurrency.md) | ACID, locking, isolation, savepoint และ deadlock |
| 5 | [Indexing and Performance](05-indexing-and-performance.md) | Index design, EXPLAIN ANALYZE และ query optimization |
| 6 | [Security, Backup and Operations](06-security-backup-and-operations.md) | Users, roles, least privilege, backup และ restore |
| 7 | [Capstone Project](07-capstone-project.md) | ประยุกต์ทุก module ในโครงการ Sales Analytics |
| 8 | [Legacy Topic Mapping](08-legacy-topic-mapping.md) | เทียบหัวข้อเดิม 12 บทกับโครงหลักสูตรใหม่ |
| 9 | [Course Maintenance Checklist](09-course-maintenance-checklist.md) | ตรวจ version, content, security และ release readiness |
| 10 | [License Transition Notes](10-license-transition-notes.md) | บันทึกการเปลี่ยน License จาก GPL-3.0 เป็น MIT |

## Course Formats

### Self-Paced

เรียน Module 1–7 ตามลำดับ พร้อมรันไฟล์ใน `examples/`

### 12-Hour Course

เน้น Module 1–5 และสรุป Security/Backup จาก Module 6

### 18-Hour Course

เรียน Module 1–7 พร้อม Guided Labs และ Capstone review

### One-Day Workshop

ใช้ schema/seed ที่เตรียมไว้ แล้วเน้น Querying, Transactions และ Performance Lab

## Practical Files

- [`../examples/00-schema.sql`](../examples/00-schema.sql) — schema และ constraints
- [`../examples/01-seed.sql`](../examples/01-seed.sql) — sample data
- [`../examples/02-labs.sql`](../examples/02-labs.sql) — guided labs

## Documentation Rules

- ใช้ `docs/` เป็นแหล่งเนื้อหาหลักเพียงชุดเดียว
- ใช้ `MySQL-All-lesson.md` เป็น consolidated navigation guide
- ตัวอย่างต้องรองรับ MySQL 8.4 LTS
- ตรวจ Release Notes เมื่อเปลี่ยน patch version
- ห้ามคัดลอกข้อความยาวจากหนังสือหรือเว็บไซต์
- ทุก module ต้องมี Learning Objectives, Lab, Common Mistakes และ Checkpoint

## License

เอกสารและตัวอย่างใน repository นี้เผยแพร่ภายใต้ [MIT License](../LICENSE)
