# Plan: Raise GitLab MR for `DATA_4716_audit_log_api`

## Context
Branch `DATA_4716_audit_log_api` adds an audit log retrieval API
(GET `/status/{id}`) backed by a new `ReporterFunction` Lambda, plus the
underlying read paths in `audit_logging.py` and supporting tests/IaC. There
is no open MR for this branch yet on `origin` (verified with `glab mr list`).
The two commits on the branch (`262cd71` and `a8559dd`) are already pushed,
so the branch is up-to-date with `origin/DATA_4716_audit_log_api`. We just
need to open the MR against `master` with a description that follows the
project's `mr-description` skill format.

## Pre-flight checks (read-only)
- Confirm branch is pushed and up-to-date with origin: already verified
  (`Your branch is up to date with 'origin/DATA_4716_audit_log_api'`).
- Confirm no existing MR on this source branch: already verified via
  `glab mr list --source-branch DATA_4716_audit_log_api` (returned none).
- Untracked local files (`.DS_Store`, `.claude/`, `.idea/`, `local-run.sh`)
  are NOT to be added to the commit/MR. Leave them alone.

## MR target
- Source branch: `DATA_4716_audit_log_api`
- Target branch: `master`
- Project: `HnBI/dns/dns-de-rte-orchestrator` (GitLab)
- Jira key (derived from branch): `DATA-4716`

## MR title
`DATA-4716: Add audit log retrieval API endpoint`

## MR description (per `mr-description` skill format)

```
## What
Adds a `GET /status/{id}` API endpoint to retrieve the audit log for a
given erasure request id. Introduces a new `ReporterFunction` Lambda
(`src/dns_de_rte_orchestrator/reporter_lambda.py`) and extends
`src/dns_de_rte_orchestrator/audit_logging.py` with an `AuditEntry` model,
a `get_logs` method on the `AuditLogger` interface (and all implementations),
and an S3-fallback reader. Wires the new Lambda, IAM policy and API route
into `template.yaml`.

## Why
Operators currently have no way to inspect the audit trail of an erasure
request without direct DynamoDB access. DATA-4716 requires a private,
API-key-protected endpoint that returns the chronological audit log for an
erasure id, falling back to S3-materialised logs when the DynamoDB record
has aged out.

## Changes
1. `src/dns_de_rte_orchestrator/audit_logging.py`
   - Add `AuditEntry` dataclass with `to_json` / `from_json`.
   - Add `get_logs(id)` to `AuditLogger` ABC and implement for `NoOpAuditLogger`,
     `InMemoryAuditLogger`, the DynamoDB logger and a new S3 reader.
   - Add `FallbackAuditLogReader` and `get_audit_log_reader` factory.
2. `src/dns_de_rte_orchestrator/reporter_lambda.py` (new)
   - Lambda handler that validates `pathParameters.id`, calls the reader,
     and returns 200/400/404/500 JSON responses.
3. `template.yaml`
   - New `AuditLogS3Bucket` / `AuditLogS3Prefix` parameters.
   - New `ReporterServerlessAccessManager`, `ReporterS3ReadPolicy`,
     `ReporterFunction` resources and `GET /status/{id}` API event.
   - New `GetStatusApiInvokeUrl` output.
4. `samconfig.toml`, `Makefile`, `.gitignore` — wire the new Lambda into
   the SAM build/package pipeline.
5. `TODO.md` — mark audit log retrieval items complete.
6. Tests
   - `tests/test_audit_logging.py` — extensive coverage for `AuditEntry`,
     `get_logs` across all implementations, S3 reader and fallback reader.
   - `tests/test_reporter_lambda.py` (new) — handler success / 400 / 404 /
     500 paths.
   - `tests/test_s3_audit_log_reader.py` (new) — S3 read + gzip/JSONL parse.
   - `tests/test_dynamodb_audit_logger.py` — extended for the new query path.
```

## Steps to execute (when plan is approved)
1. Run `glab auth status` (read-only) to confirm CLI is authenticated to
   `gitlab.com`. If not, stop and ask the user to authenticate.
2. Create the MR with `glab mr create` using the title above and the
   description body via a HEREDOC, with:
   - `--source-branch DATA_4716_audit_log_api`
   - `--target-branch master`
   - `--remove-source-branch`
   - `--squash-before-merge` only if that is the project default (otherwise
     omit; do not force a merge strategy).
   - No `--draft` flag.
   - No additional signature appended (per skill instructions).
3. Capture and report the MR URL returned by `glab`.

## Verification
- `glab mr view` on the returned URL/iid shows:
  - Correct title, description, source/target branches.
  - The two commits (`262cd71`, `a8559dd`) listed.
  - Pipeline triggered (CI status visible).
- `glab mr list --source-branch DATA_4716_audit_log_api` now lists the new
  MR as open.

## Out of scope / explicitly NOT doing
- No new commits, rebases, or force-pushes.
- No staging of the untracked local files (`.DS_Store`, `.claude/`,
  `.idea/`, `local-run.sh`).
- No `sam deploy` or any deploy step.
- No edits to `CLAUDE.md` or memory files as part of this task.
