---
name: reference_serverless_access_manager
description: "How to consume serverless-access-manager in a SAM template — ServiceToken, Sources/Targets, Attributes"
metadata: 
  node_type: memory
  type: reference
  originSessionId: bf4106af-1dcd-404e-ad00-a41a9c98a0f1
---

ServiceToken (always): !Sub 'arn:aws:lambda:eu-west-1:${AWS::AccountId}:function:paas-serverless-access-manager'

Attributes exposed via !GetAtt:
- FunctionName, LambdaExecutionRoleArn, LambdaExecutionRoleName (always available)
- VpcConfig, VpcSgId (only when VpcExecution enabled)

Sources (read-only): Connect, DynamoDB (Table or StreamArn), ElasticSearch (forces VPC), Kinesis, Lex, MSK, S3, SNS, SQS, SSM (path prefixes: /corp-sys/, /sc-spange/, /dns/, /datascience/ only), Transcribe
Targets (read-write): Connect, DynamoDB, ElasticSearch, EventBridge (Bus), LambdaFunctionUrl, MSK (forces VPC), S3, SNS, SQS, Transcribe

Consumer integration is in-template only (add Sources/Targets to the custom resource).
Exception: cross-account Kinesis triggers also require an MR to the infrastructure repo (kinesis/<env>/<region>/<stream>/terraform.tfvars).

Stack tags must be lowercase and include required tags (created_by, owner, team); validation fails otherwise.
