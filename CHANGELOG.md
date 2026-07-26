# Changelog

การเปลี่ยนแปลงสำคัญของ MySQL in Action — Free Learning Edition

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
- Composite indexes, invisible indexes และ EXPLAIN ANALYZE workflow
- Roles, least privilege, backup/restore และ upgrade readiness
- Capstone Project พร้อม rubric 100 คะแนน
- MySQL 8.4 schema, seed data และ guided labs
- Docker Compose environment ที่ pin MySQL 8.4.10
- References และ editorial policy

### Preserved

- `MySQL-All-lesson.md` ถูกเก็บไว้เป็น Legacy Combined Notes เพื่อไม่ทำลายเนื้อหาเดิม

### Migration Notes

ผู้เรียนเดิมยังเปิดไฟล์รวมได้ตามปกติ ผู้เรียนใหม่ควรเริ่มจาก `README.md` และ `docs/00-instructor-guide.md`
