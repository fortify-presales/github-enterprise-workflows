# platform-governance

Compliance automation and reporting for platform workflow adoption.

## Initial Contents

- `.github/workflows/repository-compliance.yml`
- `.github/workflows/publish-templates.yml`
- `scripts/check-compliance.ps1`
- `templates/README.md`

## Reusable Templates

Use `templates/` for raw copy/paste assets:

- `templates/rulesets/main-security-enforcement.json`
- `templates/codeowners/CODEOWNERS.security`
- `templates/workflows/repository-compliance.yml`
- `templates/scripts/check-compliance.ps1`

## Current Checks

- Detect shared workflow references in repository workflow files
- Flag disallowed `@main` usage for shared workflow calls

Extend this repository with organization inventory and automatic remediation pull requests.

## Template Distribution

Use `.github/workflows/publish-templates.yml` to sync `templates/` into downstream repositories.
See `platform-docs/publishing/template-sync.md` for usage and security guidance.
