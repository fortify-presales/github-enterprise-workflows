# Orchestrator and Detector Patterns

Many organizations already have a monorepo orchestrator/detector workflow that computes changed services and dispatches CI jobs. In that case, keep your existing detector and plug in platform reusable workflows.

## Pattern A: Existing Orchestrator (Recommended)

Use this when a repository already emits a matrix of changed services.

Reference example:

- `platform-workflows/examples/existing-orchestrator-integration.yml`

Expected matrix contract:

```json
{
  "include": [
    {
      "service": "orders",
      "path": "services/orders",
      "language": "node",
      "sonatype_application_id": "orders-app"
    }
  ]
}
```

### Integration Notes

1. Keep your existing `detect` job.
2. Feed matrix items into:
   - `reusable-fortify-fod.yml`
   - `reusable-sonatype-sca.yml`
3. Use one aggregate `reusable-security-gate.yml` job to enforce pass/fail.

## Pattern B: No Existing Detector (Starter)

Use this when a repository does not have orchestration yet.

Reference example:

- `platform-workflows/examples/detector-and-security-fanout.yml`

This starter:

1. Determines changed files from PR or push range.
2. Builds a matrix from `services/*` and `apps/*` paths.
3. Fans out Fortify and Sonatype scans per changed service.
4. Enforces one aggregate security gate.

## Pattern C: Polyglot Detector (Starter)

Use this when services in the same monorepo span multiple stacks and you want the detector to emit language-specific metadata.

Reference example:

- `platform-workflows/examples/detector-and-security-fanout-polyglot.yml`

This starter adds:

1. Per-service language detection from common build files.
2. Per-service Sonatype scan target generation.
3. Matrix fields consumed directly by Fortify and Sonatype reusable workflows.

Matrix item fields:

- `service`
- `path`
- `language`
- `scan_targets`
- `sonatype_application_id`

## Fit Guidance

- If orchestration exists: adopt Pattern A and preserve current repo conventions.
- If orchestration does not exist: start with Pattern B, then evolve service metadata and language mapping.
- If orchestration does not exist and services are polyglot: start with Pattern C.
- Keep reusable workflow references pinned to release tags (`@v1`), not `@main`.

## Common Customizations

1. Service path mapping for non-standard monorepo layouts.
2. Per-service language assignment (`node`, `python`, `maven`, `gradle`, `dotnet`).
3. Sonatype `application_id` mapping strategy.
4. Exemption handling via gate workflow inputs.
