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

Useful scripts:

- `scripts/publish-platform-directories.ps1`: publish top-level platform directories to split repositories
- `scripts/preview-platform-docs.ps1`: build/preview platform docs locally through a transient Docusaurus scaffold

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
git ls-remote https://<git-host>/<org>/platform-workflows.git
```

If this returns `Repository not found`, create the repository first or confirm your org permissions.

## Publish Platform Directories To Dedicated Repositories

Use the helper script:

- `scripts/publish-platform-directories.ps1`

Recommended defaults:

1. Prefer HTTPS mode unless your organization has SSH keys configured on all publisher runners.
2. Set `-RepoHost` explicitly for GitHub Enterprise Server.
3. Run a dry run first for each new organization/host setup.

Default behavior publishes these mappings:

- `platform-workflows` -> `<org>/platform-workflows`
- `platform-actions` -> `<org>/platform-actions`
- `platform-governance` -> `<org>/platform-governance`
- `platform-docs` -> `<org>/platform-docs`

Important:

1. The target repositories must already exist.
2. You must have write access to each target repository.
3. First publish uses force push to set target `main` from subtree history.

Command patterns by host:

1. GitHub.com dry run:

```powershell
.\scripts\publish-platform-directories.ps1 -Org <org> -SourceRef main -UseHttps -DryRun
```

2. GitHub.com publish:

```powershell
.\scripts\publish-platform-directories.ps1 -Org <org> -SourceRef main -UseHttps
```

3. GHES dry run:

```powershell
.\scripts\publish-platform-directories.ps1 -Org <org> -SourceRef main -UseHttps -RepoHost <ghes-host> -DryRun
```

4. GHES publish:

```powershell
.\scripts\publish-platform-directories.ps1 -Org <org> -SourceRef main -UseHttps -RepoHost <ghes-host>
```

5. HTTPS + PAT (GitHub.com or GHES):

```powershell
.\scripts\publish-platform-directories.ps1 -Org <org> -SourceRef main -UseHttps -RepoHost <git-host> -Pat "<TOKEN>"
```

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
.\scripts\publish-platform-directories.ps1 -Org fortify-presales -SourceRef main -UseHttps -IncludeExamples
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
For Sonatype Lifecycle -> FoD SBOM synchronization, prefer a separate scheduled/manual caller workflow (for example `lifecycle-fod-sync.yml`) instead of mixing it into branch-protection `security.yml` jobs.

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
  - Variable (optional): `LIFECYCLE_ORGANIZATION_ID` (recommended if Sonatype org name differs from GitHub org/repository owner)
  - Secret: `LIFECYCLE_USERNAME`
  - Secret: `LIFECYCLE_PASSWORD`
  - Variable (optional): `LIFECYCLE_APPLICATION_ID` (defaults to the repository name when unset)
  - Variable (optional): `FOD_RELEASE` (used by Lifecycle -> FoD SBOM sync; defaults to `<owner>/<repo>:<default_branch>`)
  - Variable (optional): `PLATFORM_ACTIONS_REPOSITORY` (for example `my-org/platform-actions`)
  - Variable (optional): `PLATFORM_ACTIONS_REF` (for example `v1` or pinned SHA)
  - Variable (optional): `PLATFORM_ACTIONS_ACTION_PATH` (default `actions/import-lifecycle-sbom-to-fod.yaml`)

## Organization-Level Configuration (GitHub.com And GHES)

Yes, these values can be managed at the organization level and inherited by repositories that are allowed to access them.

Recommended split:

- Organization Variables (non-sensitive):
  - `FOD_URL`
  - `LIFECYCLE_SERVER_URL`
  - `LIFECYCLE_APPLICATION_ID` (optional, only if shared; set per-repo if app-specific)
- Organization Secrets (sensitive):
  - `FOD_CLIENT_ID`
  - `FOD_CLIENT_SECRET`
  - `LIFECYCLE_USERNAME`
  - `LIFECYCLE_PASSWORD`

Scope model:

1. Store common defaults at organization level.
2. Override at repository level only when a specific app/repo needs different values.
3. Restrict org secrets/variables to selected repositories where possible.

UI paths:

- GitHub.com:
  - Organization `Settings` -> `Secrets and variables` -> `Actions`
- GitHub Enterprise Server:
  - Organization `Settings` -> `Secrets and variables` -> `Actions`
  - Exact labels can vary slightly by GHES version, but location is the same in org settings.

Workflow behavior notes:

1. `secrets: inherit` in caller workflows passes accessible secrets to reusable workflow jobs.
2. `${{ vars.NAME }}` resolves repository variables first, then organization-level variables when not overridden.
3. `LIFECYCLE_USERNAME` is consumed as a secret in reusable Sonatype workflow calls.

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

## Generate security.yml For Existing Repositories

Use `scripts/new-security-workflow.ps1` to generate `.github/workflows/security.yml` in an existing repository.

Node.js example for `sandbox-application`:

```powershell
.\scripts\new-security-workflow.ps1 -RepositoryPath C:\Users\klee2\repos\sandbox-application -Language node
```

Auto-detect language from repository files:

```powershell
.\scripts\new-security-workflow.ps1 -RepositoryPath C:\Users\klee2\repos\sandbox-application
```

Overwrite an existing `security.yml`:

```powershell
.\scripts\new-security-workflow.ps1 -RepositoryPath C:\Users\klee2\repos\sandbox-application -Language node -Force
```

Generate for GitHub Enterprise Server reusable workflows:

```powershell
.\scripts\new-security-workflow.ps1 -RepositoryPath C:\Users\klee2\repos\sandbox-application -Language node -PlatformOrg <org> -PlatformRepo platform-workflows -WorkflowRef v1
```

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
- `platform-docs/publishing/release-and-tagging.md`

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
3. After publishing, create an immutable release tag (for example `v1.2.0`) and move major alias `v1` to that release commit so repositories using `@v1` receive updates.
4. Update callers to consume tagged workflow/action releases.

Release/tagging command runbook:

- `platform-docs/publishing/release-and-tagging.md`

## License

This repository is licensed under Apache-2.0. See `LICENSE`.
