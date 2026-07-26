# Legacy Topic Mapping — 12 บทเดิมสู่หลักสูตร MySQL 8.4 LTS

> เอกสารนี้ใช้สำหรับผู้เรียนและผู้สอนที่เคยอ้างอิง `MySQL-All-lesson.md` รุ่นเดิม ซึ่งรวม 12 บทไว้ในไฟล์เดียว

## เหตุผลที่ปรับโครงสร้าง

โครงเดิมเหมาะกับการอ่านต่อเนื่อง แต่มีข้อจำกัดเมื่อใช้สอนและดูแลระยะยาว:

- เนื้อหาซ้ำและแก้ version ยาก
- ตัวอย่างใช้หลายฐานข้อมูลตัวอย่าง ทำให้ Lab ไม่ต่อเนื่อง
- ไม่มี version policy ที่ชัดเจน
- หัวข้อ MySQL รุ่นใหม่กระจายหรือยังไม่ครอบคลุม
- ไม่มี instructor guide, assessment rubric และ reproducible environment

หลักสูตรใหม่จึงแยกเป็น modules และใช้ฐานข้อมูลตัวอย่างเดียวตลอดหลักสูตร

## Mapping Table

| หัวข้อเดิม | สถานะ | ตำแหน่งใหม่ | สิ่งที่เพิ่มหรือปรับปรุง |
|---|---|---|---|
| MySQL SELECT Basics | Updated | [Module 3](03-querying-and-analytics.md) | explicit columns, aliases, deterministic ordering และ production-style queries |
| Filtering Data with WHERE | Updated | [Module 3](03-querying-and-analytics.md) | `NULL`, operator precedence, range predicates และ sargability |
| Sorting and Limiting Results | Updated | [Module 3](03-querying-and-analytics.md), [Module 5](05-indexing-and-performance.md) | deterministic sort, pagination และ keyset pagination |
| MySQL JOIN for Real Projects | Updated | [Module 3](03-querying-and-analytics.md) | join cardinality, row multiplication และ pre-aggregation |
| Aggregate Functions | Updated | [Module 3](03-querying-and-analytics.md) | `NULL` behavior, business metrics และ analytics patterns |
| GROUP BY and HAVING | Updated | [Module 3](03-querying-and-analytics.md) | `ONLY_FULL_GROUP_BY`, CTE และ window functions |
| Database Design with MySQL | Expanded | [Module 2](02-foundations-and-data-modeling.md) | normalization, data types, generated columns และ integrity design |
| Primary Key and Foreign Key | Expanded | [Module 2](02-foundations-and-data-modeling.md) | referential actions, constraints และ key trade-offs |
| Indexing in MySQL | Expanded | [Module 5](05-indexing-and-performance.md) | composite indexes, leftmost prefix, covering/invisible indexes และ selectivity |
| Transactions in MySQL | Expanded | [Module 4](04-transactions-and-concurrency.md) | isolation, locking reads, deadlocks, savepoints และ concurrent sessions |
| Views and Stored Procedures | Updated | [Module 3](03-querying-and-analytics.md), [Module 4](04-transactions-and-concurrency.md) | view maintainability, routine boundaries และ transaction considerations |
| Query Optimization Basics | Expanded | [Module 5](05-indexing-and-performance.md) | `EXPLAIN ANALYZE`, actual vs estimated rows, filesort และ query rewrite |

## New Topics Added

หัวข้อต่อไปนี้ไม่มีโครงสร้างชัดเจนในบทเรียนรวมเดิม และได้รับการเพิ่มในรุ่นใหม่:

- MySQL release model: LTS, Innovation และ patch policy
- Docker-based reproducible environment
- `CHECK` constraints และ generated columns
- Common Table Expressions (CTE)
- Window Functions
- JSON data type and functions
- Keyset pagination
- Locking reads with `FOR UPDATE`
- Isolation levels and deadlock handling
- Roles and Least Privilege
- Backup scope, RPO, RTO และ restore drill
- Capstone Project และ grading rubric

## Migration Guidance for Instructors

### เดิมสอนจากไฟล์รวม

ให้เปลี่ยนจากการเปิดหัวข้อใน `MySQL-All-lesson.md` รุ่นเดิม เป็นการเปิด module ตามนี้:

1. เริ่มด้วย [Module 1](01-setup-and-versioning.md)
2. ใช้ [Module 2](02-foundations-and-data-modeling.md) เตรียม schema
3. ใช้ [Module 3](03-querying-and-analytics.md) แทนบท SELECT–HAVING และ Views
4. ใช้ [Module 4](04-transactions-and-concurrency.md) แทน Transactions
5. ใช้ [Module 5](05-indexing-and-performance.md) แทน Indexing และ Optimization
6. ปิดหลักสูตรด้วย [Module 6](06-security-backup-and-operations.md) และ [Module 7](07-capstone-project.md)

### เดิมใช้ตัวอย่างหลาย schema

ให้เปลี่ยนมาใช้:

- [`../examples/00-schema.sql`](../examples/00-schema.sql)
- [`../examples/01-seed.sql`](../examples/01-seed.sql)
- [`../examples/02-labs.sql`](../examples/02-labs.sql)

เพื่อให้ผู้เรียนเห็นข้อมูลชุดเดียวตั้งแต่ schema, query, transaction จนถึง performance analysis

## Content Status

| รายการ | สถานะ |
|---|---|
| บทเรียนเดิม 12 หัวข้อ | Mapped และ updated |
| Legacy duplicated content | Removed from maintained path |
| Current source of truth | `docs/` และ `examples/` |
| Consolidated guide | `MySQL-All-lesson.md` |
| License | MIT |
| Teaching baseline | MySQL Community Server 8.4 LTS |

---

เอกสารนี้เผยแพร่ภายใต้ [MIT License](../LICENSE)
