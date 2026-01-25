---
description: Create a backup snapshot of the project infrastructure or configuration.
---

# /backup-infra

Creates a timestamped backup of critical configuration files.

## Steps

1.  **Identify Configs**: Locate `package.json`, `.env.example`, `docker-compose.yml`, and `Dockerfile`.
2.  **Create Snapshot**:
    - Create folder `.backup/{timestamp}/`
    - Copy identifiable configs there.
3.  **Report**:
    - List backed up files.
    - Confirm location.

// turbo-all
