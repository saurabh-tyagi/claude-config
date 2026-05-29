# Plan: Address MR !62 review comment #6 — move env-vars section in README

## Context

LyndonHB left an unresolved comment on `README.md:111` (the blank line immediately after the "Environment variables (process Lambda)" table):

> "Might want to move this around in the README."

The current README structure has a subsection `### Environment variables (process Lambda)` (lines 98–110) sitting inside `## Audit log lifecycle` (lines 85–110). The table lists all five process Lambda env vars:

| Variable | Purpose |
|---|---|
| `DYNAMO_DB_TABLE` | Request storage table |
| `DYNAMO_DB_INDEX` | GSI name for state-based queries |
| `DYNAMO_DB_AUDIT_LOGGING_TABLE` | Audit log DynamoDB table |
| `AUDIT_LOG_S3_BUCKET` | S3 bucket for materialised audit log archives |
| `AUDIT_LOG_S3_PREFIX` | Key prefix for archive objects within the bucket |

Only the bottom three of those five are audit-specific. Having `DYNAMO_DB_TABLE` and `DYNAMO_DB_INDEX` inside the audit lifecycle section is misleading. More importantly, environment variables are a **deployment / configuration** concern, not part of the lifecycle prose.

The intended outcome: lift the env-vars subsection out of `## Audit log lifecycle` and place it under `## Deployment` where it belongs — adjacent to the SAM build/deploy instructions.

## Approach

### Changes in `README.md`

1. **Remove** the `### Environment variables (process Lambda)` heading, the table, and the two-sentence paragraph that follows it (lines 98–111 of the current file) from inside `## Audit log lifecycle`.

2. **Update the tail** of `## Audit log lifecycle` to end cleanly after the archival description (the sentence currently ending at line 97: "…reads are seamless before and after archival."). The section keeps its two paragraphs and nothing else.

3. **Insert** the lifted content under `## Deployment` as a new sub-section `### Process Lambda environment variables`, placed immediately **before** the existing `### SAM` subsection (currently line 202). The inserted block:

```markdown
### Process Lambda environment variables

All five are wired automatically in SAM deployments via `template.yaml`
parameters. When running locally, set them in a `.env` file at the project
root.

| Variable | Purpose |
|---|---|
| `DYNAMO_DB_TABLE` | Request storage table |
| `DYNAMO_DB_INDEX` | GSI name for state-based queries |
| `DYNAMO_DB_AUDIT_LOGGING_TABLE` | Audit log DynamoDB table |
| `AUDIT_LOG_S3_BUCKET` | S3 bucket for materialised audit log archives |
| `AUDIT_LOG_S3_PREFIX` | Key prefix for archive objects within the bucket |
```

(The introductory sentence "All five are wired automatically…" moves with the table — it no longer makes sense in the audit section without the table.)

### Files modified

- `README.md` — sole change; move and re-home one subsection.

### Files NOT modified

- No code files, no tests, no SAM template.

## Verification

1. `grep -n "Environment variables" README.md` — confirms the heading now appears under the Deployment section (after line ~195) and is absent from the Audit log lifecycle section.
2. Read `## Audit log lifecycle` — confirms it ends with the archival/fallback description and has no env-var table.
3. Read `## Deployment` — confirms the new `### Process Lambda environment variables` subsection appears before `### SAM`.
4. Visually scan the overall README flow: API → Audit log lifecycle → Project Details → Development → Deployment (with env vars) → SAM → Code Quality Tools.

## Out of scope

All 5 code review comments (#1–#5) are already implemented and committed. This is the final outstanding comment.
