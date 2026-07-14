# Publish as Separate Repositories

This guide describes how to publish individual `platform-docs` directories as separate repositories in `github.com/fortify-presales`.

## Recommended Repository Layout

- `fortify-presales/platform-docs-core`
  - `intro.md`
  - `architecture.md`
- `fortify-presales/platform-docs-workflows`
  - `workflows/`
- `fortify-presales/platform-docs-actions`
  - `actions/`
- `fortify-presales/platform-docs-governance`
  - `governance/`
- `fortify-presales/platform-docs-agent-skills`
  - `agent-skills/`
- `fortify-presales/platform-docs-publishing`
  - `publishing/`
  - `docusaurus/`

## Option 1: Manual Copy (Simple)

1. Create destination repository in GitHub.
2. Copy required folder(s)/file(s) into that repository.
3. Commit and push.

Use this for initial bootstrap when history preservation is not required.

## Option 2: Preserve History with `git subtree split`

Run from this repository root.

Example for workflows repository:

```bash
git subtree split --prefix=platform-docs/workflows -b split-workflows
git remote add platform-docs-workflows https://github.com/fortify-presales/platform-docs-workflows.git
git push platform-docs-workflows split-workflows:main --force
git branch -D split-workflows
```

Repeat with other prefixes:

- `platform-docs/actions`
- `platform-docs/governance`
- `platform-docs/agent-skills`
- `platform-docs/publishing`

For core docs, either:

- create a dedicated folder (for example `platform-docs/core`) and subtree split it, or
- maintain `platform-docs-core` with manual copy from root docs files.

## Option 3: CI-Based Sync to Multiple Repositories

Use one source-of-truth repository and an automation workflow that:

1. Detects changed paths under `platform-docs/`.
2. Exports mapped paths.
3. Pushes updates to destination repositories using bot credentials.

This is recommended for long-term maintenance.

## Path Mapping Table

| Source Path | Target Repository | Target Path |
| --- | --- | --- |
| `platform-docs/workflows/**` | `platform-docs-workflows` | `/workflows/**` |
| `platform-docs/actions/**` | `platform-docs-actions` | `/actions/**` |
| `platform-docs/governance/**` | `platform-docs-governance` | `/governance/**` |
| `platform-docs/agent-skills/**` | `platform-docs-agent-skills` | `/agent-skills/**` |
| `platform-docs/publishing/**` | `platform-docs-publishing` | `/publishing/**` |
| `platform-docs/docusaurus/**` | `platform-docs-publishing` | `/docusaurus/**` |

## Versioning Recommendation

- Tag source repository releases (`docs-v1.0.0`, `docs-v1.1.0`).
- Propagate the same tag/version notes across split repositories.
- Keep a changelog in each target repository, referencing source commit SHAs.

## Operational Notes

- Use bot PAT with least privilege for cross-repo push automation.
- Protect `main` branches in target repositories.
- Require PR checks where teams contribute directly to split repositories.
