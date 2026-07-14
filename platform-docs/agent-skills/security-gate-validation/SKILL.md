# Skill: Security Gate Validation

## Purpose

Ensure final branch protection gate behavior is correct and deterministic across Fortify and Sonatype outcomes.

## Use When

- gate behavior is inconsistent
- scans pass but gate fails unexpectedly
- exemptions need controlled handling

## Checks

- required upstream jobs are present and referenced by needs
- gate is aggregate (single required check) after Fortify/Sonatype fanout
- gate logic treats required scans as blocking where configured
- exemption path requires explicit ticket and expiration
- summary output communicates decision clearly

## Actions

1. Inspect gate workflow logic.
2. Validate output contracts from upstream jobs.
3. Simulate decision outcomes for pass/fail cases.
4. Report logic gaps and propose fixes.
5. Confirm branch protection references the stable gate check name.

## Output

- gate logic validation report
- corrected decision matrix
- recommended branch protection check names
