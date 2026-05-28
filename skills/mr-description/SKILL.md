---
name: mr-description
description: Writes merge request message description when raising a GitLab Merge Request. Use when creating a merge request or when user asks to summarise changes for a merge request.
team: de
---

When writing a MR description -

1. Run `git log origin/main..HEAD --oneline` to get the commits and `git diff origin/main..HEAD` to get the full diff.
2. Derive the Jira key from the branch name (format: `<JIRA-KEY>_<short-name>`). If no Jira key is present, omit it.
3. Write a description following this format:

## What
Few sentences explaining what changes have been made. Highlight key files changed. Keep this concise and prioritise comments for reviewer benefit.

## Why
Brief context of why this change is needed — the motivation, ticket, or problem being solved.

## Changes
1. Bullet points of specific changes made
2. Group related changes together
3. Mention any files that were deleted or renamed
4. New test cases added

Do not append any additional signature to the MR description.
