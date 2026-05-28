# Audit Log Retrieval API (`GET /status/{id}`)

## Context

`TODO.md:57-60` calls for two things:
1. An API endpoint + Lambda for retrieving the audit log of a given erasure id.
2. Materialising the audit log to S3 after a successful erasure.

This plan delivers (1) with a built-in S3 fallback so the endpoint keeps working once (2) ships and DynamoDB rows are aged out / moved. It does **not** implement the writer side of the S3 materialisation — only the reader.

The endpoint will be served from the existing private, VPCE-restricted `CreateRequestApi` (chosen by the user). DynamoDB is the primary source; if it returns zero items the Lambda falls back to reading `s3://{bucket}/{prefix}/{erasure_id}.jsonl.gz`. Entries are returned in chronological order (oldest first).

## Files to modify

| File | Change |
| --- | --- |
| `src/dns_de_rte_orchestrator/audit_logging.py` | Add `AuditEntry` dataclass, `get_logs()` to `AuditLogger` ABC + all impls, new `S3AuditLogReader`, new `FallbackAuditLogReader`, factory helpers |
| `src/dns_de_rte_orchestrator/reporter_lambda.py` | **NEW** — handler for `GET /status/{id}` |
| `template.yaml` | Add `AuditLogS3Bucket` + `AuditLogS3Prefix` parameters; add `ReporterServerlessAccessManager` (DynamoDB read + S3 read targets); add `ReporterFunction` wired to `CreateRequestApi` on `/status/{id}` GET; output is unchanged |
| `samconfig.toml` | Add `AuditLogS3Bucket` and `AuditLogS3Prefix` to dev + prod `parameter_overrides` |
| `Makefile` | Add `build-ReporterFunction` target (mirror `build-CreateFunction` at `Makefile:10-14`) and add to `.PHONY` |
| `tests/test_audit_logging.py` | Tests for `get_logs` on `NoOp`, `InMemory`, `DynamoDBAuditLogger` (stub), `S3AuditLogReader` (stub), `FallbackAuditLogReader` |
| `tests/test_dynamodb_audit_logger.py` | Integration test for `get_logs` using `moto`'s `@mock_aws` |
| `tests/test_s3_audit_log_reader.py` | **NEW** — integration test using `moto` `mock_aws` for S3 |
| `tests/test_reporter_lambda.py` | **NEW** — handler tests (200, 404, 500, missing path param) following `tests/test_creator_lambda.py:10-44` pattern |
| `TODO.md` | Mark the two retrieval sub-bullets as done |

## Design

### `audit_logging.py` changes

```python
@dataclass(frozen=True)
class AuditEntry:
    id: str
    timestamp: datetime  # always tz-aware UTC
    message: str

    def to_json(self) -> dict[str, str]:
        return {"id": self.id, "timestamp": self.timestamp.isoformat(), "message": self.message}
```

- Extend `AuditLogger` ABC with `get_logs(self, id: str) -> list[AuditEntry]` (chronological).
- Implement on `NoOpAuditLogger` (returns `[]`), `InMemoryAuditLogger` (filter `memory_log`, sort by ts), `DynamoDBAuditLogger` (paginated `query` on hash key with `ScanIndexForward=True`, default for `query`).
- New class `S3AuditLogReader` (separate from `AuditLogger` since it's read-only):
  - `__init__(self, bucket: str, prefix: str, s3_client)`
  - `get_logs(id) -> list[AuditEntry]`: builds key `{prefix}/{id}.jsonl.gz` (strip trailing slash from prefix), `get_object`, gunzip, parse each line as JSON, build `AuditEntry`. On `NoSuchKey` / `404` returns `[]`. Other exceptions propagate.
- New class `FallbackAuditLogReader`:
  - `__init__(primary: AuditLogger, fallback: S3AuditLogReader)`
  - `get_logs(id)`: returns primary; if empty returns fallback.
- New env-var constants: `AUDIT_LOG_S3_BUCKET`, `AUDIT_LOG_S3_PREFIX`.
- New factory `get_audit_log_reader() -> FallbackAuditLogReader` used by the reporter lambda; reuses `get_audit_logger()` for the DynamoDB side and builds an `S3AuditLogReader` from env. Raises `ValueError` if S3 env vars are missing.

### `reporter_lambda.py`

Mirror `creator_lambda.py` structure:
- Module-level `load_dotenv()`, `Logger()`, `Tracer()`, single `reader = get_audit_log_reader()` at import time.
- Reuse the response shape from `creator_lambda._response` (copy verbatim — the helper is private and small; keeping the lambdas independent is the existing convention).
- Handler:
  - Read `event["pathParameters"]["id"]`. If missing/empty → 400 `{"error": "missing erasure id"}`.
  - Call `reader.get_logs(id)`. If empty → 404 `{"error": "no audit log found", "id": id}`.
  - Else → 200 `{"id": id, "entries": [entry.to_json() for entry in entries]}`.
  - Broad except → 500 `{"error": "internal error"}` (matches `creator_lambda.py:142-144`).
- Decorate with `@tracer.capture_lambda_handler` and `@logger.inject_lambda_context`.

### `template.yaml` changes

- New `Parameters`:
  - `AuditLogS3Bucket: Type: String`
  - `AuditLogS3Prefix: Type: String`
- New `ReporterServerlessAccessManager` (mirroring `ProcessServerlessAccessManager` at `template.yaml:133-152`):
  - `FunctionName: !Sub 'data-rte-orchestrator-status-${Environment}'`
  - Targets:
    - `AuditLogDynamoDBTable` (DynamoDB read).
    - `AuditLogS3Bucket` (S3 read on the bucket arn). The exact `Type` for S3 follows the project's PaaS `ServerlessAccessManager` convention — verify with the platform team's docs at deploy time; if S3 is not a supported target type, add an explicit `AWS::IAM::Policy` granting `s3:GetObject` on `arn:aws:s3:::${AuditLogS3Bucket}/${AuditLogS3Prefix}/*` attached to `ReporterServerlessAccessManager.LambdaExecutionRoleArn`. **Open question — confirm before deploy.**
- New `ReporterFunction`:
  - `Handler: dns_de_rte_orchestrator.reporter_lambda.lambda_handler`
  - `Runtime: python3.13`, `MemorySize: 256`, `Timeout: 30`, `ReservedConcurrentExecutions: 5`
  - Env vars: `DYNAMO_DB_AUDIT_LOGGING_TABLE`, `AUDIT_LOG_S3_BUCKET`, `AUDIT_LOG_S3_PREFIX`, `POWERTOOLS_SERVICE_NAME=status-erasure-request-${Environment}`. **No PII concern** — audit messages should already be PII-free, so `POWERTOOLS_LOGGER_LOG_EVENT` may be set for debugging if desired; default to leaving it unset to match existing conservative posture.
  - Event:
    ```yaml
    GetErasureStatus:
      Type: Api
      Properties:
        RestApiId: !Ref CreateRequestApi
        Path: /status/{id}
        Method: get
        Auth:
          ApiKeyRequired: true
    ```

### `samconfig.toml`

Add to both `[dev.deploy.parameters]` and `[prod.deploy.parameters]`:
```
AuditLogS3Bucket=<bucket name from infra team>
AuditLogS3Prefix=audit-logs
```
The exact bucket name will need to be confirmed (likely the existing `hbi-dns-infra-datalake` or a new audit-specific bucket).

### `Makefile`

```makefile
build-ReporterFunction:
	uv export --no-dev --format requirements-txt -o .aws-sam-requirements.txt
	uv pip install --python 3.13 --target "${ARTIFACTS_DIR}/" -r .aws-sam-requirements.txt
	cp -r src/dns_de_rte_orchestrator "${ARTIFACTS_DIR}/"
	rm -f .aws-sam-requirements.txt
```
Plus add `build-ReporterFunction` to the `.PHONY` line.

## Tests

Reuse existing patterns:

- **Unit (`test_audit_logging.py`)** — extend `StubDynamoDBClient` (currently `tests/test_audit_logging.py:17-23`) to record `query` calls and return canned pages. Add tests:
  - `NoOpAuditLogger.get_logs` returns `[]`.
  - `InMemoryAuditLogger.get_logs` returns chronologically sorted entries for the requested id only.
  - `DynamoDBAuditLogger.get_logs` calls `query` with `KeyConditionExpression`, hash-key value, `ScanIndexForward=True`, paginates correctly, and converts items to `AuditEntry`.
  - `FallbackAuditLogReader` returns primary when non-empty; falls back to S3 when primary empty; returns `[]` when both empty.
  - `S3AuditLogReader` happy path (stubbed `get_object` returning gzipped JSONL bytes), `NoSuchKey` returns `[]`, malformed JSON line raises.

- **Integration (`test_dynamodb_audit_logger.py`)** — add a `test_get_logs_returns_chronological_entries` using the existing `dynamodb_table` fixture (`tests/test_dynamodb_audit_logger.py:16-42`); insert via `logger.log()` then assert `logger.get_logs("req")` returns ordered `AuditEntry` objects.

- **Integration (new `test_s3_audit_log_reader.py`)** — `@mock_aws`, create bucket, upload a gzipped JSONL with 3 entries, assert `S3AuditLogReader.get_logs("req")` returns them; assert missing key → `[]`; assert prefix is honoured.

- **Handler (new `test_reporter_lambda.py`)** — copy the env-var-before-import trick from `tests/test_creator_lambda.py:10-13`; build a fake `FallbackAuditLogReader` via `MagicMock`; test:
  - 200 with chronological entries when reader returns data.
  - 404 when reader returns `[]`.
  - 400 when path param missing.
  - 500 when reader raises.
  - Body shape: `{"id": ..., "entries": [{"id","timestamp","message"}, ...]}`.

## Verification

```sh
uv sync --all-groups
uv run pytest                            # all tests, including new ones
uv run pytest tests/test_reporter_lambda.py tests/test_s3_audit_log_reader.py -v
uv run prek                              # ruff + black + basedpyright
sam validate --lint                      # template.yaml + samconfig.toml correctness
sam build                                # confirms Makefile target wires up
```

End-to-end (post-deploy, manual): hit `https://<api-id>.execute-api.eu-west-1.amazonaws.com/dev/status/<known-id>` with the API key from inside the VPC; expect 200 with JSON entries chronologically. Hit with an unknown id; expect 404. Confirm CloudWatch logs for `status-erasure-request-dev` show no PII.

## Refactor: consolidate field-name constants onto `AuditEntry`

Right now the audit field names (`"id"`, `"timestamp"`, `"message"`) are duplicated:
- `DynamoDBAuditLogger.ID_FIELD/TIMESTAMP_FIELD/MESSAGE_FIELD` (`audit_logging.py:110-112`) for DynamoDB attribute names.
- Hard-coded literal strings inside `AuditEntry.to_json` (`audit_logging.py:31-36`) and `S3AuditLogReader.get_logs` (`audit_logging.py:206-213`) — these JSON keys must match the DynamoDB names so the S3 materialiser and reader stay symmetric.

Move the three constants onto `AuditEntry` as the single source of truth:

```python
@dataclass(frozen=True)
class AuditEntry:
    ID_FIELD: ClassVar[Literal["id"]] = "id"
    TIMESTAMP_FIELD: ClassVar[Literal["timestamp"]] = "timestamp"
    MESSAGE_FIELD: ClassVar[Literal["message"]] = "message"

    id: str
    timestamp: datetime
    message: str

    def to_json(self) -> dict[str, str]:
        return {
            self.ID_FIELD: self.id,
            self.TIMESTAMP_FIELD: self.timestamp.isoformat(),
            self.MESSAGE_FIELD: self.message,
        }

    @classmethod
    def from_json(cls, data: dict[str, str]) -> "AuditEntry":
        return cls(
            id=data[cls.ID_FIELD],
            timestamp=datetime.fromisoformat(data[cls.TIMESTAMP_FIELD]),
            message=data[cls.MESSAGE_FIELD],
        )
```

`ClassVar` keeps these out of the dataclass field set so they don't become constructor args or affect equality — only instance fields (`id`, `timestamp`, `message`) participate in the dataclass machinery.

Then update call sites to read from `AuditEntry` instead of `DynamoDBAuditLogger`:

| File | Lines | Change |
| --- | --- | --- |
| `audit_logging.py` | 110-112 | **Delete** the three `*_FIELD` class attrs from `DynamoDBAuditLogger` |
| `audit_logging.py` | 139, 155-157, 163-165 | Replace `self.ID_FIELD`/`cls.ID_FIELD` etc. with `AuditEntry.ID_FIELD`/`AuditEntry.TIMESTAMP_FIELD`/`AuditEntry.MESSAGE_FIELD` |
| `audit_logging.py` | 206-213 | `S3AuditLogReader.get_logs` uses `AuditEntry.from_json(json.loads(line))` instead of indexing literal `"id"`/`"timestamp"`/`"message"` |
| `tests/test_dynamodb_audit_logger.py` | 23, 25, 31, 35, 61, 62, 68-70, 86, 90, 91, 108, 109, 115, 116, 128, 134 | Replace `DynamoDBAuditLogger.ID_FIELD` etc. with `AuditEntry.ID_FIELD` etc. |
| `tests/test_audit_logging.py` | new tests added in feature 1 | Use `AuditEntry.*_FIELD` directly; existing tests do not reference these constants |

`DynamoDBRequestRepository` (`request_repository.py`) has its own unrelated `ID_FIELD` constant for the requests table — it stays as is. The audit table constants are the only ones moving.

This refactor lands as part of feature 1 because the new `S3AuditLogReader` and `AuditEntry.to_json` immediately benefit (the JSONL keys on S3 must equal the DynamoDB attribute names).

### Verification for the refactor

- `uv run pytest` — all existing audit logger tests must pass unchanged.
- `uv run prek` — basedpyright must accept `ClassVar[Literal["id"]]`.
- Spot-check that no test accidentally relies on `DynamoDBAuditLogger.ID_FIELD` being a class attribute on `DynamoDBAuditLogger` itself (the grep above lists all references — only the test file referenced needs updating).

## Open items to confirm before merging

1. Whether the `Custom::ServerlessAccessManager` target schema supports S3 read targets, or whether we need an explicit IAM policy attached to its execution role for S3 reads.
2. Concrete S3 bucket + prefix values for dev and prod (currently placeholders in `samconfig.toml`).
