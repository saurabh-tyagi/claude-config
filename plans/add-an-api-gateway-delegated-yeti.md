# Add API Gateway in front of Creator Lambda

## Context

Today the Creator Lambda ([src/dns_de_rte_orchestrator/creator_lambda.py](src/dns_de_rte_orchestrator/creator_lambda.py)) is defined in [template.yaml](template.yaml) but has **no invocation source** — nothing is wired to trigger it. The system is meant to replace a Tines-based orchestrator where OneTrust submits GDPR Right‑to‑Erasure requests over HTTP.

This change adds an **AWS API Gateway REST API** in front of `CreateFunction` so OneTrust (and any future HTTP client) can POST a new erasure request and have it written to DynamoDB. API key authentication is required because the endpoint is internet‑reachable and accepts PII.

Out of scope (existing, unrelated TODOs): implementing `request_from_event`, audit logging, Process Lambda wiring.

## Approach

Add a single `AWS::Serverless::Api` resource to [template.yaml](template.yaml) and attach an API event source to the existing `CreateFunction`. Configure API key auth via a usage plan. Expose `POST /erasure-request`.

### Changes to [template.yaml](template.yaml)

1. **New `Parameters`** (optional, scoped small):
   - None strictly required — reuse existing `Environment`.

2. **New resource: `CreateApi`** (`AWS::Serverless::Api`)
   - `StageName: !Ref Environment` (e.g. `dev`, `prod`)
   - `EndpointConfiguration: REGIONAL` (consistent with `eu-west-1` deploy in [samconfig.toml](samconfig.toml))
   - `TracingEnabled: true` to match Lambda `Tracing: Active`
   - `Auth`:
     - `ApiKeyRequired: true` as the default on all methods
     - `UsagePlan`:
       - `CreateUsagePlan: PER_API`
       - `Description: "Usage plan for RTE Orchestrator Create API"`
       - `Quota` / `Throttle` set to sane defaults (e.g. `RateLimit: 10`, `BurstLimit: 20`, `Quota: 10000/DAY`) — RTE volume is low.
   - `MethodSettings`:
     - `LoggingLevel: INFO`, `DataTraceEnabled: false` (PII — never log request bodies), `MetricsEnabled: true`
   - Tags matching existing `samconfig.toml` tag scheme (application, team, product, etc.) — SAM auto‑tags from config, but explicit tags on `AWS::Serverless::Api` are fine.

3. **Attach Event source to `CreateFunction`**
   - Add `Events` block on the existing `CreateFunction` resource:
     ```yaml
     Events:
       CreateErasureRequest:
         Type: Api
         Properties:
           RestApiId: !Ref CreateApi
           Path: /erasure-request
           Method: POST
     ```
   - This auto‑wires the Lambda permission for API Gateway to invoke the function. No changes needed to `ServerlessAccessManager` / `LambdaExecutionRoleArn`.

4. **New `Outputs`**:
   - `CreateApiUrl` — the invoke URL (`https://{ApiId}.execute-api.${AWS::Region}.amazonaws.com/${Environment}/erasure-request`). Useful for configuring OneTrust.
   - `CreateApiId` — the API Gateway REST API ID (handy for debugging / console links).
   - Note: the API key **value** is intentionally not output; retrieve it from the API Gateway console or via `aws apigateway get-api-key --include-value`.

### No changes required to the Lambda code (in this change)

`lambda_handler` in [creator_lambda.py](src/dns_de_rte_orchestrator/creator_lambda.py) already accepts `dict[Any, Any]`. When invoked by API Gateway (proxy integration), it will receive the standard API Gateway proxy event. `request_from_event` currently raises `NotImplementedError` — that remains a separately tracked TODO and is **out of scope** for this change. Callers will receive a 500 from the Lambda until that is completed; this is expected.

> If the reviewer wants a minimal safety net, we can return a `502`/`500` explicitly from the Lambda here, but per AGENTS.md "don't add features beyond what the task requires" — leaving as is.

### Changes to [TODO.md](TODO.md)

Tick off what this change delivers and add a line for API‑key rotation process if not already tracked:
- Add: `- [x] Add API Gateway for Create Lambda` under the SAM section.

### No changes to [.gitlab-ci.yml](.gitlab-ci.yml) or [Makefile](Makefile)

- `sam validate --lint` and `sam build` already run on `template.yaml` changes (see rules in `sam-validate` / `sam-build` jobs). They will pick up the new resource automatically.
- `Makefile` only builds Lambda artifacts — API Gateway needs no build step.

## Critical files

- [template.yaml](template.yaml) — main change.
- [samconfig.toml](samconfig.toml) — reference only; verify `Environment` parameter overrides still line up (`dev`, `prod`).
- [src/dns_de_rte_orchestrator/creator_lambda.py](src/dns_de_rte_orchestrator/creator_lambda.py) — no edit; confirms the handler signature works for API GW events.
- [TODO.md](TODO.md) — update checklist.

## Verification

1. **Local validation**
   ```sh
   sam validate --lint
   sam build
   ```
   Both must pass. `sam validate --lint` is also enforced in CI via the `sam-validate` job.

2. **CI**
   - Push branch `DAS_4125_API_gateway`, open an MR. The `sam-validate` and `sam-build` jobs must go green.
   - Manually trigger `sam-deploy-dev` from the MR pipeline.

3. **Post‑deploy smoke test (dev)**
   - In the AWS console, locate the new `data-rte-orchestrator-dev` stack → API Gateway → usage plan → retrieve the API key value.
   - Exercise the endpoint:
     ```sh
     curl -i -X POST \
       -H "x-api-key: <KEY>" \
       -H "Content-Type: application/json" \
       -d '{"id":"test-1","source":"manual","date_issued":"2026-05-01T00:00:00Z","erasure_details":{"email":"test@example.com"}}' \
       "https://<api-id>.execute-api.eu-west-1.amazonaws.com/dev/erasure-request"
     ```
   - Expected (until `request_from_event` is implemented): HTTP `502`/`500` with Lambda error in CloudWatch. Absence of a `403` confirms the API key / auth wiring is correct.
   - A request **without** the `x-api-key` header must return `403 Forbidden` — confirms `ApiKeyRequired: true` is enforced.

4. **Observability**
   - Confirm API Gateway access logs / metrics appear in CloudWatch.
   - Confirm X‑Ray traces link API Gateway → Lambda (both have tracing enabled).
