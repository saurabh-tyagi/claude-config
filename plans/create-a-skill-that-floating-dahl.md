# Plan: `sam-template` skill for SAM `template.yaml` authoring

## Context

The user authors AWS SAM `template.yaml` files for ~30 Lambda services in `/Users/saurabhtyagi/ws/dns-de-automation/lambda`. The repo's templates have drifted over years — runtimes range from `python3.8` to `python3.13`, naming prefixes mix `dns-de-` and `data-de-`, and a handful of templates use older role-attachment styles. The user does NOT want the skill to blindly follow whatever exists in the repo. Instead, the skill should:

1. Use **only templates modified in the last 6 months** (since 2025-11-21, given today is 2026-05-21) as the style reference, since those reflect current house style.
2. Cross-check those patterns against AWS SAM official documentation and use **official best practices as the fallback** when recent templates are silent or inconsistent.
3. When editing an existing template, mirror that template's style but flag deviations from the 6-month baseline + AWS best practices so the user can choose to upgrade.

The skill must also integrate correctly with `Custom::ServerlessAccessManager` from `/Users/saurabhtyagi/ws/serverless-access-manager`, which all current templates use.

## In-scope reference templates (last 6 months)

These 7 templates form the canonical style corpus. The skill must read them all and base style guidance on them — not on the older 25 templates.

| Last touched | Path |
|---|---|
| 2026-04-09 | `lambda/ingest-api/template.yaml` |
| 2026-04-02 | `lambda/personal-data-catalog/template.yaml` |
| 2026-03-26 | `lambda/metrics-publisher-v2/template.yaml` |
| 2026-03-26 | `lambda/realtime-product-recommendations-api/template.yaml` |
| 2026-02-16 | `lambda/rte-datamover-guard-checks/template.yaml` |
| 2026-01-15 | `lambda/openai-cost-exporter/template.yaml` |
| 2025-12-08 | `lambda/datamover-event-generator/template.yaml` |

The "current" cutoff is computed at skill build time. The skill itself does not re-scan repos at runtime — patterns extracted from these 7 are baked into reference files and into memory.

## Skill structure

Create the skill at `/Users/saurabhtyagi/.claude/skills/sam-template/`:

```
sam-template/
  SKILL.md                  # entry point with frontmatter + decision flow
  reference/
    skeleton.md             # canonical skeleton (Parameters, Transform, Description) drawn from the 7 recent templates, validated against AWS SAM docs
    access-manager.md       # how to wire Custom::ServerlessAccessManager (consumer-side)
    sources-targets.md      # cheatsheet: supported Source/Target Types + required Properties (from serverless-access-manager README)
    function-resource.md    # AWS::Serverless::Function: FunctionName, Role, VpcConfig, Layers, PackageType
    iam-extensions.md       # extra AWS::IAM::Policy / AWS::IAM::RolePolicy attached to access-manager role
    events-and-triggers.md  # AWS::Lambda::Permission for S3/EventBridge; SAM-native Events block
    tags-and-outputs.md     # tag keys observed in recent templates; Outputs convention
    best-practices.md       # AWS SAM official best practices the skill enforces when recent templates are silent (e.g. explicit log retention, function tracing, IAM least-privilege)
    recent-examples.md      # short pointers + 1-line summary per the 7 in-scope templates
```

Each reference file is short (≤80 lines) and quotes verbatim YAML.

## SKILL.md (frontmatter + body)

Frontmatter:
```
name: sam-template
description: Use whenever an AWS SAM template.yaml is being created or modified in the dns-de-automation lambda style, or any SAM template that integrates with serverless-access-manager. Trigger on direct requests ("add a new lambda", "update template.yaml", "add an SQS target to the access manager"), AND proactively whenever Claude is implementing code changes that end up adding or modifying a SAM template.yaml as a side-effect (for example: adding a new Lambda env var, wiring a new event source, adding an IAM permission, introducing a new SAM resource). If the implementation touches template.yaml at all, invoke this skill before writing the change.
team: de
```

The description deliberately covers two trigger modes:
- **Explicit**: user asks to author or edit a SAM template.
- **Implicit / side-effect**: user asks for a code or feature change and Claude's implementation plan involves editing `template.yaml` (e.g. "add a new env var to the function", "give the lambda permission to read from this bucket", "schedule the lambda every hour"). In that case Claude must invoke the skill before touching `template.yaml`, even though the user did not explicitly mention SAM.

Body sections (in order):

1. **Decide: new template vs edit existing.** Detect by checking whether `template.yaml` already exists in the target directory.
2. **If editing existing:**
   - Read the full existing template first.
   - Mirror its style on: FunctionName prefix (`dns-de-` vs `data-de-`), Runtime version, Role-attachment style (`!GetAtt ServerlessAccessManager.LambdaExecutionRoleArn` vs `!Ref LambdaRole`), tag key set, PackageType (Zip vs Image), `VpcExecution` value.
   - If the existing template diverges from the 6-month baseline (e.g. `python3.8`, missing tags, inline `Policies:` block), **flag the deviation explicitly** with a one-line note pointing to the recent baseline and AWS docs, and ask whether to upgrade. Do not silently rewrite.
3. **If creating new:** use the canonical skeleton from `reference/skeleton.md`. Defaults derived from the 7 recent templates, falling back to AWS SAM best practices where the corpus is silent or split:
   - `Runtime: python3.13` (most common in recent corpus)
   - `Timeout: 900`, `MemorySize: 2048` unless workload is API-shaped (then `Timeout: 30`, `MemorySize: 1024`)
   - `Tracing: Active` (AWS best practice; corpus is silent — fall back to docs)
   - FunctionName: `data-de-<service>-${Environment}` (recent templates favour `data-de-` prefix)
   - `Role: !GetAtt ServerlessAccessManager.LambdaExecutionRoleArn`
   - `VpcExecution: 'true'` on the access manager
   - Explicit `AWS::Logs::LogGroup` with `RetentionInDays` (AWS best practice; corpus is silent — fall back to docs and propose 30 or 90 days)
   - Ask the user before deviating from these.
4. **Wire ServerlessAccessManager** per `reference/access-manager.md`: ServiceToken always `!Sub 'arn:aws:lambda:eu-west-1:${AWS::AccountId}:function:paas-serverless-access-manager'`. Use `Sources` for read-only inputs, `Targets` for read/write outputs. Validate every entry against the supported list in `reference/sources-targets.md`.
5. **IAM extensions**: never use SAM `Policies:` templates inline. For permissions the access manager does not model, attach a separate `AWS::IAM::Policy` with `Roles: [!GetAtt ServerlessAccessManager.LambdaExecutionRoleName]`. Style observed in `lambda/ingest-api/template.yaml` and `lambda/personal-data-catalog/template.yaml`.
6. **Event triggers**: prefer `AWS::Lambda::Permission` resources for S3 / EventBridge / SNS rule wiring. SAM-native `Events:` block is acceptable when AWS docs recommend it (SQS, SNS direct subscription, scheduled events).
7. **Outputs**: emit `<FunctionLogicalId>FunctionARN` with `!GetAtt <FunctionLogicalId>.Arn`. No `Export:` (matches recent corpus).
8. **Anti-patterns** to refuse and explain:
   - Inline `Policies:` with SAM policy templates.
   - `Globals:` block (not used in this repo).
   - Hard-coded VPC subnets/security groups.
   - Missing `Environment` parameter.
   - Region pinning to anything other than `eu-west-1`.
   - Silently rewriting an existing template's runtime, prefix, or role style during an edit.

## Memory writes (first invocation)

On the first time the skill runs in a conversation, write these memory files via Write tool to `/Users/saurabhtyagi/.claude/projects/-Users-saurabhtyagi--claude/memory/`. The skill reads `MEMORY.md` first to avoid duplicates.

- `project_dns_de_sam_conventions.md` (type: project) — concrete patterns extracted from the 7 recent templates: `data-de-<service>-${Environment}` naming, `python3.13` default, `Custom::ServerlessAccessManager` universal, no `Globals` block, region pinned to `eu-west-1`. Cite the 7 source files and the 2025-11-21 cutoff used to derive them. Include a "stale by 2026-11-21" note so future-you re-derives.
- `reference_serverless_access_manager.md` (type: reference) — README at `/Users/saurabhtyagi/ws/serverless-access-manager/README.md`; ServiceToken pattern; supported Source/Target Types; consumer-side integration is in-template only (except cross-account Kinesis which needs a separate MR to the `infrastructure` repo).
- `feedback_sam_skill_style_rule.md` (type: feedback) — Use only templates modified in the last 6 months as the style reference; cross-check against AWS SAM official docs; do not blindly follow older templates. **Why:** user explicitly asked for this 2026-05-21. **How to apply:** every time the `sam-template` skill runs.

Each entry is also added to `MEMORY.md` index as a one-line pointer.

## Verification

1. **Skill discovery**: in a new session, type "create a SAM template for a new lambda" and confirm Claude proposes invoking `sam-template`.
2. **Recency boundary**: ask the skill to "list which templates you used as references". Confirm it names exactly the 7 in the table above and not the older ones.
3. **New-template golden path**: ask the skill to scaffold a template for a hypothetical service. Diff against `lambda/openai-cost-exporter/template.yaml` (a recent reference) — Parameters, ServiceToken, Role attachment, Outputs should align. Tracing/LogGroup should appear (AWS-best-practice fallbacks).
4. **Edit-existing golden path**: point the skill at `lambda/braze-batcher/template.yaml` (older, uses `LambdaRole` parameter style) and ask it to add a new SSM Source. Confirm the skill keeps the `LambdaRole` style, adds the source, AND flags that the template diverges from the recent baseline (inviting an upgrade).
5. **Runtime mirror**: open a `python3.8` template and ask the skill to add an env var. Confirm runtime is left untouched but a one-line "current baseline is python3.13" note appears.
6. **Memory writes**: confirm the three memory files appear and are indexed in `MEMORY.md` after first invocation. Re-invoke in a new session and confirm no duplicates are written.
7. **AWS-doc fallback**: scaffold a new template and confirm `Tracing: Active` and an explicit `AWS::Logs::LogGroup` with `RetentionInDays` are present, since the recent corpus does not specify them.
8. **Anti-pattern guard**: ask the skill to "add `S3CrudPolicy` to the lambda's Policies block" — confirm it refuses and proposes adding an S3 Target on the access manager instead.
9. **Implicit-trigger path**: in a new session, ask "give the file-ingestion-framework lambda permission to read from a new bucket `hbi-dns-foo`" without mentioning SAM or `template.yaml`. Confirm Claude recognises that fulfilling the request requires editing `template.yaml`, invokes the `sam-template` skill, and applies the access-manager Source/Target pattern instead of inlining `S3ReadPolicy`.
