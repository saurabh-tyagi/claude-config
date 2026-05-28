# Plan — Untrack `.claude/` from git and push to MR

## Context

In the previous turn I committed `.claude/settings.json` (commit `2f1abf3`)
to the `DATA_4716_audit_log_api` branch as part of setting up a project-scoped
PostToolUse hook that injects the AGENTS.md type-checking rule when
`reportAny` / `reportExplicitAny` appears in Bash output.

The user has decided this file should not be tracked in the project repo.
`git ls-files .claude/` confirms only `.claude/settings.json` is currently
tracked under `.claude/`. The user wants the file untracked (kept on disk
so the hook remains active locally) and the change committed and pushed to
the MR.

## Steps

1. `git rm --cached .claude/settings.json` — untrack the file without
   deleting it from disk. The PostToolUse hook continues to fire locally.

2. Add `.claude/` to `.gitignore` so future files under `.claude/` (e.g.
   `settings.local.json`, agent caches) are never accidentally tracked.
   Place the entry near the existing tooling/IDE sections.

3. Stage `.gitignore`, create a new commit, push.

   Commit message (per `commit-message` skill, branch `DATA_4716_audit_log_api`):
   ```
   DATA-4716: Untrack .claude/ project settings
   ```

4. Push to `origin DATA_4716_audit_log_api` (no force).

## Critical files

- `.claude/settings.json` — untracked via `git rm --cached`, kept on disk
- `.gitignore` — add `.claude/` entry

## Verification

1. `git ls-files .claude/` returns empty.
2. `ls .claude/settings.json` still shows the file on disk.
3. `git status` shows the file as ignored (not untracked).
4. `git log -1 --stat` shows the deletion in the new commit.
5. `glab mr view` shows the new commit on the MR.
