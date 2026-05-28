# Add API Gateway in front of CreateFunction Lambda

## Context

`dns-de-rte-orchestrator` currently exposes `CreateFunction` with no HTTP entry point — it is invokable only via direct AWS SDK calls. Upstream callers (OneTrust and internal HTTP clients within the VPC) need a stable HTTPS endpoint to create Right-to-Erasure requests. This change adds a private API Gateway in front of `CreateFunction` and adapts the handler to accept API Gateway proxy events.

The API Gateway *settings pattern* (PRIVATE endpoint + VPCE resource-policy gating + implicit SAM proxy events, no CORS/WAF/throttling/custom-domain/access-logging) is lifted from `~/ws/dns-data-services-api/src/sam/api/right_to_erasure/template.yml`. The reference's domain-specific path (`/privacy/customer/erasure`), querystring parameters, and ALB ListenerRule are **not** copied — only the settings shape.

## Scope decisions

- New endpoint: `POST /erasure-request`, JSON body mapped to `ErasureRequest` fields.
- Private API Gateway restricted to a VPC Endpoint (new `VPCEndpointId` template parameter).
- Handler adaptation in scope: implement `request_from_event` and return proxy responses.

## Changes

### 1. `template.yaml`

File: [template.yaml](template.yaml)

**Add parameter** after line 17:
```yaml
VPCEndpointId:
  Description: VPC Endpoint ID allowed to invoke the API
  Type: String
```

**Add `AWS::Serverless::Api` resource** before `CreateFunction` (before line 33):
```yaml
CreateRequestApi:
  Type: AWS::Serverless::Api
  Properties:
    StageName: !Ref Environment
    OpenApiVersion: '2.0'
    Description: !Sub "RTE orchestrator create-request API (${Environment})"
    EndpointConfiguration:
      Type: PRIVATE
      VPCEndpointIds:
        - !Ref VPCEndpointId
    Auth:
      ApiKeyRequired: false
      ResourcePolicy:
        CustomStatements:
          - Effect: Allow
            Action: execute-api:Invoke
            Resource:
              - !Sub "arn:aws:execute-api:${AWS::Region}:${AWS::AccountId}:*"
            Principal: '*'
          - Effect: Deny
            Action: execute-api:Invoke
            Resource:
              - !Sub "arn:aws:execute-api:${AWS::Region}:${AWS::AccountId}:*"
            Principal: '*'
            Condition:
              StringNotEquals:
                aws:SourceVpce: !Ref VPCEndpointId
```
Uses `!Sub` with `${AWS::AccountId}`/`${AWS::Region}` rather than the reference's hardcoded `334512769709`/`eu-west-1` for portability.

**Add `Events:` block** to `CreateFunction` (after line 54, same indent as `Environment:`):
```yaml
Events:
  CreateErasureRequest:
    Type: Api
    Properties:
      RestApiId: !Ref CreateRequestApi
      Path: /erasure-request
      Method: post
```

**Add `Outputs:`** section at end of file:
```yaml
Outputs:
  CreateRequestApiInvokeUrl:
    Description: Invoke URL for the RTE create-request API
    Value: !Sub "https://${CreateRequestApi}.execute-api.${AWS::Region}.amazonaws.com/${Environment}/erasure-request"
```

### 2. `samconfig.toml`

File: [samconfig.toml](samconfig.toml)

Add `VPCEndpointId=<placeholder>` to `parameter_overrides` in both the dev block ([samconfig.toml:27-31](samconfig.toml#L27-L31)) and prod block ([samconfig.toml:51-55](samconfig.toml#L51-L55)). Actual VPCE IDs are not known — leave as `VPCEndpointId=TODO-REPLACE` and call out in the commit message so the user can supply them before deploy.

### 3. `creator_lambda.py`

File: [src/dns_de_rte_orchestrator/creator_lambda.py](src/dns_de_rte_orchestrator/creator_lambda.py)

Current state: `request_from_event` at [creator_lambda.py:21-26](src/dns_de_rte_orchestrator/creator_lambda.py#L21-L26) is a stub; `lambda_handler` at [creator_lambda.py:29-43](src/dns_de_rte_orchestrator/creator_lambda.py#L29-L43) returns `None`.

**Implement `request_from_event`** to:
- Parse `event["body"]` with `json.loads` (handle `event.get("isBase64Encoded")` via `base64.b64decode`).
- Validate required fields match `ErasureRequest` dataclass at [erasure_request.py:27-70](src/dns_de_rte_orchestrator/erasure_request.py#L27-L70): `id`, `source`, `state`, `date_issued`, `erasure_details`.
- Parse `date_issued` via `datetime.fromisoformat`.
- Validate `state` against `VALID_STATES` from [erasure_request.py:15-23](src/dns_de_rte_orchestrator/erasure_request.py#L15-L23).
- Return a hydrated `ErasureRequest`.
- Define module-level `class InvalidRequestError(ValueError): pass` and raise it on any parsing/validation failure so the handler can cleanly map to HTTP 400.

**Update `lambda_handler`** to return a proxy response `dict[str, Any]` with keys `statusCode`, `body` (JSON string), `headers` (`{"Content-Type": "application/json"}`):
- `200` + `{"id": request.id}` on success.
- `400` + `{"error": str(e)}` on `InvalidRequestError` / `json.JSONDecodeError`.
- `500` + `{"error": "internal error"}` on any other exception from `request_repo.create`; use `logger.exception`.
- Keep `@tracer.capture_lambda_handler` and `@logger.inject_lambda_context`.
- Do not log raw body or `erasure_details` (PII). Safe logging is already built into `ErasureRequest.__str__` via `_safe_dict` at [erasure_request.py:75-80](src/dns_de_rte_orchestrator/erasure_request.py#L75-L80) — log `str(request)`, never the raw event.
- Do not use `APIGatewayRestResolver` — a single-route explicit parser fits the minimal style better.

### 4. Tests

File (new): [tests/test_creator_lambda.py](tests/test_creator_lambda.py)

Mirror the plain-pytest-function style already used in [tests/test_erasure_request.py](tests/test_erasure_request.py). Cover:
- `test_request_from_event_happy_path` — full JSON body → valid `ErasureRequest`.
- `test_request_from_event_missing_field_raises` — body missing `id` → `InvalidRequestError`.
- `test_request_from_event_invalid_json_raises` — body `"not-json"` → `InvalidRequestError`.
- `test_request_from_event_invalid_state_raises` — body with `state="bogus"` → `InvalidRequestError`.
- `test_lambda_handler_returns_200_on_success` — monkeypatch `request_repo.create` to no-op; assert `statusCode == 200` and `json.loads(resp["body"])["id"] == "..."`.
- `test_lambda_handler_returns_400_on_bad_body` — invalid JSON body → `statusCode == 400`.

### 5. `TODO.md`

File: [TODO.md](TODO.md)

Under the "Add AWS SAM deployment configuration" block at [TODO.md:56-65](TODO.md#L56-L65), append:
```
  - [x] Add API Gateway in front of Create Lambda (private, VPCE-restricted)
```

## Verification

Run in order from the project root:

1. `uv run pytest` — all tests (existing + new) pass.
2. `uv run prek` — lint / format / type-check clean.
3. `sam validate --lint` — template valid.
4. `sam build` — build succeeds (Makefile-based packaging already wired).
5. Deploy is out of scope (user/CI only). Local `sam local invoke` is not viable here: per README lines 124-128, the `Custom::ServerlessAccessManager` custom resource blocks local invocation.
6. Post-deploy smoke test (performed by user in dev): from inside the VPC, `curl -X POST -H 'Content-Type: application/json' -d '{...}' https://<apiId>.execute-api.eu-west-1.amazonaws.com/dev/erasure-request` → expect `200 {"id": "..."}`. Calls from outside the allowed VPCE must return `403`.

## Critical files

- [template.yaml](template.yaml) — L17 (parameter), before L33 (new API resource), after L54 (Events block), EOF (Outputs).
- [samconfig.toml](samconfig.toml) — L27-31 (dev), L51-55 (prod).
- [src/dns_de_rte_orchestrator/creator_lambda.py](src/dns_de_rte_orchestrator/creator_lambda.py) — L21-26 (`request_from_event`), L29-43 (`lambda_handler`).
- [src/dns_de_rte_orchestrator/erasure_request.py](src/dns_de_rte_orchestrator/erasure_request.py) — read-only reference (fields, `VALID_STATES`, `_safe_dict`).
- [tests/test_creator_lambda.py](tests/test_creator_lambda.py) — new file.
- [TODO.md](TODO.md) — L56-65.
