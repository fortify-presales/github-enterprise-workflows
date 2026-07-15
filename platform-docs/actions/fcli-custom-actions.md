# fcli Custom Actions

## Scope

Custom actions are used for enterprise-specific logic that should not be duplicated across workflow YAML files.

Typical examples:

- Custom policy checks
- PR-specific policy checks
- Sonatype Lifecycle SBOM enrichment and FoD import

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

## Signing Custom Actions

For production use, sign custom actions and configure runners to trust the signer public key.
This avoids use of unsigned-action bypass options and provides tamper detection.

### Why Sign

- Ensures action integrity between authoring and execution.
- Prevents accidental or malicious action-file changes from running unnoticed.
- Supports enterprise governance requirements for trusted automation content.

### Signing Workflow

1. Generate or use an existing private/public key pair managed by your organization.
2. Sign the action file with the private key.
3. Distribute only the public key to runner environments.
4. Import the public key on runners before executing custom actions.
5. Run actions without unsigned bypass flags.

### Sign an Action File

```bash
fcli fod action sign ./platform-actions/actions/import-lifecycle-sbom-to-fod.yaml --with /path/to/private.key
```

### Trust the Signer on a Runner

```bash
fcli config public-key import --from /path/to/public.key
```

### GitHub Actions Example (Public Key From Secret)

Store the public key PEM as an organization or repository secret, then import before running custom actions.

```yaml
- name: Import trusted fcli action signer key
	shell: bash
	run: |
		set -euo pipefail
		cat > fcli-action-public.pem << 'EOF'
		${{ secrets.FCLI_ACTION_PUBLIC_KEY_PEM }}
		EOF
		fcli config public-key import --from fcli-action-public.pem

- name: Run signed custom action
	shell: bash
	run: |
		set -euo pipefail
		fcli fod action run https://raw.githubusercontent.com/fortify-presales/platform-actions/v1/actions/import-lifecycle-sbom-to-fod.yaml
```

### Operational Notes

- Re-sign actions after any content change.
- Keep private keys out of CI; use only public keys in runner environments.
- Prefer pinned refs (for example release tags) for remote action URLs.
- Remove `--on-unsigned=ignore` from production pipelines after trust is configured and validated.
