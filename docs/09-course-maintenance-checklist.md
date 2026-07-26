# Course Maintenance Checklist

ใช้ checklist นี้เมื่อเปลี่ยน teaching baseline, patch version หรือเพิ่มเนื้อหาใหม่

## Version Review

- [ ] ตรวจ patch ล่าสุดของ MySQL 8.4 LTS จาก Release Notes ทางการ
- [ ] ตรวจ deprecations, removals และ behavior changes
- [ ] อัปเดต Docker image หลังผ่านการตรวจเท่านั้น
- [ ] รัน schema, seed และ lab scripts
- [ ] อัปเดต README, REFERENCES และ CHANGELOG

## Content Review

- [ ] เก็บเนื้อหาหลักใน `docs/`
- [ ] เก็บ executable SQL ใน `examples/`
- [ ] หลีกเลี่ยงบทเรียนฉบับเต็มซ้ำหลายไฟล์
- [ ] อัปเดต legacy-topic mapping เมื่อ scope เปลี่ยน
- [ ] ตรวจ Markdown links
- [ ] ตรวจ Common Mistakes และ Checkpoint Questions

## Security and Privacy Review

- [ ] ไม่มี `.env`, password, token หรือ private key
- [ ] ไม่มีข้อมูลจริงของบุคคล ลูกค้า หรือองค์กร
- [ ] application examples ไม่ใช้ `root`
- [ ] อธิบาย Least Privilege เมื่อเกี่ยวข้อง
- [ ] ตรวจ backup และ restore instructions

## License Review

- [ ] คง root `LICENSE` แบบ MIT
- [ ] contributions ต้องเข้ากันได้กับ MIT
- [ ] ไม่รวม third-party copyrighted text หรือ code โดยไม่ได้รับอนุญาต
- [ ] เก็บ external materials เป็น links หรือ citations ใน `REFERENCES.md`

## Release Review

- [ ] กำหนด semantic version
- [ ] บันทึกการเปลี่ยนแปลงใน `CHANGELOG.md`
- [ ] ตรวจ links และ file paths
- [ ] ตรวจ Docker commands
- [ ] ตรวจว่า course map สอดคล้องกับไฟล์จริง
