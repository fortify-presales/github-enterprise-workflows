# Skill: Sonatype SCA Setup and Configuration

## Purpose

Validate and configure Sonatype SCA integration, including optional central CI configuration API usage and FoD SBOM import.

## Use When

- Sonatype evaluation fails due to missing config or invalid app/stage setup
- repository onboarding requires central CI configuration alignment
- SBOM import to FoD is required

## Required Configuration Checks

- LIFECYCLE_SERVER_URL configured
- credentials configured
  - LIFECYCLE_USERNAME
  - LIFECYCLE_PASSWORD
- application_id and stage are valid
- scan_targets are explicit and match repository manifests
- scan_targets support per-service fanout in monorepos
- application_id mapping strategy is deterministic per service

## Central Configuration Checks

- parameterPriority policy is defined
  - CI or API
- organization/application-level central config exists where expected
- pipeline-side values are not conflicting with enforced API values

## Optional FoD SBOM Import Checks

- FoD credentials present
- action path for SBOM import is valid
- CycloneDX version configured and compatible

## Actions

1. Inspect Sonatype workflow inputs/env.
2. Validate central configuration strategy.
3. Validate artifact upload behavior for GHES.
4. Produce remediation suggestions for invalid or missing values.
5. Validate detector matrix fields required by Sonatype fanout jobs.

## Output

- readiness status report
- central config recommendation
- optional SBOM import enablement checklist
