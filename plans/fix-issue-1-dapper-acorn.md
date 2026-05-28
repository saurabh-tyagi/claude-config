# Fix Issue 1: Consolidate API Gateway Resource Policy

## Context

The code review on branch `DAS_4125_API_gateway` flagged the API Gateway resource policy in [template.yaml:46-62](template.yaml#L46-L62) as a high-severity security concern.

The current policy has two statements:
1. An `Allow` on `Principal: '*'` with **no condition** — blanket permissive
2. A `Deny` on `Principal: '*'` conditioned on `aws:SourceVpce` not matching

While `Deny` wins in IAM evaluation (so the API is VPCE-restricted today), this pattern is fragile:
- If the `Deny` is ever removed, weakened, or the condition key is null, the API is fully open to the internet
- The `Allow` duplicates what `EndpointConfiguration.Type: PRIVATE` already provides via the AWS-managed default policy
- Two overlapping statements on the same resource make the policy harder to reason about

The fix is to collapse to a single positive-intent `Allow` conditioned on `aws:SourceVpce` — any caller not coming through the allowed VPCE has no matching Allow and is implicitly denied.

## Files to Modify

- [template.yaml](template.yaml) — replace the `CustomStatements` block at lines 49-62

## Change

Replace the Allow + Deny pair at [template.yaml:49-62](template.yaml#L49-L62) with a single Allow statement conditioned on `aws:SourceVpce`:

```yaml
Auth:
  ApiKeyRequired: false
  ResourcePolicy:
    CustomStatements:
      - Effect: Allow
        Action: execute-api:Invoke
        Resource:
          - !Sub "arn:aws:execute-api:${AWS::Region}:${AWS::AccountId}:*"
        Principal: '*'
        Condition:
          StringEquals:
            aws:SourceVpce: !Ref VPCEndpointId
```

No other files need changes. The `VPCEndpointId` parameter is already declared at [template.yaml:18-20](template.yaml#L18-L20) and referenced by `EndpointConfiguration.VPCEndpointIds` at [template.yaml:44-45](template.yaml#L44-L45).

## Verification

1. Lint and validate the SAM template:
   ```sh
   uv run sam validate --lint
   ```
2. Build the template to ensure the stack still renders cleanly:
   ```sh
   uv run sam build
   ```
3. Run existing tests to confirm no Python-side regressions:
   ```sh
   uv run pytest
   ```
4. (Post-deploy, manual) Confirm:
   - A request through the allowed VPCE still returns 200 from `POST /erasure-request`
   - A request from outside the VPCE (or via a different VPCE ID) is rejected with `403 Forbidden` from API Gateway
