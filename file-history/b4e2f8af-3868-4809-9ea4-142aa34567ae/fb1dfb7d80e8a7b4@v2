# Plan: Browser-friendly HTML audit status page

**Branch:** `DATA_4929_html_audit_log` (created from `master`). Verified master already
contains every dependency this plan needs — `reporter_lambda.py`, `FallbackAuditLogReader`
/ `S3AuditLogReader` / `get_audit_log_reader()` in `audit_logging.py`, and the
`CreateRequestApi` / `ReporterFunction` / API-key resources in `template.yaml`. No
rebase or cherry-pick from the old DATA-4715 branch is required.

## Prerequisite (branch setup)

Work must NOT continue on `DATA_4715_audit_log_to_s3`. Before any change, switch to a
fresh branch cut from `master`:

```sh
git checkout master && git pull --ff-only
git checkout -b DATA_4929_html_audit_log
```

(Done — branch `DATA_4929_html_audit_log` is checked out from up-to-date `master`.)
All edits in this plan land on that branch.

## Context

Today the only way to read an erasure request's audit log is `GET /status/{id}` on
`CreateRequestApi`, which returns JSON and requires an `x-api-key` header — designed
for programmatic callers (OneTrust). Internal users want to open a URL in a browser
(on the corporate VPC) and see the audit history rendered as a readable HTML page,
without injecting headers or parsing JSON.

This adds a second, browser-friendly route that renders the same `AuditEntry` data as
an HTML table. It reuses the existing reader and Lambda; only a new event, a handler
branch, a Jinja2 template, and the `jinja2` dependency are added. The existing JSON
endpoint stays byte-for-byte unchanged for OneTrust/programmatic callers.

Decisions confirmed with the user:
- **Auth**: new route uses `ApiKeyRequired: false`, relying on the existing PRIVATE
  VPC-endpoint resource policy (no header needed → works in a browser).
- **Shape**: new route `GET /status/{id}/view` on the **same** `ReporterFunction`
  (second API event); JSON `/status/{id}` left untouched.
- **Templating**: add `jinja2` as a runtime dependency.

## Data shape (from exploration)

- `reader.get_logs(id)` → `list[AuditEntry]`; `AuditEntry` is `@dataclass(frozen=True)`
  with `id: str`, `timestamp: datetime` (UTC), `message: str`
  (`src/dns_de_rte_orchestrator/audit_logging.py:29-54`).
- `message` is free text → **must be HTML-escaped** (Jinja2 autoescape handles this).

## Changes

### 1. Add dependency
- `uv add jinja2` → adds to `[project.dependencies]` in `pyproject.toml`.
- No `Makefile` change: `build-ReporterFunction` already runs
  `uv export --no-dev` (picks up new runtime dep) and copies the whole
  `src/dns_de_rte_orchestrator` package (so a template placed inside it is bundled).

### 2. HTML template
- New file `src/dns_de_rte_orchestrator/templates/audit_status.html.j2`.
- Renders: page title with erasure id, a table of entries
  (`timestamp` formatted human-readably, `message`), and a friendly empty/error state.
- Jinja2 `Environment(autoescape=True)` so `message` is escaped.

### 3. Reporter Lambda — add HTML branch
File: `src/dns_de_rte_orchestrator/reporter_lambda.py`
- Keep the module-level `reader` and existing `_response` (JSON) helper.
- Add a module-level Jinja2 `Environment` using a `PackageLoader`/`FileSystemLoader`
  rooted at the `templates/` dir (resolve via `importlib.resources` / `Path(__file__).parent`),
  built once at import time (mirrors how `reader` is initialised once).
- Extract shared logic into a helper `_load_entries(event) -> tuple[str | None, list[AuditEntry] | None, dict | None]`
  (or simpler: a function returning `(erasure_id, entries)` and raising/encoding the
  error cases) so both routes parse `pathParameters.id` and call `reader.get_logs`
  identically.
- Add `_html_response(status_code, html)` returning
  `{"statusCode", "headers": {"Content-Type": "text/html; charset=utf-8"}, "body": html}`.
- In `lambda_handler`, detect the HTML route via
  `event["requestContext"]["resourcePath"]` (or path `.endswith("/view")`):
  - HTML route: render template for 200 / empty (404-style friendly page) / 400 / 500.
  - Otherwise: existing JSON behaviour, unchanged.
- All HTML error/empty cases render a small friendly page rather than raw JSON.

### 4. SAM template — new event + route
File: `template.yaml` (ReporterFunction at line 216 on this branch; existing
`GetErasureStatus` event at line 238, `Path: /status/{id}`)
- Add a second `Events` entry on `ReporterFunction`:
  ```yaml
  GetErasureStatusView:
    Type: Api
    Properties:
      RestApiId: !Ref CreateRequestApi
      Path: /status/{id}/view
      Method: get
      Auth:
        ApiKeyRequired: false
  ```
- No new function, no binary media types (HTML is text), no CORS (single private API,
  same-origin navigation).
- **Invoke the `sam-template` skill before editing `template.yaml`** (project rule).

## Files touched
- `pyproject.toml` (+`jinja2`) and `uv.lock`
- `src/dns_de_rte_orchestrator/templates/audit_status.html.j2` (new)
- `src/dns_de_rte_orchestrator/reporter_lambda.py`
- `template.yaml`
- `tests/test_reporter_lambda.py` (+ optional fixture)
- `TODO.md` (mark item done — project rule)

## Tests
Follow `tests/test_reporter_lambda.py` conventions (set env vars before import,
`monkeypatch.setattr(reporter_module, "reader", _RecordingReader(...))`, build real
`AuditEntry` objects, `make_*_event` helpers, `cast(LambdaContext, MagicMock())`):
- `make_view_event(id)` with `requestContext.resourcePath = "/status/{id}/view"`.
- 200: response is `text/html`, body contains the rendered timestamp + message rows.
- **XSS**: a `message` like `<script>alert(1)</script>` appears **escaped** in the body.
- Empty entries → friendly HTML "no audit log" page (not JSON).
- Missing/blank id → HTML 400 page.
- Reader raises → HTML 500 page.
- Assert the JSON route `/status/{id}` is unchanged (existing tests still pass).

## Verification
1. `uv sync --all-groups`
2. `uv run pytest` — all tests green, including new HTML cases.
3. `uv run basedpyright` (or project type-check) clean — no new `Any`/ignores.
4. `sam validate --lint` then `sam build` succeed (confirms jinja2 + template bundle).
5. Manual (optional, in-VPC): open `/status/<id>/view` in a browser → rendered table.
