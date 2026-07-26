# Changelog

การเปลี่ยนแปลงสำคัญของ **MySQL in Action — Free Learning Edition**

## [2.1.0] — 2026-07-26

### Changed

- เปลี่ยน License ของ repository จาก **GNU GPL v3** เป็น **MIT License**
- ปรับ `README.md` ให้แสดง MIT badge, license scope และสิทธิการนำไปใช้
- เปลี่ยน `MySQL-All-lesson.md` จาก Legacy Combined Notes เป็น Current Consolidated Course Guide
- กำหนด `docs/` และ `examples/` เป็นแหล่งเนื้อหาหลักแบบ One Source of Truth
- ปรับคำสั่ง Docker ใน README ให้ใช้ค่ารหัสผ่านจาก environment variable แทนการแสดงรหัสผ่านตัวอย่างใน command

### Added

- `docs/README.md` เป็นสารบัญและ learning path กลาง
- `docs/08-legacy-topic-mapping.md` สำหรับ map บทเรียนเดิม 12 หัวข้อเข้าสู่โมดูล MySQL 8.4 LTS
- License section และ trademark clarification ใน README
- Course maintenance rules สำหรับลดเนื้อหาซ้ำและ version drift

### Removed

- เนื้อหาซ้ำหลายพันบรรทัดในไฟล์รวมเดิม ซึ่งทำให้ตรวจ version และแก้ไขความสอดคล้องได้ยาก
- สถานะ Legacy Combined Notes ของ `MySQL-All-lesson.md`

### Migration Notes

- ผู้เรียนใหม่เริ่มจาก `README.md` หรือ `docs/README.md`
- ผู้เรียนเดิมใช้ `docs/08-legacy-topic-mapping.md` เพื่อค้นหาตำแหน่งหัวข้อเดิม
- การใช้งาน แจกจ่าย และดัดแปลง repository หลังรุ่นนี้ให้อ้างอิงเงื่อนไขใน `LICENSE` แบบ MIT

## [2.0.0] — 2026-07-26

### Changed

- เปลี่ยนตัวตน repository จาก README ของ PHP เป็นหลักสูตร MySQL โดยตรง
- กำหนด teaching baseline เป็น MySQL Community Server 8.4 LTS
- ตรวจสอบ patch ล่าสุดเป็น MySQL 8.4.10
- แยกเอกสารรวมออกเป็น course modules สำหรับผู้เรียนและผู้สอน
- ปรับแนวทางจาก syntax-only เป็น workflow: design → query → transaction → performance → security → recovery

### Added

- Instructor Guide พร้อมแผนสอน 12 ชั่วโมง, 18 ชั่วโมง และ workshop 1 วัน
- Setup และ release-model guidance
- Data modeling, modern constraints และ generated columns
- CTE, Window Functions, keyset pagination และ JSON query examples
- Transaction, locking, isolation และ deadlock guidance
- Composite indexes, invisible indexes และ `EXPLAIN ANALYZE` workflow
- Roles, least privilege, backup/restore และ upgrade readiness
- Capstone Project พร้อม rubric 100 คะแนน
- MySQL 8.4 schema, seed data และ guided labs
- Docker Compose environment ที่ pin MySQL 8.4.10
- References และ editorial policy

### Preserved

- เก็บบทเรียนรวมเดิมไว้ชั่วคราวก่อนปรับเป็น consolidated guide ในรุ่น 2.1.0
