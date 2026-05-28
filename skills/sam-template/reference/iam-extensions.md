# IAM Extensions

When `Custom::ServerlessAccessManager` Sources/Targets do not cover a required permission, attach a separate IAM policy to the role it creates.

**Never use SAM inline `Policies:` templates.** They are not used anywhere in this repo.

## AWS::IAM::Policy (preferred style)

Used in `ingest-api/template.yaml` and `personal-data-catalog/template.yaml`:

```yaml
SecretsSSMPermsPolicy:
  Type: AWS::IAM::Policy
  Properties:
    PolicyName: <descriptive-hyphenated-name>
    PolicyDocument:
      Version: "2012-10-17"
      Statement:
        - Effect: Allow
          Action:
            - 'secretsmanager:DescribeSecret'
            - 'secretsmanager:GetSecretValue'
          Resource:
            - !Ref MySecret
        - Effect: Allow
          Action: 'ssm:GetParameter'
          Resource: !Sub 'arn:aws:ssm:${AWS::Region}:${AWS::AccountId}:parameter/dns/my-service/*'
    Roles:
      - !GetAtt ServerlessAccessManager.LambdaExecutionRoleName
```

## AWS::IAM::RolePolicy (alternative, seen in older templates)

```yaml
ExtraPolicy:
  Type: AWS::IAM::RolePolicy
  Properties:
    PolicyName: <descriptive-name>
    PolicyDocument:
      Version: "2012-10-17"
      Statement:
        - Effect: Allow
          Action: 'some:Action'
          Resource: '*'
    RoleName: !GetAtt ServerlessAccessManager.LambdaExecutionRoleName
```

Both styles work. `AWS::IAM::Policy` is preferred (matches the two most recent examples).

## When to use IAM extensions

Use a separate policy attachment when you need:

- **Secrets Manager** access (not modelled by access manager)
- **SSM parameters outside the allowed path prefixes** (`/corp-sys/`, `/sc-spange/`, `/dns/`, `/datascience/`)
- **SSM PutParameter** (access manager only grants GetParameter)
- **Cross-account role assumption** (`sts:AssumeRole`)
- **Any AWS API** not covered by the Sources/Targets types

## IAM least-privilege rules (AWS best practice)

- Scope `Resource` to specific ARNs where possible. Use wildcards only when the full set cannot be enumerated at deploy time.
- Use `${AWS::Region}` and `${AWS::AccountId}` pseudo-parameters in ARNs — never hard-code account IDs in policy documents.
- Prefer specific actions over broad wildcards (`secretsmanager:GetSecretValue` not `secretsmanager:*`).
