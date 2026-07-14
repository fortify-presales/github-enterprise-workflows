# GitHub Enterprise Enforcement Templates

This appendix contains copy/paste starter templates you can adapt for your organization.

Raw files are available under `platform-governance/templates/`:

- `platform-governance/templates/rulesets/main-security-enforcement.json`
- `platform-governance/templates/codeowners/CODEOWNERS.security`
- `platform-governance/templates/workflows/repository-compliance.yml`
- `platform-governance/templates/scripts/check-compliance.ps1`

## Template 1: Branch Ruleset (Conceptual JSON)

Use this as a reference structure for API or IaC-based ruleset management.

```json
{
  "name": "main-security-enforcement",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main"],
      "exclude": []
    }
  },
  "rules": [
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 1,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": true,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": true,
        "required_status_checks": [
          {
            "context": "Security Gate"
          }
        ]
      }
    },
    {
      "type": "non_fast_forward"
    },
    {
      "type": "deletion"
    }
  ]
}
```

## Template 2: CODEOWNERS

```text
# Require platform/security review for workflow changes
.github/workflows/* @fortify-presales/platform-team @fortify-presales/security-team

# Protect shared policy actions
platform-actions/actions/* @fortify-presales/platform-team @fortify-presales/security-team

# Protect governance automation
platform-governance/* @fortify-presales/platform-team
```

## Template 3: Governance Compliance Workflow

```yaml
name: Repository Compliance

on:
  workflow_dispatch:
  schedule:
    - cron: "0 2 * * *"

permissions:
  contents: read

jobs:
  compliance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run compliance checks
        shell: pwsh
        run: |
          ./scripts/check-compliance.ps1 -RootPath .
```

## Template 4: Compliance Script Checks (PowerShell)

```powershell
param(
    [string]$RootPath = "."
)

$ErrorActionPreference = "Stop"
$workflowFiles = Get-ChildItem -Path $RootPath -Recurse -File -Include *.yml,*.yaml |
    Where-Object { $_.FullName -match "\\.github\\workflows\\" }

$violations = @()
foreach ($file in $workflowFiles) {
    $content = Get-Content -Path $file.FullName -Raw

    if ($content -match "uses:\s*fortify-presales/platform-workflows/.+@main") {
        $violations += "Disallowed @main reference: $($file.FullName)"
    }

    if ($content -notmatch "fortify-presales/platform-workflows/.github/workflows/reusable-fortify-fod.yml@v1") {
        $violations += "Missing required Fortify reusable workflow ref: $($file.FullName)"
    }

    if ($content -notmatch "fortify-presales/platform-workflows/.github/workflows/reusable-sonatype-sca.yml@v1") {
        $violations += "Missing required Sonatype reusable workflow ref: $($file.FullName)"
    }
}

if ($violations.Count -gt 0) {
    Write-Host "Compliance violations found:"
    $violations | ForEach-Object { Write-Host "- $_" }
    exit 1
}

Write-Host "Compliance checks passed."
exit 0
```

## Template 5: Actions Allowlist Baseline (Policy Checklist)

Use this checklist when configuring enterprise/org Actions policy:

- Allow local actions/reusable workflows from your organization.
- Explicitly allow central repositories:
  - `fortify-presales/platform-workflows`
  - `fortify-presales/platform-actions`
- Allow approved third-party actions used by central workflows:
  - `actions/checkout`
  - `actions/setup-java`
  - `actions/setup-node`
  - `actions/setup-python`
  - `actions/setup-dotnet`
  - `actions/upload-artifact`
  - `fortify/github-action`
  - `sonatype/actions/evaluate`
- Block all unapproved external actions.

## Template 6: Repository Caller Workflow (Minimal)

```yaml
name: Security

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read
  security-events: write
  pull-requests: write

jobs:
  fortify:
    uses: fortify-presales/platform-workflows/.github/workflows/reusable-fortify-fod.yml@v1
    with:
      language: node
      build_strategy: auto
    secrets: inherit

  sonatype:
    uses: fortify-presales/platform-workflows/.github/workflows/reusable-sonatype-sca.yml@v1
    with:
      application_id: my-app
    secrets: inherit

  gate:
    needs: [fortify, sonatype]
    uses: fortify-presales/platform-workflows/.github/workflows/reusable-security-gate.yml@v1
    with:
      required_statuses_csv: >-
        Fortify=${{ needs.fortify.result }},Sonatype=${{ needs.sonatype.result }}

  # Optional multi-tool extension
  # gate:
  #   needs: [fortify, sonatype, snyk, codeql]
  #   uses: fortify-presales/platform-workflows/.github/workflows/reusable-security-gate.yml@v1
  #   with:
  #     required_statuses_csv: >-
  #       Fortify=${{ needs.fortify.result }},Sonatype=${{ needs.sonatype.result }},Snyk=${{ needs.snyk.result }},CodeQL=${{ needs.codeql.result }}
  #     allowed_statuses_csv: success
```

## Adaptation Notes

- Treat these templates as starting points.
- Validate exact GHES capabilities for your version.
- Keep required check names stable once branch protection is active.
