---
name: commit-message
description: Generate concise git commit messages for Data Engineering changes. Use PROACTIVELY when the user asks to commit files, create a commit, or generate a git commit message.
team: de
---

## Context

Data Engineering changes typically touch ingestion pipelines, Airflow DAGs, AWS infrastructure, and source integrations. Commit messages should describe the user-visible intent and impact, not just restate low-level diff details.

## Instructions

1. Run `git diff origin/main..HEAD` to get the diff of the local branch against its remote base.
2. Derive the Jira key from the branch name when it matches `<JIRA-KEY>_<short-name>`.
   If the branch name does not include a Jira key, ask the user for one before generating the final message.
3. Write a one-line commit message in this format:

   ```text
   <JIRA-KEY>: <Imperative subject line>
   ```

4. Follow these rules:
   - Start the subject line with a capital letter.
   - Use imperative mood (command wording), not past tense or present participle.
   - Do not add a trailing period.
   - Do not add signatures or extra metadata.
   - Summarize intent and impact; do not just restate diff details.

## Examples

### Good

- `DA-1234: Fix use of deprecated method`
- `DA-5634: Add RtE cleaner component`

### Bad

- `DA-5634: Adding RtE cleaner component`  
  Reason: uses present participle instead of imperative mood.
- `Edit Common.scala to use method2 instead of method1 - DA-1234`  
  Reason: missing Jira key prefix format.
- `DA-1234: fix use of deprecated method`  
  Reason: subject line should start with a capital letter.
- `DA-1234: Fixed use of deprecated method`  
  Reason: uses past tense instead of imperative mood.
- `DA-5634: RtE cleaner component`  
  Reason: noun phrase instead of action.
- `DA-4634: Increase CPU request from 2 to 3`  
  Reason: too low-level and diff-like; prefer higher-level intent.
- `DA-6093: Add api-ingest tests to the CI pipeline.`  
  Reason: trailing period is not allowed.
