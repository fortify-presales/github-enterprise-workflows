# fcli Custom Actions

## Scope

Custom actions are used for enterprise-specific logic that should not be duplicated across workflow YAML files.

Typical examples:

- Custom policy checks
- PR-specific policy checks
- Sonatype SBOM enrichment and FoD import

## Action Authoring Standards

1. Include action schema declaration.
2. Include `author` and `usage` metadata.
3. Keep CLI options explicit and typed.
4. Mask sensitive options using high sensitivity masking.
5. Use deterministic `check` blocks for pass/fail behavior.
6. Keep policy criteria centralized in the action code.

## Schema Guidance

- Use released schema versions compatible with target fcli versions.
- Keep schema version upgrades controlled and tested.

## Testing Guidance

- Validate each action against sample release IDs in non-production.
- Validate success and failure paths.
- Validate output formatting for summaries and logs.
- Validate behavior for missing inputs and permission errors.

## Governance Guidance

- Version action files with the platform-workflow release tags.
- Avoid ad hoc repository-local copies of shared action logic.
