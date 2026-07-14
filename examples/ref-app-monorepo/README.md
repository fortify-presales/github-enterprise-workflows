# ref-app-monorepo

Minimal polyglot monorepo example for validating detector and fanout patterns.

## Layout

- `services/orders` (Node.js)
- `services/billing` (Python)
- `apps/catalog` (Java Maven)

## Security Workflow

- `.github/workflows/security.yml` includes:
  - changed-service detector
  - Fortify and Sonatype fanout
  - generic security gate

## Notes

Set these repository values before running scans:

- Variables:
  - `SONATYPE_APPLICATION_ID_PREFIX` (for example `platform-example`)
- Secrets:
  - `FOD_CLIENT_ID`
  - `FOD_CLIENT_SECRET`
  - `LIFECYCLE_PASSWORD`
- Variables:
  - `FOD_URL`
  - `LIFECYCLE_SERVER_URL`
  - `LIFECYCLE_USERNAME`
