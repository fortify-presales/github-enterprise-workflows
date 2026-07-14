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

## Controlled Exception Path

- Exemptions require explicit ticket reference.
- Exemptions are time-bounded.
- Exemptions are logged in summary output.
