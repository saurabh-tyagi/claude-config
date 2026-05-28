# Plan — Address review findings M1, M2, M3, m8, m11, n5

## Context

The deep-code-reviewer flagged six issues on `DATA_4715_audit_log_to_s3` against
`master`. None are in the critical bucket, but two are deployment-time bugs
that would cause the new audit-log-to-S3 pipeline to silently misbehave in
production, and one is an API regression that can cause a successful create to
return 500. The other three are smaller correctness/visibility/hygiene
fix-ups.

This plan tightens those gaps before merge so the audit archival path is
trustworthy on the very first deploy that actually exercises it (whenever the
phase-3 handler lands), and so callers of `POST /erasure-request` cannot get a
spurious 5xx after the request has already been persisted.

## Scope and approach

### M1 — `_archive_if_done` has no live trigger; document and update TODO.md

`request_processor.py:195-212` already gates archival on `request.state ==
"done"`. No production handler currently transitions to `"done"` (`phase-2`
and `phase-3` raise `NotImplementedError` before any transition). The
plumbing is correct; the trigger is pending phase-3 implementation.

Changes:
- Expand the `_archive_if_done` docstring to spell out the precondition: it
  fires only when the just-completed `process_request` was the call that
  transitioned the request to `"done"` in this same iteration. Future
  maintainers who add a new terminal handler must call `_archive_if_done`
  themselves if the transition happens outside `process_request`.
- Update `TODO.md` `Add audit logging materialising to S3 after successful
  erasure` line to flag that the archival code is in place but is not yet
  triggered by any production handler — explicit reminder that phase-3 must
  end with a transition to `"done"`.

No regression test is added in this PR — there is no real "done" path to
exercise yet. A real end-to-end test will land alongside phase-3
implementation.

### M2 — Constrain `AuditLogS3Prefix` so the IAM ARN cannot break

`template.yaml:201,227` builds the resource ARN as
`arn:aws:s3:::${bucket}/${prefix}/*`. Empty prefix → `bucket//*` → no match
→ AccessDenied at runtime. The Python code (`audit_logging.py`) tolerates an
empty prefix, so the policy and the code disagree.

Changes (`template.yaml:30-32`):
- Add `MinLength: 1` and an `AllowedPattern` that forbids leading or trailing
  slashes to the `AuditLogS3Prefix` parameter. Tighten the `Description` to
  state the contract ("prefix within the bucket; must be non-empty; no
  leading or trailing slash").
- Optional: add `MinLength: 3`, `MaxLength: 63`, and the standard S3 bucket
  name `AllowedPattern` to `AuditLogS3Bucket` for symmetry.

This keeps the IAM ARNs at lines 201 and 227 unchanged — they are correct as
soon as the parameter constraint is enforced. We rely on parameter
validation rather than relaxing the ARN, so we do not over-grant S3
permissions on the bucket root.

### M3 — Make post-create audit logging non-fatal

`creator_lambda.py:165` calls `audit.log(...)` after the request has been
successfully persisted. If that call raises (transient DynamoDB hiccup), the
caller gets a 500 even though the request *was* created. The new 409
duplicate path makes this latent issue easier to hit: a client that retries
on 5xx will then see a 409 it cannot reconcile.

Changes (`creator_lambda.py:153-166`):
- Wrap only the `audit.log(...)` call in a `try/except Exception` and log the
  failure at WARNING via `logger.exception(...)`. The 200 response is still
  returned. The audit gap is acceptable and observable; a 500 on a
  successfully persisted request is not.
- Keep the existing `try` block that wraps `request_repo.create` exactly as
  it is — its `except Exception` returning 500 is correct: if the create
  itself fails, we have not persisted anything.

### m8 — Strengthen `test_archiver_exception_does_not_propagate`

`tests/test_request_processor.py:285-293` only asserts no exception escapes
from `proc.process()`. It would still pass if a refactor accidentally
skipped the archive call entirely.

Changes:
- Add `cast(MagicMock, archiver_mock.archive).assert_called_once_with("req-archive")`
  after the `proc.process()` call (mirrors line 251 in the success-path test
  in the same file).

### m11 — Emit a dry-run log in `_archive_if_done`

`request_processor.py:202-203` returns silently when `dry_run` is True.
Adjacent dry-run branches (`_transition_request`, `process_new`, etc.) emit
`DryRun: …` log lines. Match the convention.

Changes:
- Replace the bare `return` with `logger.info("DryRun: would archive audit
  log for %s", request.id); return` (only when `request.state == "done"`, so
  we don't log for every non-terminal request — i.e., move the dry-run check
  *after* the state check).

### n5 — Redact API Gateway ID in README example

`README.md:37` contains `omqlg03jma.execute-api.eu-west-1.amazonaws.com`,
which looks like a live API ID.

Changes:
- Replace the host with `<api-id>.execute-api.eu-west-1.amazonaws.com` in
  the curl example.

## Files to modify

- `src/dns_de_rte_orchestrator/request_processor.py` — docstring on
  `_archive_if_done` (M1), reorder dry-run + state checks and add dry-run
  log line (m11)
- `src/dns_de_rte_orchestrator/creator_lambda.py` — wrap post-create
  `audit.log` in try/except (M3)
- `template.yaml` — add `MinLength`/`AllowedPattern` on `AuditLogS3Prefix`
  parameter (M2)
- `tests/test_request_processor.py` — add `assert_called_once_with` in
  `test_archiver_exception_does_not_propagate` (m8)
- `TODO.md` — annotate that S3 archival has no live trigger yet (M1)
- `README.md` — redact API Gateway host (n5)

No new functions or files. No test-file or production-file restructuring.

## Existing utilities reused

- `logger.exception` / `logger.info` — already used throughout
  `request_processor.py` and `creator_lambda.py`; no new logging plumbing.
- `MagicMock.assert_called_once_with` — pattern already used in the same
  test file (`tests/test_request_processor.py:251`).
- SAM parameter `AllowedPattern` / `MinLength` — already used on other
  parameters across the team's templates.

## Verification

Run from the repo root:

1. `uv run basedpyright` — must report 0 errors / 0 warnings (changes are
   small and should not affect typing).
2. `uv run pytest` — all 173 existing tests plus the strengthened m8 test
   must pass. Specifically check:
   - `tests/test_request_processor.py::test_archiver_exception_does_not_propagate`
     — now asserts the archive call was attempted.
   - `tests/test_creator_lambda.py` — confirm no existing test expects a 500
     when `audit.log` raises (should be none; if one exists, update to
     expect 200 with the warn-log instead).
3. `sam validate --lint` — must pass; the new `AllowedPattern` /
   `MinLength` on `AuditLogS3Prefix` is standard SAM/CFN.
4. `sam build` — must complete successfully.
5. Manual sanity: read the diff and confirm no other call site of
   `audit.log` in the creator lambda's success path is left bare.

No deploy is part of this plan — `sam deploy` is human/CI-only per
`CLAUDE.md`.

## Out of scope (deferred)

- m1 (CloudWatch metric on archive failure) — useful but a larger change
  (new Powertools `Metrics` wiring); track separately.
- m9 (`AWS::IAM::Policy` vs `serverless-access-manager` reconciliation) —
  needs platform-team confirmation, not a code change.
- m2/m3/m4/m5/m6/m7/m10 and n1–n7 (other than n5) — minor/nit; defer.
