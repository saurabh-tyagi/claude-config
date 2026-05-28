---
name: reference_serverless_access_manager
description: "How to consume serverless-access-manager in a SAM template — ServiceToken, Sources/Targets types, Attributes, cross-account Kinesis caveat"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 8ab8f42b-46cd-44cd-b864-c684692a2407
---

README at `/Users/saurabhtyagi/ws/serverless-access-manager/README.md`.

ServiceToken (always): `!Sub 'arn:aws:lambda:eu-west-1:${AWS::AccountId}:function:paas-serverless-access-manager'`

**Attributes exposed via `!GetAtt`:**
- `FunctionName`, `LambdaExecutionRoleArn`, `LambdaExecutionRoleName` — always available
- `VpcConfig`, `VpcSgId` — only when `VpcExecution: 'true'` or MSK/ElasticSearch source/target

**Sources (read-only):** Connect, DynamoDB (Table or StreamArn), ElasticSearch (forces VPC), Kinesis, Lex, MSK, S3, SNS, SQS, SSM (limited path prefixes: `/corp-sys/`, `/sc-spange/`, `/dns/`, `/datascience/` only), Transcribe

**Targets (read-write):** Connect, DynamoDB, ElasticSearch, EventBridge (Bus), LambdaFunctionUrl, MSK (forces VPC), S3, SNS, SQS, Transcribe

Consumer integration is in-template only — add `Sources`/`Targets` to the custom resource. No changes needed to the serverless-access-manager repo itself.

**Exception:** cross-account Kinesis triggers also require a separate MR to the `infrastructure` repo (`kinesis/<env>/<region>/<stream>/terraform.tfvars`) to add the Lambda execution role ARN to the stream principal list and create the event source mapping.

Stack tags must be lowercase and include `created_by` and `owner`; validation fails otherwise.
