# ref-app-java

Minimal Java Maven example project for validating platform reusable workflows.

## Local run

```bash
mvn -DskipTests package
java -cp target/ref-app-java-0.1.0.jar com.example.App
```

## Notes

- Branch-protection workflow is in `.github/workflows/security.yml`.
- Scheduled/manual Sonatype Lifecycle -> FoD SBOM sync is in `.github/workflows/lifecycle-fod-sync.yml` (nightly at `0 2 * * *`).
- Optionally set `vars.LIFECYCLE_APPLICATION_ID`; if unset, Sonatype defaults to `org/repo` (`github.repository`). Also set Fortify credentials/secrets before running scans.
