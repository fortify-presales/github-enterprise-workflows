# ref-app-python

Minimal Python example project for validating platform reusable workflows.

## Local run

```bash
python -m venv .venv
. .venv/Scripts/activate
pip install -r requirements.txt
python src/app.py
```

## Notes

- Branch-protection workflow is in `.github/workflows/security.yml`.
- Scheduled/manual Sonatype Lifecycle -> FoD SBOM sync is in `.github/workflows/lifecycle-fod-sync.yml` (nightly at `0 2 * * *`).
- Optionally set `vars.LIFECYCLE_APPLICATION_ID`; if unset, Sonatype defaults to `org/repo` (`github.repository`). Also set Fortify credentials/secrets before running scans.
