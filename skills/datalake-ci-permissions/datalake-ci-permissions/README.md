# datalake-ci-permissions

Add or update AWS resource and GitLab CI IAM roles scoped to the datalake environment.

## When to use

Use this skill when adding or modifying IAM permissions for the datalake environment — new AWS resources (S3, Lambda, ECR, CloudFormation stacks, SNS, SQS, Kinesis, DynamoDB, RDS) or their corresponding GitLab CI deployment roles.

Do not trigger for `dev`, `prod`, `sandbox`, or `services` environments unless explicitly requested.

## What it does

1. Identifies the component being changed under `infrastructure/` or `infrastructure-platform/`.
2. Reads the relevant component README to confirm expected input names.
3. Finds the closest existing datalake role in `gitlab-ci-aws-permissions/environments/datalake/global/data/terraform.yaml` to reuse or extend.
4. Selects the narrowest templated policy (`s3-readonly`, `ecr-push`, `cf-deploy`, `lambda-permission-deploy`, `lambda-function-url`, etc.) that covers the requested capability.
5. Updates both the infrastructure component config and the CI IAM role, keeping all changes under datalake paths.

## Installing

**User-level** (available in all projects):
```bash
cp -r . ~/.claude/skills/datalake-ci-permissions
```

**Project-level** (available in one project):
```bash
cp SKILL.md /path/to/project/.claude/commands/datalake-ci-permissions.md
```
