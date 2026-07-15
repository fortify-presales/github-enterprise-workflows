# GitHub Enterprise Enforcement Examples

This appendix provides example settings you can adapt for your GHES or GitHub Enterprise Cloud environment.

For copy/paste starter snippets, see `governance/enforcement-templates.md`.

## Example 1: Branch Ruleset (Main Branch)

Target branch pattern:

- `main`

Suggested protections:

1. Require pull request before merge
2. Require approvals (for example 1 or 2)
3. Require status checks to pass
4. Require branches to be up to date
5. Block force push and branch deletion

Required status checks example:

- `Security Gate`

Optional additional checks:

- `Repository Compliance`

## Example 2: Required Check Model

Use one required gate check instead of requiring many scanner-specific checks.

Why:

- simpler branch policy management
- easier onboarding for repositories
- clear pass/fail point for auditors

Gate expectation:

- gate fails when Fortify or Sonatype Lifecycle policy criteria fail
- gate passes only when required scans succeed

## Example 3: Actions Allowlist Policy

At enterprise or organization Actions settings, choose a restrictive policy and allow only:

- `fortify-presales/platform-workflows`
- `fortify-presales/platform-actions` (if consumed directly)
- approved marketplace actions used by reusable workflows, for example:
  - `actions/checkout`
  - `actions/setup-java`
  - `actions/setup-node`
  - `actions/setup-python`
  - `actions/setup-dotnet`
  - `actions/upload-artifact`
  - `fortify/github-action`
  - `sonatype/actions/evaluate`

Operational recommendation:

- pin third-party actions to major version or immutable SHA per policy
- keep allowlist ownership with platform/security admins

## Example 4: CODEOWNERS for Workflow Protection

Example CODEOWNERS entries:

```text
# Protect repository workflow definitions
.github/workflows/* @fortify-presales/platform-team @fortify-presales/security-team

# Protect shared policy/action definitions
platform-actions/actions/* @fortify-presales/platform-team @fortify-presales/security-team

# Protect governance automation
platform-governance/* @fortify-presales/platform-team
```

Recommended repository settings:

- require CODEOWNERS review
- dismiss stale approvals when new commits are pushed

## Example 5: Compliance Scan Schedule

For governance repository automation:

- run daily (`0 2 * * *`) for full inventory checks
- support `workflow_dispatch` for on-demand verification
- produce both summary metrics and per-repo violation details

Typical violation categories:

1. no central workflow reference
2. disallowed `@main` reference
3. deprecated major version
4. missing required gate check

## Example 6: Enforcement Maturity Policy

1. Level 1 (Advisory)
   - governance reports only
   - no merge blocking
2. Level 2 (Controlled)
   - required `Security Gate`
   - CODEOWNERS enforced
3. Level 3 (Strict)
   - restrictive Actions allowlist
   - required workflows where available
   - optional pre-receive push rejection

## Implementation Checklist

- Define required check names and keep them stable.
- Roll out organization rulesets in phases.
- Validate allowlist against current reusable workflow dependencies.
- Add CODEOWNERS and branch protections before strict enforcement.
- Measure adoption and false-positive rate before raising strictness.
