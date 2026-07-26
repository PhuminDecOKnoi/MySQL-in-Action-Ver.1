# Legacy Topic Mapping — 12 บทเดิมสู่หลักสูตร MySQL 8.4 LTS

> ใช้สำหรับผู้เรียนและผู้สอนที่เคยอ้างอิง `MySQL-All-lesson.md` รุ่นเดิม

## เหตุผลที่ปรับโครงสร้าง

โครงเดิมรวมบทเรียน 12 หัวข้อไว้ในไฟล์เดียว ทำให้:

- ตรวจ version และ compatibility ได้ยาก
- มีเนื้อหาซ้ำและเกิด version drift
- ใช้หลาย schema ทำให้ Lab ไม่ต่อเนื่อง
- ไม่มี instructor guide, assessment rubric และ reproducible environment

หลักสูตรใหม่จึงแยกเป็น modules และใช้ฐานข้อมูลตัวอย่างเดียวตลอดหลักสูตร

## Mapping Table

| หัวข้อเดิม | สถานะ | ตำแหน่งใหม่ | สิ่งที่เพิ่มหรือปรับปรุง |
|---|---|---|---|
| MySQL SELECT Basics | Updated | [Module 3](03-querying-and-analytics.md) | explicit columns, aliases และ deterministic ordering |
| Filtering Data with WHERE | Updated | [Module 3](03-querying-and-analytics.md) | `NULL`, operator precedence, range predicates และ sargability |
| Sorting and Limiting Results | Updated | [Module 3](03-querying-and-analytics.md), [Module 5](05-indexing-and-performance.md) | deterministic sort และ keyset pagination |
| MySQL JOIN for Real Projects | Updated | [Module 3](03-querying-and-analytics.md) | join cardinality, row multiplication และ pre-aggregation |
| Aggregate Functions | Updated | [Module 3](03-querying-and-analytics.md) | `NULL` behavior และ business metrics |
| GROUP BY and HAVING | Updated | [Module 3](03-querying-and-analytics.md) | `ONLY_FULL_GROUP_BY`, CTE และ window functions |
| Database Design with MySQL | Expanded | [Module 2](02-foundations-and-data-modeling.md) | normalization, data types, generated columns และ integrity design |
| Primary Key and Foreign Key | Expanded | [Module 2](02-foundations-and-data-modeling.md) | referential actions, constraints และ key trade-offs |
| Indexing in MySQL | Expanded | [Module 5](05-indexing-and-performance.md) | composite, covering และ invisible indexes |
| Transactions in MySQL | Expanded | [Module 4](04-transactions-and-concurrency.md) | isolation, locking reads, deadlocks และ savepoints |
| Views and Stored Procedures | Updated | [Module 3](03-querying-and-analytics.md), [Module 4](04-transactions-and-concurrency.md) | maintainability และ transaction boundaries |
| Query Optimization Basics | Expanded | [Module 5](05-indexing-and-performance.md) | `EXPLAIN ANALYZE`, actual vs estimated rows และ query rewrite |

## New Topics Added

- MySQL LTS and Innovation release model
- Docker-based reproducible environment
- `CHECK` constraints and generated columns
- Common Table Expressions
- Window Functions
- JSON data type and functions
- Keyset pagination
- Locking reads with `FOR UPDATE`
- Isolation levels and deadlock handling
- Roles and Least Privilege
- Backup scope, RPO, RTO and restore drill
- Capstone Project and grading rubric

## Migration Guidance

1. เริ่มด้วย [Module 1](01-setup-and-versioning.md)
2. ใช้ [Module 2](02-foundations-and-data-modeling.md) เตรียม schema
3. ใช้ [Module 3](03-querying-and-analytics.md) แทนบท SELECT–HAVING และ Views
4. ใช้ [Module 4](04-transactions-and-concurrency.md) แทน Transactions
5. ใช้ [Module 5](05-indexing-and-performance.md) แทน Indexing และ Optimization
6. ปิดด้วย [Module 6](06-security-backup-and-operations.md) และ [Module 7](07-capstone-project.md)

## Current Sources

- [`../examples/00-schema.sql`](../examples/00-schema.sql)
- [`../examples/01-seed.sql`](../examples/01-seed.sql)
- [`../examples/02-labs.sql`](../examples/02-labs.sql)

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
