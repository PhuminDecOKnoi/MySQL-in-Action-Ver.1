File Name: Primary Key and Foreign Key in MySQL.md

# Primary Key and Foreign Key in MySQL

## บทนำ

`Primary Key` และ `Foreign Key` คือรากฐานของฐานข้อมูลเชิงสัมพันธ์ใน MySQL เพราะช่วยให้ข้อมูลแต่ละแถวมีตัวตนที่ชัดเจน และช่วยให้ตารางหลายตารางเชื่อมโยงกันได้อย่างถูกต้อง เช่น ลูกค้ากับคำสั่งซื้อ พนักงานกับแผนก หรือสินค้า กับรายการขาย

ถ้าเข้าใจสองเรื่องนี้ดี คุณจะออกแบบฐานข้อมูลได้เป็นระบบมากขึ้น เขียน `JOIN` ได้ถูกต้องขึ้น และลดปัญหาข้อมูลซ้ำ ข้อมูลหลุด หรือข้อมูลที่อ้างอิงกันผิด

หัวข้อนี้เหมาะสำหรับผู้เริ่มต้นที่ต้องการเข้าใจโครงสร้างฐานข้อมูลให้ถูกตั้งแต่ต้น และเหมาะสำหรับผู้ที่เริ่มพัฒนาระบบจริงด้วย MySQL

## สิ่งที่ผู้เรียนจะได้เรียน

- ความหมายของ `Primary Key` และ `Foreign Key`
- เหตุผลที่ต้องใช้ key ในฐานข้อมูลเชิงสัมพันธ์
- วิธีสร้าง `PRIMARY KEY` และ `FOREIGN KEY` ใน MySQL
- ความสัมพันธ์แบบ one-to-many ที่ใช้จริงบ่อยที่สุด
- ความต่างระหว่าง key เชิงธุรกิจกับ key ทางเทคนิค
- การใช้ `AUTO_INCREMENT`
- ข้อควรระวังเรื่อง `NULL`, การลบข้อมูล, และ data integrity
- แนวปฏิบัติที่เหมาะกับงานจริง

## Key คืออะไร และทำไมจึงสำคัญ

ในฐานข้อมูล เราต้องมีวิธีระบุว่า “แถวนี้คือแถวไหน” และ “แถวนี้เกี่ยวข้องกับแถวไหนในอีกตารางหนึ่ง”

- `Primary Key` ใช้ระบุแถวหนึ่งแถวให้ไม่ซ้ำกัน
- `Foreign Key` ใช้เชื่อมความสัมพันธ์ระหว่างตาราง

ถ้าไม่มี key ที่ชัดเจน ฐานข้อมูลจะมีปัญหาเช่น:

- ข้อมูลซ้ำจนแยกไม่ออกว่าแถวไหนคือข้อมูลจริง
- คำสั่งซื้ออาจอ้างถึงลูกค้าที่ไม่มีอยู่จริง
- การ `JOIN` ข้อมูลอาจผิดหรือคลุมเครือ
- การแก้ไขและดูแลข้อมูลในระยะยาวทำได้ยาก

---

## หัวข้อย่อยที่ 1: Primary Key คืออะไร

`Primary Key` คือคอลัมน์ หรือชุดของคอลัมน์ ที่ใช้ระบุแต่ละแถวในตารางแบบไม่ซ้ำกัน และห้ามเป็น `NULL`

ตัวอย่างเช่น ในตาราง `customers` เราอาจใช้ `customer_id` เป็น `PRIMARY KEY`

```sql
-- สร้างตาราง customers พร้อม primary key
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- แต่ละแถวต้องมีค่า `customer_id` ไม่ซ้ำกัน
- `PRIMARY KEY` ห้ามมีค่า `NULL`
- โดยทั่วไปมักมี 1 primary key ต่อ 1 ตาราง
- นิยมใช้คอลัมน์ประเภท `INT` หรือ `BIGINT` ร่วมกับ `AUTO_INCREMENT`

---

## หัวข้อย่อยที่ 2: ทำไม Primary Key จึงสำคัญ

`Primary Key` ทำให้แต่ละแถวมีตัวระบุที่แน่นอน เช่น ลูกค้าคนหนึ่งอาจชื่อซ้ำกับอีกคนได้ แต่ `customer_id` ไม่ควรซ้ำ

```sql
-- เพิ่มข้อมูลลูกค้าหลายคน
INSERT INTO customers (full_name, email)
VALUES
    ('Anan Krit', 'anan@example.com'),
    ('Anan Krit', 'anan.k@example.com'),
    ('Mali Suda', 'mali@example.com');
```

### สิ่งที่ควรเข้าใจ

- แม้ `full_name` จะซ้ำกันได้ แต่ `customer_id` ของแต่ละแถวต้องไม่ซ้ำ
- ระบบจึงอ้างอิงข้อมูลได้แม่นยำกว่าใช้ชื่อหรือข้อความทั่วไป
- key ที่ดีช่วยให้การ update, delete, และ join ปลอดภัยขึ้น

---

## หัวข้อย่อยที่ 3: AUTO_INCREMENT คืออะไร

`AUTO_INCREMENT` คือคุณสมบัติที่ให้ MySQL สร้างเลขลำดับใหม่ให้อัตโนมัติทุกครั้งที่เพิ่มข้อมูลแถวใหม่

```sql
-- customer_id จะเพิ่มให้อัตโนมัติ
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL
);
```

### สิ่งที่ควรเข้าใจ

- ช่วยลดภาระในการกำหนดค่า id เอง
- เหมาะกับตารางส่วนใหญ่ในระบบธุรกิจ
- มักใช้คู่กับ `PRIMARY KEY`

---

## หัวข้อย่อยที่ 4: Foreign Key คืออะไร

`Foreign Key` คือคอลัมน์ในตารางหนึ่ง ที่อ้างอิงไปยัง `PRIMARY KEY` ของอีกตารางหนึ่ง เพื่อบอกความสัมพันธ์ของข้อมูล

ตัวอย่างเช่น ในตาราง `orders` เราใช้ `customer_id` เพื่ออ้างอิงลูกค้าที่เป็นเจ้าของคำสั่งซื้อ

```sql
-- ตาราง orders อ้างอิง customers ผ่าน customer_id
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### สิ่งที่ควรเข้าใจ

- `orders.customer_id` คือ `FOREIGN KEY`
- ค่านี้ต้องอ้างถึง `customers.customer_id` ที่มีอยู่จริง
- ถ้าพยายามใส่ `customer_id` ที่ไม่มีอยู่ MySQL จะปฏิเสธข้อมูล

---

## หัวข้อย่อยที่ 5: ความสัมพันธ์แบบ One-to-Many

รูปแบบที่ใช้จริงบ่อยมากคือ one-to-many เช่น:

- ลูกค้า 1 คน มีคำสั่งซื้อได้หลายรายการ
- แผนก 1 แผนก มีพนักงานได้หลายคน
- หมวดสินค้า 1 หมวด มีสินค้าได้หลายรายการ

```sql
-- ลูกค้า 1 คน มีหลาย orders ได้
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL
);

CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### สิ่งที่ควรเข้าใจ

- ตารางฝั่ง “หนึ่ง” คือ `customers`
- ตารางฝั่ง “หลาย” คือ `orders`
- `FOREIGN KEY` จะอยู่ฝั่งที่เป็น “หลาย”

---

## หัวข้อย่อยที่ 6: ตัวอย่างจริงแบบ customers และ orders

ด้านล่างคือตัวอย่างโครงสร้างที่ใช้จริงในหลายระบบ

```sql
-- ตารางลูกค้า
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

-- ตารางคำสั่งซื้อ
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

```sql
-- เพิ่มข้อมูลลูกค้า
INSERT INTO customers (full_name, email)
VALUES
    ('Anan Krit', 'anan@example.com'),
    ('Mali Suda', 'mali@example.com');

-- เพิ่มข้อมูลคำสั่งซื้อ โดยอ้างอิง customer_id ที่มีอยู่จริง
INSERT INTO orders (customer_id, total_amount)
VALUES
    (1, 2500.00),
    (1, 1800.00),
    (2, 3200.00);
```

### สิ่งที่ควรเข้าใจ

- ลูกค้าหมายเลข 1 มี order ได้หลายรายการ
- order ทุกแถวต้องอ้างถึงลูกค้าที่มีอยู่จริง
- ความสัมพันธ์แบบนี้รองรับการ query และ report ได้ดี

---

## หัวข้อย่อยที่ 7: JOIN กับ Primary Key และ Foreign Key

เมื่อออกแบบ key ถูกต้อง เราจะเขียน `JOIN` ได้ง่ายและชัดเจน

```sql
-- ดึงคำสั่งซื้อพร้อมชื่อลูกค้า
SELECT
    o.order_id,
    o.order_date,
    o.total_amount,
    c.full_name
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id;
```

### สิ่งที่ควรเข้าใจ

- `o.customer_id` เชื่อมกับ `c.customer_id`
- นี่คือผลลัพธ์จากการออกแบบ `PRIMARY KEY` และ `FOREIGN KEY` ที่ชัดเจน
- ถ้า key ไม่ถูกต้อง query จะซับซ้อนและเสี่ยงผิดมากขึ้น

---

## หัวข้อย่อยที่ 8: Business Key กับ Surrogate Key

ในงานจริงมักมี 2 แนวคิดที่ควรรู้

### 1) Business Key

คือค่าที่มีความหมายทางธุรกิจ เช่น:

- เลขบัตรประชาชน
- รหัสพนักงาน
- เลขคำสั่งซื้อ
- email

### 2) Surrogate Key

คือ key ที่สร้างขึ้นมาเพื่อใช้ในระบบ เช่น `id`, `customer_id`, `order_id`

```sql
-- ใช้ surrogate key เป็น primary key
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(30) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL
);
```

### สิ่งที่ควรเข้าใจ

- ในหลายระบบนิยมใช้ `surrogate key` เป็น `PRIMARY KEY`
- ส่วน `business key` มักใช้ `UNIQUE` เพิ่มเพื่อป้องกันข้อมูลซ้ำ
- วิธีนี้ยืดหยุ่นกว่าหากข้อมูลทางธุรกิจเปลี่ยนในอนาคต

---

## หัวข้อย่อยที่ 9: Composite Primary Key เบื้องต้น

บางตารางอาจใช้ `PRIMARY KEY` มากกว่า 1 คอลัมน์ร่วมกัน โดยเรียกว่า composite key เช่น ตารางกลางใน many-to-many

```sql
-- ตารางกลางแบบใช้ composite primary key
CREATE TABLE order_items (
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### สิ่งที่ควรเข้าใจ

- คู่ของ `(order_id, product_id)` ต้องไม่ซ้ำกัน
- เหมาะกับตารางที่ต้องการป้องกันความซ้ำในระดับคู่ข้อมูล
- ในบางโครงการอาจเลือกใช้ `order_item_id` แยกอีกแบบหนึ่งแทน ขึ้นกับการออกแบบ

---

## หัวข้อย่อยที่ 10: ข้อผิดพลาดที่ Foreign Key ช่วยป้องกัน

หนึ่งในประโยชน์สำคัญของ `FOREIGN KEY` คือช่วยป้องกันข้อมูลผิดความสัมพันธ์

```sql
-- ตัวอย่างนี้จะผิด ถ้ายังไม่มี customer_id = 99 ใน customers
INSERT INTO orders (customer_id, total_amount)
VALUES (99, 1500.00);
```

### สิ่งที่ควรเข้าใจ

- ถ้าไม่มี `customer_id = 99` จริง ฐานข้อมูลควรไม่ยอมให้ insert
- ช่วยป้องกันข้อมูล orphan
- เป็นการรักษา `data integrity` ที่ระดับฐานข้อมูล

---

## หัวข้อย่อยที่ 11: การลบข้อมูลและผลกระทบของ Foreign Key

เมื่อมีความสัมพันธ์ระหว่างตาราง การลบข้อมูลต้องคิดให้รอบคอบ เช่น ถ้าลบ customer แล้ว order ที่ผูกอยู่จะทำอย่างไร

```sql
-- ตัวอย่าง foreign key พร้อมกำหนดพฤติกรรมตอนลบข้อมูล
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```

### สิ่งที่ควรเข้าใจ

- `ON DELETE RESTRICT` ไม่ให้ลบลูกค้าถ้ายังมี order ผูกอยู่
- `ON UPDATE CASCADE` ช่วยอัปเดตค่าที่อ้างอิงตามกันเมื่อ key ต้นทางเปลี่ยน
- ควรเลือกพฤติกรรมให้สอดคล้องกับธุรกิจ ไม่ใช้แบบเดียวทุกกรณี

---

## หัวข้อย่อยที่ 12: RESTRICT, CASCADE, SET NULL ต่างกันอย่างไร

ค่าที่กำหนดหลัง `ON DELETE` หรือ `ON UPDATE` มีผลต่อความสัมพันธ์ของข้อมูล

```sql
-- ตัวอย่างการใช้ ON DELETE SET NULL
CREATE TABLE tasks (
    task_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    assigned_employee_id BIGINT NULL,
    task_name VARCHAR(200) NOT NULL,
    CONSTRAINT fk_tasks_employee
        FOREIGN KEY (assigned_employee_id) REFERENCES employees(employee_id)
        ON DELETE SET NULL
);
```

### ความหมายโดยย่อ

- `RESTRICT` ไม่ยอมให้ลบหรือแก้ ถ้ายังมีข้อมูลอ้างอิงอยู่
- `CASCADE` ลบหรือแก้ตามกัน
- `SET NULL` ตั้งค่าฝั่งที่อ้างอิงให้เป็น `NULL`

### สิ่งที่ควรเข้าใจ

- อย่าใช้ `CASCADE` โดยไม่คิด เพราะอาจลบข้อมูลต่อเนื่องหลายตาราง
- `SET NULL` ใช้ได้เมื่อคอลัมน์นั้นอนุญาต `NULL`
- งานจริงควรเลือกตามกฎธุรกิจ ไม่ใช่ตามความสะดวกอย่างเดียว

---

## หัวข้อย่อยที่ 13: Primary Key และ Foreign Key กับ Data Integrity

`Data Integrity` คือความถูกต้องและสอดคล้องของข้อมูลในระบบ ซึ่ง key ทั้งสองมีบทบาทมาก

```sql
-- ตัวอย่าง schema ที่ช่วยรักษาความถูกต้องของข้อมูล
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_id BIGINT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
```

### สิ่งที่ควรเข้าใจ

- พนักงานทุกคนต้องอยู่ในแผนกที่มีอยู่จริง
- ลดความเสี่ยงจากข้อมูลสะกดไม่ตรงหรืออ้างอิงกันผิด
- ทำให้รายงานและ `JOIN` เชื่อถือได้มากขึ้น

---

## หัวข้อย่อยที่ 14: ควรสร้าง Index บน Foreign Key หรือไม่

ในงานจริง คอลัมน์ที่เป็น `FOREIGN KEY` มักถูกใช้ใน `JOIN` และ `WHERE` บ่อย จึงควรพิจารณาเรื่อง index ด้วย

```sql
-- index สำหรับ foreign key ที่ใช้ join บ่อย
CREATE INDEX idx_orders_customer_id
    ON orders(customer_id);
```

### สิ่งที่ควรเข้าใจ

- ช่วยให้ query ที่ join หรือ filter เร็วขึ้น
- โดยเฉพาะตารางที่มีข้อมูลจำนวนมาก
- key ที่ดีควรมาพร้อมการออกแบบ performance ที่เหมาะสม

---

## หัวข้อย่อยที่ 15: ตัวอย่างระบบจริงแบบ departments และ employees

ตัวอย่างนี้สะท้อนโครงสร้างที่ใช้จริงในระบบ HR หรือระบบองค์กร

```sql
-- ตารางแผนก
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ตารางพนักงาน
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_id BIGINT NOT NULL,
    employee_code VARCHAR(30) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    hired_at DATE NOT NULL,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
```

```sql
-- ดึงรายชื่อพนักงานพร้อมชื่อแผนก
SELECT
    e.employee_code,
    e.full_name,
    d.department_name
FROM employees AS e
JOIN departments AS d
    ON e.department_id = d.department_id;
```

### สิ่งที่ควรเข้าใจ

- `department_id` เป็นตัวเชื่อมระหว่างพนักงานกับแผนก
- ชื่อแผนกถูกเก็บเพียงครั้งเดียวในตาราง `departments`
- ลดข้อมูลซ้ำและทำให้แก้ไขข้อมูลได้จากจุดเดียว

---

## Best Practices สำหรับงานจริง

### 1) ใช้ surrogate key เป็น primary key ในหลายกรณี

```sql
-- รูปแบบที่นิยมในงานจริง
customer_id BIGINT PRIMARY KEY AUTO_INCREMENT
```

ช่วยให้ schema ยืดหยุ่นและลดผลกระทบเมื่อข้อมูลทางธุรกิจเปลี่ยน

### 2) ใช้ UNIQUE กับ business key ที่ต้องไม่ซ้ำ

```sql
-- email ไม่ควรซ้ำ แม้ไม่ใช้เป็น primary key
email VARCHAR(150) NOT NULL UNIQUE
```

### 3) ตั้งชื่อ foreign key constraint ให้ชัด

```sql
CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
```

### 4) หลีกเลี่ยงการลบแบบ cascade โดยไม่จำเป็น

ต้องแน่ใจว่าผลกระทบต่อข้อมูลปลายทางเป็นไปตามที่ธุรกิจต้องการจริง

### 5) ออกแบบ key ให้สอดคล้องกับ query ที่จะใช้จริง

เช่น ระบบที่ต้อง `JOIN` order กับ customer บ่อย ควรมีทั้ง `FOREIGN KEY` และ index ที่เหมาะสม

### 6) อย่าใช้ข้อมูลที่เปลี่ยนบ่อยเป็น primary key

เช่น email, phone, หรือชื่อ เพราะอาจเปลี่ยนในอนาคตและกระทบหลายตาราง

---

## ข้อควรระวัง

- อย่าใส่ `FOREIGN KEY` แบบไม่เข้าใจผลต่อการลบและแก้ไขข้อมูล
- อย่าใช้ `CASCADE` โดยไม่วิเคราะห์ผลกระทบ
- อย่าคิดว่า `PRIMARY KEY` กับ `UNIQUE` เหมือนกันทั้งหมด เพราะหน้าที่ต่างกัน
- อย่าลืมว่า `PRIMARY KEY` ห้ามเป็น `NULL`
- อย่าปล่อยให้ตารางสำคัญไม่มี key ชัดเจน เพราะจะกระทบทั้ง query และ data quality

## สรุป

`Primary Key` และ `Foreign Key` เป็นแกนหลักของการออกแบบฐานข้อมูลเชิงสัมพันธ์ใน MySQL โดย `Primary Key` ใช้ระบุแต่ละแถวให้ไม่ซ้ำ และ `Foreign Key` ใช้เชื่อมความสัมพันธ์ระหว่างตารางอย่างถูกต้อง

เมื่อเข้าใจสองเรื่องนี้ คุณจะออกแบบ schema ได้ดีขึ้น เขียน `JOIN` ได้แม่นขึ้น และรักษา `data integrity` ได้ตั้งแต่ระดับฐานข้อมูล ซึ่งเป็นพื้นฐานสำคัญของงานพัฒนาระบบจริง

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `Database Design with MySQL`
- `MySQL JOIN for Real Projects`
- `Constraints and Data Integrity in MySQL`
- `Indexes and Query Performance in MySQL`
- `Transactions in MySQL`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียนคำสั่งสร้างตาราง `departments` ที่มี `department_id` เป็น `PRIMARY KEY`

### แบบฝึกหัด 2
เขียนคำสั่งสร้างตาราง `employees` ที่มี `department_id` เป็น `FOREIGN KEY` ไปยัง `departments`

### แบบฝึกหัด 3
อธิบายความแตกต่างระหว่าง `PRIMARY KEY` และ `FOREIGN KEY` แบบสั้น ๆ

### แบบฝึกหัด 4
เขียน query เพื่อแสดงรายชื่อพนักงานพร้อมชื่อแผนก

### แบบฝึกหัด 5
อธิบายว่า `ON DELETE RESTRICT` และ `ON DELETE SET NULL` ต่างกันอย่างไร

## เฉลยแบบย่อ

```sql
-- ข้อ 1
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL
);

-- ข้อ 2
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_id BIGINT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ข้อ 4
SELECT
    e.full_name,
    d.department_name
FROM employees AS e
JOIN departments AS d
    ON e.department_id = d.department_id;
```
