# GitHub Enterprise Enforcement Strategy

This page defines practical controls for forcing adoption of centralized Fortify and Sonatype reusable workflows.

For copy-ready sample settings, see `governance/enforcement-examples.md`.
For copy/paste starter snippets, see `governance/enforcement-templates.md`.

## Layered Enforcement Model

Use multiple controls together.

1. Rulesets with required checks
2. Actions allowlist policy
3. CODEOWNERS protection
4. Required workflows (if supported by your GHES version)
5. Governance scanning and remediation
6. Optional pre-receive hard enforcement

## 1) Rulesets with Required Security Gate

Primary control:

- Require a single status check such as `Security Gate` on protected branches.
- Ensure this gate depends on centralized Fortify and Sonatype reusable workflows.

Why this works:

- Teams cannot merge unless centralized controls run and pass.
- Auditing is simpler than requiring many scanner-specific checks.

## 2) Actions Allowlist Policy

Configure enterprise/organization Actions settings to:

- allow only approved action sources
- allow only approved reusable workflow repositories
- block unapproved external actions

This reduces bypass risk by disallowing ad hoc substitutes.

## 3) CODEOWNERS for Workflow and Policy Paths

Protect these paths with required owner review:

- `.github/workflows/**`
- shared policy/action paths in platform repositories

This prevents direct modification of enforcement logic without platform/security approval.

## 4) Required Workflows (Where Available)

If your GHES version supports required workflows:

- enforce org-level required workflow execution
- use alongside required checks and allowlist policy

## 5) Governance Scan and Auto-Remediation

Run scheduled governance workflows to detect:

- missing centralized workflow references
- disallowed `@main` references
- deprecated tags/versions

Then:

- produce compliance reports
- open pull requests with remediation updates

## 6) Optional Pre-Receive Hook Enforcement

For strict environments:

- reject pushes that introduce non-compliant workflow references

Tradeoff:

- strongest push-time control
- higher operational overhead

## Maturity Rollout

1. Establish
   - Introduce gate workflow and required check
   - Apply Actions allowlist
2. Scale
   - Add CODEOWNERS and governance reporting
   - Begin auto-remediation PRs
3. Enforce
   - Enable required workflows where available
   - Add pre-receive hooks if needed

## Recommended Baseline

- Required `Security Gate` check
- Actions allowlist with approved sources only
- CODEOWNERS on workflow/policy files
- Scheduled governance + remediation pull requests
