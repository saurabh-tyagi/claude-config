---
name: datalake-ci-permissions
description: Use when user asks to add or update any AWS resource deployment or GitLab CI IAM roles scoped to the datalake environment. Do not trigger for non-datalake environments (dev, prod, sandbox, services) unless explicitly requested.
team: de
---

# Datalake CI Permissions

Keep all edits scoped to datalake unless the user explicitly asks for another environment.

## Work in Scope

- Edit only `gitlab-ci-aws-permissions/environments/datalake/**`.
- Edit only `infrastructure/**/environments/datalake/**` or `infrastructure-platform/**/environments/datalake/**`.
- Reuse existing datalake naming, team, and repository patterns before adding new ones.

Do not change `dev`, `sandbox`, `prod`, `services`, or other non-datalake environments by default.

## Before Editing

1. Identify which component is being added or changed under `infrastructure/` or `infrastructure-platform/`.
2. Read the component README to confirm expected `terraform.tfvars` input names and integration behaviour. Common READMEs:
   - `infrastructure/s3/README.md` for S3 bucket configuration.
   - `infrastructure/sns/README.md` when SNS topics subscribe Lambda functions or other consumers.
   - `infrastructure/sqs/README.md` when SQS queues trigger downstream processing.
   - `infrastructure/kinesis/README.md` when Kinesis streams create event source mappings.
   - `infrastructure/dynamodb/README.md` for DynamoDB table access.
   - `infrastructure/rds/README.md` for RDS instance access.
3. Open `gitlab-ci-aws-permissions/environments/datalake/global/data/terraform.yaml` and find the closest existing role for the same team or repository.

Prefer nearby datalake examples over inventing a new structure.

## Choose the Right Permission Pattern

Scan `gitlab-ci-aws-permissions/README.md` and `gitlab-ci-aws-permissions/terraform/policy-*.tf` for the full list of available templated policies. Use the narrowest one that covers the requested capability. Common patterns:

- `s3-readonly` / `s3-readwrite`: Use for S3 read or read/write access. Scope to specific `s3_bucket_names` where possible.
- `ecr-push`: Use when the project builds and pushes Docker images.
- `cf-deploy`: Use when the project deploys CloudFormation or serverless stacks. Add `services: ["lambda"]` when the stack creates or updates Lambda functions or layers. Add `s3_bucket_names` only when the deployment package bucket is not covered by defaults.
- `lambda-permission-deploy`: Use when deployment needs `lambda:AddPermission` or `lambda:RemovePermission` for invokers such as API Gateway, SNS, EventBridge, ELB, CloudWatch alarms, or cross-account principals.
- `lambda-function-url`: Use when deployment needs Lambda function URL permissions. Set `lambda_prefixes`, `teams`, and `principals` to the narrowest valid values.

Prefer an existing templated policy over adding broad inline statements.

## Edit Workflow

1. Update the datalake component configuration under the relevant `environments/datalake/...` path.
2. Update the matching datalake CI role in `gitlab-ci-aws-permissions/environments/datalake/global/data/terraform.yaml`.
3. For existing roles: extend them when the same repository and trust boundary already exist and only a new permission is needed. Add a new role only when the repository, environment, or branch scope differs from all existing roles.
4. Keep `trusted_projects.paths` restricted to the exact repository or smallest valid wildcard.
5. Keep `branches` and principals no broader than required.

## Validation Checklist

- Confirm every edited file stays under a datalake path.
- Confirm `team`, `vertical`, repository path, and branch patterns match the owning project.
- Confirm resource names, prefixes, and principals match the actual resource naming and access model.
- Confirm the component config and IAM change are consistent with each other.
- Prefer least privilege; do not add broad wildcard resources or principals when a templated policy already covers the use case.
