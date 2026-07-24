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

## Repositories That Must Be Re-Tagged

Every time you publish changes, re-tag **all** of these repositories so callers on `@v1` pick up the new content:

| Repository | Why |
|---|---|
| `platform-workflows` | Reusable workflow callers use `@v1` |
| `platform-actions` | fcli action URL defaults include `@v1` ref |
| `platform-docs` | Optional, only if docs site is published by tag |

Forgetting to re-tag `platform-actions` is the most common cause of `FileNotFoundException` errors when fcli tries to load a custom action by URL.

## Step 3a: Fast Path (GitHub CLI, No Local Clone)

Use this when you only need to move tags without inspecting the repository locally.

For each repository that was updated:

```powershell
$org = "fortify-presales"
$repos = @("platform-workflows", "platform-actions")

foreach ($repo in $repos) {
    # Delete existing major alias tag
    gh api repos/$org/$repo/git/refs/tags/v1 -X DELETE

    # Get current main tip SHA
    $sha = gh api repos/$org/$repo/commits/main --jq .sha

    # Create immutable versioned tag
    gh api repos/$org/$repo/git/refs `
        -f ref="refs/tags/v1.1.0" `
        -f sha=$sha

    # Recreate major alias tag at same SHA
    gh api repos/$org/$repo/git/refs `
        -f ref="refs/tags/v1" `
        -f sha=$sha

    Write-Host "Re-tagged $repo to $sha"
}
```

For GitHub Enterprise Server, add `--hostname <ghes-host>` to each `gh api` call.

## Step 3b: Prepare Target Repository Locally (Alternative)

Use this when you want to inspect the published content or create annotated tags.

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

Repeat the clone/pull for `platform-actions`.

## Step 4: Create Immutable Release Tag

Repeat for each repository (`platform-workflows`, `platform-actions`):

```powershell
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin v1.1.0
```

## Step 5: Move Major Alias Tag

Move `v1` to latest release commit for each repository:

```powershell
git tag -fa v1 -m "Move v1 to v1.1.0"
git push origin v1 --force
```

## Step 6: Verify Tag References

GitHub.com:

```powershell
foreach ($repo in @("platform-workflows", "platform-actions")) {
    git ls-remote --tags https://github.com/<org>/$repo.git
}
```

GHES:

```powershell
foreach ($repo in @("platform-workflows", "platform-actions")) {
    git ls-remote --tags https://<ghes-host>/<org>/$repo.git
}
```

## Consumer Impact

- Repositories using `@v1` get updates after the major alias tag is moved.
- Repositories pinned to exact tags (for example `@v1.0.0`) do not update automatically.
- If callers reference a workflow or action file that does not exist at the tagged commit, they will receive a `workflow was not found` or `FileNotFoundException` error at runtime.

## Recommended Policy

1. Always create a new immutable tag for each release.
2. Move major alias tags intentionally and document the change.
3. Keep release notes that map major alias moves to immutable tags.
