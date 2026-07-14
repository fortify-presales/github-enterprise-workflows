# ref-app-dotnet

Minimal .NET example project for validating platform reusable workflows.

## Local run

```bash
dotnet build ./src/PlatformExampleDotnet/PlatformExampleDotnet.csproj
dotnet run --project ./src/PlatformExampleDotnet/PlatformExampleDotnet.csproj
```

## Notes

- Security workflow is in `.github/workflows/security.yml`.
- Optionally set `vars.LIFECYCLE_APPLICATION_ID`; if unset, Sonatype defaults to `org/repo` (`github.repository`). Also set Fortify credentials/secrets before running scans.
