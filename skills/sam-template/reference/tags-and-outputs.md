# Tags and Outputs

## Tags

Tag keys observed in the 7 recent reference templates. Use the same keys that already appear in the existing template when editing; use the full set below for new templates.

```yaml
Tags:
  application: '<service-name>'       # lowercase, hyphen-separated
  created_by: cloudformation          # always this literal value
  owner: 'de'                         # always 'de'
  team: !Ref TeamName                 # references the TeamName parameter (Default: de)
  # Optional — include when present in the existing template:
  project: '<project-name>'
  product: '<product-name>'
```

### Tag validation rules (enforced by serverless-access-manager)

- All tag keys and values must be **lowercase**.
- `created_by` and `owner` (or equivalent required tags) must be present.
- Validation failure causes the CloudFormation stack deployment to fail.

### What NOT to do

- Do not use `CostCentre`, `Environment`, or `Service` as tag keys — not used in this codebase.
- Do not use uppercase values (e.g. `owner: 'DE'` will fail validation — use `'de'`).

## Outputs

Every template emits exactly one Output: the function ARN.

```yaml
Outputs:
  <FunctionLogicalId>ARN:
    Description: "<service> function ARN"
    Value: !GetAtt <FunctionLogicalId>.Arn
```

### Naming convention from corpus

| Template | Output key |
|---|---|
| `ingest-api` | `APIIngestionLambdaFunctionARN` |
| `openai-cost-exporter` | `OpenAICostExporterLambdaFunctionARN` |
| `metrics-publisher-v2` | `MetricsPublisherV2LambdaFunctionARN` |
| `rte-datamover-guard-checks` | `RtEDataMoverGuardCheckLambdaFunctionARN` |
| `datamover-event-generator` | `DataMoverEventGeneratorLambdaFunctionARN` |

Pattern: `<PascalCaseServiceName>[Lambda]FunctionARN` — the `Lambda` infix is optional but common.

### Rules

- No `Export:` block — cross-stack references are not used in this codebase.
- One Output per template. Do not add extra Outputs for role ARN, VPC config, etc.
