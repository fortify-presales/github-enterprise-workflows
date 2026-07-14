# ref-app-node

Minimal Node.js example project for validating platform reusable workflows.

## Local run

```bash
npm install
npm run build
npm start
```

## Notes

- Security workflow is in `.github/workflows/security.yml`.
- Optionally set `vars.LIFECYCLE_APPLICATION_ID`; if unset, Sonatype defaults to `org/repo` (`github.repository`). Also set Fortify credentials/secrets before running scans.
