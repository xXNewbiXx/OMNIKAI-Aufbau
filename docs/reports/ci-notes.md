# CI Notes

## Checks

- **Markdownlint:** `npx -y markdownlint-cli README.md docs/branch-protection.md docs/reports/ci-notes.md --disable MD013`
  - **Fail:** reports offending file and line.
  - **Fix:** adjust formatting then rerun.
- **JSON syntax:** uses `jq empty` on each tracked `.json` file.
  - **Fail:** `❌ Invalid JSON in <file>`.
  - **Fix:** correct the JSON structure.
- **n8n flow schema:** `npx -y ajv-cli@5 validate -s infra/schemas/n8n-flow.schema.json -d flows/n8n/<file>.json --spec=draft7`
  - **Fail:** `❌ Schema validation failed for <file>`.
  - **Fix:** update the flow or schema to match.

These checks exit on first error, keeping the workflow under two minutes.
