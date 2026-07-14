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

- Security workflow is in `.github/workflows/security.yml`.
- Optionally set `vars.LIFECYCLE_APPLICATION_ID`; if unset, Sonatype defaults to `org/repo` (`github.repository`). Also set Fortify credentials/secrets before running scans.
