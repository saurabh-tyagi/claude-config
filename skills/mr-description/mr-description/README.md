# mr-description

Write a structured GitLab merge request description from the current branch diff.

## When to use

Use this skill when raising a merge request in a DE repository — ingestion pipelines, Airflow DAGs, AWS infrastructure, source integrations, or services built on Redshift exports.

## What it does

1. Diffs the local branch against `origin/main`.
2. Derives the Jira key from the branch name (format: `<JIRA-KEY>_<short-name>`), if present.
3. Produces a structured MR description with three sections:
   - **What** — summary of what changed and key files affected.
   - **Why** — motivation, ticket reference, or problem being solved.
   - **Changes** — itemised list of specific changes, grouped by concern.

## Installing

**User-level** (available in all projects):
```bash
cp -r . ~/.claude/skills/mr-description
```

**Project-level** (available in one project):
```bash
cp SKILL.md /path/to/project/.claude/commands/mr-description.md
```
