# Reusable Workflow: Sonatype Lifecycle FoD Sync

## Purpose

Synchronize the latest Sonatype Lifecycle CycloneDX SBOM into Fortify on Demand (FoD), including optional enrichment through the custom fcli action.

## Workflow File

- `platform-workflows/.github/workflows/reusable-sonatype-fod-sync.yml`

## Triggers

- `schedule`
- `workflow_dispatch`
- `workflow_call`

Execution is limited to the repository default branch (`github.ref_name == github.event.repository.default_branch`).

## Required Configuration

Repository variables:

- `LIFECYCLE_SERVER_URL`
- `FOD_URL`

Repository secrets:

- `LIFECYCLE_USERNAME`
- `LIFECYCLE_PASSWORD`
- `FOD_CLIENT_ID`
- `FOD_CLIENT_SECRET`

## Key Inputs

- `application_id`: Sonatype Lifecycle app public ID (defaults to repository name)
- `stage`: Lifecycle stage (default `build`)
- `sbom_version`: CycloneDX endpoint version (default `1.6`)
- `fod_release`: FoD release (defaults to `<owner>/<repo>:<default_branch>`)
- `sbom_artifact_name`: SBOM artifact name (default `lifecycle-sbom`)
- `upload_sbom_artifact`: artifact upload toggle (default `true`)

## Action Source Configuration

The SBOM import action is now portable across organizations and GHES.

### Explicit Override (Highest Priority)

- `lifecycle_fod_import_action`: full URL or local path to action file

Deprecated compatibility alias:

- `sonatype_fod_import_action`

### Derived Default (When No Explicit Override Is Set)

Inputs used for composition:

- `platform_actions_repository` (default `fortify-presales/platform-actions`)
- `platform_actions_ref` (default `v1`)
- `platform_actions_action_path` (default `actions/import-lifecycle-sbom-to-fod.yaml`)

Resolution formula:

`<github.server_url>/<platform_actions_repository>/raw/<platform_actions_ref>/<platform_actions_action_path>`

This makes the default host GHES-aware (uses `github.server_url`, not hardcoded `raw.githubusercontent.com`).

## Examples

GitHub.com example:

- `platform_actions_repository: my-org/platform-actions`
- `platform_actions_ref: v1`
- `platform_actions_action_path: actions/import-lifecycle-sbom-to-fod.yaml`

Resulting default action reference:

`https://github.com/my-org/platform-actions/raw/v1/actions/import-lifecycle-sbom-to-fod.yaml`

GHES example:

- `platform_actions_repository: security/platform-actions`
- `platform_actions_ref: v1`
- `platform_actions_action_path: actions/import-lifecycle-sbom-to-fod.yaml`

Resulting default action reference:

`https://<ghes-host>/security/platform-actions/raw/v1/actions/import-lifecycle-sbom-to-fod.yaml`

## Signing Guidance

For signed custom action guidance and trust bootstrap patterns, see:

- `actions/fcli-custom-actions.md`

## Compatibility Notes

- Existing callers using `sonatype_fod_import_action` continue to work.
- Existing custom action CLI aliases (`--sonatype-*`) remain supported alongside `--lifecycle-*`.
