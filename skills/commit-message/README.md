# commit-message

Generate concise git commit messages for Data Engineering changes.

## When to use

Use this skill when committing changes to DE repositories — ingestion pipelines, Airflow DAGs, AWS infrastructure, source integrations, or services built on Redshift exports.

## What it does

1. Diffs the local branch against its remote base.
2. Derives the Jira key from the branch name (format: `<JIRA-KEY>_<short-name>`), or asks for one if absent.
3. Produces a single-line commit message: `<JIRA-KEY>: <Imperative subject line>`.

## Installing

**User-level** (available in all projects):
```bash
cp -r . ~/.claude/skills/commit-message
```

**Project-level** (available in one project):
```bash
cp SKILL.md /path/to/project/.claude/commands/commit-message.md
```
