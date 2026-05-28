---
name: serverless-access-manager review playbook
description: Review rules for SAM templates using or eligible for the team's Custom::ServerlessAccessManager Lambda-backed custom resource
type: reference
---

# AWS SAM: serverless-access-manager Custom Resource — Review Playbook

When reviewing SAM templates, check whether the team's internal `Custom::ServerlessAccessManager` Lambda-backed custom resource is being used correctly. This resource is the canonical pattern for managing Lambda execution roles, VPC security groups, and Datadog log forwarding — defined at `/Users/saurabhtyagi/ws/serverless-access-manager/README.md` (re-read this file before finalising findings; the source/target list can drift).

**Before producing findings, re-read `/Users/saurabhtyagi/ws/serverless-access-manager/README.md` to get the current canonical source/target type list.**

## Recommend adoption when serverless-access-manager is absent

Flag as **Medium** any SAM template that manually defines an `AWS::IAM::Role` execution role for a Lambda that interacts with services covered by a supported source or target type (DynamoDB, MSK, S3, SQS, SNS, Kinesis, EventBridge, ElasticSearch, SSM, Connect, Lex, LambdaFunctionUrl, Transcribe). These templates should use `Custom::ServerlessAccessManager` instead to reduce boilerplate and keep IAM management centralised.

## Required properties and correct `!GetAtt` wiring

For any template that already uses `Custom::ServerlessAccessManager`:

- `FunctionName` must be set on the custom resource — it is the key used for naming all underlying resources.
- Lambda `Role` **must** reference `!GetAtt ServerlessAccessManager.LambdaExecutionRoleArn`. An inline or separately-declared IAM role for the same function is a **High** issue — the custom resource manages the role; a second role is unused or conflicts.
- When VPC execution is enabled (explicitly or implicitly via ElasticSearch/MSK sources or targets), Lambda `VpcConfig` **must** be `!GetAtt ServerlessAccessManager.VpcConfig`. Hardcoding subnet/SG IDs is **Medium**.
- Lambda `FunctionName` should reuse `!GetAtt ServerlessAccessManager.FunctionName` (deduplicates the string). Using a literal string that duplicates the `FunctionName` property value is **Low**.

## `Type` value validation (case-sensitive)

All `Type` values in `Sources` and `Targets` are case-sensitive. Flag any mis-cased value as **High** — an incorrect type is silently ignored or causes `InvalidInput`.

Valid source types: `Connect`, `DynamoDB`, `ElasticSearch`, `Kinesis`, `Lex`, `MSK`, `S3`, `SNS`, `SQS`, `SSM`, `Transcribe`.

Valid target types: `Connect`, `DynamoDB`, `ElasticSearch`, `EventBridge`, `LambdaFunctionUrl`, `MSK`, `S3`, `SNS`, `SQS`, `Transcribe`.

Common mistake: `Eventbridge` → must be `EventBridge`.

## Stack-tag requirements

The custom resource validates stack tags before provisioning. Required tags must be present and **all tag keys and values must be lowercase**. Violation causes an `InvalidInput` error at deploy time — flag as **High**. Example: `Owner: MyTeam` must be `owner: myteam`.

## SSM source path-prefix restriction

The `SSM` source type only supports these parameter path prefixes: `/corp-sys/`, `/sc-spange/`, `/dns/`, `/datascience/`. Flag any `Parameters` entry outside these prefixes as **High** — it will fail at runtime.

## Transcribe source/target specifics

- `input_prefix` and `output_prefix` must use wildcards that match the actual S3 path layout (e.g. `*/concatenated/composited-video/*.mp4`).
- `output_prefix` must cover the entire output folder, not just `*.json`. AWS Transcribe writes `.write_access_check_file.temp` to the output prefix before starting the job — a narrowly-scoped prefix causes a silent failure. Flag `output_prefix` patterns scoped only to `*.json` as **High**.
- If the Lambda runs in a private subnet and the template does not include evidence of a NAT Gateway or Transcribe PrivateLink, flag as **Medium** (AWS Transcribe is a public endpoint; a VPC-isolated Lambda will timeout silently).

## Cross-account Kinesis source

When a `Kinesis` source `Stream` value is a full ARN (cross-account), flag as **Info** if either of these is missing from the template:

- An `AWS::Lambda::Permission` resource granting `kinesis.amazonaws.com` `lambda:InvokeFunction` rights with both `SourceAccount` and `SourceArn` set.
- A note that the stream's resource policy in the infrastructure repo must grant the execution role read permissions. (This lives outside the SAM template — flag as Info rather than High, but make the omission explicit.)

For same-account Kinesis (`Stream` is a plain name, not an ARN), neither of these is required.

## Redundant `VpcExecution: true`

`VpcExecution: true` is implicitly forced by `ElasticSearch` or `MSK` sources/targets. Flag it as **Low** when the template already declares one of those — it is harmless but redundant noise.

## Unexplained `DatadogLogging: "false"`

`DatadogLogging` defaults to `"true"`. If a template sets it to `"false"` with no comment explaining why, flag as **Medium** — Datadog log forwarding is expected in all environments, and a silent opt-out will cause an observability gap.

## No inline IAM alongside `serverless-access-manager`

If the template contains `Custom::ServerlessAccessManager` and also attaches an `AWS::IAM::ManagedPolicy` or inline `Policies:` to the same Lambda's execution role, flag as **High**. The custom resource owns the role; any external mutation conflicts with its reconciliation loop.
