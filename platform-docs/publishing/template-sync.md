# Template Sync Workflow

Use the governance template sync workflow to push `platform-governance/templates/` into a downstream repository.

## Workflow

- `platform-governance/.github/workflows/publish-templates.yml`

## Required Secret

Configure this secret in the source repository:

- `TEMPLATE_SYNC_TOKEN`: Personal Access Token or GitHub App token with write access to the target repository.

## Inputs

1. `target_repository`: Destination repository in `owner/repo` format.
2. `target_branch`: Branch in the target repository (default `main`).
3. `target_path`: Destination subpath (default `.`).
4. `dry_run`: If `true`, show changes but do not push.

## Behavior

1. Checks out this repository.
2. Checks out target repository into `target-repo/`.
3. Replaces `target-repo/<target_path>/templates/` with current templates.
4. Shows resulting changes.
5. Commits and pushes when `dry_run=false`.

## Example Run

- `target_repository`: `fortify-presales/platform-governance-templates`
- `target_branch`: `main`
- `target_path`: `.`
- `dry_run`: `true` (first run)

## Operational Guidance

- Always run `dry_run=true` before first push to a new target.
- Protect target branch with PR policy if direct pushes are not allowed.
- If direct push is disallowed, modify workflow to create a branch + pull request.
