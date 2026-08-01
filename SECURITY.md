# Security Policy

## Scope

This repository is an educational MySQL course. Security reports should focus on repository-owned SQL examples, Docker configuration, scripts, documentation, workflows, and learning assets.

## Reporting a Security Issue

Please avoid public disclosure until the issue has been reviewed.

Include the following where possible:

- affected file or module;
- MySQL version and environment;
- reproducible steps;
- expected and actual behavior;
- potential impact;
- recommended mitigation.

Do not include production credentials, real personal data, confidential database contents, or proprietary information.

## Database Security Baseline

Contributions should:

- avoid hard-coded usernames, passwords, tokens, and connection strings;
- never commit `.env` files containing real secrets;
- use least-privilege database accounts instead of `root` for application examples;
- use parameterized queries in application-facing examples;
- validate input before building dynamic SQL;
- avoid exposing sensitive data in logs, exports, screenshots, or seed data;
- use fictional or anonymized datasets;
- review privileges, roles, backup files, and restore procedures carefully;
- explain the risk of destructive statements such as `DROP`, `TRUNCATE`, and unrestricted `UPDATE` or `DELETE`;
- document security and privacy implications when adding new exercises.

## Educational Disclaimer

The examples are intended for learning. Production deployments require additional controls, including access governance, encryption, backup protection, monitoring, audit logging, patch management, privacy compliance, and incident response.
