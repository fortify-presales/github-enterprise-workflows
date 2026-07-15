# Reusable Workflow: Security Gate

## Purpose

Aggregate security outcomes into one branch protection decision.

## Inputs

- `required_statuses_csv`: Comma-separated required tool statuses (`Name=status`)
- `allowed_statuses_csv`: Allowed status values (default `success`)
- `allow_exemption`: Boolean
- `exemption_ticket`: Optional change or risk acceptance identifier

## Upstream Requirements

- Upstream tool jobs expose result status values.
- Gate job receives those values using `needs` and passes them to inputs.
- Caller passes `required_statuses_csv` values like `Snyk=success,CodeQL=success`.

## Decision Model

1. Collect required tool statuses from `required_statuses_csv`.
2. Evaluate each status against `allowed_statuses_csv`.
3. Fail when blocking criteria are met (unless exemption is allowed and ticketed).
4. Emit clear summary for PR and audit trail.

## Example Multi-Tool Input

```yaml
jobs:
	gate:
		uses: fortify-presales/platform-workflows/.github/workflows/reusable-security-gate.yml@v1
		with:
			fortify_status: ${{ needs.fortify.result }}
			sonatype_status: ${{ needs.sonatype.result }}
			required_statuses_csv: >-
				Fortify=${{ needs.fortify.result }},Sonatype=${{ needs.sonatype.result }},Snyk=${{ needs.snyk.result }},CodeQL=${{ needs.codeql.result }}
			allowed_statuses_csv: success
```

## Branch Policy Use

Protect main/release branches by requiring this gate check instead of requiring each individual low-level check.

## Configure Branch Protection To Require Only Security Gate

Use a single required check context for merge protection:

- `Security Gate`

Depending on workflow and UI rendering, the check context may appear as:

- `Security / Security Gate`

Always copy the exact check context from a recent pull request run.

### GitHub.com UI (Branch Protection Rule)

1. Open repository **Settings** > **Branches**.
2. Create or edit the branch protection rule for target branches (for example, `main`).
3. Enable **Require status checks to pass before merging**.
4. Remove individual tool checks (for example, Fortify or Sonatype checks).
5. Add only the Security Gate check context (`Security Gate` or `Security / Security Gate`, whichever exactly matches your PR check).
6. Save changes.

### GitHub.com UI (Rulesets)

1. Open repository **Settings** > **Rules** > **Rulesets**.
2. Create or edit a branch ruleset targeting protected branches.
3. Add the **Require status checks** rule.
4. Set required checks to only Security Gate.
5. Save and enable the ruleset.

### GHES UI (Classic Branch Protection)

1. Open repository **Settings** > **Branches**.
2. Create or edit the branch protection rule for target branches.
3. Enable **Require status checks to pass before merging**.
4. Keep only Security Gate as required status check.
5. Save changes.

### GHES UI (Rulesets, version-dependent)

If your GHES version supports rulesets:

1. Open **Settings** > **Rules** > **Rulesets**.
2. Create or edit a branch ruleset.
3. Add **Require status checks** and keep only Security Gate.
4. Save and verify enforcement.

If rulesets are unavailable on your GHES version, use classic branch protection rules.

### API Examples

GitHub.com branch protection update:

```bash
curl -L -X PUT \
	-H "Accept: application/vnd.github+json" \
	-H "Authorization: Bearer ${GITHUB_TOKEN}" \
	https://api.github.com/repos/${OWNER}/${REPO}/branches/${BRANCH}/protection \
	-d '{
		"required_status_checks": {
			"strict": true,
			"contexts": ["Security Gate"]
		},
		"enforce_admins": true,
		"required_pull_request_reviews": null,
		"restrictions": null
	}'
```

GHES branch protection update:

```bash
curl -L -X PUT \
	-H "Accept: application/vnd.github+json" \
	-H "Authorization: Bearer ${GHES_TOKEN}" \
	${GHES_URL}/api/v3/repos/${OWNER}/${REPO}/branches/${BRANCH}/protection \
	-d '{
		"required_status_checks": {
			"strict": true,
			"contexts": ["Security Gate"]
		},
		"enforce_admins": true,
		"required_pull_request_reviews": null,
		"restrictions": null
	}'
```

For GHES ruleset API operations, see `governance/ghes-ruleset-api.md`.

### Validation Checklist

1. Trigger one PR run after workflow job-name changes so the new check context is registered.
2. Confirm required check context matches exactly (case-sensitive).
3. Ensure only Security Gate is required.
4. If both rulesets and classic branch rules are active, confirm the effective policy does not require additional checks.

## Controlled Exception Path

- Exemptions require explicit ticket reference.
- Exemptions are time-bounded.
- Exemptions are logged in summary output.
