# ref-app-java

Minimal Java Maven example project for validating platform reusable workflows.

## Local run

```bash
mvn -DskipTests package
java -cp target/ref-app-java-0.1.0.jar com.example.App
```

## Notes

- Security workflow is in `.github/workflows/security.yml`.
- Optionally set `vars.LIFECYCLE_APPLICATION_ID`; if unset, Sonatype defaults to `org/repo` (`github.repository`). Also set Fortify credentials/secrets before running scans.
