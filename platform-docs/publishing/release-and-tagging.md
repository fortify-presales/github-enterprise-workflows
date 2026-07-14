# Release And Tagging Runbook

Use this runbook after publishing updates from the source monorepo to split repositories.

## Why This Matters

Reusable workflow callers usually reference a major tag such as `@v1`.

- `v1.2.0` style tags are immutable release snapshots.
- `v1` is a moving major alias.
- Callers on `@v1` only receive updates after `v1` is moved to a newer release commit.

## Prerequisites

1. Changes are committed in source repository.
2. Split repositories have been updated by subtree publish.
3. You have permission to push tags on target repository.

## Step 1: Commit Source Changes

From source monorepo root:

```powershell
git add .
git commit -m "Update reusable workflows and docs"
```

## Step 2: Publish Split Repositories

```powershell
.\scripts\publish-platform-directories.ps1 -Org <org> -SourceRef main -UseHttps
```

For GitHub Enterprise Server:

```powershell
.\scripts\publish-platform-directories.ps1 -Org <org> -SourceRef main -UseHttps -RepoHost <ghes-host>
```

## Step 3: Prepare Target Repository Locally

GitHub.com example (`platform-workflows`):

```powershell
cd C:\Users\klee2\repos
git clone https://github.com/<org>/platform-workflows.git
cd .\platform-workflows
git fetch --all --tags
git checkout main
git pull
```

GHES example:

```powershell
git clone https://<ghes-host>/<org>/platform-workflows.git
```

## Step 4: Create Immutable Release Tag

Example with `v1.1.0`:

```powershell
git tag -a v1.1.0 -m "platform-workflows v1.1.0"
git push origin v1.1.0
```

## Step 5: Move Major Alias Tag

Move `v1` to latest release commit:

```powershell
git tag -fa v1 -m "Move v1 to v1.1.0"
git push origin v1 --force
```

## Step 6: Verify Tag References

GitHub.com:

```powershell
git ls-remote --tags https://github.com/<org>/platform-workflows.git
```

GHES:

```powershell
git ls-remote --tags https://<ghes-host>/<org>/platform-workflows.git
```

## Consumer Impact

- Repositories using `@v1` get updates after Step 5.
- Repositories pinned to exact tags (for example `@v1.0.0`) do not update automatically.

## Recommended Policy

1. Always create a new immutable tag for each release.
2. Move major alias tags intentionally and document the change.
3. Keep release notes that map major alias moves to immutable tags.
