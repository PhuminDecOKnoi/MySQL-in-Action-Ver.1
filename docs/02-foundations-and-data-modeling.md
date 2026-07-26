# Module 2 — SQL Foundations and Data Modeling

## Learning Objectives

ผู้เรียนจะสามารถ:

- ออกแบบตารางจาก business entities
- เลือกชนิดข้อมูลให้เหมาะสม
- ใช้ Primary Key, Foreign Key, UNIQUE และ CHECK
- อธิบาย normalization ถึงระดับ 3NF แบบใช้งานจริง
- สร้าง schema ที่รักษา data integrity ตั้งแต่ฐานข้อมูล

## 1. เริ่มจาก Business Objects

ตัวอย่างระบบขายประกอบด้วย:

- Customer
- Product
- Order
- Order Item
- Payment

แต่ละ object ควรมีตารางที่รับผิดชอบข้อมูลของตัวเอง ลดข้อมูลซ้ำ และเชื่อมกันด้วย key

## 2. เลือกชนิดข้อมูล

แนวทางพื้นฐาน:

- ID: `BIGINT UNSIGNED`
- เงิน: `DECIMAL(12,2)` ไม่ใช้ `FLOAT`
- วันที่และเวลา: `DATE`, `DATETIME`, `TIMESTAMP`
- สถานะที่อาจเปลี่ยน: `VARCHAR` พร้อม `CHECK`
- ข้อความหลายภาษา: `VARCHAR`/`TEXT` บน `utf8mb4`
- Boolean: `BOOLEAN` ซึ่งเป็น alias ของ `TINYINT(1)`

## 3. Primary Key

```sql
CREATE TABLE customers (
    customer_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

Primary Key ต้องไม่ซ้ำ ไม่เป็น `NULL` และควรมีความเสถียร

## 4. Foreign Key

```sql
CREATE TABLE orders (
    order_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT UNSIGNED NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    ordered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
```

Foreign Key ป้องกัน order ที่อ้างถึง customer ที่ไม่มีอยู่จริง

## 5. CHECK Constraint

```sql
CREATE TABLE products (
    product_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    sku VARCHAR(50) NOT NULL UNIQUE,
    product_name VARCHAR(200) NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    stock_qty INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_products_price CHECK (unit_price >= 0),
    CONSTRAINT chk_products_stock CHECK (stock_qty >= 0)
);
```

`CHECK` ทำให้กฎสำคัญอยู่ใกล้ข้อมูล ไม่ต้องพึ่ง application เพียงอย่างเดียว

## 6. Normalization แบบใช้งานจริง

### First Normal Form

หนึ่งช่องเก็บหนึ่งค่า หลีกเลี่ยงการเก็บรายการสินค้าเป็นข้อความคั่นด้วย comma

### Second Normal Form

ข้อมูลต้องขึ้นกับ key ทั้งชุด โดยเฉพาะตารางที่ใช้ composite key

### Third Normal Form

ไม่เก็บข้อมูลที่ขึ้นกับ non-key column ตัวอื่น เช่น ไม่ควรเก็บชื่อจังหวัดซ้ำในทุก order หากมี master data ที่เหมาะสม

## 7. Denormalization เมื่อมีเหตุผล

บางระบบเก็บ `unit_price` ใน `order_items` แม้ราคาปัจจุบันอยู่ใน `products` เพราะต้องเก็บราคาตอนซื้อจริง นี่คือ historical fact ไม่ใช่ duplication ที่ผิด

## 8. Generated Columns เบื้องต้น

```sql
CREATE TABLE order_items (
    order_item_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    line_total DECIMAL(14,2)
        GENERATED ALWAYS AS (quantity * unit_price) STORED,
    CONSTRAINT chk_order_items_qty CHECK (quantity > 0)
);
```

Generated column ช่วยให้สูตรสม่ำเสมอ แต่ต้องประเมินต้นทุน storage และ index

## Lab 2

1. สร้างตาราง `categories`
2. เพิ่ม Foreign Key จาก `products` ไป `categories`
3. เพิ่ม `CHECK` ให้ราคามากกว่าหรือเท่ากับศูนย์
4. อธิบายว่าเหตุใด `unit_price` ต้องอยู่ใน `order_items`
5. ใช้ `SHOW CREATE TABLE` ตรวจสอบ constraint

## Common Mistakes

- ใช้ `VARCHAR` เก็บทุกอย่าง
- ใช้ `FLOAT` เก็บเงิน
- ไม่มี `UNIQUE` ที่ email หรือ business identifier
- ใช้ `ON DELETE CASCADE` โดยไม่วิเคราะห์ผลกระทบ
- เก็บหลายค่าในคอลัมน์เดียว
- ใช้ application validation แต่ไม่มี database constraint

## Checkpoint

- Primary Key ต่างจาก Unique Key อย่างไร?
- Foreign Key ป้องกันปัญหาแบบใด?
- Denormalization กรณีใดถือว่ามีเหตุผล?
