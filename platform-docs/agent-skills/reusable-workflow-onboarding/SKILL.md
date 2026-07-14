# Skill: Reusable Workflow Onboarding

## Purpose

Onboard a repository to centralized reusable workflows for Fortify and Sonatype with minimal per-repository YAML.

## Use When

- repository has no security workflow
- repository references outdated or non-approved workflow paths
- repository uses branch references instead of approved tags
- repository already has an orchestrator/detector and needs reusable workflow integration

## Inputs Expected

- repository type and language
- default branch
- required scan types
- approved reusable workflow repository and version
- whether detector/orchestrator already exists
- expected detector matrix fields

## Actions

1. Detect existing workflow files.
2. Propose caller workflow using approved reusable workflow references.
3. Populate language-specific input values.
4. Add permissions baseline.
5. Add security gate job reference if required.
6. Produce a setup checklist for missing secrets and variables.
7. If detector exists, map matrix fields to reusable workflow inputs.
8. If detector does not exist, provide detector + fanout starter using approved examples.

## Validation Rules

- no shared workflow references using main
- required Fortify caller job present
- required Sonatype caller job present
- required branch triggers configured
- detector matrix includes service metadata needed for fanout
	- service
	- path
	- language
	- sonatype_application_id

## Output

- proposed workflow YAML
- proposed detector integration plan
- setup checklist
- compliance status summary
