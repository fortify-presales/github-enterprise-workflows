# Skill: Fortify FoD Setup and Configuration

## Purpose

Validate and configure repository integration for Fortify on Demand reusable workflows.

## Use When

- Fortify scan fails at setup, authentication, packaging, or policy stages
- repository is onboarding to Fortify reusable workflow
- policy check action needs standardization

## Required Configuration Checks

- FOD_URL present as repository or environment variable
- API key credentials present
  - FOD_CLIENT_ID
  - FOD_CLIENT_SECRET
- FOD release naming strategy is valid
- setup behavior configured
  - DO_SETUP
  - COPY_FROM_RELEASE
  - SAST_ASSESSMENT_TYPE
- packaging behavior configured for language and toolchain
- source_dir is set correctly for monorepo service fanout
- build_strategy matches service language and repo conventions
- runtime versions are explicitly set when policy requires pinning

## Optional Advanced Checks

- custom action references for policy checks are valid
- post-scan export and PR comment settings are aligned to policy
- debug artifact strategy is GHES compatible
- detector matrix language values map to Fortify workflow language input
- per-service release naming pattern is deterministic for branch and PR events

## Actions

1. Inspect workflow env and inputs.
2. Compare against required baseline.
3. Generate exact missing items checklist.
4. Suggest safe defaults for missing optional values.
5. Flag risky configuration (for example broad overrides or non-pinned references).
6. Validate monorepo fanout compatibility for source_dir and language.

## Output

- pass/fail readiness report
- remediation patch suggestions
- final variable and secret matrix
