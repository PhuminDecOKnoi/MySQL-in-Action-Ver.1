File Name: Database Design with MySQL.md

# Database Design with MySQL

## บทนำ

การออกแบบฐานข้อมูล (Database Design) คือรากฐานสำคัญของระบบที่ใช้ MySQL ไม่ว่าจะเป็นเว็บแอปพลิเคชัน ระบบหลังบ้าน ระบบ HR ระบบขายสินค้า หรือระบบรายงานภายในองค์กร หากออกแบบดีตั้งแต่ต้น ระบบจะอ่านข้อมูลง่าย ขยายต่อได้ ป้องกันข้อมูลซ้ำซ้อน และช่วยให้ query ทำงานได้มีประสิทธิภาพมากขึ้น

หัวข้อนี้เหมาะสำหรับผู้เริ่มต้นจนถึงผู้ที่เริ่มพัฒนาระบบจริง เพราะจะช่วยให้เข้าใจวิธีคิดตั้งแต่การแปลง requirement ไปเป็น table, การเลือก `primary key`, `foreign key`, การจัดความสัมพันธ์ของข้อมูล ไปจนถึงแนวคิดเรื่อง `normalization`, `indexing`, และ `data integrity`

## สิ่งที่ผู้เรียนจะได้เรียน

- หลักคิดพื้นฐานของการออกแบบฐานข้อมูล
- วิธีแปลง requirement เป็นตารางและความสัมพันธ์
- การออกแบบ `primary key` และ `foreign key`
- ความแตกต่างของความสัมพันธ์แบบ one-to-one, one-to-many, many-to-many
- แนวคิดเรื่อง `normalization` แบบใช้งานได้จริง
- การใช้ `constraints` เพื่อรักษาคุณภาพข้อมูล
- การออกแบบ `index` เบื้องต้นให้รองรับ query จริง
- แนวปฏิบัติที่เหมาะกับงานพัฒนาในยุคปัจจุบัน

## Database Design คืออะไร และสำคัญอย่างไร

การออกแบบฐานข้อมูลคือการวางโครงสร้างการเก็บข้อมูลให้สอดคล้องกับธุรกิจและการใช้งานจริง ไม่ใช่แค่ “สร้าง table ให้เก็บข้อมูลได้” แต่ต้องตอบคำถามสำคัญ เช่น

- ข้อมูลอะไรควรอยู่ table เดียวกัน
- ข้อมูลอะไรควรแยกออกเป็นอีก table
- ความสัมพันธ์ระหว่างข้อมูลคืออะไร
- จะป้องกันข้อมูลซ้ำหรือข้อมูลผิดพลาดอย่างไร
- query ที่ระบบต้องใช้บ่อยคืออะไร

ถ้าออกแบบไม่ดี อาจเจอปัญหาเช่น:

- ข้อมูลซ้ำหลายจุด
- แก้ข้อมูลครั้งเดียวแต่ต้องไล่แก้หลาย table
- report ผิดเพราะความสัมพันธ์ไม่ชัด
- query ช้าเมื่อข้อมูลเริ่มเยอะ
- เพิ่ม feature ใหม่ได้ยาก

---

## หัวข้อย่อยที่ 1: เริ่มจาก Requirement ก่อนสร้าง Table

การออกแบบฐานข้อมูลที่ดีเริ่มจากการเข้าใจ requirement ทางธุรกิจ ไม่ใช่เริ่มจากการเดาชื่อ table ก่อน ตัวอย่างเช่น ถ้าจะสร้างระบบขายสินค้า เราอาจมี requirement หลักดังนี้

- ลูกค้าสมัครสมาชิกได้
- ลูกค้าสั่งซื้อสินค้าได้หลายรายการต่อ 1 order
- 1 order มีสินค้าได้หลายชิ้น
- ระบบต้องดูยอดรวมต่อ order ได้
- ระบบต้องดูประวัติคำสั่งซื้อของลูกค้าได้

จาก requirement นี้ เราจึงค่อยแยก entity ออกมา เช่น

- `customers`
- `products`
- `orders`
- `order_items`

### สิ่งที่ควรเข้าใจ

- อย่าเริ่มจาก table ถ้ายังไม่เข้าใจกระบวนการธุรกิจ
- entity ควรสะท้อน “ของจริง” ในระบบ เช่น ลูกค้า สินค้า คำสั่งซื้อ
- requirement ที่ชัด จะช่วยลดการ refactor โครงสร้างใหญ่ในภายหลัง

---

## หัวข้อย่อยที่ 2: ระบุ Entity และ Attribute

เมื่อรู้ requirement แล้ว ขั้นต่อไปคือแยกว่าแต่ละ entity ควรมีข้อมูลอะไรบ้าง

ตัวอย่าง:

- `customers` อาจมี `customer_id`, `full_name`, `email`, `phone`
- `products` อาจมี `product_id`, `product_name`, `price`, `stock`
- `orders` อาจมี `order_id`, `customer_id`, `order_date`, `status`

```sql
-- ตารางลูกค้า
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- entity คือสิ่งหลักที่ระบบต้องเก็บ
- attribute คือรายละเอียดของ entity นั้น
- เลือกชนิดข้อมูล (`data type`) ให้เหมาะกับข้อมูลจริงตั้งแต่ต้น

---

## หัวข้อย่อยที่ 3: เลือก Primary Key ให้เหมาะสม

`Primary Key` คือคอลัมน์ที่ใช้ระบุแต่ละแถวไม่ให้ซ้ำกัน ในระบบจริงนิยมใช้คอลัมน์ประเภทตัวเลขที่เพิ่มอัตโนมัติ เช่น `INT` หรือ `BIGINT` พร้อม `AUTO_INCREMENT`

```sql
-- ใช้ customer_id เป็น primary key
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL
);
```

### สิ่งที่ควรเข้าใจ

- `PRIMARY KEY` ต้องไม่ซ้ำ และห้ามเป็น `NULL`
- ควรใช้ key ที่เสถียรและไม่เปลี่ยนตามธุรกิจ
- โดยทั่วไปไม่ควรใช้ข้อมูลที่อาจเปลี่ยนได้ เช่น email หรือ phone เป็น primary key โดยตรง

---

## หัวข้อย่อยที่ 4: ใช้ Foreign Key เพื่อเชื่อมความสัมพันธ์

`Foreign Key` ใช้เชื่อม table เข้าหากัน และช่วยรักษา `data integrity` เช่น order ทุกใบต้องอ้างถึงลูกค้าที่มีอยู่จริง

```sql
-- ตารางคำสั่งซื้อที่เชื่อมกับลูกค้า
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

- `foreign key` ป้องกันข้อมูล orphan เช่น order ที่ไม่มี customer จริง
- ความสัมพันธ์ที่ชัดเจนช่วยให้ `JOIN` ในภายหลังง่ายและปลอดภัยขึ้น
- ควรวางชื่อ constraint ให้สื่อความหมายเมื่อดู schema ภายหลัง

---

## หัวข้อย่อยที่ 5: เข้าใจความสัมพันธ์หลักของข้อมูล

ความสัมพันธ์ที่พบบ่อยมี 3 แบบ

### 1) One-to-One

เช่น 1 user มี 1 profile

```sql
-- ตาราง users
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE
);

-- ตาราง profiles
CREATE TABLE profiles (
    user_id BIGINT PRIMARY KEY,
    display_name VARCHAR(150) NOT NULL,
    birth_date DATE NULL,
    CONSTRAINT fk_profiles_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

### 2) One-to-Many

เช่น 1 customer มีหลาย orders

```sql
-- ลูกค้า 1 คน มีได้หลายคำสั่งซื้อ
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### 3) Many-to-Many

เช่น 1 order มีหลาย products และ 1 product อยู่ได้ในหลาย orders

```sql
-- ตารางกลางสำหรับ many-to-many
CREATE TABLE order_items (
    order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### สิ่งที่ควรเข้าใจ

- ความสัมพันธ์แบบ many-to-many มักต้องมี table กลาง
- table กลางมักเก็บข้อมูลเพิ่มเติม เช่น `quantity`, `unit_price`
- ความสัมพันธ์ที่ถูกต้องมีผลต่อทั้ง query, report, และ data integrity

---

## หัวข้อย่อยที่ 6: Normalization แบบใช้งานจริง

`Normalization` คือแนวคิดในการลดข้อมูลซ้ำและจัดข้อมูลให้เป็นระเบียบมากขึ้น ในงานจริงไม่จำเป็นต้องท่องทฤษฎีลึกก่อน แต่ควรเข้าใจหลักการใช้งาน เช่น

- อย่าเก็บข้อมูลหลายค่าในคอลัมน์เดียว
- อย่าเก็บข้อมูลซ้ำโดยไม่จำเป็น
- แยกข้อมูลที่เป็นคนละเรื่องออกจากกัน

### ตัวอย่างที่ไม่ดี

```sql
-- ไม่แนะนำ: เก็บสินค้าหลายชิ้นในคอลัมน์เดียว
CREATE TABLE bad_orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(150),
    product_list TEXT
);
```

### ตัวอย่างที่ดีกว่า

```sql
-- ดี: แยก order และ order_items ออกจากกัน
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL
);

CREATE TABLE order_items (
    order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL
);
```

### สิ่งที่ควรเข้าใจ

- normalization ช่วยให้ update ง่ายขึ้นและลดความขัดแย้งของข้อมูล
- อย่าเก็บรายการหลายค่าแบบคั่น comma ในคอลัมน์เดียวถ้าระบบต้อง query ต่อ
- การแยก table อย่างเหมาะสมช่วยให้ระบบขยายต่อได้ดี

---

## หัวข้อย่อยที่ 7: เลือก Data Type ให้เหมาะกับข้อมูล

การเลือก `data type` ที่เหมาะสมมีผลต่อทั้งความถูกต้องและ performance

```sql
-- ตัวอย่างการเลือกชนิดข้อมูลที่เหมาะสม
CREATE TABLE products (
    product_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    sku VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### แนวคิดสำคัญ

- ใช้ `VARCHAR` กับข้อความที่ความยาวไม่คงที่
- ใช้ `DECIMAL` กับข้อมูลการเงิน หลีกเลี่ยง `FLOAT` สำหรับราคา
- ใช้ `INT` หรือ `BIGINT` กับเลขจำนวนเต็ม
- ใช้ `DATE` หรือ `DATETIME` กับวันเวลาให้ตรงตามบริบท
- ใช้ `NOT NULL` เมื่อ field นั้นต้องมีเสมอ

---

## หัวข้อย่อยที่ 8: ใช้ Constraints เพื่อควบคุมคุณภาพข้อมูล

constraints ช่วยให้ฐานข้อมูลช่วยตรวจสอบกฎพื้นฐานแทนระบบบางส่วน เช่น บังคับไม่ให้ email ซ้ำ หรือห้าม stock ติดลบ

```sql
-- ตัวอย่าง constraints ที่ใช้จริง
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(30) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    salary DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    CHECK (salary >= 0)
);
```

### สิ่งที่ควรเข้าใจ

- `PRIMARY KEY` ป้องกัน key ซ้ำ
- `UNIQUE` ป้องกันค่าซ้ำในคอลัมน์ที่ต้องไม่ซ้ำ
- `NOT NULL` ป้องกันค่าหาย
- `CHECK` ใช้บังคับเงื่อนไขของข้อมูล
- constraints ช่วยลดความเสี่ยงที่ข้อมูลเสียตั้งแต่ระดับฐานข้อมูล

---

## หัวข้อย่อยที่ 9: ตั้งชื่อ Table และ Column ให้สม่ำเสมอ

ชื่อที่ดีช่วยให้ schema อ่านง่ายและดูแลง่าย โดยเฉพาะเมื่อระบบมีหลาย table

### แนวทางที่นิยม

- ใช้ชื่อ table เป็นพหูพจน์ เช่น `customers`, `orders`, `products`
- ใช้ `snake_case` ให้สม่ำเสมอ
- ตั้งชื่อ key ให้ชัด เช่น `customer_id`, `product_id`
- ตั้งชื่อวันเวลาให้ชัด เช่น `created_at`, `updated_at`, `deleted_at`

```sql
-- ตัวอย่างชื่อที่อ่านง่ายและสม่ำเสมอ
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- ความสม่ำเสมอสำคัญกว่าความแปลกใหม่
- ตั้งชื่อให้คนอื่นในทีมอ่านแล้วเข้าใจทันที
- schema ที่อ่านง่ายช่วยให้ code review และ maintenance ดีขึ้นมาก

---

## หัวข้อย่อยที่ 10: ออกแบบ Index ตาม Query ที่ใช้งานจริง

`Index` ช่วยให้การค้นหาและ join เร็วขึ้น แต่ไม่ควรใส่ทุกคอลัมน์แบบไม่คิด เพราะ index มากเกินไปทำให้ insert/update ช้าลงและใช้พื้นที่เพิ่ม

```sql
-- index สำหรับค้นหาตาม email
CREATE UNIQUE INDEX idx_customers_email
    ON customers(email);

-- index สำหรับ join และ filter คำสั่งซื้อของลูกค้า
CREATE INDEX idx_orders_customer_id
    ON orders(customer_id);

-- index สำหรับค้นหาตาม status และ order_date
CREATE INDEX idx_orders_status_order_date
    ON orders(status, order_date);
```

### สิ่งที่ควรเข้าใจ

- สร้าง index จาก query ที่ใช้จริง ไม่ใช่จากการเดา
- คอลัมน์ที่ใช้ใน `WHERE`, `JOIN`, `ORDER BY` บ่อย มักเป็นตัวเลือกที่ดี
- foreign key หลายกรณีควรมี index รองรับ

---

## หัวข้อย่อยที่ 11: ตัวอย่าง Schema ของระบบขายสินค้า

ด้านล่างคือตัวอย่าง schema ที่เชื่อมกันครบสำหรับระบบขนาดเล็ก

```sql
-- ตารางลูกค้า
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(30) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ตารางสินค้า
CREATE TABLE products (
    product_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ตารางคำสั่งซื้อ
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ตารางรายการสินค้าในคำสั่งซื้อ
CREATE TABLE order_items (
    order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### สิ่งที่ควรเข้าใจ

- `customers` เก็บข้อมูลลูกค้าเพียงครั้งเดียว
- `products` เก็บ master data ของสินค้า
- `orders` เก็บหัวคำสั่งซื้อ
- `order_items` เก็บรายละเอียดสินค้าในแต่ละ order
- โครงสร้างแบบนี้รองรับ `JOIN`, report, และการขยายระบบได้ดี

---

## หัวข้อย่อยที่ 12: ออกแบบเพื่อรองรับ Audit และ Tracking

ในงานจริง ควรคิดเรื่องการติดตามข้อมูลตั้งแต่แรก เช่น วันสร้าง วันแก้ไข ผู้สร้าง หรือสถานะการใช้งาน

```sql
-- ตัวอย่างคอลัมน์สำหรับ tracking
CREATE TABLE documents (
    document_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    document_name VARCHAR(200) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- `created_at` และ `updated_at` มีประโยชน์มากในการ audit และ troubleshooting
- บางระบบอาจเพิ่ม `created_by`, `updated_by` ตามความจำเป็น
- อย่ารอให้ระบบโตแล้วค่อยคิดเรื่อง tracking เพราะแก้ภายหลังมักกระทบหลายส่วน

---

## หัวข้อย่อยที่ 13: Soft Delete vs Hard Delete

ในระบบธุรกิจหลายประเภท การลบข้อมูลทิ้งจริงอาจไม่เหมาะ เพราะกระทบ report หรือ audit trail จึงนิยมใช้ `soft delete`

```sql
-- ตัวอย่าง soft delete
CREATE TABLE categories (
    category_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    deleted_at DATETIME NULL
);
```

```sql
-- ดึงเฉพาะข้อมูลที่ยังไม่ถูกลบแบบ soft delete
SELECT category_id, category_name
FROM categories
WHERE deleted_at IS NULL;
```

### สิ่งที่ควรเข้าใจ

- `hard delete` คือการลบแถวออกจริง
- `soft delete` คือเก็บแถวไว้แต่ทำเครื่องหมายว่าถูกลบแล้ว
- ระบบที่ต้อง audit หรือดูประวัติย้อนหลัง มักได้ประโยชน์จาก soft delete

---

## หัวข้อย่อยที่ 14: Security Basics ในการออกแบบฐานข้อมูล

แม้ database design จะไม่ใช่ security ทั้งหมด แต่มีผลต่อความปลอดภัยโดยตรง เช่น การแยกข้อมูลสำคัญ การจำกัดข้อมูลซ้ำ และการเก็บรหัสผ่านอย่างถูกวิธี

```sql
-- ตัวอย่างตาราง users สำหรับระบบ login
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### สิ่งที่ควรเข้าใจ

- ไม่ควรเก็บรหัสผ่านเป็น plain text
- ควรเก็บ `password_hash` แทน
- ข้อมูลสำคัญ เช่น email, phone, salary ควรถูกออกแบบให้เข้าถึงเฉพาะส่วนที่จำเป็น
- design ที่ดีช่วยลดการ expose ข้อมูลเกินจำเป็น

---

## หัวข้อย่อยที่ 15: Backup และ Restore ควรถูกคิดตั้งแต่ต้น

ระบบที่ออกแบบดีควรสามารถ backup และ restore ได้ง่าย โครงสร้างที่ชัดช่วยให้การย้ายข้อมูลและการกู้คืนระบบทำได้ปลอดภัยขึ้น

```sql
-- สำรองฐานข้อมูลด้วย mysqldump (ตัวอย่างคำสั่ง shell)
-- mysqldump -u root -p shop_db > shop_db_backup.sql

-- restore กลับเข้าฐานข้อมูล (ตัวอย่างคำสั่ง shell)
-- mysql -u root -p shop_db < shop_db_backup.sql
```

### สิ่งที่ควรเข้าใจ

- แม้คำสั่ง backup/restore ไม่ใช่ SQL โดยตรง แต่เป็นเรื่องที่ควรนึกถึงตั้งแต่ระยะออกแบบ
- schema ที่ชัดเจนและสัมพันธ์กันดี ช่วยให้ migration และ restore ปลอดภัยขึ้น
- ใน production ควรมีทั้ง backup policy และการทดสอบ restore จริง

---

## ตัวอย่างการใช้งานจริง: Query ที่สะท้อนว่า Design ดีหรือไม่

เมื่อ schema ออกแบบดี เราจะเขียน query ที่ชัดเจนและต่อยอดได้ง่าย เช่น ดึงคำสั่งซื้อพร้อมชื่อลูกค้าและยอดรวม

```sql
-- รายงานคำสั่งซื้อพร้อมชื่อลูกค้าและยอดรวมต่อ order
SELECT
    o.order_id,
    c.full_name,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id, c.full_name, o.order_date, o.status
ORDER BY o.order_date DESC;
```

### สิ่งที่ควรเข้าใจ

- ถ้า schema ดี query จะอ่านง่ายและสรุปข้อมูลได้ตรงธุรกิจ
- ถ้า schema แย่ query มักยาว ซับซ้อน และเสี่ยงต่อข้อมูลผิด
- design ที่ดีช่วยทั้ง developer, analyst, และ DBA

---

## Best Practices สำหรับงานจริง

### 1) ออกแบบจาก use case ไม่ใช่จากความเคยชิน

ถามก่อนเสมอว่าระบบต้องตอบคำถามอะไร และผู้ใช้งานจะ query อะไรบ่อย

### 2) ใช้ primary key และ foreign key ให้ชัดเจน

```sql
-- ตัวอย่างความสัมพันธ์ที่ชัดเจน
CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
```

### 3) อย่าเก็บข้อมูลซ้ำโดยไม่จำเป็น

เช่น อย่าเก็บ `customer_name` ซ้ำในทุก order ถ้าระบบมี `customers` อยู่แล้ว เว้นแต่มีเหตุผลเชิงธุรกิจชัดเจน เช่น ต้อง snapshot ชื่อ ณ เวลาที่สั่งซื้อ

### 4) ใช้ DECIMAL กับข้อมูลการเงิน

```sql
-- ดีสำหรับราคาและยอดเงิน
price DECIMAL(10,2) NOT NULL
```

### 5) ออกแบบ index ตาม query จริง

ดูจาก query ที่ใช้บ่อย เช่น ค้นหาตาม `email`, ดู order ของลูกค้า, filter ตาม `status` และวันที่

### 6) เผื่อการเติบโตของระบบ

เช่น ใช้ `BIGINT` หากคาดว่าข้อมูลจะมีจำนวนมาก และคิดเรื่อง `created_at`, `updated_at` ตั้งแต่ต้น

### 7) อย่ารีบ denormalize โดยไม่มีเหตุผล

การรวมข้อมูลหลายอย่างไว้ table เดียวอาจดูง่ายช่วงแรก แต่ทำให้ระบบโตยากในระยะยาว

---

## ข้อควรระวัง

- อย่าออกแบบ table จากหน้าจอเพียงอย่างเดียว ควรดู process ทั้งระบบ
- อย่าใช้ `VARCHAR` กับทุกอย่างแบบไม่คิดชนิดข้อมูล
- อย่าเก็บหลายค่าในคอลัมน์เดียวถ้าต้อง query แยกในอนาคต
- อย่าลืม constraints และ foreign keys หากข้อมูลต้องสัมพันธ์กันจริง
- อย่าใส่ index มากเกินไปโดยไม่ดู query ที่ใช้จริง
- อย่ามองข้ามเรื่อง audit, security, และ backup ตั้งแต่ช่วงออกแบบ

## สรุป

การออกแบบฐานข้อมูลด้วย MySQL ที่ดีไม่ใช่แค่ทำให้เก็บข้อมูลได้ แต่ต้องทำให้ข้อมูลเชื่อมโยงกันอย่างถูกต้อง ลดความซ้ำซ้อน รองรับ query จริง และขยายระบบได้ในอนาคต

ถ้าเริ่มจาก requirement ที่ชัด แยก entity ได้ถูกต้อง ใช้ `primary key`, `foreign key`, `constraints`, `normalization`, และ `index` อย่างเหมาะสม คุณจะได้ schema ที่แข็งแรงและพร้อมใช้งานในโครงการจริงมากขึ้น

หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `MySQL JOIN for Real Projects`
- `Indexes and Query Performance in MySQL`
- `Transactions in MySQL`
- `Constraints and Data Integrity in MySQL`
- `Designing Audit Tables with MySQL`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
อธิบายว่าระบบขายสินค้าออนไลน์ควรมี table หลักอะไรบ้างอย่างน้อย 4 table

### แบบฝึกหัด 2
เขียนคำสั่งสร้าง table `departments` ที่มี `department_id`, `department_name`, `created_at`

### แบบฝึกหัด 3
เขียนคำสั่งสร้าง table `employees` ที่เชื่อมกับ `departments` ผ่าน `department_id`

### แบบฝึกหัด 4
อธิบายความแตกต่างระหว่าง one-to-many และ many-to-many แบบสั้น ๆ

### แบบฝึกหัด 5
เขียนตัวอย่าง index สำหรับคอลัมน์ `email` ใน table `customers`

## เฉลยแบบย่อ

```sql
-- ข้อ 2
CREATE TABLE departments (
    department_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ข้อ 3
CREATE TABLE employees (
    employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    department_id BIGINT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ข้อ 5
CREATE UNIQUE INDEX idx_customers_email
    ON customers(email);
```
