# Enable 1M context window for Bedrock Sonnet/Opus

## Context
`~/.claude/settings.json` had a `_todo_1m_context` note to enable the 1M
context window via the `context-1m-2025-08-07` beta header. Goal: activate
it for Sonnet 4.6 and Opus 4.7 on Bedrock so long-context sessions don't
get truncated at the default 200k limit.

## Approach
Claude Code forwards the `ANTHROPIC_CUSTOM_HEADERS` env var as raw HTTP
headers to the model provider (Bedrock in this case). Setting it once at
the top level applies to every request, regardless of which model is
active, so a single env entry covers both Sonnet and Opus.

## Change
In `/Users/saurabhtyagi/.claude/settings.json`:
- Remove the `_todo_1m_context` reminder key.
- Add to `env`:
  ```json
  "ANTHROPIC_CUSTOM_HEADERS": "anthropic-beta: context-1m-2025-08-07"
  ```

## Caveat worth confirming
The 1M context beta is documented as supported on **Claude Sonnet 4 / 4.5
/ 4.6**. I am not aware of public confirmation that **Opus 4.7** on
Bedrock honors `context-1m-2025-08-07` — Opus may either ignore the
header (harmless) or reject the request (breaks Opus calls). Two options:

1. **Global header (current edit)** — simplest; revert if Opus errors.
2. **Sonnet-only** — would require a per-model header mechanism, which
   Claude Code's settings.json doesn't expose today, so this isn't
   straightforward without a wrapper script.

Recommendation: ship the global header, then test an Opus call. If
Bedrock rejects it, fall back to running Opus without the beta (e.g.
unset the env var when invoking Opus, or drop the header entirely).

## Verification
1. `claude --version` then start a session; run `/model sonnet`, paste
   ~250k tokens of context, confirm no truncation error.
2. `/model opus`, send a short prompt; confirm the request succeeds (no
   `ValidationException` from Bedrock about the beta header).
3. If Opus fails, remove the env var and reopen this plan.
