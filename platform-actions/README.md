# platform-actions

Central custom fcli actions used by platform reusable workflows.

## Initial Actions

- `actions/check-release-policy.yaml`
- `actions/check-pr-policy.yaml`
- `actions/check-sast-policy.yaml`
- `actions/check-sca-policy.yaml`

## Naming Convention

Action names follow:

- `check-<scope>-<condition>-policy.yaml`

Preferred concise names:

- `check-release-policy.yaml`
- `check-pr-policy.yaml`
- `check-sast-policy.yaml`
- `check-sca-policy.yaml`

Where:

- scope is `pr` or `release`
- condition summarizes the blocking rule

## Notes

- Keep policy logic centralized here.
- Version this repository in sync with `platform-workflows` major versions.
