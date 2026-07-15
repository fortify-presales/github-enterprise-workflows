# Security Workflow Documentation

This directory contains structured documentation for enterprise reusable workflows targeting GitHub Enterprise Server (GHES), with compatibility for GitHub.com testing.

## Audience

- Platform engineering teams owning centralized workflows
- Security engineering teams owning Fortify and Sonatype Lifecycle policy controls
- Application teams consuming reusable workflows

## Recommended Reading Order

1. `intro.md`
2. `architecture.md`
3. `workflows/fortify-fod-reusable.md`
4. `workflows/sonatype-sca-reusable.md`
5. `workflows/sonatype-lifecycle-fod-sync.md`
6. `workflows/security-gate.md`
7. `workflows/orchestrator-detector-patterns.md`
8. `actions/fcli-custom-actions.md`
9. `governance/compliance-rollout.md`
10. `governance/enforcement-strategy.md`
11. `governance/enforcement-examples.md`
12. `governance/enforcement-templates.md`
13. `governance/ghes-ruleset-api.md`
14. `agent-skills/README.md`
15. Publishing guidance under `publishing/`, including `publishing/template-sync.md`

## Folder Layout

- `workflows/`: Reusable workflow contracts and implementation guidance
- `actions/`: fcli custom action standards and examples
- `governance/`: Includes explicit GitHub Enterprise enforcement strategy
- `agent-skills/`: LLM agent skill templates for setup and configuration tasks
- `publishing/`: How to publish this content with Docusaurus
- `docusaurus/`: Docusaurus sidebar/navigation metadata

## Split Publishing Model

This structure is intentionally compatible with publishing as either:

- A single documentation repository
- Multiple repositories split by subdirectory ownership

Suggested split for `github.com/fortify-presales`:

- `platform-docs-core`: `intro.md`, `architecture.md`
- `platform-docs-workflows`: `workflows/`
- `platform-docs-actions`: `actions/`
- `platform-docs-governance`: `governance/`
- `platform-docs-agent-skills`: `agent-skills/`
- `platform-docs-publishing`: `publishing/`, `docusaurus/`

See `publishing/repository-split.md` for implementation options.
