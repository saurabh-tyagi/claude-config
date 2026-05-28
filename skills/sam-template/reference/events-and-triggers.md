# Events and Trigger Wiring

## EventBridge rule → Lambda

The EventBridge rule is created separately (in the calling pipeline or infrastructure repo). The template only grants the rule permission to invoke the function:

```yaml
EventBridgeInvokePermission:
  Type: AWS::Lambda::Permission
  Properties:
    Action: lambda:InvokeFunction
    FunctionName: !GetAtt MyServiceFunction.Arn
    Principal: events.amazonaws.com
    SourceArn: !Sub 'arn:aws:events:eu-west-1:${AWS::AccountId}:rule/my-rule-name'
```

Also declare `EventBridge` as a `Target` on `ServerlessAccessManager` so the function can put events to the bus:

```yaml
Targets:
  Supernova:
    Type: EventBridge
    Properties:
      Bus: !Ref EventBus
```

## S3 event → Lambda

One `AWS::Lambda::Permission` per bucket:

```yaml
S3InvokePermissionDev:
  Type: AWS::Lambda::Permission
  Properties:
    Action: lambda:InvokeFunction
    FunctionName: !GetAtt MyServiceFunction.Arn
    Principal: s3.amazonaws.com
    SourceAccount: !Ref AWS::AccountId
    SourceArn: !Sub 'arn:aws:s3:::hbi-dns-dev-landing'

S3InvokePermissionProd:
  Type: AWS::Lambda::Permission
  Properties:
    Action: lambda:InvokeFunction
    FunctionName: !GetAtt MyServiceFunction.Arn
    Principal: s3.amazonaws.com
    SourceAccount: !Ref AWS::AccountId
    SourceArn: !Sub 'arn:aws:s3:::hbi-dns-landing'
```

The S3 bucket notification configuration (which files trigger the function) is configured separately, outside the template.

## ALB → Lambda

```yaml
AlbInvokePermission:
  Type: AWS::Lambda::Permission
  DependsOn: MyAlias
  Properties:
    Action: lambda:InvokeFunction
    FunctionName: !Ref MyAlias
    Principal: elasticloadbalancing.amazonaws.com
```

## SQS trigger (SAM Events block)

For SQS triggers, use SAM-native `Events:` on the function. Also declare the queue as a `Source` on the access manager:

```yaml
# On ServerlessAccessManager:
Sources:
  MySQSQueue:
    Type: SQS
    Properties:
      Queue: my-queue-name

# On the Function:
Events:
  SQSTrigger:
    Type: SQS
    Properties:
      Queue: !Sub 'arn:aws:sqs:eu-west-1:${AWS::AccountId}:my-queue-name'
      BatchSize: 10
      FunctionResponseTypes:
        - ReportBatchItemFailures
```

## SNS subscription (SAM Events block)

```yaml
Events:
  SNSTopicTrigger:
    Type: SNS
    Properties:
      Topic: !Ref SNSTopicARN
```

## Scheduled rule (SAM Events block)

```yaml
Events:
  ScheduledTrigger:
    Type: Schedule
    Properties:
      Schedule: rate(1 hour)
      Enabled: true
```

## MSK (Kafka) trigger

Declare the topic as a `Source` on the access manager. The event source mapping is created automatically:

```yaml
Sources:
  KafkaTopic:
    Type: MSK
    Properties:
      Topics:
        - my-kafka-topic
```

No separate `AWS::Lambda::EventSourceMapping` or `Events:` block is needed — access manager handles it.

## Decision guide

| Event source | Mechanism |
|---|---|
| EventBridge rule | `AWS::Lambda::Permission` + `Targets.EventBridge` |
| S3 event | `AWS::Lambda::Permission` per bucket + `Sources.S3` (for read access) |
| ALB | `AWS::Lambda::Permission` + `AWS::ElasticLoadBalancingV2::*` resources |
| SQS | `Sources.SQS` on access manager + SAM `Events.Type: SQS` |
| SNS | SAM `Events.Type: SNS` |
| MSK | `Sources.MSK` on access manager (handles ESM automatically) |
| Schedule | SAM `Events.Type: Schedule` |
| CloudWatch Alarm | `AWS::Lambda::Permission` with `Principal: lambda.alarms.cloudwatch.amazonaws.com` |
