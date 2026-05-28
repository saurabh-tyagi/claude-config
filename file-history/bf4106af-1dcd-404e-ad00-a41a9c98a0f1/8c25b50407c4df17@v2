---
name: sam_dns_de_conventions
description: House style for AWS SAM template.yaml in dns-de-automation/lambda — derived from 7 templates modified since 2025-11-21
metadata: 
  node_type: memory
  type: project
  originSessionId: bf4106af-1dcd-404e-ad00-a41a9c98a0f1
---

data-de-<service>-${Environment} is the canonical FunctionName prefix (all 5 non-legacy recent templates use data-de-). Custom::ServerlessAccessManager is declared in every template to provision the IAM role, VPC config, and log forwarding. Role is always !GetAtt ServerlessAccessManager.LambdaExecutionRoleArn. VpcExecution: 'true' is the default. No Globals: block is used anywhere. Runtime defaults are python3.13 (metrics-publisher-v2, rte-datamover-guard-checks) or python3.12 (openai-cost-exporter, datamover-event-generator). Timeout: 900 and MemorySize: 2048 are the workhorse defaults. Region is pinned to eu-west-1 in all ServiceToken ARNs.

Source templates (cutoff 2025-11-21, stale by 2026-11-21):
- lambda/ingest-api/template.yaml (2026-04-09)
- lambda/personal-data-catalog/template.yaml (2026-04-02)
- lambda/metrics-publisher-v2/template.yaml (2026-03-26)
- lambda/realtime-product-recommendations-api/template.yaml (2026-03-26)
- lambda/rte-datamover-guard-checks/template.yaml (2026-02-16)
- lambda/openai-cost-exporter/template.yaml (2026-01-15)
- lambda/datamover-event-generator/template.yaml (2025-12-08)

**Why:** user asked for a sam-template skill on 2026-05-21.
**How to apply:** any time a SAM template.yaml is created or edited in dns-de-automation.
