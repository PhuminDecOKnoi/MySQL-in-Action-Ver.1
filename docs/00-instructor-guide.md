# Module 0 — Instructor Guide

## จุดประสงค์

เอกสารนี้ช่วยให้ผู้สอนนำ repository ไปใช้จัดอบรมได้ทันที โดยไม่ต้องเรียงหัวข้อใหม่เอง หลักสูตรเน้นการสาธิตสั้น แล้วให้ผู้เรียนลงมือเขียน SQL กับฐานข้อมูล `mysql_in_action`

## กลุ่มเป้าหมาย

- ผู้เริ่มต้นที่เข้าใจคอมพิวเตอร์พื้นฐาน
- นักพัฒนาเว็บที่ต้องใช้ฐานข้อมูล
- Data/Business Analyst ที่ต้องเขียน SQL
- ผู้ดูแลระบบหรือผู้ตรวจสอบที่ต้องอ่านข้อมูลจากฐานข้อมูล

## ข้อกำหนดก่อนเรียน

- ใช้ Terminal หรือ Command Prompt ได้
- เข้าใจความหมายเบื้องต้นของ table, row และ column
- ติดตั้ง Docker Desktop หรือ MySQL Community Server 8.4 LTS

## แผนสอนแบบ 12 ชั่วโมง

| ช่วง | หัวข้อ | วิธีสอน |
|---|---|---|
| 1 | Setup และ SQL mental model | Demo + Lab |
| 2 | Schema, data types, constraints | Whiteboard + Lab |
| 3 | SELECT, filtering, sorting | Live coding |
| 4 | JOIN และ aggregation | Pair exercise |
| 5 | CTE และ window functions | Guided lab |
| 6 | Transactions และ locking | Simulation |
| 7 | Index และ EXPLAIN ANALYZE | Before/after benchmark |
| 8 | Security, backup และ recap | Demo + Quiz |

## แผนสอนแบบ 18 ชั่วโมง

เพิ่มเวลาสำหรับ:

- Normalization และ schema review
- Query debugging
- Isolation level experiment
- Composite index design
- Backup/restore drill
- Capstone presentation

## Workshop แบบ 1 วัน

### เช้า

1. Setup environment
2. สร้าง schema
3. Seed data
4. SELECT, WHERE, ORDER BY, LIMIT
5. JOIN และ GROUP BY

### บ่าย

1. CTE และ Window Functions
2. Transactions และ deadlock concept
3. Index และ EXPLAIN ANALYZE
4. Security ด้วย Role
5. Capstone mini challenge

## รูปแบบการสอนต่อหนึ่งหัวข้อ

ใช้วงจร 5 ขั้น:

1. **Context** — อธิบายปัญหางานจริง
2. **Concept** — อธิบายหลักการสั้น ๆ
3. **Code** — สาธิต SQL ที่รันได้
4. **Challenge** — ให้ผู้เรียนแก้โจทย์
5. **Review** — เปรียบเทียบวิธีและอ่าน execution plan

## Dataset หลัก

ใช้ระบบขายสินค้าแบบย่อ ประกอบด้วย:

- `customers`
- `products`
- `orders`
- `order_items`
- `payments`

Dataset เดียวช่วยให้ผู้เรียนเชื่อมโยงความรู้จาก schema ไปถึง analytics และ performance tuning ได้ต่อเนื่อง

## กติกาสำหรับ Lab

- ห้ามใช้ `SELECT *` ในคำตอบสุดท้าย เว้นแต่โจทย์ให้สำรวจโครงสร้าง
- ทุก query ต้องระบุเป้าหมายทางธุรกิจ
- Query ที่เกี่ยวกับ performance ต้องแนบ `EXPLAIN` หรือ `EXPLAIN ANALYZE`
- การแก้ข้อมูลหลายตารางต้องพิจารณา Transaction
- ห้ามใช้บัญชี `root` เป็นตัวอย่างบัญชี application

## เกณฑ์ประเมิน

| ด้าน | น้ำหนัก |
|---|---:|
| ความถูกต้องของผลลัพธ์ | 35% |
| การออกแบบ schema และ integrity | 20% |
| ความอ่านง่ายของ SQL | 15% |
| Performance reasoning | 15% |
| Security และ operational awareness | 15% |

## Checkpoint Questions

1. ทำไมหลักสูตรใช้ 8.4 LTS แทน Innovation release?
2. Constraint ช่วยลดภาระ validation ของ application อย่างไร?
3. เมื่อใดควรใช้ Transaction?
4. ทำไมไม่ควรสร้าง index ทุกคอลัมน์?
5. Backup ที่ไม่เคยทดสอบ restore มีความเสี่ยงอย่างไร?

## แนวทางปรับใช้กับองค์กร

ผู้สอนสามารถเปลี่ยนชื่อ entities ให้ตรงกับงานจริง เช่น:

- HR: employees, departments, attendance, payroll
- Audit: sites, findings, evidence, corrective_actions
- Sales: customers, orders, products, payments
- Training: learners, courses, enrollments, assessments

ควรรักษาแนวคิดเรื่อง key, relationship, constraints, transaction และ least privilege ไว้เหมือนเดิม
