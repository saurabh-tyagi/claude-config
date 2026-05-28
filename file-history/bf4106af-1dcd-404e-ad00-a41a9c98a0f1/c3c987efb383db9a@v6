# Fix I4 — Update README with audit log lifecycle and new env vars

## Context

Review issue I4: the README was not updated when DATA-4715 landed. Two things are missing:

1. The audit log lifecycle is undocumented — readers don't know that audit entries live in DynamoDB while a request is in-flight and are archived to S3 once the request reaches the terminal `done` state.
2. The two new env vars added to `ProcessFunction` (`AUDIT_LOG_S3_BUCKET`, `AUDIT_LOG_S3_PREFIX`) are not mentioned anywhere in the README, even though the equivalent vars on `ReporterFunction` are implicitly described through the `GET /status/{id}` fallback note.

## Change — `README.md` only

### 1. Document `POST /erasure-request`

The API section currently only documents `GET /status/{id}`. Add a `POST /erasure-request` subsection above it covering: purpose, required fields, response codes (200 success, 400 bad request, 409 duplicate id, 500 internal error). This is the natural place to introduce the erasure id concept that the lifecycle section will reference.

### 2. Add "Audit log lifecycle" section

Add a short section under the API section (or as its own `## Audit log lifecycle` heading) explaining:

- While a request is being processed, audit log entries are written to DynamoDB (keyed by erasure id + timestamp).
- Once a request is successfully processed and reaches the `done` state, the complete audit log is archived to S3 as a gzipped JSON Lines object (`{prefix}/{id}.jsonl.gz`) and the DynamoDB entries are removed.
- The `GET /status/{id}` endpoint reads from DynamoDB first, falling back to the S3 archive — so reads work seamlessly before and after archival.

### 3. Document env vars for ProcessFunction

Add a table or bullet list of the env vars required by the process Lambda, including the two new ones:

| Variable | Purpose |
|---|---|
| `DYNAMO_DB_TABLE` | Request storage table |
| `DYNAMO_DB_INDEX` | GSI for state-based queries |
| `DYNAMO_DB_AUDIT_LOGGING_TABLE` | Audit log DynamoDB table |
| `AUDIT_LOG_S3_BUCKET` | S3 bucket for materialised audit log archives |
| `AUDIT_LOG_S3_PREFIX` | Key prefix for archive objects in the bucket |

These are already defined as SAM parameters and wired via `template.yaml` — the README just needs to surface them for developers configuring local `.env` files or debugging.

## Critical files

- `README.md` only

## Verification

1. Read the updated README and confirm the three additions are present and accurate.
2. `uv run pytest` — no regressions (README change cannot break tests).
