# Skill: Governance Template and Ruleset Operations

## Purpose

Operate governance rollout artifacts, including template distribution workflows and GHES ruleset API procedures.

## Use When

- teams need to distribute governance templates to downstream repositories
- GHES branch rulesets must be created or updated consistently
- enforcement drift is detected across repositories

## Inputs Expected

- target repositories and branches
- template sync mode (dry run or push)
- GHES URL and auth method
- ruleset payload source path

## Actions

1. Validate template source files under platform-governance templates.
2. Validate publish-templates workflow inputs and secret prerequisites.
3. Produce runbook steps for dry-run then push rollout.
4. Validate GHES ruleset payload fields and required status checks.
5. Produce API command sequence for list/create/update/verify rulesets.

## Validation Rules

- template sync token scope is least privilege and write-capable for target repos
- dry-run is executed before first push to new target repository
- required status check includes Security Gate
- ruleset targets the correct branch patterns
- CODEOWNERS and actions allowlist guidance are included in rollout notes

## Output

- template distribution checklist
- GHES ruleset operation checklist
- remediation recommendations for enforcement gaps
