# Module 7 — Capstone Project: Sales Analytics and Order Integrity

## เป้าหมาย

สร้างฐานข้อมูลระบบขายขนาดย่อมที่รองรับทั้งงาน transaction และ analytics โดยผู้เรียนต้องแสดงเหตุผลด้าน schema, data integrity, query design, performance และ security

## Scenario

บริษัทต้องการระบบที่สามารถ:

- เก็บข้อมูลลูกค้าและสินค้า
- บันทึก order หลายรายการสินค้า
- บันทึกการชำระเงิน
- ป้องกันจำนวนสินค้าและยอดเงินที่ไม่สมเหตุผล
- แสดงรายงานยอดขายและอันดับสินค้า
- รองรับการค้นหา order ล่าสุดอย่างมีประสิทธิภาพ
- แยกสิทธิ์ application กับ reporting user
- สำรองและกู้คืนข้อมูลได้

## Deliverables

1. ER diagram หรือ relationship map
2. SQL schema
3. Seed data อย่างน้อย 20 customers, 20 products และ 50 orders
4. Query answers ตามโจทย์
5. Index design พร้อมเหตุผล
6. `EXPLAIN ANALYZE` ก่อนและหลังปรับปรุงอย่างน้อย 1 query
7. Transaction workflow สำหรับสร้าง order
8. Role และ user design
9. Backup และ restore evidence
10. README สรุปวิธีรัน

## Requirement A — Data Model

ต้องมีตาราง:

- `customers`
- `products`
- `orders`
- `order_items`
- `payments`

ข้อกำหนดขั้นต่ำ:

- ทุกตารางมี Primary Key
- Business identifier ที่ต้องไม่ซ้ำใช้ `UNIQUE`
- ความสัมพันธ์ใช้ Foreign Key
- จำนวนและยอดเงินใช้ `CHECK`
- ใช้ `utf8mb4`
- ใช้ InnoDB

## Requirement B — Query Challenges

### 1. Customer Order Summary

แสดงลูกค้าทุกคน รวมถึงคนที่ยังไม่มี order พร้อมจำนวน order และยอดซื้อรวม

### 2. Monthly Sales

สรุปยอดขายรายเดือน เฉพาะ order ที่ชำระแล้วหรือจัดส่งแล้ว

### 3. Top Products

จัดอันดับสินค้า 5 อันดับแรกตามจำนวนขาย โดยใช้ Window Function

### 4. Running Total

แสดงยอดขายรายวันและ running total

### 5. Customers Above Average

แสดงลูกค้าที่มียอดซื้อรวมสูงกว่าค่าเฉลี่ยของลูกค้าทั้งหมด

### 6. Unpaid Orders

แสดง order ที่ยังไม่มี payment สำเร็จ

### 7. Pagination

สร้าง keyset pagination สำหรับ order ล่าสุด

## Requirement C — Transaction

ออกแบบ workflow:

1. Lock สินค้าที่ต้องซื้อ
2. ตรวจ stock
3. สร้าง order
4. สร้าง order items
5. ลด stock
6. Commit เมื่อทุกขั้นสำเร็จ
7. Rollback เมื่อเงื่อนไขไม่ผ่าน

อธิบายว่าจุดใดอาจเกิด race condition และป้องกันอย่างไร

## Requirement D — Performance

เลือก query สำคัญ 1 รายการ แล้วทำ:

1. รัน `EXPLAIN ANALYZE`
2. บันทึก actual rows และเวลา
3. เสนอ index
4. รันซ้ำ
5. สรุป trade-off ต่อ write workload

ห้ามสรุปว่า query เร็วขึ้นโดยไม่มีผลวัด

## Requirement E — Security

สร้าง:

- `app_read`
- `app_write`
- `report_user`
- `application_user`

ยืนยันว่า reporting user อ่านได้แต่แก้ข้อมูลไม่ได้

## Requirement F — Backup and Restore

1. ทำ logical backup ด้วย `mysqldump`
2. Restore ไป database ชื่อใหม่
3. เปรียบเทียบ table list และ row counts
4. บันทึกคำสั่งและผลตรวจสอบ

## เกณฑ์ประเมิน

| หัวข้อ | คะแนน |
|---|---:|
| Schema และ constraints | 20 |
| Query correctness | 25 |
| Analytics: CTE/window functions | 15 |
| Transaction reasoning | 15 |
| Index และ performance evidence | 15 |
| Security และ backup | 10 |
| **รวม** | **100** |

## ระดับคุณภาพ

### ผ่าน

Schema ใช้งานได้ Query หลักถูกต้อง และมี transaction เบื้องต้น

### ดี

ใช้ constraints ครบ มี CTE/window functions และมีผล `EXPLAIN ANALYZE`

### ดีมาก

อธิบาย trade-off ได้ชัด ทดสอบ concurrency, least privilege และ restore ได้จริง

## Presentation Checklist

- ปัญหาที่ระบบแก้
- เหตุผลของ data model
- Query ที่ซับซ้อนที่สุด
- ปัญหา performance ที่พบ
- Index ที่เพิ่มและผลวัด
- ความเสี่ยงด้าน transaction
- วิธีควบคุมสิทธิ์
- ผล restore test
