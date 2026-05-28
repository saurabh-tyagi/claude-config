---
name: sam-template
description: Use whenever an AWS SAM template.yaml is being created or modified in the dns-de-automation lambda style, or any SAM template that integrates with serverless-access-manager. Trigger on direct requests ("add a new lambda", "update template.yaml", "add an SQS target to the access manager"), AND proactively whenever Claude is implementing code changes that end up adding or modifying a SAM template.yaml as a side-effect (for example: adding a new Lambda env var, wiring a new event source, adding an IAM permission, introducing a new SAM resource). If the implementation touches template.yaml at all, invoke this skill before writing the change.
team: de
---

# SAM Template Skill

This skill ensures `template.yaml` files match the house style of `dns-de-automation/lambda` and correctly integrate with `Custom::ServerlessAccessManager`.

## Reference files

All patterns live in `reference/` next to this file:

- `reference/skeleton.md` — canonical template skeleton
- `reference/access-manager.md` — how to wire the custom resource
- `reference/sources-targets.md` — Sources/Targets type cheatsheet
- `reference/function-resource.md` — Function properties
- `reference/iam-extensions.md` — extra IAM policy attachment
- `reference/events-and-triggers.md` — event wiring patterns
- `reference/tags-and-outputs.md` — tagging and Outputs
- `reference/best-practices.md` — AWS SAM official best practices applied as fallbacks
- `reference/recent-examples.md` — the 7 in-scope reference templates

**Style source**: patterns extracted from the 7 templates modified since 2025-11-21 (see `reference/recent-examples.md`). For anything those templates do not address, fall back to `reference/best-practices.md`.

---

## Step 0: On first invocation, write memory

Before doing any template work, check `/Users/saurabhtyagi/.claude/projects/-Users-saurabhtyagi--claude/memory/MEMORY.md` to see if the line `sam_dns_de_conventions` already appears. If it does not, write the three memory files described at the bottom of this skill (section **Memory writes**). This ensures future conversations inherit the established context without re-scanning.

---

## Step 1: Detect mode — new template vs edit existing

Check whether `template.yaml` already exists in the target service directory.

- **File does not exist** → proceed to **Step 2: New template**.
- **File exists** → proceed to **Step 3: Edit existing**.

---

## Step 2: New template

Read `reference/skeleton.md` and apply the canonical defaults:

| Field | Default | Reason |
|-------|---------|--------|
| Runtime | `python3.13` | Most recent in corpus |
| MemorySize | `2048` | Standard workhorse |
| Timeout | `900` | Long-running ingest default |
| FunctionName prefix | `data-de-` | Observed in all 5 recent non-legacy templates |
| Role | `!GetAtt ServerlessAccessManager.LambdaExecutionRoleArn` | Universal pattern |
| VpcExecution | `'true'` | Universal in corpus |
| Tracing | `Active` | AWS best practice (corpus is silent — see `reference/best-practices.md`) |
| LogGroup | Explicit `AWS::Logs::LogGroup` with `RetentionInDays: 30` | AWS best practice (corpus is silent) |

If the workload is API-shaped (short, synchronous, ALB/API Gateway backed), suggest `Timeout: 30` and `MemorySize: 1024` and ask the user to confirm.

Ask the user to confirm any deviation from these defaults before writing.

Then follow: **Step 4: Wire ServerlessAccessManager**, **Step 5: IAM**, **Step 6: Events**, **Step 7: Outputs**.

---

## Step 3: Edit existing template

1. Read the full existing `template.yaml` first.
2. Detect and lock to the template's existing style choices — do NOT change these without explicit user approval:
   - **FunctionName prefix**: `dns-de-` vs `data-de-` (look at `ServerlessAccessManager.FunctionName`)
   - **Runtime**: whatever Python version is set (e.g. `python3.8`). Do not silently upgrade.
   - **Role attachment style**: `!GetAtt ServerlessAccessManager.LambdaExecutionRoleArn` vs `!Ref LambdaRole`
   - **Tag key set**: only use tag keys already present in the template
   - **PackageType**: Zip vs Image
   - **VpcExecution**: `'true'` or `'false'`
   - **FunctionName on function**: `!GetAtt ServerlessAccessManager.FunctionName` vs `!Sub` inline
3. Make only the change the user requested.
4. If the existing template deviates from the 6-month baseline (e.g. `python3.8`, missing `Tags:`, inline `Policies:`), **flag it** with a one-line note — do not silently rewrite:
   > ⚠ Note: this template uses `python3.8`; the current baseline is `python3.13`. Keeping existing runtime. Ask if you'd like to upgrade.

---

## Step 4: Wire ServerlessAccessManager

See `reference/access-manager.md` for the full pattern. Key rules:

- `ServiceToken` must always be: `!Sub 'arn:aws:lambda:eu-west-1:${AWS::AccountId}:function:paas-serverless-access-manager'`
- `FunctionName` on the custom resource and on `AWS::Serverless::Function` must be identical. Use `!GetAtt ServerlessAccessManager.FunctionName` on the function to avoid duplication.
- Use `Sources` for read-only access (S3, SSM, MSK, Kinesis, SQS, DynamoDB stream, SNS, etc.).
- Use `Targets` for read-write access (S3, DynamoDB, EventBridge, SQS, SNS, MSK, etc.).
- Validate every entry's `Type` against the list in `reference/sources-targets.md`.
- Name Source/Target entries descriptively and include `Dev`/`Prod` variants when the resource name differs per environment (e.g. `DevTargetS3` / `ProdTargetS3`).
- `VpcExecution: 'true'` is required to get `ServerlessAccessManager.VpcConfig`. MSK targets and ElasticSearch force VPC automatically.

---

## Step 5: IAM extensions

Never use SAM inline `Policies:` templates (e.g. `S3CrudPolicy`, `DynamoDBReadPolicy`). They are not used anywhere in this repo.

If the access manager Sources/Targets do not cover a required permission (e.g. Secrets Manager, cross-account role, specific SSM path not covered by allowed prefixes):

```yaml
ExtraPermissionsPolicy:
  Type: AWS::IAM::Policy
  Properties:
    PolicyName: <descriptive-name>
    PolicyDocument:
      Version: "2012-10-17"
      Statement:
        - Effect: Allow
          Action:
            - 'secretsmanager:GetSecretValue'
          Resource: !Ref MySecret
    Roles:
      - !GetAtt ServerlessAccessManager.LambdaExecutionRoleName
```

See `reference/iam-extensions.md` for worked examples.

---

## Step 6: Event triggers

See `reference/events-and-triggers.md` for full patterns.

- **EventBridge rule → Lambda**: use `AWS::Lambda::Permission` with `Principal: events.amazonaws.com`.
- **S3 event → Lambda**: use `AWS::Lambda::Permission` with `Principal: s3.amazonaws.com`.
- **ALB → Lambda**: use `AWS::Lambda::Permission` with `Principal: elasticloadbalancing.amazonaws.com`.
- **SQS trigger**: declare as `Sources.Type: SQS` on the access manager and add a SAM `Events:` block with `Type: SQS`.
- **SAM `Events:` block**: acceptable for SQS, SNS direct subscription, and EventBridge scheduled rules. Not needed for S3/EventBridge patterns wired via separate resources.

---

## Step 7: Outputs

Always emit exactly one Output — the function ARN:

```yaml
Outputs:
  <FunctionLogicalId>ARN:
    Description: "<service> function ARN"
    Value: !GetAtt <FunctionLogicalId>.Arn
```

No `Export:` blocks. No cross-stack references via Outputs.

---

## Anti-patterns — refuse and explain

If the user's request would produce any of the following, refuse and explain the preferred approach:

| Anti-pattern | Preferred alternative |
|---|---|
| Inline `Policies:` with SAM policy templates (`S3CrudPolicy`, etc.) | Add `Sources`/`Targets` entry on `ServerlessAccessManager` |
| `Globals:` block | Not used in this repo; set properties per-function |
| Hard-coded VPC subnets or security groups | Use `VpcConfig: !GetAtt ServerlessAccessManager.VpcConfig` |
| Missing `Environment` parameter | Always declare `Environment: {Type: String}` |
| Region other than `eu-west-1` in ServiceToken ARN | Keep `eu-west-1` pinned |
| Silently upgrading runtime, prefix, or role style during an edit | Flag the deviation and ask |
| Adding `Export:` to Outputs | Not used in this codebase |

---

## Memory writes

On first invocation (when `sam_dns_de_conventions` not in MEMORY.md), write these three files, then append index lines to MEMORY.md.

### File 1: `project_sam_dns_de_conventions.md`
```
---
name: sam_dns_de_conventions
description: House style for AWS SAM template.yaml in dns-de-automation/lambda — derived from 7 templates modified since 2025-11-21
metadata:
  type: project
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
```

### File 2: `reference_serverless_access_manager.md`
```
---
name: reference_serverless_access_manager
description: How to consume serverless-access-manager in a SAM template — ServiceToken, Sources/Targets, Attributes
metadata:
  type: reference
---

README at /Users/saurabhtyagi/ws/serverless-access-manager/README.md.

ServiceToken (always): !Sub 'arn:aws:lambda:eu-west-1:${AWS::AccountId}:function:paas-serverless-access-manager'

Attributes exposed via !GetAtt:
- FunctionName, LambdaExecutionRoleArn, LambdaExecutionRoleName (always available)
- VpcConfig, VpcSgId (only when VpcExecution enabled)

Sources (read-only): Connect, DynamoDB (Table or StreamArn), ElasticSearch (forces VPC), Kinesis, Lex, MSK, S3, SNS, SQS, SSM (path prefixes: /corp-sys/, /sc-spange/, /dns/, /datascience/ only), Transcribe
Targets (read-write): Connect, DynamoDB, ElasticSearch, EventBridge (Bus), LambdaFunctionUrl, MSK (forces VPC), S3, SNS, SQS, Transcribe

Consumer integration is in-template only (add Sources/Targets to the custom resource).
Exception: cross-account Kinesis triggers also require an MR to the infrastructure repo (kinesis/<env>/<region>/<stream>/terraform.tfvars).

Stack tags must be lowercase and include required tags (created_by, owner, team); validation fails otherwise.
```

### File 3: `feedback_sam_skill_style_rule.md`
```
---
name: feedback_sam_skill_style_rule
description: When working on SAM templates, use only recently-modified templates as the style reference; do not blindly follow older ones
metadata:
  type: feedback
---

When authoring or editing SAM templates in dns-de-automation, use only templates modified in the last 6 months as the style reference. Cross-check against AWS SAM official documentation. Do not blindly follow older templates (python3.8, dns-de- prefix, missing tags, etc.).

**Why:** user explicitly asked 2026-05-21 — the repo has years of style drift and older templates should not be treated as canonical.
**How to apply:** every time the sam-template skill runs; re-derive the 6-month corpus when the stale date (2026-11-21) is reached.
```

### MEMORY.md lines to append:
```
- [SAM dns-de-automation conventions](project_sam_dns_de_conventions.md) — house style from 7 templates modified since 2025-11-21: data-de- prefix, python3.13, Custom::ServerlessAccessManager universal
- [serverless-access-manager reference](reference_serverless_access_manager.md) — ServiceToken pattern, Sources/Targets types, Attributes, cross-account Kinesis caveat
- [SAM skill style rule](feedback_sam_skill_style_rule.md) — use only last-6-months templates as style reference; fall back to AWS docs
```
