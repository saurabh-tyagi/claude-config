---
name: sam_dns_de_conventions
description: House style for AWS SAM template.yaml in dns-de-automation/lambda — derived from 7 templates modified since 2025-11-21
metadata: 
  node_type: memory
  type: project
  originSessionId: 8ab8f42b-46cd-44cd-b864-c684692a2407
---

`data-de-<service>-${Environment}` is the canonical FunctionName prefix (all 5 non-legacy recent templates use `data-de-`). `Custom::ServerlessAccessManager` is declared in every template to provision the IAM role, VPC config, and log forwarding. Role is always `!GetAtt ServerlessAccessManager.LambdaExecutionRoleArn`. `VpcExecution: 'true'` is the default (only `datamover-event-generator` omits it). No `Globals:` block is used anywhere. Runtime default is `python3.13` (metrics-publisher-v2, rte-datamover-guard-checks) or `python3.12` (openai-cost-exporter, datamover-event-generator). `Timeout: 900` and `MemorySize: 2048` are the workhorse defaults. Region is pinned to `eu-west-1` in all ServiceToken ARNs. Tags use lowercase keys: `application`, `created_by`, `owner`, `team`.

Source templates (cutoff 2025-11-21, stale by 2026-11-21):
- `lambda/ingest-api/template.yaml` (2026-04-09)
- `lambda/personal-data-catalog/template.yaml` (2026-04-02)
- `lambda/metrics-publisher-v2/template.yaml` (2026-03-26)
- `lambda/realtime-product-recommendations-api/template.yaml` (2026-03-26)
- `lambda/rte-datamover-guard-checks/template.yaml` (2026-02-16)
- `lambda/openai-cost-exporter/template.yaml` (2026-01-15)
- `lambda/datamover-event-generator/template.yaml` (2025-12-08)

**Why:** User asked for a sam-template skill on 2026-05-21.
**How to apply:** Any time a SAM `template.yaml` is created or edited in `dns-de-automation/lambda`. Re-derive the corpus after 2026-11-21.
