# ref-app-java

Minimal Java Maven example project for validating platform reusable workflows.

## Local run

```bash
mvn -DskipTests package
java -cp target/ref-app-java-0.1.0.jar com.example.App
```

## Notes

- Security workflow is in `.github/workflows/security.yml`.
- Set `vars.SONATYPE_APPLICATION_ID` and Fortify credentials/secrets before running scans.
