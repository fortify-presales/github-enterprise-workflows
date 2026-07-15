# Architecture

## Logical Components

1. Platform workflow repository
2. Optional platform action repository for custom fcli actions
3. Optional governance repository for compliance automation
4. Service repositories with caller workflows only

## Reference Topology

```text
Organization
|
|-- platform-workflows
|   |-- .github/workflows/reusable-fortify-fod.yml
|   |-- .github/workflows/reusable-sonatype-sca.yml
|   |-- .github/workflows/reusable-sonatype-fod-sync.yml
|   |-- .github/workflows/reusable-security-gate.yml
|
|-- platform-actions
|   |-- actions/*.yaml
|
|-- platform-governance
|   |-- compliance reports and policy enforcement
|
|-- service-a/.github/workflows/security.yml
|-- service-b/.github/workflows/security.yml
```

## Data and Control Flow

1. Service workflow triggers on push or pull request.
2. Caller workflow invokes centralized reusable workflows.
3. Reusable workflow runs scan tools and post-scan actions.
4. Policy gate evaluates pass/fail criteria.
5. Results are published to PR comments, security events, and artifacts.

## Security Boundaries

- Secret values are not hard-coded in workflow files.
- Repository callers use `secrets: inherit` or environment-mapped secrets.
- Minimal workflow token permissions are used by default.
