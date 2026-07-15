# Introduction

This documentation set defines an enterprise operating model for reusable GitHub Actions workflows focused on:

- Fortify on Demand (FoD) Static Application Security Testing (SAST)
- Sonatype Lifecycle Software Composition Analysis (SCA)

## Goals

- Standardize security workflows across many repositories.
- Keep security logic centralized in one managed repository.
- Allow repository-level variation through explicit, approved inputs.
- Preserve compatibility across GHES and GitHub.com.

## Non-Goals

- Replacing team-specific build logic for all languages.
- Defining application business logic or release strategy.
- Providing one-off ad hoc scanner scripts.

## Principles

- Reusable workflows are versioned and centrally governed.
- Repositories contain thin caller workflows.
- Secrets remain in enterprise secret stores and environment-scoped settings.
- Policy checks are deterministic and auditable.
