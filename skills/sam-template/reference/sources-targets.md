# Sources and Targets Cheatsheet

From the `serverless-access-manager` README. Validate every entry against this list.

## Sources (read-only access)

| Type | Required Properties | Notes |
|---|---|---|
| `Connect` | `Alias` | Alias of Connect instance |
| `DynamoDB` | `Table` OR `StreamArn` | `Table`: read access. `StreamArn`: stream trigger. Both optional individually but one is expected. |
| `ElasticSearch` | `Cluster` | Forces VPC execution |
| `Kinesis` | `Stream` | Stream name or full ARN for cross-account |
| `Lex` | `BotID` | Readonly access to intents |
| `MSK` | `Topics` (list) | Kafka topics. Requires event source mapping wired separately. |
| `S3` | `Bucket` | Readonly access |
| `SNS` | `Topic` | Subscribe access |
| `SQS` | `Queue` | Triggered by queue. Grants read + delete. |
| `SSM` | `Parameters` (list) | ⚠ Allowed path prefixes only: `/corp-sys/`, `/sc-spange/`, `/dns/`, `/datascience/`. Other paths need `AWS::IAM::Policy` instead. |
| `Transcribe` | `bucket_name`, `input_prefix` | Read access to source video files |

## Targets (read-write access)

| Type | Required Properties | Notes |
|---|---|---|
| `Connect` | `Alias` | Create participants |
| `DynamoDB` | `Table` | Read-write. Append `/index/<gsi-name>` for GSI access. |
| `ElasticSearch` | `Cluster` | Forces VPC execution |
| `EventBridge` | `Bus` | Publish events to named bus |
| `LambdaFunctionUrl` | `Functions` (list) | `AWS_IAM` auth only |
| `MSK` | `Topics` (list) | Write to Kafka topics. Forces VPC execution. |
| `S3` | `Bucket` | Read-write access |
| `SNS` | `Topic` | Publish access |
| `SQS` | `Queue` | Consume and publish |
| `Transcribe` | `bucket_name`, `output_prefix` | Write transcription output |

## SSM path prefix constraint

The access manager only grants SSM access to parameters under these prefixes:
- `/corp-sys/`
- `/sc-spange/`
- `/dns/`
- `/datascience/`

For SSM parameters under other paths (e.g. `/data-engineering/`), use `AWS::IAM::Policy` attached to `ServerlessAccessManager.LambdaExecutionRoleName` instead:

```yaml
CustomSSMPolicy:
  Type: AWS::IAM::Policy
  Properties:
    PolicyName: custom-ssm-access
    PolicyDocument:
      Version: "2012-10-17"
      Statement:
        - Effect: Allow
          Action: 'ssm:GetParameter'
          Resource: !Sub 'arn:aws:ssm:${AWS::Region}:${AWS::AccountId}:parameter/data-engineering/*'
    Roles:
      - !GetAtt ServerlessAccessManager.LambdaExecutionRoleName
```

## Cross-account Kinesis

Adding `Sources.Kinesis.Stream` alone does NOT trigger the Lambda. You also need:

1. An `AWS::Lambda::Permission` resource granting `kinesis.amazonaws.com` invoke rights.
2. A separate MR to the `infrastructure` repo (`kinesis/<env>/<region>/<stream>/terraform.tfvars`) adding the Lambda execution role ARN to the stream's principal list and creating the event source mapping.

Warn the user about step 2 when wiring a Kinesis source.
