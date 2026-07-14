# ref-app-dotnet

Minimal .NET example project for validating platform reusable workflows.

## Local run

```bash
dotnet build ./src/PlatformExampleDotnet/PlatformExampleDotnet.csproj
dotnet run --project ./src/PlatformExampleDotnet/PlatformExampleDotnet.csproj
```

## Notes

- Security workflow is in `.github/workflows/security.yml`.
- Set `vars.LIFECYCLE_APPLICATIONS_ID` and Fortify credentials/secrets before running scans.
