# Custom::ServerlessAccessManager Wiring

Every template in `dns-de-automation/lambda` uses this custom resource. It provisions the IAM execution role, VPC security group, and Datadog log forwarding.

## Minimal required block

```yaml
ServerlessAccessManager:
  Type: Custom::ServerlessAccessManager
  Properties:
    ServiceToken: !Sub 'arn:aws:lambda:eu-west-1:${AWS::AccountId}:function:paas-serverless-access-manager'
    FunctionName: !Sub 'data-de-<service>-${Environment}'
```

`FunctionName` is the only required property. Everything else is optional.

## With VPC + Sources + Targets (typical)

```yaml
ServerlessAccessManager:
  Type: Custom::ServerlessAccessManager
  Properties:
    ServiceToken: !Sub 'arn:aws:lambda:eu-west-1:${AWS::AccountId}:function:paas-serverless-access-manager'
    FunctionName: !Sub 'data-de-<service>-${Environment}'
    VpcExecution: 'true'
    Sources:
      SSMParams:
        Type: SSM
        Properties:
          Parameters:
            - /dns/my-service/some-param
    Targets:
      DevTargetS3:
        Type: S3
        Properties:
          Bucket: hbi-dns-dev-rdl-staging
      ProdTargetS3:
        Type: S3
        Properties:
          Bucket: hbi-dns-rdl-staging
      EventBusPush:
        Type: EventBridge
        Properties:
          Bus: !Ref EventBus
```

## Consuming the attributes on the Function

```yaml
MyFunction:
  Type: AWS::Serverless::Function
  Properties:
    FunctionName: !GetAtt ServerlessAccessManager.FunctionName   # deduplicates the name string
    Role: !GetAtt ServerlessAccessManager.LambdaExecutionRoleArn
    VpcConfig: !GetAtt ServerlessAccessManager.VpcConfig         # only when VpcExecution: 'true'
```

## Available attributes

| Attribute | When available |
|---|---|
| `FunctionName` | Always |
| `LambdaExecutionRoleArn` | Always |
| `LambdaExecutionRoleName` | Always (used for extra IAM policy attachment) |
| `VpcConfig` | When `VpcExecution: 'true'` or MSK/ElasticSearch target/source present |
| `VpcSgId` | Same as VpcConfig |

## DatadogLogging

Default is `"true"` (Datadog log forwarding enabled). To disable:

```yaml
DatadogLogging: 'false'
```

Only `zendesk-alerter` in the repo disables this. Leave it at default unless explicitly requested.

## Dev/Prod target naming convention

When the same logical resource has different names per environment, declare two named entries:

```yaml
Targets:
  DevTargetDynamo:
    Type: DynamoDB
    Properties:
      Table: my-table-dev
  ProdTargetDynamo:
    Type: DynamoDB
    Properties:
      Table: my-table-prod
```

The access manager grants access to both and the correct one is used at runtime via the `Env` environment variable.

## DynamoDB GSI access

To grant access to a GSI, append `/index/<gsi-name>` to the table name:

```yaml
Targets:
  DevDynamoGSI:
    Type: DynamoDB
    Properties:
      Table: rte-validation-results-dev/index/idx-by-batch-id-and-failed-s3-file-dev
```
