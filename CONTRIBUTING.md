# Contributing to MySQL in Action

ขอบคุณที่ร่วมพัฒนา **MySQL in Action — Free Learning Edition**

## License Agreement

เมื่อส่ง contribution เข้ามาใน repository นี้ ผู้ส่งยืนยันว่า:

- มีสิทธิในเนื้อหา โค้ด หรือตัวอย่างที่ส่งมา
- contribution ไม่คัดลอกงานที่มีลิขสิทธิ์โดยไม่ได้รับอนุญาต
- contribution จะเผยแพร่ภายใต้ [MIT License](LICENSE) ของ repository
- ยอมให้ผู้ใช้อื่นนำ contribution ไปใช้ แก้ไข รวม เผยแพร่ แจกจ่าย หรือใช้เชิงพาณิชย์ตามเงื่อนไข MIT

## เป้าหมายคุณภาพ

การแก้ไขทุกครั้งควรรักษาคุณภาพของหลักสูตรให้:

- ถูกต้องตาม MySQL รุ่นที่ระบุ
- อ่านง่ายสำหรับผู้เรียนภาษาไทย
- มีตัวอย่าง SQL ที่รันได้
- ไม่คัดลอกเนื้อหาที่มีลิขสิทธิ์
- อธิบาย trade-off ไม่ใช่ให้จำ syntax เพียงอย่างเดียว
- ไม่สร้างเนื้อหาซ้ำกับ module อื่นโดยไม่จำเป็น
- รักษา `docs/` และ `examples/` เป็นแหล่งข้อมูลหลักแบบ One Source of Truth

## Lesson Template

```markdown
# Module/Topic Title

> Teaching baseline: MySQL Community Server 8.4 LTS

## Learning Objectives

## Business Context

## Concept

## SQL Example

## Lab

## Common Mistakes

## Checkpoint

## Further Reading
```

## SQL Style

- Keyword ใช้ตัวพิมพ์ใหญ่ เช่น `SELECT`, `FROM`, `WHERE`
- ชื่อตารางและคอลัมน์ใช้ `snake_case`
- ระบุคอลัมน์แทน `SELECT *` ในตัวอย่าง production-style
- ใช้ alias ที่สื่อความหมาย
- แบ่งบรรทัดเพื่อให้ review ง่าย
- ใส่ comment เฉพาะจุดที่ช่วยการเรียนรู้
- ใช้ `DECIMAL` กับข้อมูลการเงิน
- ระบุ deterministic ordering เมื่อใช้ `LIMIT`
- ใช้ transaction และ error handling เมื่อมีหลายคำสั่งที่ต้องสำเร็จร่วมกัน

## Content Placement

| ประเภท | ตำแหน่ง |
|---|---|
| บทเรียนหลัก | `docs/` |
| Schema และ SQL ที่รันจริง | `examples/` |
| ภาพรวมโครงการ | `README.md` |
| คู่มือรวมและ navigation | `MySQL-All-lesson.md` |
| แหล่งอ้างอิง | `REFERENCES.md` |
| ประวัติการเปลี่ยนแปลง | `CHANGELOG.md` |

อย่าเพิ่มบทเรียนฉบับเต็มซ้ำในหลายไฟล์ เพราะจะทำให้เกิด version drift

## Version Review

เมื่อแก้เนื้อหาที่ขึ้นกับ version:

1. ตรวจ MySQL Reference Manual
2. ตรวจ MySQL Release Notes
3. ระบุ teaching baseline
4. ทดสอบกับ MySQL 8.4 LTS
5. ตรวจ deprecated หรือ removed behavior
6. อัปเดต `REFERENCES.md` และ `CHANGELOG.md` เมื่อจำเป็น
7. อัปเดต Docker image เฉพาะเมื่อ patch ผ่านการตรวจแล้ว

## Security and Privacy

- ห้าม commit `.env`, password, token หรือ private key
- ห้ามใช้ข้อมูลจริงของบุคคล ลูกค้า หรือองค์กรในตัวอย่าง
- ใช้ข้อมูลสมมติและ anonymized data เท่านั้น
- application examples ต้องไม่เชื่อมฐานข้อมูลด้วย `root`
- อธิบาย Least Privilege เมื่อเพิ่มตัวอย่าง user หรือ role

## Pull Request Checklist

- [ ] ตัวอย่าง SQL รันได้บน MySQL 8.4 LTS
- [ ] ไม่มี secret หรือ `.env` จริง
- [ ] ไม่มีข้อมูลส่วนบุคคลหรือข้อมูลจริงขององค์กร
- [ ] ไม่มีข้อความคัดลอกยาวจากหนังสือหรือเว็บไซต์
- [ ] มี Learning Objectives และ Lab
- [ ] ตรวจ spelling และ Markdown links
- [ ] อธิบาย security/performance impact เมื่อเกี่ยวข้อง
- [ ] ไม่สร้างเนื้อหาซ้ำที่ทำให้เกิด version drift
- [ ] อัปเดต `CHANGELOG.md` เมื่อเป็นการเปลี่ยนแปลงสำคัญ
- [ ] contribution สามารถเผยแพร่ภายใต้ MIT License ได้

## Commit Messages

ใช้ข้อความสั้นและสื่อ scope เช่น:

```text
Add window function lab
Clarify transaction isolation examples
Update MySQL 8.4 patch baseline
Fix broken module links
```

## Code of Conduct

ร่วมกัน review ด้วยเหตุผลทางเทคนิค ให้ข้อเสนอแนะอย่างสุภาพ และแยกการวิจารณ์งานออกจากการวิจารณ์บุคคล
