# Canonical SAM Template Skeleton

Derived from 7 templates modified since 2025-11-21 in `dns-de-automation/lambda`. AWS best-practice additions are marked **[BP]**.

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Transform: AWS::Serverless-2016-10-31
Description: <One-line service description>

Parameters:
  Environment:
    Description: Environment
    Type: String
  TeamName:
    Description: Team responsible for application
    Type: String
    Default: de
  ApplicationName:
    Description: Name of application
    Type: String
    Default: '<service-name>'
  # Add service-specific params below (SSM names, secret ARNs, layer ARNs, etc.)
  # Common patterns:
  #   EventBus: Name of the Supernova EventBridge bus
  #   SupernovaLayerVersion: ARN of supernova layer
  #   DeCommonLayer: ARN of dns-de-common-layer
  #   ImageTag: Image SHA (image-based functions only)
  #   LogLevel: (Default: 'INFO') — if the function reads it

Resources:
  # --- Access manager MUST be first resource ---
  ServerlessAccessManager:
    Type: Custom::ServerlessAccessManager
    Properties:
      ServiceToken: !Sub 'arn:aws:lambda:eu-west-1:${AWS::AccountId}:function:paas-serverless-access-manager'
      FunctionName: !Sub 'data-de-<service>-${Environment}'
      VpcExecution: 'true'
      # Sources: ...   (read-only: S3, SSM, MSK, Kinesis, SQS, DynamoDB stream, SNS)
      # Targets: ...   (read-write: S3, DynamoDB, EventBridge, SQS, SNS, MSK)

  # --- Optional: extra IAM policy for perms access manager doesn't model ---
  # ExtraPermissionsPolicy:
  #   Type: AWS::IAM::Policy
  #   Properties:
  #     ...

  # --- [BP] Explicit log group with retention ---
  <FunctionLogicalId>LogGroup:
    Type: AWS::Logs::LogGroup
    Properties:
      LogGroupName: !Sub '/aws/lambda/data-de-<service>-${Environment}'
      RetentionInDays: 30

  <FunctionLogicalId>:
    Type: AWS::Serverless::Function
    DependsOn: <FunctionLogicalId>LogGroup
    Properties:
      FunctionName: !GetAtt ServerlessAccessManager.FunctionName
      Role: !GetAtt ServerlessAccessManager.LambdaExecutionRoleArn
      VpcConfig: !GetAtt ServerlessAccessManager.VpcConfig
      CodeUri: src/
      Handler: app.lambda_handler
      Runtime: python3.13
      MemorySize: 2048
      Timeout: 900
      Tracing: Active  # [BP] X-Ray tracing
      Environment:
        Variables:
          Env: !Ref Environment
          # Add service-specific env vars here
      Tags:
        application: '<service-name>'
        created_by: cloudformation
        owner: 'de'
        team: !Ref TeamName

Outputs:
  <FunctionLogicalId>ARN:
    Description: "<service> function ARN"
    Value: !GetAtt <FunctionLogicalId>.Arn
```

## Defaults summary

| Property | Default | Notes |
|---|---|---|
| Runtime | `python3.13` | Most common in recent corpus |
| MemorySize | `2048` | Standard workhorse |
| Timeout | `900` | Long-running ingest default |
| EphemeralStorage | omit | Add `Size: 10240` if writing large temp files |
| FunctionName prefix | `data-de-` | Recent corpus unanimous |
| VpcExecution | `'true'` | Always unless explicitly no-VPC needed |
| Tracing | `Active` | AWS best practice; not in corpus |
| LogGroup | Explicit + `RetentionInDays: 30` | AWS best practice; not in corpus |

## API-shaped workload overrides

When the function is synchronous and latency-sensitive (ALB/API Gateway backed):
- `Timeout: 30`
- `MemorySize: 1024` (or `1769` if full vCPU needed — see `realtime-product-recommendations-api`)
- Ask the user to confirm before applying.
