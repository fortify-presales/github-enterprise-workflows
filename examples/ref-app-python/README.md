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
- Set `vars.LIFECYCLE_APPLICATIONS_ID` and Fortify credentials/secrets before running scans.
