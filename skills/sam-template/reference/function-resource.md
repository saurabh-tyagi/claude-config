# AWS::Serverless::Function Patterns

## Zip-based (default)

```yaml
MyServiceFunction:
  Type: AWS::Serverless::Function
  Properties:
    FunctionName: !GetAtt ServerlessAccessManager.FunctionName
    Role: !GetAtt ServerlessAccessManager.LambdaExecutionRoleArn
    VpcConfig: !GetAtt ServerlessAccessManager.VpcConfig
    CodeUri: src/
    Handler: app.lambda_handler
    Runtime: python3.13
    MemorySize: 2048
    Timeout: 900
    Tracing: Active
    Environment:
      Variables:
        Env: !Ref Environment
    Layers:
      - !Ref SupernovaLayerVersion  # Supernova layer first if used
      - !Ref DeCommonLayer           # Common layer second
    Tags:
      application: '<service-name>'
      created_by: cloudformation
      owner: 'de'
      team: !Ref TeamName
```

## Image-based

```yaml
MyServiceFunction:
  Type: AWS::Serverless::Function
  Properties:
    FunctionName: !GetAtt ServerlessAccessManager.FunctionName
    Role: !GetAtt ServerlessAccessManager.LambdaExecutionRoleArn
    VpcConfig: !GetAtt ServerlessAccessManager.VpcConfig
    PackageType: Image
    ImageUri: !Sub "334512769709.dkr.ecr.eu-west-1.amazonaws.com/data-de/<service>/${Environment}:${ImageTag}"
    Architectures: [x86_64]
    MemorySize: 2048
    Timeout: 900
    Tracing: Active
    Environment:
      Variables:
        Env: !Ref Environment
    Tags:
      application: '<service-name>'
      created_by: cloudformation
      owner: 'de'
      team: !Ref TeamName
```

Notes:
- ECR account `334512769709` is the deploy account. Always use this in ECR URIs.
- ECR repo pattern: `data-de/<service>/${Environment}:<ImageTag>`
- Zip functions require `CodeUri`, `Handler`, and `Runtime`. Image functions must not have these.

## Key property rules

| Property | Rule |
|---|---|
| `FunctionName` | Use `!GetAtt ServerlessAccessManager.FunctionName` — do NOT repeat the `!Sub` string |
| `Role` | Always `!GetAtt ServerlessAccessManager.LambdaExecutionRoleArn` (new templates) |
| `VpcConfig` | Only include when `VpcExecution: 'true'` on access manager |
| `Handler` | `app.lambda_handler` is the standard entrypoint; use `<module>.lambda_handler` for multi-module services |
| `Runtime` | `python3.13` default for new code |
| `Layers` | Supernova layer first, common layer second, service-specific layers after |
| `EphemeralStorage` | Omit unless writing large temp files; use `Size: 10240` if needed |
| `Tracing` | `Active` (AWS best practice) |

## SSM resolve syntax in env vars

When an env var value comes from SSM at deploy time (not runtime lookup), use:

```yaml
SomeVar: !Sub '{{resolve:ssm:${SSMParamName}}}'
```

Where `SSMParamName` is a CloudFormation parameter holding the SSM path.

## Logical ID naming convention

`<ServiceName>Function` in PascalCase. Examples from the corpus:
- `APIIngestionLambdaFunction`
- `MetricsPublisherV2Function`
- `RtEDataMoverGuardCheckFunction`
- `OpenAICostExporterFunction`
