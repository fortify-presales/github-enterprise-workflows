# Publishing with Docusaurus

## Minimal Setup

1. Initialize Docusaurus in a publishing repository or docs site branch.
2. Copy this `platform-docs/` content into the Docusaurus `docs` directory.
3. Copy `platform-docs/docusaurus/sidebars.js` to the site root as `sidebars.js`.
4. Configure navbar and docs route in `docusaurus.config.js`.

## Run and Preview Locally

Quickest path from repository root:

```powershell
.\scripts\preview-platform-docs.ps1 -Mode start
```

Other modes:

```powershell
.\scripts\preview-platform-docs.ps1 -Mode prepare
.\scripts\preview-platform-docs.ps1 -Mode build
.\scripts\preview-platform-docs.ps1 -Mode serve -Port 3001
.\scripts\preview-platform-docs.ps1 -Mode start -OpenBrowser
.\scripts\preview-platform-docs.ps1 -Mode clean
```

By default, this script creates a transient Docusaurus scaffold under `.tmp/platform-docs-site`, syncs `platform-docs` content, and runs the requested mode.

Manual equivalent:

From repository root:

```bash
npx create-docusaurus@latest security-docs classic
cd security-docs
rm -rf docs/*
cp -R ../platform-docs/* docs/
rm -rf docs/docusaurus docs/.github
cp ../platform-docs/docusaurus/sidebars.js ./sidebars.js
npm ci
npm run start
```

Production-like local preview:

```bash
cd security-docs
npm run build
npm run serve
```

If `npm run start` fails, run `npm run build` to get actionable validation output.

## Suggested Command Sequence

```bash
npx create-docusaurus@latest security-docs classic
cd security-docs
# replace generated docs with this repo's platform-docs content
npm install
npm run start
```

## CI Workflows In This Repository

Two workflows are provided under the platform-docs subtree so they are published to the split `platform-docs` repository by `publish-platform-directories.ps1`:

- GitHub Pages deployment: `platform-docs/.github/workflows/publish-platform-docs-pages.yml`
- GHES-friendly static branch publish: `platform-docs/.github/workflows/publish-platform-docs-static-branch.yml`

### 1) GitHub.com Pages Flow

- Builds a transient Docusaurus site at runtime from the current repository docs content and `docusaurus/sidebars.js`.
- Deploys generated `build` output using Pages actions.

Prerequisites:

1. Enable GitHub Pages in repository settings.
2. Ensure workflow permissions allow `pages:write` and `id-token:write`.

### 2) GHES or Generic Static Hosting Flow

- Builds a transient Docusaurus site and force-pushes static files to a target branch (default `gh-pages`).
- Works for GHES and GitHub.com where an external/static host serves branch content.

Manual dispatch input:

- `target_branch`: branch to receive built site content.

Typical hosting integration:

1. Configure your internal static host to serve the `gh-pages` branch.
2. Trigger workflow on merge to `main` or manually for controlled releases.
3. Validate published site from host URL.

## Versioning

Use Docusaurus docs versioning for major workflow contract changes (`v1`, `v2`).

## CI/CD

Publish with GitHub Pages or internal static hosting.

## Split Repository Publishing

If you split content into multiple repositories, publish each repository with its
own Docusaurus site or aggregate multiple repositories into a single site via CI
sync jobs that copy each repo into one combined docs tree before build.
