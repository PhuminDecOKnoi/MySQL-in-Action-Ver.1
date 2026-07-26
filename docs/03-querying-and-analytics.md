# Module 3 — Querying and Analytics

## Learning Objectives

ผู้เรียนจะสามารถ:

- เขียน query ที่เลือกข้อมูลเท่าที่จำเป็น
- ใช้ filter, sort และ pagination อย่างถูกต้อง
- เชื่อมตารางด้วย JOIN
- สรุปข้อมูลด้วย aggregate functions
- ใช้ CTE และ Window Functions สำหรับงานวิเคราะห์
- ใช้ JSON functions เบื้องต้นโดยไม่แทนที่ relational design โดยไม่จำเป็น

## 1. SELECT อย่างมีวินัย

```sql
SELECT
    customer_id,
    full_name,
    email
FROM customers
WHERE customer_status = 'active'
ORDER BY created_at DESC
LIMIT 20;
```

หลักปฏิบัติ:

- ระบุคอลัมน์แทน `SELECT *`
- ใช้ alias ที่สื่อความหมาย
- ใส่ `ORDER BY` เมื่อผลลัพธ์ต้องมีลำดับแน่นอน
- ใช้ `LIMIT` กับหน้ารายการหรือ dashboard

## 2. Filtering

```sql
SELECT order_id, customer_id, ordered_at, order_status
FROM orders
WHERE ordered_at >= '2026-01-01'
  AND ordered_at < '2027-01-01'
  AND order_status IN ('paid', 'shipped');
```

สำหรับช่วงวันที่ ใช้ขอบเขตแบบ inclusive/exclusive เพื่อรองรับเวลาได้ชัดเจน

## 3. JOIN

```sql
SELECT
    o.order_id,
    c.full_name,
    o.ordered_at,
    o.order_status
FROM orders AS o
JOIN customers AS c
  ON c.customer_id = o.customer_id;
```

### LEFT JOIN

```sql
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o
  ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name;
```

ใช้ `LEFT JOIN` เมื่อต้องการเก็บแถวจากตารางด้านซ้าย แม้ไม่มีข้อมูลที่สัมพันธ์กัน

## 4. Aggregate Functions

```sql
SELECT
    o.order_status,
    COUNT(*) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS gross_value
FROM orders AS o
JOIN order_items AS oi
  ON oi.order_id = o.order_id
GROUP BY o.order_status
HAVING SUM(oi.quantity * oi.unit_price) > 1000;
```

`WHERE` กรองแถวก่อน aggregate ส่วน `HAVING` กรองผลหลัง aggregate

## 5. Common Table Expressions

```sql
WITH order_totals AS (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
)
SELECT
    o.order_id,
    c.full_name,
    ot.order_total
FROM order_totals AS ot
JOIN orders AS o
  ON o.order_id = ot.order_id
JOIN customers AS c
  ON c.customer_id = o.customer_id
ORDER BY ot.order_total DESC;
```

CTE ช่วยแบ่ง query ซับซ้อนให้เป็นขั้นตอนที่อ่านและทดสอบง่ายขึ้น

## 6. Window Functions

### Ranking

```sql
SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.quantity) DESC
    ) AS sales_rank
FROM products AS p
JOIN order_items AS oi
  ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name;
```

### Running Total

```sql
WITH daily_sales AS (
    SELECT
        DATE(o.ordered_at) AS sale_date,
        SUM(oi.quantity * oi.unit_price) AS daily_total
    FROM orders AS o
    JOIN order_items AS oi
      ON oi.order_id = o.order_id
    WHERE o.order_status IN ('paid', 'shipped')
    GROUP BY DATE(o.ordered_at)
)
SELECT
    sale_date,
    daily_total,
    SUM(daily_total) OVER (
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM daily_sales;
```

Window Functions คำนวณค่าที่สัมพันธ์กับแถวอื่นโดยไม่ยุบผลลัพธ์เหลือหนึ่งแถวต่อกลุ่ม

## 7. Pagination

### OFFSET Pagination

```sql
SELECT order_id, ordered_at, order_status
FROM orders
ORDER BY ordered_at DESC, order_id DESC
LIMIT 20 OFFSET 100;
```

เหมาะกับข้อมูลไม่ใหญ่มาก แต่ offset สูงอาจช้า

### Keyset Pagination

```sql
SELECT order_id, ordered_at, order_status
FROM orders
WHERE (ordered_at, order_id) < ('2026-07-01 10:30:00', 5000)
ORDER BY ordered_at DESC, order_id DESC
LIMIT 20;
```

เหมาะกับ feed หรือข้อมูลขนาดใหญ่ที่เลื่อนหน้าต่อเนื่อง

## 8. JSON เบื้องต้น

ใช้ JSON เมื่อข้อมูลมีโครงสร้างยืดหยุ่นและไม่ใช่ relationship หลักของระบบ

```sql
SELECT
    product_id,
    JSON_EXTRACT(attributes, '$.color') AS color
FROM products
WHERE JSON_CONTAINS(attributes, '"wireless"', '$.features');
```

อย่าใช้ JSON เพื่อหลีกเลี่ยงการออกแบบตารางที่ควรเป็น relational

## Lab 3

1. แสดงลูกค้าที่ไม่เคยสั่งซื้อ
2. สรุปยอดขายต่อเดือน
3. จัดอันดับสินค้า 5 อันดับแรกตามจำนวนขาย
4. คำนวณ running total รายวัน
5. เขียน keyset pagination สำหรับ order ล่าสุด

## Common Mistakes

- JOIN โดยไม่มีเงื่อนไข ทำให้เกิด Cartesian product
- ใช้ `WHERE` กับคอลัมน์จากด้านขวาของ `LEFT JOIN` จน behavior กลายเป็น INNER JOIN
- เลือก nonaggregate column ที่ไม่สอดคล้องกับ `GROUP BY`
- ใช้ OFFSET สูงมากโดยไม่ประเมินต้นทุน
- ใช้ JSON แทนตารางสัมพันธ์ทุกกรณี

## Checkpoint

- CTE ช่วยด้าน readability อย่างไร?
- Window Function ต่างจาก `GROUP BY` อย่างไร?
- เมื่อใดควรใช้ keyset pagination?
