# Course Maintenance Checklist

Use this checklist when updating the course baseline or adding new material.

## Version review

- [ ] Confirm the current MySQL 8.4 LTS patch in official release notes
- [ ] Review deprecations, removals, and behavior changes
- [ ] Update Docker image only after validation
- [ ] Run schema, seed, and lab scripts
- [ ] Update README, REFERENCES, and CHANGELOG

## Content review

- [ ] Keep detailed content in `docs/`
- [ ] Keep executable SQL in `examples/`
- [ ] Avoid duplicating full lessons in multiple files
- [ ] Update the legacy-topic mapping when module scope changes
- [ ] Verify Markdown links

## License review

- [ ] Keep the root `LICENSE` file unchanged unless the copyright owner approves relicensing
- [ ] Ensure contributions are compatible with MIT
- [ ] Do not include third-party copyrighted text or code beyond permitted use
- [ ] Keep external materials as links or citations in `REFERENCES.md`

## Release review

- [ ] Assign a semantic version
- [ ] Record significant changes in `CHANGELOG.md`
- [ ] Review security and privacy examples
- [ ] Verify that no `.env`, secrets, or real organizational data are committed
