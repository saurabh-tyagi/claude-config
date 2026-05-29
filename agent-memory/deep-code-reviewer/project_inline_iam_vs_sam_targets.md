---
name: inline-iam-vs-sam-targets
description: This org's SAM templates repeatedly attach inline AWS::IAM::Policy to serverless-access-manager-managed roles instead of using S3/DynamoDB/etc Targets
metadata:
  type: project
---

In dns-de-* / data-rte-* SAM templates, the team has a recurring habit of attaching standalone `AWS::IAM::Policy` resources (with `Roles: [!GetAtt XxxServerlessAccessManager.LambdaExecutionRoleName]`) to grant S3/Secrets/SSM access, instead of declaring those as `Sources`/`Targets` on the `Custom::ServerlessAccessManager` resource. Seen in dns-de-rte-orchestrator template.yaml: `ProcessS3WritePolicy` (new in DATA-4715), `ProcessSecretsSSMPermsPolicy`, `ReporterS3ReadPolicy`.

**Why:** The access-manager custom resource owns and reconciles the execution role; external policy attachments conflict with its reconciliation loop (playbook §"No inline IAM"). BUT the team sometimes does it deliberately because the S3 Target grants readwrite on the whole bucket and is NOT prefix-scoped — and they want prefix-level least-privilege for PII audit logs.

**How to apply:** Flag inline IAM on a managed role as High per the playbook, but always note the prefix-scoping tradeoff: the access-manager S3 Target (`Bucket` only) cannot scope to a key prefix. If the deviation is intentional for least-privilege, the fix is a one-line justifying comment, not removal. Ask whether prefix-scoping is a hard requirement before insisting on the Target. See [[serverless-access-manager review playbook]].
