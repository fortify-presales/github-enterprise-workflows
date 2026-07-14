# Reusable Workflow: Fortify FoD SAST

## Purpose

Provide one centrally managed Fortify FoD reusable workflow contract that supports multiple languages and build models.

## Inputs

- `language`: `java|gradle|node|python|dotnet|other`
- `build_command`: Optional build command run before packaging/scan
- `source_dir`: Scan source directory
- `package_extra_opts`: Extra ScanCentral package options
- `list_source_files`: Print file inventory under `source_dir` before scan (default `false`)
- `fod_release_override`: Explicit FoD release override
- `copy_from_release`: Parent release for setup inheritance
- `do_setup`: Enable release setup flow
- `do_sast_scan`: Enable SAST scan start
- `do_sca_scan`: Enable SCA-in-SAST if licensed/configured
- `do_aviator_audit`: Enable Fortify Aviator Audit stage (default `false`)
- `sast_assessment_type`: SAST assessment type passed to FoD (default `Static Assessment`)
- `do_wait`: Wait for scan completion
- `do_check_policy`: Run custom or built-in policy checks
- `check_policy_action`: Custom action path/name
- `check_policy_extra_opts`: Extra opts for policy action
- `runner`: Runner label or group
- `debug`: Enable debug mode and debug artifact collection

## Required Environment Variables

- `FOD_URL`
- `FOD_CLIENT_ID`
- `FOD_CLIENT_SECRET`

Optional authentication mode:

- `FOD_TENANT`, `FOD_USER`, `FOD_PASSWORD`

## Operational Environment Variables

- Setup and bootstrap:
  - `FCLI_BOOTSTRAP_VERSION`
  - `FCLI_BOOTSTRAP_URL`
  - `TOOL_DEFINITIONS`
  - `PREINSTALLED`
- Release management:
  - `FOD_RELEASE`
  - `SETUP_ACTION`
  - `SETUP_EXTRA_OPTS`
  - `COPY_FROM_RELEASE`
  - `SAST_ASSESSMENT_TYPE`
- Packaging and scan execution:
  - `PACKAGE_ACTION`
  - `PACKAGE_ACTION_EXTRA_OPTS`
  - `USE_PACKAGE`
  - `PACKAGE_EXTRA_OPTS`
  - `SC_CLIENT_VERSION`
  - `SC_CLIENT_HOME`
  - `SAST_SCAN_EXTRA_OPTS`
  - `SAST_WAIT_EXTRA_OPTS`
- Post-scan:
  - `DO_AVIATOR_AUDIT`
  - `DO_RELEASE_SUMMARY`
  - `DO_CHECK_POLICY`
  - `CHECK_POLICY_ACTION`
  - `CHECK_POLICY_EXTRA_OPTS`
  - `DO_PR_COMMENT`
  - `DO_SAST_EXPORT`

## Recommended Action Selection

- Default (deprecation-safe): `fortify/github-action/without-artifacts@v3`
- GitHub.com (if artifact wrappers are required and approved): `fortify/github-action@v3`
- GHES artifact wrapper mode may transitively rely on deprecated artifact action versions depending on upstream release state.

## Language Guidance

- Java/Gradle: pass explicit package build options and cache settings.
- Node: ensure lockfiles are present and build scripts are optional-safe.
- Python: preinstall dependencies and provide requirements-based package options.
- Dotnet: restore and build with deterministic configuration.

## Failure Semantics

- Workflow should fail on scanner execution errors by default.
- Policy check stage controls branch protection outcome.
- Optional non-blocking mode can be allowed only during onboarding.
