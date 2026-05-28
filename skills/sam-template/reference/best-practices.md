# AWS SAM Best Practices

These are AWS-official best practices applied as fallbacks when the recent corpus is silent. Apply them for new templates. For edits, flag their absence but do not silently add them.

## X-Ray Tracing

```yaml
# On the function:
Tracing: Active
```

AWS recommends enabling tracing on all Lambda functions for observability. The recent corpus does not set this — it is a gap the skill should fill on new templates.

Ref: https://docs.aws.amazon.com/lambda/latest/dg/services-xray.html

## Explicit CloudWatch Log Group with retention

Lambda auto-creates a log group but without a retention policy (logs retained forever by default). Best practice is to declare it explicitly:

```yaml
MyServiceFunctionLogGroup:
  Type: AWS::Logs::LogGroup
  Properties:
    LogGroupName: !Sub '/aws/lambda/${ServerlessAccessManager.FunctionName}'
    RetentionInDays: 30   # 30 days for most services; consider 90 for audit-sensitive

MyServiceFunction:
  Type: AWS::Serverless::Function
  DependsOn: MyServiceFunctionLogGroup   # ensure log group exists before function
  Properties:
    ...
```

Suggested retention values:
- **30 days** — default for most services
- **90 days** — audit or compliance-sensitive services
- Ask the user if unsure.

Ref: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html

## IAM least privilege

- Use specific actions (not `*`) in `AWS::IAM::Policy` statements.
- Scope `Resource` to named ARNs; use pseudo-params (`${AWS::AccountId}`, `${AWS::Region}`) not hard-coded IDs.
- Grant `secretsmanager:GetSecretValue` + `secretsmanager:DescribeSecret` when reading a secret (DescribeSecret allows rotation metadata lookups).

## Dead-letter queue / async invocations

When a Lambda is invoked asynchronously (EventBridge rule, S3 event, SNS), consider adding a DLQ:

```yaml
MyServiceFunction:
  Properties:
    EventInvokeConfig:
      MaximumRetryAttempts: 2
      DestinationConfig:
        OnFailure:
          Type: SQS
          Destination: !GetAtt MyDLQ.Arn
```

The corpus does not use this — propose it to the user when the function is async-invoked and failures need to be observable.

## Reserved concurrency

Do not set `ReservedConcurrentExecutions` unless the user explicitly asks or the function is latency-sensitive and must not be throttled. Unrestricted concurrency is the safe default for batch/ingest functions.

## EphemeralStorage

Only add `EphemeralStorage.Size: 10240` when the function needs large `/tmp` space (file downloads, large CSVs). The default is 512 MB. Do not increase it speculatively.

## Architectures

Only set `Architectures: [x86_64]` for image-based functions where the image is built for x86. For Zip functions, omit it (defaults to x86_64 anyway) unless explicitly building for ARM.
