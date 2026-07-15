# Skill: Orchestrator and Detector Integration

## Purpose

Integrate centralized Fortify and Sonatype Lifecycle reusable workflows into repositories that already have a service detector and orchestration pattern.

## Use When

- repository already has changed-service detection and matrix fanout
- security jobs need to plug into existing orchestration without replacing it
- matrix contracts are inconsistent across repositories

## Inputs Expected

- detector job name
- detector output name containing matrix JSON
- matrix fields currently emitted
- reusable workflow versions to consume

## Required Matrix Contract

- service
- path
- language
- lifecycle_application_id

Optional fields:

- scan_targets
- build_strategy
- exemption_ticket

## Actions

1. Inspect existing detector/orchestrator jobs.
2. Validate matrix JSON shape and required fields.
3. Map matrix fields into reusable Fortify and Sonatype Lifecycle callers.
4. Ensure a single aggregate security gate job remains stable for branch protection.
5. Produce patch-ready workflow edits and a compatibility report.

## Validation Rules

- detector outputs valid JSON matrix
- Fortify job consumes path and language correctly
- Sonatype Lifecycle job consumes application_id and scan_targets correctly
- gate check name is stable and referenced by branch protection policy
- shared workflow references are pinned to approved release tags

## Output

- integration patch suggestions
- matrix contract report
- branch protection check name recommendation
