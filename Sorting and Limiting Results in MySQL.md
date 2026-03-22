File Name: Sorting and Limiting Results in MySQL.md

# Sorting and Limiting Results in MySQL

## บทนำ

การดึงข้อมูลจากฐานข้อมูลไม่ได้จบแค่การ `SELECT` ข้อมูลออกมาเท่านั้น แต่ในงานจริงเรามักต้อง “จัดลำดับ” และ “จำกัดจำนวน” ของผลลัพธ์ด้วย เพื่อให้ข้อมูลอ่านง่าย ตรงความต้องการ และพร้อมใช้งานต่อได้ทันที เช่น แสดงสินค้าราคาสูงสุด 10 รายการ, แสดงพนักงานที่เข้าทำงานล่าสุด, หรือดึงรายการคำสั่งซื้อล่าสุดสำหรับหน้า dashboard

ใน MySQL เราใช้ `ORDER BY` สำหรับการเรียงลำดับ และใช้ `LIMIT` สำหรับการจำกัดจำนวนแถวที่ต้องการแสดง หัวข้อนี้เหมาะสำหรับผู้เริ่มต้นที่ต้องการใช้งาน query ได้อย่างเป็นมืออาชีพมากขึ้น และเหมาะกับผู้ที่เริ่มทำงานกับข้อมูลจริงในระบบธุรกิจ

## สิ่งที่ผู้เรียนจะได้เรียน

- การเรียงข้อมูลด้วย `ORDER BY`
- ความแตกต่างระหว่าง `ASC` และ `DESC`
- การเรียงหลายคอลัมน์ใน query เดียว
- การจำกัดผลลัพธ์ด้วย `LIMIT`
- การใช้ `LIMIT` ร่วมกับ `OFFSET` สำหรับการแบ่งหน้าเบื้องต้น
- การใช้ `ORDER BY` และ `LIMIT` ร่วมกันในงานจริง
- ข้อควรระวังด้านความถูกต้องและ performance

## ตารางตัวอย่างสำหรับบทเรียน

ตัวอย่างนี้จะใช้ตาราง `products` เพื่อให้เห็นภาพของการเรียงข้อมูลและการจำกัดผลลัพธ์ได้ชัดเจน

```sql
-- สร้างฐานข้อมูลตัวอย่าง
CREATE DATABASE shop_db;

-- เลือกใช้งานฐานข้อมูล
USE shop_db;

-- สร้างตารางสินค้า
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at DATETIME NOT NULL
);

-- เพิ่มข้อมูลตัวอย่าง
INSERT INTO products (product_name, category, price, stock, created_at)
VALUES
    ('Mechanical Keyboard', 'Accessories', 2490.00, 15, '2025-01-10 09:00:00'),
    ('Wireless Mouse', 'Accessories', 890.00, 42, '2025-01-12 10:30:00'),
    ('27-inch Monitor', 'Display', 6990.00, 8, '2025-01-08 14:15:00'),
    ('USB-C Hub', 'Accessories', 1290.00, 25, '2025-01-15 11:00:00'),
    ('Laptop Stand', 'Office', 1590.00, 18, '2025-01-05 08:45:00'),
    ('Webcam HD', 'Camera', 2190.00, 10, '2025-01-14 16:20:00');
```

### สิ่งที่ควรเข้าใจ

- `price` ใช้สำหรับฝึกเรียงลำดับตัวเลข
- `created_at` ใช้สำหรับฝึกเรียงข้อมูลตามวันและเวลา
- `stock` ใช้สำหรับดูตัวอย่างการจัดลำดับข้อมูลเพื่อการบริหารสินค้า

---

## หัวข้อย่อยที่ 1: เรียงข้อมูลด้วย ORDER BY

`ORDER BY` ใช้สำหรับกำหนดลำดับของผลลัพธ์ที่ได้จาก query ถ้าไม่ใส่ `ORDER BY` MySQL อาจคืนข้อมูลตามลำดับที่ไม่ควรนำไปคาดหวังในการใช้งานจริง

```sql
-- เรียงสินค้าตามราคาจากน้อยไปมาก
SELECT product_name, price
FROM products
ORDER BY price;
```

### สิ่งที่ควรเข้าใจ

- `ORDER BY` ใช้กำหนดลำดับของแถวในผลลัพธ์
- ถ้าไม่ระบุทิศทาง MySQL จะถือเป็น `ASC` โดยทั่วไป
- ในงานจริงไม่ควรคาดหวังลำดับข้อมูลถ้าไม่ได้ระบุ `ORDER BY` อย่างชัดเจน

---

## หัวข้อย่อยที่ 2: ใช้ ASC และ DESC

เราสามารถกำหนดทิศทางการเรียงลำดับได้ 2 แบบ คือ `ASC` และ `DESC`

```sql
-- เรียงราคาจากน้อยไปมาก
SELECT product_name, price
FROM products
ORDER BY price ASC;
```

```sql
-- เรียงราคาจากมากไปน้อย
SELECT product_name, price
FROM products
ORDER BY price DESC;
```

### สิ่งที่ควรเข้าใจ

- `ASC` คือเรียงจากน้อยไปมาก หรือ A → Z
- `DESC` คือเรียงจากมากไปน้อย หรือ Z → A
- การเลือกทิศทางขึ้นอยู่กับจุดประสงค์ของงาน เช่น ดูสินค้าราคาแพงสุด หรือดูล่าสุดก่อน

---

## หัวข้อย่อยที่ 3: เรียงข้อมูลตามข้อความ ตัวเลข และวันที่

`ORDER BY` ใช้ได้กับหลายชนิดข้อมูล ไม่ว่าจะเป็นข้อความ ตัวเลข หรือวันเวลา

```sql
-- เรียงตามชื่อสินค้าแบบ A ถึง Z
SELECT product_name, category
FROM products
ORDER BY product_name ASC;
```

```sql
-- เรียงตามจำนวน stock จากมากไปน้อย
SELECT product_name, stock
FROM products
ORDER BY stock DESC;
```

```sql
-- เรียงตามวันที่สร้างจากใหม่ไปเก่า
SELECT product_name, created_at
FROM products
ORDER BY created_at DESC;
```

### สิ่งที่ควรเข้าใจ

- ข้อความจะเรียงตามลำดับตัวอักษร
- ตัวเลขจะเรียงตามค่าจริงของตัวเลข
- วันที่และเวลาเหมาะมากกับการแสดง “ล่าสุด” หรือ “เก่าสุด”

---

## หัวข้อย่อยที่ 4: เรียงหลายคอลัมน์ใน query เดียว

ในงานจริง ข้อมูลอาจมีค่าซ้ำกันในคอลัมน์แรกที่ใช้เรียง จึงต้องมีคอลัมน์ถัดไปช่วยจัดลำดับต่อ

```sql
-- เรียงตาม category ก่อน
-- ถ้าหมวดหมู่ซ้ำกัน ให้เรียงตามราคาแพงไปถูก
SELECT product_name, category, price
FROM products
ORDER BY category ASC, price DESC;
```

### สิ่งที่ควรเข้าใจ

- MySQL จะเรียงตามคอลัมน์แรกก่อน
- ถ้าค่าซ้ำกัน จึงใช้คอลัมน์ถัดไปเป็นตัวตัดสิน
- เทคนิคนี้มีประโยชน์มากในรายงานและหน้ารายการข้อมูล

---

## หัวข้อย่อยที่ 5: จำกัดจำนวนผลลัพธ์ด้วย LIMIT

`LIMIT` ใช้กำหนดจำนวนแถวสูงสุดที่ต้องการให้แสดง เหมาะกับการดึงข้อมูลเฉพาะส่วน เช่น แสดง 5 รายการล่าสุด หรือ 10 รายการขายดี

```sql
-- แสดงสินค้า 3 แถวแรก
SELECT product_name, price
FROM products
LIMIT 3;
```

### สิ่งที่ควรเข้าใจ

- `LIMIT 3` หมายถึงแสดงไม่เกิน 3 แถว
- ถ้าไม่ใช้ `ORDER BY` ร่วมด้วย ผลลัพธ์อาจไม่ใช่ 3 รายการที่ “ต้องการจริง” ในเชิงธุรกิจ

---

## หัวข้อย่อยที่ 6: ใช้ ORDER BY ร่วมกับ LIMIT

นี่คือรูปแบบที่ใช้งานจริงบ่อยมาก เพราะช่วยให้เราเลือก “Top N” หรือ “Latest N” ได้อย่างชัดเจน

```sql
-- แสดงสินค้าแพงที่สุด 3 รายการ
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 3;
```

```sql
-- แสดงสินค้าที่ถูกสร้างล่าสุด 2 รายการ
SELECT product_name, created_at
FROM products
ORDER BY created_at DESC
LIMIT 2;
```

### สิ่งที่ควรเข้าใจ

- `ORDER BY` กำหนดลำดับ
- `LIMIT` ตัดจำนวนผลลัพธ์ตามลำดับที่เรียงแล้ว
- ถ้าต้องการผลลัพธ์ที่มีความหมาย ควรใช้สองส่วนนี้ร่วมกัน

---

## หัวข้อย่อยที่ 7: ใช้ LIMIT กับ OFFSET สำหรับการแบ่งหน้าเบื้องต้น

ในระบบที่มีรายการข้อมูลจำนวนมาก เช่น หน้าสินค้า หรือหน้าประวัติคำสั่งซื้อ เรามักใช้ `LIMIT` ร่วมกับ `OFFSET` เพื่อแบ่งข้อมูลออกเป็นหน้า

```sql
-- แสดงข้อมูล 3 รายการแรก
SELECT id, product_name, price
FROM products
ORDER BY id ASC
LIMIT 3 OFFSET 0;
```

```sql
-- แสดงข้อมูล 3 รายการถัดไป
SELECT id, product_name, price
FROM products
ORDER BY id ASC
LIMIT 3 OFFSET 3;
```

### สิ่งที่ควรเข้าใจ

- `LIMIT 3 OFFSET 0` คือเริ่มจากแถวแรกและเอา 3 แถว
- `LIMIT 3 OFFSET 3` คือข้าม 3 แถวแรก แล้วเอา 3 แถวถัดไป
- แนวคิดนี้เป็นพื้นฐานของ pagination

---

## หัวข้อย่อยที่ 8: รูปแบบย่อของ LIMIT offset, count

MySQL ยังรองรับรูปแบบย่อที่เขียน `LIMIT offset, count` ได้เช่นกัน

```sql
-- ข้าม 2 แถวแรก แล้วดึงมา 2 แถว
SELECT id, product_name, price
FROM products
ORDER BY id ASC
LIMIT 2, 2;
```

### สิ่งที่ควรเข้าใจ

- `LIMIT 2, 2` มีความหมายใกล้กับ `LIMIT 2 OFFSET 2`
- แม้ใช้งานได้ แต่หลายทีมเลือกใช้รูปแบบ `LIMIT ... OFFSET ...` เพราะอ่านง่ายกว่า

---

## หัวข้อย่อยที่ 9: ตัวอย่างการใช้งานจริงในระบบงาน

ตัวอย่างต่อไปนี้สะท้อน query ที่พบได้บ่อยใน dashboard หรือหน้ารายการข้อมูลจริง

```sql
-- แสดงสินค้าในหมวด Accessories
-- เรียงจากราคาสูงไปต่ำ
-- และแสดงเพียง 2 รายการแรก
SELECT product_name, category, price
FROM products
WHERE category = 'Accessories'
ORDER BY price DESC
LIMIT 2;
```

```sql
-- แสดงสินค้าที่ stock ต่ำสุด 3 รายการ
SELECT product_name, stock
FROM products
ORDER BY stock ASC
LIMIT 3;
```

### สิ่งที่ควรเข้าใจ

- ใช้ `WHERE` เพื่อกรองข้อมูลเฉพาะกลุ่ม
- ใช้ `ORDER BY` เพื่อจัดลำดับตามเป้าหมายของธุรกิจ
- ใช้ `LIMIT` เพื่อลดข้อมูลให้เหลือเฉพาะสิ่งที่ต้องการแสดง

---

## Best Practices สำหรับงานจริง

### 1) อย่าใช้ LIMIT โดยไม่มี ORDER BY ถ้าต้องการผลลัพธ์ที่คาดเดาได้

```sql
-- ยังไม่ชัดเจนในเชิงธุรกิจ เพราะไม่ได้ระบุลำดับ
SELECT product_name, price
FROM products
LIMIT 5;
```

```sql
-- ชัดเจนกว่า เพราะบอกว่าต้องการสินค้าล่าสุด 5 รายการ
SELECT product_name, created_at
FROM products
ORDER BY created_at DESC
LIMIT 5;
```

### 2) เรียงข้อมูลตามคอลัมน์ที่มีความหมายต่อธุรกิจ

เช่น รายการล่าสุดใช้ `created_at`, รายการแพงสุดใช้ `price`, รายการที่ควรเติมสต๊อกก่อนใช้ `stock`

### 3) ระวัง OFFSET สูงมากในข้อมูลขนาดใหญ่

การใช้ `OFFSET` มาก ๆ อาจทำให้ query ช้าลงเมื่อข้อมูลมีจำนวนมาก ในระบบขนาดใหญ่บางครั้งจะใช้ keyset pagination หรือ cursor-based pagination แทน

### 4) ดึงเฉพาะคอลัมน์ที่จำเป็น

```sql
-- ดี: ดึงเฉพาะข้อมูลที่ต้องใช้แสดงผล
SELECT product_name, price, stock
FROM products
ORDER BY price DESC
LIMIT 10;
```

### 5) พิจารณา index สำหรับคอลัมน์ที่ใช้เรียงบ่อย

ถ้าระบบต้องเรียงข้อมูลตาม `created_at`, `price`, หรือ `category` เป็นประจำ การออกแบบ index ที่เหมาะสมจะช่วยเรื่อง performance ได้มาก

---

## ข้อควรระวัง

- อย่าคาดหวังลำดับของข้อมูลถ้าไม่ได้ใช้ `ORDER BY`
- อย่าใช้ `LIMIT` เพียงอย่างเดียวถ้าผลลัพธ์ต้องมีความหมายเชิงธุรกิจ
- ระวัง `OFFSET` สูงในตารางขนาดใหญ่
- ตรวจสอบชนิดข้อมูลของคอลัมน์ที่นำมาเรียง เพื่อให้ผลลัพธ์ถูกต้อง
- เมื่อทำ pagination จริง ควรมีลำดับที่แน่นอนและสม่ำเสมอ เช่น `ORDER BY created_at DESC, id DESC`

## สรุป

`ORDER BY` และ `LIMIT` เป็นเครื่องมือสำคัญในการจัดการผลลัพธ์ของ query ใน MySQL ทำให้ข้อมูลที่ดึงออกมามีลำดับที่ชัดเจน อ่านง่าย และพร้อมใช้งานจริง ไม่ว่าจะเป็นหน้าแสดงรายการ รายงาน หรือ dashboard

เมื่อเข้าใจหัวข้อนี้แล้ว หัวข้อถัดไปที่ควรเรียนต่อคือ:

- `Filtering Data with WHERE in MySQL`
- `GROUP BY and Aggregate Functions`
- `MySQL JOIN Basics`
- `Indexes and Query Performance`
- `Pagination Patterns in Real Applications`

## แบบฝึกหัดท้ายบท

### แบบฝึกหัด 1
เขียน query เพื่อแสดงสินค้าเรียงตาม `price` จากน้อยไปมาก

### แบบฝึกหัด 2
เขียน query เพื่อแสดงสินค้า 3 รายการที่ราคาสูงที่สุด

### แบบฝึกหัด 3
เขียน query เพื่อแสดงสินค้าเรียงตาม `created_at` จากใหม่ไปเก่า

### แบบฝึกหัด 4
เขียน query เพื่อแสดงสินค้า 2 รายการแรกของหน้าที่ 2 โดยให้หน้าละ 2 รายการ

### แบบฝึกหัด 5
เขียน query เพื่อแสดงสินค้าในหมวด `Accessories` โดยเรียงตามราคาแพงไปถูก และแสดงเพียง 2 รายการ

## เฉลยแบบย่อ

```sql
-- ข้อ 1
SELECT product_name, price
FROM products
ORDER BY price ASC;

-- ข้อ 2
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 3;

-- ข้อ 3
SELECT product_name, created_at
FROM products
ORDER BY created_at DESC;

-- ข้อ 4
SELECT id, product_name, price
FROM products
ORDER BY id ASC
LIMIT 2 OFFSET 2;

-- ข้อ 5
SELECT product_name, category, price
FROM products
WHERE category = 'Accessories'
ORDER BY price DESC
LIMIT 2;
```
