# Plan: Update MR !49 description to reflect latest changes

## Context
After commit `5771e38`, the MR description on !49 is stale:
- It references `tests/conftest.py` as a new file — but that file has been deleted.
- It says `samconfig.toml` adds `VPCEndpointId=vpce-0ccf7efad71b28b54` — but the value is now SSM-resolved.
- It says the API "intentionally has no application-layer auth" — but API key auth has been added.
- The `template.yaml` change list doesn't mention the new `CreateRequestApiKey`, `CreateRequestUsagePlan`, or `CreateRequestUsagePlanKey` resources, the `CreateRequestApiKeyId` output, or the reworded `POWERTOOLS_LOGGER_LOG_EVENT` comment.

The goal of this change is to replace the description with one that matches the current state of the branch, so reviewers and future readers see an accurate summary.

## Approach
Use `glab api` to PUT a new description on the MR:
```
glab api --method PUT projects/HnBI%2Fdns%2Fdns-de-rte-orchestrator/merge_requests/49 -f description="<new body>"
```
No code changes — this is a metadata-only update on the MR.

## New description body

```markdown
## What

Adds a private API Gateway in front of the `CreateFunction` Lambda, allowing internal systems (e.g. OneTrust) to submit GDPR Right to Erasure requests via a VPC Endpoint. Access is restricted at both the network layer (VPCE-only resource policy) and the application layer (API key + Usage Plan).

Key files:
- `template.yaml` — new `CreateRequestApi`, API key + usage plan resources
- `src/dns_de_rte_orchestrator/creator_lambda.py` — `request_from_event` + HTTP responses
- `src/dns_de_rte_orchestrator/erasure_request.py` — exported `VALID_DETAIL_KEYS`
- `samconfig.toml` — `VPCEndpointId` parameter resolved from SSM

## Why

Jira: [DAS-4125] — The Creator Lambda previously had no HTTP interface, so erasure requests could not be submitted by external systems. This change exposes a `POST /erasure-request` endpoint, restricted to the internal VPCE and gated by an API key, to complete the inbound leg of the RTE orchestration pipeline.

## Changes

1. **`template.yaml`**
   - Added `VPCEndpointId` CloudFormation parameter
   - Added `CreateRequestApi` (`AWS::Serverless::Api`) as a private API Gateway with a resource policy restricting invocations to the configured VPCE
   - Added `ApiKeyRequired: true` at both the API Auth level and on the `CreateErasureRequest` event
   - Added `CreateRequestApiKey`, `CreateRequestUsagePlan`, and `CreateRequestUsagePlanKey` to issue and bind the API key
   - Wired `CreateFunction` to the API via `POST /erasure-request`
   - Added `Outputs` for the invoke URL and the API key ID (the secret value is fetched from the API Gateway console)
   - Comment on `POWERTOOLS_LOGGER_LOG_EVENT` explaining that `erasure_details` (PII: email, name, postcode) must not be persisted to CloudWatch

2. **`src/dns_de_rte_orchestrator/creator_lambda.py`**
   - Implemented `request_from_event`: parses API Gateway proxy event body (including base64), validates required fields, types, lengths, and `erasure_details` keys
   - Added `InvalidRequestError` exception and `_require_str` helper
   - Added `_response` helper for API Gateway-compatible responses
   - `lambda_handler` returns structured 200 / 400 / 500 responses and handles exceptions explicitly

3. **`src/dns_de_rte_orchestrator/erasure_request.py`**
   - Exported `VALID_DETAIL_KEYS` frozenset for use in request validation

4. **`samconfig.toml`**
   - Set `VPCEndpointId={{resolve:ssm:/dns/de/rte-orchestrator/prod/vpce-id}}` for both `dev` and `prod`, so the value is read from SSM Parameter Store at deploy time. The SSM parameter must exist in the account before the next deploy (initial value: `vpce-0ccf7efad71b28b54`).

5. **`tests/test_creator_lambda.py`** *(new)*
   - Sets `REPOSITORY_TYPE=memory` at module import time (must run before `creator_lambda` is imported, since that module calls `get_request_repository()` at import time)
   - Unit tests for `request_from_event` covering valid input, missing fields, invalid JSON, unknown detail keys, invalid field types, and oversized fields
   - Unit tests for `lambda_handler` covering 200, 400, and 500 response paths using a monkeypatched `request_repo`

6. **`TODO.md`**
   - Marked API Gateway task as complete

## Caller integration notes

- Endpoint: `POST https://<api-id>.execute-api.eu-west-1.amazonaws.com/<env>/erasure-request`
- Requires `x-api-key: <key value>` header (key value retrieved from the API Gateway console using the ID exported by the stack)
- Must be invoked from inside the configured VPCE
```

## Files to edit
None — this is a GitLab API call only, no repo changes.

## Verification
- `glab api projects/HnBI%2Fdns%2Fdns-de-rte-orchestrator/merge_requests/49` and confirm `description` matches the new body.
- Open MR !49 in the GitLab UI and visually skim that the description reflects the current state of the branch (SSM, API key auth, no `conftest.py`).
