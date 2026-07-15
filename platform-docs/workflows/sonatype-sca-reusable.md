# Reusable Workflow: Sonatype Lifecycle SCA

## Purpose

Provide a reusable Sonatype Lifecycle SCA workflow with optional central configuration and optional FoD SBOM import integration.

For scheduled/manual SBOM synchronization into FoD (with configurable action-source repository/ref/path), see `workflows/sonatype-lifecycle-fod-sync.md`.

## Inputs

- `application_id`: Sonatype Lifecycle application public ID (optional; defaults to the repository name when empty)
- `organization_id`: Sonatype Lifecycle organization name/public ID (optional; defaults to repository owner `github.repository_owner`)
- `create_application_if_missing`: If true, reusable workflow checks whether the application exists and creates it under the resolved organization when missing
- `stage`: Sonatype Lifecycle stage, such as `build` or `release`
- `scan_targets`: Paths or files for evaluation
- `manifest_path`: Root path for manifests
- `parameter_priority`: `CI` or `API`
- `use_central_ci_config`: Enable use of CI Configuration REST API
- `fail_policy_warnings`: Whether policy warnings fail the job
- `import_sbom_to_fod`: If true, imports CycloneDX SBOM into FoD
- `sbom_file`: Output SBOM path
- `sonatype_cyclonedx_version`: CycloneDX version segment

## Required Environment Variables

- `LIFECYCLE_SERVER_URL`

## Optional Environment Variables

- `LIFECYCLE_ORGANIZATION_ID` (recommended for enterprises where Sonatype Lifecycle org IDs differ from GitHub organization names)

## Required Credentials

- `LIFECYCLE_USERNAME` (secret)
- `LIFECYCLE_PASSWORD` (secret)

## Optional FoD Integration Variables

- `FOD_URL`
- `FOD_CLIENT_ID`
- `FOD_CLIENT_SECRET`
- `FOD_RELEASE`

## Central Configuration Model

Use Sonatype Lifecycle CI Configuration REST API for enterprise defaults.

- Read merged config: `GET /api/v2/config/ci/{ownerType}/{ownerId}`
- Update config: `PUT /api/v2/config/ci/{ownerType}/{ownerId}`
- Delete config: `DELETE /api/v2/config/ci/{ownerType}/{ownerId}`

`parameterPriority` behavior:

- `API`: API values override pipeline-supplied values
- `CI`: pipeline non-empty values override API values

## GHES Artifact Considerations

For signed custom action execution guidance (to avoid unsigned bypass flags), see `actions/fcli-custom-actions.md`.

If IQ CLI output artifact upload encounters GHES TLS chain issues, use this controlled workaround:

```yaml
- name: Upload Result File as an artifact
  if: ${{ !cancelled() && steps.run-iq-cli.outputs.result-file-path }}
  uses: actions/upload-artifact@v4
  env:
    NODE_TLS_REJECT_UNAUTHORIZED: 0
  with:
    name: result-file
    path: ${{ steps.run-iq-cli.outputs.result-file-path }}
```

Use this only when enterprise certificate trust cannot yet be corrected.
