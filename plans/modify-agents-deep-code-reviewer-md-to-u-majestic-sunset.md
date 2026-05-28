# Plan: Add serverless-access-manager guidelines to deep-code-reviewer agent

## Context

The `deep-code-reviewer` agent currently reviews AWS SAM templates with generic IaC checks (formatting, type precision, paradigm adherence). It has no awareness of the internal `serverless-access-manager` Lambda-backed custom resource (`Custom::ServerlessAccessManager`), which is the team's standard pattern for managing Lambda execution roles, VPC security groups, and Datadog log forwarding via a single custom resource.

As a result, the agent does not flag SAM templates that:
- Manually define IAM execution roles when `serverless-access-manager` should manage them
- Use wrong `Type` values in `Sources`/`Targets` (e.g. `Eventbridge` instead of `EventBridge`)
- Violate stack-tag rules (must be lowercase) enforced by the custom resource
- Misuse SSM allowed-path prefixes or Transcribe wildcard prefixes
- Skip the cross-account wiring required for cross-account Kinesis sources

This change adds a dedicated SAM subsection to Phase 3 of the agent's review process and points it at the canonical README for full reference.

## Approach

Edit the single file `/Users/saurabhtyagi/.claude/agents/deep-code-reviewer.md` — append a new subsection **3l. AWS SAM: serverless-access-manager Custom Resource** under Phase 3 (Deep Analysis), placed after `3k. Paradigm Adherence and Extensibility` and before the `Phase 4` heading.

No other sections of the agent definition need to change. The supported-language list already includes AWS SAM, so no scope edits are needed. The existing Phase 4 reporting format will absorb the new findings unchanged.

## Content to add

A new subsection covering:

1. **When to recommend `serverless-access-manager`**: SAM templates with Lambda functions that manually create execution roles, security groups, or wire Datadog log forwarding for permissions/services that map to the supported source/target list.

2. **Required-property and reference-pattern checks**:
   - `FunctionName` must be set on the custom resource.
   - Lambda `Role` should use `!GetAtt ServerlessAccessManager.LambdaExecutionRoleArn`.
   - Lambda `VpcConfig` should use `!GetAtt ServerlessAccessManager.VpcConfig` when VPC execution is needed.
   - Lambda `FunctionName` should reuse `!GetAtt ServerlessAccessManager.FunctionName` for deduplication.

3. **`Type` value validation against the supported set** (case-sensitive):
   - Sources: `Connect`, `DynamoDB`, `ElasticSearch`, `Kinesis`, `Lex`, `MSK`, `S3`, `SNS`, `SQS`, `SSM`, `Transcribe`.
   - Targets: `Connect`, `DynamoDB`, `ElasticSearch`, `EventBridge`, `LambdaFunctionUrl`, `MSK`, `S3`, `SNS`, `SQS`, `Transcribe`.
   - Flag mis-cased values like `Eventbridge` as **High** severity.

4. **Stack-tag rule**: required tags must be present; all keys and values must be lowercase. Flag violations as **High** — they cause the custom resource to raise `InvalidInput` at deploy time.

5. **SSM source `Parameters`**: only the prefixes `/corp-sys/`, `/sc-spange/`, `/dns/`, `/datascience/` are supported. Flag other prefixes as **High**.

6. **Transcribe specifics**:
   - `input_prefix` / `output_prefix` should use wildcards that match real S3 path layout.
   - `output_prefix` must grant write access to the whole output folder (Transcribe writes `.write_access_check_file.temp`); flag patterns that scope only to `*.json`.
   - VPC-bound Lambdas need NAT or Transcribe PrivateLink — flag silent-timeout risk when neither is present.

7. **Cross-account Kinesis source**: full ARN required in `Stream` property; a separate `AWS::Lambda::Permission` resource is required to grant `kinesis.amazonaws.com` invoke rights with `SourceAccount` and `SourceArn`; trust on the stream's resource policy in the infra repo is required (flag as **Info** since it lives outside the SAM template).

8. **`VpcExecution: true`**: redundant when any Source/Target implicitly forces VPC (ElasticSearch, MSK targets). Flag as **Medium**.

9. **`DatadogLogging: "false"`**: flag when the disabling appears unintentional (no comment, no obvious justification). **Medium**.

10. **No conflicting inline IAM**: if `serverless-access-manager` is in the template, flag any inline policies attached to the same Lambda role as **High** — they conflict with the custom resource's role management.

11. **Reference**: point the agent at `/Users/saurabhtyagi/ws/serverless-access-manager/README.md` as the source of truth, and instruct it to re-read that file for the latest source/target list before producing review output (it can drift over time).

## Critical files to modify

- `/Users/saurabhtyagi/.claude/agents/deep-code-reviewer.md` — append subsection 3l after the existing 3k subsection (around the boundary before `## Phase 4: Structured Issue Reporting`).

## Verification

1. Open `/Users/saurabhtyagi/.claude/agents/deep-code-reviewer.md` and confirm the new 3l section is present and the existing structure (3a–3k, Phase 4, Phase 5, Behavioral Guidelines, Persistent Agent Memory) is untouched.
2. Spot-check a SAM template that uses `Custom::ServerlessAccessManager` by asking the agent to review it; verify it cites the new 3l rules (e.g. flags lowercase-tag violations, validates `Type` casing, points at the README).
3. Spot-check a SAM template that *should* use `serverless-access-manager` but does not (manually-defined IAM role with DynamoDB/MSK permissions); verify the agent recommends switching to the custom resource pattern.
