# Governance and Rollout

For hard-enforcement options in GitHub Enterprise, see `governance/enforcement-strategy.md`.

## Compliance Checks

A repository is compliant when:

1. It references approved reusable workflow paths.
2. It pins approved workflow versions.
3. It avoids `@main` for shared workflow references.
4. It includes required Fortify and Sonatype caller jobs unless exempted.
5. It enforces a security gate on protected branches.

## Rollout Phases

1. Pilot
   - 10 to 20 repositories across language families
   - Validate build/package compatibility and runtime performance
2. Early adoption
   - Expand to medium criticality services
   - Add compliance dashboards
3. Enforcement
   - Require approved references for protected branches
   - Automatically open remediation pull requests where possible

## Exception Handling

- Exception requests require security and platform approval.
- Exception records must include expiration date.
- Expired exceptions fail compliance checks.

## Metrics

- Coverage: percent repositories onboarded
- Compliance: percent repositories on approved versions
- Drift: repositories using deprecated references
- Mean remediation time for non-compliance
