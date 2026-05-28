# Recent Reference Templates (since 2025-11-21)

These 7 templates are the canonical style corpus. Do NOT base style guidance on templates older than 2025-11-21.

| Date | Path | Key characteristics |
|---|---|---|
| 2026-04-09 | `lambda/ingest-api/template.yaml` | Zip, `dns-de-` prefix, Layer, extra `AWS::IAM::Policy` for Secrets Manager + SSM, S3+EventBridge targets, EphemeralStorage 10240, many service-specific params |
| 2026-04-02 | `lambda/personal-data-catalog/template.yaml` | Zip, `dns-de-` prefix, extra `AWS::IAM::Policy` for Secrets Manager, SSM Source, S3 targets, `python3.8` (**legacy runtime — flag if asked to edit**) |
| 2026-03-26 | `lambda/metrics-publisher-v2/template.yaml` | Zip, `data-de-` prefix, `python3.13`, SupernovaLayer, SQS+EventBridge targets, no tags block (note: missing tags) |
| 2026-03-26 | `lambda/realtime-product-recommendations-api/template.yaml` | Image, `data-de-` prefix, `python3.13`, ALB, no VpcExecution, provisioned concurrency with Application Auto Scaling, CloudWatch alarm, `AWS::Lambda::Version`+`Alias` — **outlier/complex case** |
| 2026-02-16 | `lambda/rte-datamover-guard-checks/template.yaml` | Zip, `data-de-` prefix, `python3.13`, DynamoDB targets with GSI, SSM resolve in env vars |
| 2026-01-15 | `lambda/openai-cost-exporter/template.yaml` | Zip, `data-de-` prefix, `python3.12`, S3+EventBridge targets, SSM Source, tags with `project`+`product` keys — **best minimal skeleton reference** |
| 2025-12-08 | `lambda/datamover-event-generator/template.yaml` | Zip, `data-de-` prefix, `python3.12`, S3+SQS targets, no VpcExecution (only recent template without VPC) |

## Notes on each

### ingest-api — IAM extension pattern

Demonstrates the `AWS::IAM::Policy` attachment to `ServerlessAccessManager.LambdaExecutionRoleName` for Secrets Manager + SSM permissions the access manager doesn't model. Use as the reference for this pattern.

### personal-data-catalog — python3.8 in a recent template

This template was modified recently but still uses `python3.8`. When editing it, mirror the runtime. Flag the deviation with a note.

### metrics-publisher-v2 — missing Tags block

Tags are absent from this template. When editing it, do not add tags (mirror existing style). On new templates, always include tags.

### realtime-product-recommendations-api — complex outlier

Contains `AWS::Lambda::Version`, `AWS::Lambda::Alias`, `AWS::ApplicationAutoScaling::*`, and `AWS::CloudWatch::Alarm`. This is the only ALB-fronted API service and is architecturally unusual. Reference it only for ALB or provisioned concurrency patterns.

### openai-cost-exporter — ideal minimal skeleton

Clean, simple Zip function with VPC, one SSM Source, two S3 targets, an EventBridge target, and proper tags. Use as the default example when scaffolding a new template.

### datamover-event-generator — only recent template without VpcExecution

The access manager block does not set `VpcExecution: 'true'`, so `VpcConfig` is not passed to the function. This is the exception — most services need VPC. Confirm with the user before omitting VpcExecution.

## Stale date

This corpus is derived from a 2025-11-21 cutoff. Re-derive the 6-month corpus after 2026-11-21 by running:

```bash
cd /Users/saurabhtyagi/ws/dns-de-automation
for f in $(find lambda -maxdepth 2 -name "template.yaml"); do
  last=$(git log -1 --format="%ai" -- "$f" 2>/dev/null)
  echo "$last|$f"
done | sort -r | awk -F'|' '$1 >= "2026-05-21" {print $0}'
```

Adjust the date to be 6 months before the current date.
