# GHES Ruleset API Examples

This page provides starter API examples to manage branch rulesets for security workflow enforcement.

## Prerequisites

- GHES URL and API reachability.
- Token with repo administration permissions.
- Organization and repository names.

Set environment variables:

```bash
export GHES_URL="https://ghe.example.com"
export GH_TOKEN="<token>"
export ORG="fortify-presales"
export REPO="sample-service"
```

## 1) List Repository Rulesets

```bash
curl -sS \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GH_TOKEN}" \
  "${GHES_URL}/api/v3/repos/${ORG}/${REPO}/rulesets"
```

## 2) Create Branch Ruleset

Using template payload from `platform-governance/templates/rulesets/main-security-enforcement.json`.

```bash
curl -sS -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GH_TOKEN}" \
  -H "Content-Type: application/json" \
  "${GHES_URL}/api/v3/repos/${ORG}/${REPO}/rulesets" \
  --data @platform-governance/templates/rulesets/main-security-enforcement.json
```

## 3) Update Existing Ruleset

```bash
export RULESET_ID="123"

curl -sS -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GH_TOKEN}" \
  -H "Content-Type: application/json" \
  "${GHES_URL}/api/v3/repos/${ORG}/${REPO}/rulesets/${RULESET_ID}" \
  --data @platform-governance/templates/rulesets/main-security-enforcement.json
```

## 4) Verify Required Check

Confirm required status checks include `Security Gate`.

```bash
curl -sS \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GH_TOKEN}" \
  "${GHES_URL}/api/v3/repos/${ORG}/${REPO}/rulesets/${RULESET_ID}"
```

## Notes

- API shapes can vary by GHES version; verify against your instance documentation.
- Prefer applying rulesets through controlled automation and audited change management.
- For org-wide rollout, iterate repositories and apply the same payload with repository-specific exclusions where needed.
