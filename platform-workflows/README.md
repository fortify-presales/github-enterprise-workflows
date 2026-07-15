# platform-workflows

Central reusable GitHub Actions workflows for security and governance.

## Contents

- `.github/workflows/reusable-fortify-fod.yml`
- `.github/workflows/reusable-sonatype-sca.yml`
- `.github/workflows/reusable-sonatype-fod-sync.yml`
- `.github/workflows/reusable-security-gate.yml`

## Sonatype Lifecycle FoD Sync Guidance

Use `.github/workflows/reusable-sonatype-fod-sync.yml` from a dedicated scheduled/manual caller workflow (separate from branch-protection `security.yml`).

Key inputs for action source portability:

- `lifecycle_fod_import_action` (explicit URL/path override)
- `platform_actions_repository` (for example `my-org/platform-actions`)
- `platform_actions_ref` (for example `v1` or pinned SHA)
- `platform_actions_action_path` (default `actions/import-lifecycle-sbom-to-fod.yaml`)

When `lifecycle_fod_import_action` is empty, the reusable workflow derives a default URL from `github.server_url`, enabling GitHub.com and GHES compatibility without hardcoding `raw.githubusercontent.com`.

## Usage

Reference workflows from application repositories using a version tag.

```yaml
jobs:
  fortify:
    uses: fortify-presales/platform-workflows/.github/workflows/reusable-fortify-fod.yml@v1
    secrets: inherit
```

## Build-First Scanning

Many applications must be built before FoD packaging and scan submission. The
Fortify reusable workflow supports this through build strategy inputs.

Recommended patterns:

- Auto build for common stacks:
  - set `build_strategy: auto`
  - set `language: node|python|maven|gradle|dotnet`
  - optionally override `java_version`, `node_version`, `python_version`, `dotnet_version`
- Custom build for project-specific commands:
  - set `build_strategy: custom`
  - provide `build_command`
- Disable build when scanning pre-built package:
  - set `build_strategy: none`

Example caller snippet:

```yaml
jobs:
  fortify:
    uses: fortify-presales/platform-workflows/.github/workflows/reusable-fortify-fod.yml@v1
    with:
      language: node
      build_strategy: auto
      node_version: "22"
      source_dir: .
      package_extra_opts: -bt none # Set explicit ScanCentral package flags for your stack
      do_sca_scan: true
      do_check_policy: true
    secrets: inherit
```

## Versioning

- Use semantic tags (`v1.0.0`, `v1.1.0`)
- Maintain major aliases (`v1`)
- Do not consume `@main` from application repositories

## Orchestrator and Detector Examples

For monorepo microservice patterns:

- Existing orchestrator integration: `examples/existing-orchestrator-integration.yml`
- Detector + fanout starter: `examples/detector-and-security-fanout.yml`
- Detector + fanout polyglot starter: `examples/detector-and-security-fanout-polyglot.yml`

Use the first pattern when repositories already compute changed services, the second when they do not, and the third for mixed-language monorepos.
