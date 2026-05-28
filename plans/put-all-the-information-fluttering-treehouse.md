# Plan: Optimise `~/.claude/settings.json`

## Context
The current `/Users/saurabhtyagi/.claude/settings.json` has accumulated redundant permission entries, identity-only model aliases, and empty attribution fields. The user wants a tidied config that keeps `opusplan` as the default model and leaves a clear TODO for enabling the 1M-context window (which requires a Bedrock beta header — to be wired up in a separate turn once the exact header/profile is confirmed).

## Goals
1. Keep `model: "opusplan"` (already set — verify it stays).
2. Document a TODO for 1M-context enablement (Bedrock beta header `anthropic-beta: context-1m-2025-08-07` via `ANTHROPIC_CUSTOM_HEADERS`) — do **not** enable in this change.
3. Drop redundant bare-command permissions where a `:*` wildcard already covers them.
4. Drop identity model aliases (`opus → opus`, `sonnet → sonnet`, `haiku → haiku`).
5. Drop empty `attribution` block.
6. Tighten `Bash(sed:*)` to non-mutating forms only (currently permits `sed -i` in-place edits).

## Critical file
- `/Users/saurabhtyagi/.claude/settings.json`

## Concrete edits

### Remove (12 redundant bare-command entries — `:*` wildcard supersedes each)
- `Bash(git status)`
- `Bash(git diff)`
- `Bash(make test)`
- `Bash(make lint)`
- `Bash(make validate)`
- `Bash(make check)`

### Remove (identity aliases under `model_aliases`)
- `"opus": "opus"`
- `"sonnet": "sonnet"`
- `"haiku": "haiku"`

Keep meaningful aliases: `plan → opusplan`, `review → opus`, `heavy → opus`, `fast → sonnet`.

### Remove (empty fields)
- Entire `attribution` object (`commit: ""`, `pr: ""`).

### Tighten sed
Replace `Bash(sed:*)` with explicit non-mutating invocation prefixes. Since the harness matches by literal command prefix, the safest swap is to **deny in-place edits** alongside the existing allow:
- Keep `Bash(sed:*)` in `allow`.
- Add `Bash(sed -i:*)` and `Bash(sed -i *)` to `deny` so write-in-place forms are blocked while pipe/stream uses still work.

(Alternative considered: remove `sed` entirely and rely on Edit/Write — rejected because read-only `sed` is genuinely useful for stream filtering.)

### Add 1M-context TODO (top-level comment is not valid JSON, so use a no-op key)
Add this key at top level so the intent is visible in-file:
```json
"_todo_1m_context": "To enable 1M context on Bedrock Sonnet 4.6, add env ANTHROPIC_CUSTOM_HEADERS='anthropic-beta: context-1m-2025-08-07'. Confirm header name/profile before enabling."
```
(Claude Code ignores unknown top-level keys; schema will warn but not break.)

## Final shape (illustrative — not the full file)
```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "_todo_1m_context": "...see above...",
  "awsAuthRefresh": "aws sso login --profile claude-bedrock",
  "env": { ...unchanged... },
  "model": "opusplan",
  "effortLevel": "high",
  "theme": "auto",
  "model_aliases": {
    "plan": "opusplan",
    "review": "opus",
    "heavy": "opus",
    "fast": "sonnet"
  },
  "model_options": { ...unchanged... },
  "permissions": {
    "allow": [ ...with bare git/make duplicates removed... ],
    "deny": [ ...existing... , "Bash(sed -i:*)", "Bash(sed -i *)" ]
  },
  "statusLine": { ...unchanged... }
}
```

## Verification
1. `jq . /Users/saurabhtyagi/.claude/settings.json` — confirms valid JSON.
2. Reload Claude Code; statusline should still show model `opusplan` and `effort high`.
3. Run a benign `git status` and `make test --version` (or similar) and confirm no permission prompt appears (proves wildcards still cover).
4. Attempt `sed -i 's/x/y/' /tmp/foo` via Bash — should be blocked by deny rule.
5. Attempt `echo a | sed 's/a/b/'` — should still be allowed.
6. Reference `/model plan`, `/model fast` — aliases still resolve.

## Out of scope (future turns)
- Actually enabling the 1M-context beta header once the exact env-var precedence on Bedrock is confirmed.
- Auditing other deny patterns (e.g. `cp`, `mv`) for symmetric tightening.
