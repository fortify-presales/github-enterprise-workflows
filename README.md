# GitHub Enterprise Workflows Platform

This repository is the source-of-truth monorepo for reusable GitHub security workflows, custom policy actions, governance automation, and example projects.

Primary focus:

- Fortify on Demand (FoD) SAST workflow patterns
- Sonatype SCA workflow patterns
- GitHub Enterprise Server (GHES)-first compatibility
- Reusable workflow governance and rollout

## What Is In This Repository

Top-level platform directories:

- `platform-workflows/`: centralized reusable workflows and orchestrator/detector examples
- `platform-actions/`: centralized fcli custom actions for policy checks and security controls
- `platform-governance/`: compliance checks, rollout templates, and governance automation
- `platform-docs/`: architecture, workflow contracts, governance docs, and publishing guides
- `examples/*/`: minimal example projects for Java, Node, Python, .NET, and monorepo patterns
- `sample_workflows/` and `sample_actions/`: standalone workflow/action examples
- `scripts/`: helper scripts for example bootstrapping and subtree publishing

## Recommended Platform Model

Use this repository as a central authoring repo, then publish subdirectories into dedicated repositories in your organization (for example under `fortify-presales`).

Typical target repositories:

- `platform-workflows`
- `platform-actions`
- `platform-governance`
- `platform-docs`

Optional example repositories:

- `ref-app-java`
- `ref-app-node`
- `ref-app-python`
- `ref-app-dotnet`
- `ref-app-monorepo`

## Prerequisites

1. Git is installed and available on PATH.
2. You have create and push access to your target GitHub organization.
3. Authentication is configured using one of:
   - SSH keys (default path for publishing script)
  - HTTPS credentials (Git Credential Manager or PAT)
4. `git subtree` is available in your local git installation.
5. Destination repositories exist in advance (empty is recommended for first publish).

## First-Time Setup

The first-time setup has two phases:

1. Bootstrap this source repository (`github-enterprise-workflows`).
2. Create destination platform repositories that subtree publishing will push into.

### Phase 1: Bootstrap This Source Repository

Run these commands from repository root:

```powershell
git init -b main
git add .
git commit -m "Initial platform workflows, docs, and examples"
git remote add origin https://github.com/<org>/github-enterprise-workflows.git
git push -u origin main
```

If your organization or host differs, update remote URL accordingly.

For GitHub Enterprise Server, use your enterprise host:

```powershell
git remote add origin https://<ghes-host>/<org>/github-enterprise-workflows.git
git push -u origin main
```

### Phase 2: Create Destination Repositories For Subtree Publish

The publishing script pushes to these repositories by default:

- `platform-workflows`
- `platform-actions`
- `platform-governance`
- `platform-docs`

Optional repositories when publishing examples:

- `ref-app-monorepo`
- `ref-app-java`
- `ref-app-node`
- `ref-app-python`
- `ref-app-dotnet`

Create repositories manually in GitHub UI, or with GitHub CLI:

```powershell
$repos = @("platform-workflows", "platform-actions", "platform-governance", "platform-docs")
foreach ($r in $repos) { gh repo create "<org>/$r" --private -y }
```

Preflight check before publish (must succeed for each target):

```powershell
git ls-remote https://github.com/<org>/platform-workflows.git
```

If this returns `Repository not found`, create the repository first or confirm your org permissions.

## Publish Platform Directories To Dedicated Repositories

Use the helper script:

- `scripts/publish-platform-directories.ps1`

Default behavior publishes these mappings:

- `platform-workflows` -> `<org>/platform-workflows`
- `platform-actions` -> `<org>/platform-actions`
- `platform-governance` -> `<org>/platform-governance`
- `platform-docs` -> `<org>/platform-docs`

Important:

1. The target repositories must already exist.
2. You must have write access to each target repository.
3. First publish uses force push to set target `main` from subtree history.

Dry run first:

```powershell
.\scripts\publish-platform-directories.ps1 -Org fortify-presales -SourceRef main -DryRun
```

Publish:

```powershell
.\scripts\publish-platform-directories.ps1 -Org fortify-presales -SourceRef main -UseHttps
```

Include example projects:

```powershell
.\scripts\publish-platform-directories.ps1 -Org fortify-presales -SourceRef main -IncludeExamples
```

Use HTTPS + PAT:

```powershell
.\scripts\publish-platform-directories.ps1 -Org fortify-presales -SourceRef main -UseHttps -Pat "<TOKEN>"
```

Use a custom Git host (GHES):

```powershell
.\scripts\publish-platform-directories.ps1 -Org <org> -SourceRef main -UseHttps -RepoHost <ghes-host>
```

How publishing works:

1. `git subtree split` builds a branch per subdirectory.
2. Script force-pushes that split branch to `main` of target repository.
3. Temporary split branches are deleted locally.

## Platform Workflow Consumption Pattern

Application repositories should keep thin caller workflows and reference centralized reusable workflows by version tag (not `@main`).

Example:

```yaml
jobs:
  fortify:
    uses: fortify-presales/platform-workflows/.github/workflows/reusable-fortify-fod.yml@v1
    secrets: inherit
```

Permissions baseline in caller repositories:

```yaml
permissions:
  contents: read
  security-events: write
  pull-requests: write
```

## Required Variables And Secrets

Minimum shared configuration for most examples:

- Fortify:
  - Variable: `FOD_URL`
  - Secret: `FOD_CLIENT_ID`
  - Secret: `FOD_CLIENT_SECRET`
- Sonatype:
  - Variable: `LIFECYCLE_SERVER_URL`
  - Variable or Secret: `LIFECYCLE_USERNAME`
  - Secret: `LIFECYCLE_PASSWORD`
  - Variable: `SONATYPE_APPLICATION_ID`

## Create New Example Repositories From Templates

Example project set in this repository:

Location: `examples/`

- `ref-app-java`
- `ref-app-node`
- `ref-app-python`
- `ref-app-dotnet`
- `ref-app-monorepo`

What each example includes:

1. Minimal source code and build file(s).
2. A `.github/workflows/security.yml` caller workflow wired to reusable platform workflows.

`ref-app-monorepo` additionally demonstrates detector + matrix fanout for polyglot services.

These are intended as starter repositories. Copy each example folder into its own repository for end-to-end validation.

Use:

- `scripts/new-ref-app.ps1`

Example:

```powershell
.\scripts\new-ref-app.ps1 -TemplateName ref-app-node -DestinationPath C:\repos\my-ref-app-node -NewName my-ref-app-node
```

Supported template names:

- `ref-app-java`
- `ref-app-node`
- `ref-app-python`
- `ref-app-dotnet`
- `ref-app-monorepo`

## Documentation Hub

Main docs index:

- `platform-docs/README.md`

High-value docs:

- `platform-docs/intro.md`
- `platform-docs/architecture.md`
- `platform-docs/workflows/fortify-fod-reusable.md`
- `platform-docs/workflows/sonatype-sca-reusable.md`
- `platform-docs/workflows/security-gate.md`
- `platform-docs/governance/compliance-rollout.md`
- `platform-docs/publishing/repository-split.md`
- `platform-docs/publishing/template-sync.md`

## Governance And Compliance Assets

See:

- `platform-governance/README.md`
- `platform-governance/scripts/check-compliance.ps1`
- `platform-governance/templates/README.md`

These assets are intended for organization-wide rollout checks, template distribution, and enforcement support.

## Notes For GHES Environments

1. Prefer GHES-compatible artifact upload actions where required.
2. Keep reusable workflows and custom actions version-pinned with tags.
3. Avoid direct `@main` consumption in downstream repositories.
4. Document and control any TLS/proxy exceptions used in workflows.

## Operational Guidance

1. Keep this monorepo as the editing source of truth.
2. Publish updates with subtree script to platform repositories.
3. Tag versions in split repositories (for example `v1`, `v1.2.0`).
4. Update callers to consume tagged workflow/action releases.

## License

This repository is licensed under Apache-2.0. See `LICENSE`.
