# Publishing with Docusaurus

## Minimal Setup

1. Initialize Docusaurus in a publishing repository or docs site branch.
2. Copy this `platform-docs/` content into the Docusaurus `docs` directory.
3. Copy `platform-docs/docusaurus/sidebars.js` to the site root as `sidebars.js`.
4. Configure navbar and docs route in `docusaurus.config.js`.

## Suggested Command Sequence

```bash
npx create-docusaurus@latest security-docs classic
cd security-docs
# replace generated docs with this repo's platform-docs content
npm install
npm run start
```

## Versioning

Use Docusaurus docs versioning for major workflow contract changes (`v1`, `v2`).

## CI/CD

Publish with GitHub Pages or internal static hosting.

## Split Repository Publishing

If you split content into multiple repositories, publish each repository with its
own Docusaurus site or aggregate multiple repositories into a single site via CI
sync jobs that copy each repo into one combined docs tree before build.
