# Contributing to MySQL in Action

## เป้าหมาย

การแก้ไขทุกครั้งควรรักษาคุณภาพของหลักสูตรให้:

- ถูกต้องตาม MySQL รุ่นที่ระบุ
- อ่านง่ายสำหรับผู้เรียนภาษาไทย
- มีตัวอย่าง SQL ที่รันได้
- ไม่คัดลอกเนื้อหาที่มีลิขสิทธิ์
- อธิบาย trade-off ไม่ใช่ให้จำ syntax เพียงอย่างเดียว

## Lesson Template

```markdown
# Module/Topic Title

## Learning Objectives

## Business Context

## Concept

## SQL Example

## Lab

## Common Mistakes

## Checkpoint
```

## SQL Style

- Keyword ใช้ตัวพิมพ์ใหญ่ เช่น `SELECT`, `FROM`, `WHERE`
- ชื่อตารางและคอลัมน์ใช้ `snake_case`
- ระบุคอลัมน์แทน `SELECT *` ในตัวอย่าง production-style
- ใช้ alias ที่สื่อความหมาย
- แบ่งบรรทัดเพื่อให้ review ง่าย
- ใส่ comment เฉพาะจุดที่ช่วยการเรียนรู้

## Version Review

เมื่อแก้เนื้อหาที่ขึ้นกับ version:

1. ตรวจ MySQL Reference Manual
2. ตรวจ Release Notes
3. ระบุ teaching baseline
4. ทดสอบกับ MySQL 8.4 LTS
5. อัปเดต `REFERENCES.md` และ `CHANGELOG.md` เมื่อจำเป็น

## Pull Request Checklist

- [ ] ตัวอย่าง SQL รันได้บน MySQL 8.4 LTS
- [ ] ไม่มี secret หรือ `.env` จริง
- [ ] ไม่มีข้อความคัดลอกยาวจากหนังสือหรือเว็บไซต์
- [ ] มี Learning Objectives และ Lab
- [ ] ตรวจ spelling และ Markdown links
- [ ] อธิบาย security/performance impact เมื่อเกี่ยวข้อง
