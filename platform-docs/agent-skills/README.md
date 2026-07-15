# LLM Agent Skills for Setup and Configuration

These skill documents are templates for agent workflows that can help with:

- onboarding repositories to reusable security workflows
- integrating with existing orchestrator and detector patterns
- validating Fortify setup and configuration
- validating Sonatype Lifecycle setup and central CI configuration
- distributing governance templates across repositories
- applying and validating GHES ruleset enforcement
- enforcing organization-level defaults while allowing approved overrides

## Suggested Skill Set

1. reusable-workflow-onboarding
2. fortify-fod-setup-config
3. sonatype-sca-setup-config
4. security-gate-validation
5. orchestrator-detector-integration
6. governance-template-and-ruleset-operations

## New Skill Template Paths

- `orchestrator-detector-integration/SKILL.md`
- `governance-template-and-ruleset-operations/SKILL.md`

## Typical Outcomes

- caller workflow scaffolded with required inputs
- detector matrix contract validated for fanout jobs
- secrets and variables checklist generated
- governance template sync runbook generated
- GHES ruleset API execution checklist generated
- configuration drift checks reported
- suggested remediation edits generated

## Where to Place Active Skills

For Copilot-style local skills, place each skill under:

`.copilot/skills/<skill-name>/SKILL.md`

This directory currently provides documented templates that can be copied into active skill locations.
