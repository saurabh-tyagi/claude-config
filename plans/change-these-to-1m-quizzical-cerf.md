# Enable 1M context window for Opus 4.7 and Sonnet 4.6

## Context

Anthropic / Bedrock support a 1M-token context window for `claude-opus-4-7`, `claude-opus-4-6`, and `claude-sonnet-4-6`. The user is currently running these models on Bedrock at the default 200k context. They want to switch both Opus and Sonnet to 1M and update the statusline so the context progress bar reflects the new ceiling.

Per the Claude Code docs (`code.claude.com/docs/en/amazon-bedrock.md`, `code.claude.com/docs/en/model-config.md`), the correct mechanism on Bedrock is to append a `[1m]` suffix to the model ID in the `ANTHROPIC_DEFAULT_*_MODEL` env vars. Claude Code strips the suffix before sending the request to Bedrock and handles the underlying beta routing internally — no `ANTHROPIC_BETAS`, no `ANTHROPIC_CUSTOM_HEADERS`, no `max_tokens` change required. Note: `opusplan` does not auto-upgrade the plan-mode Opus phase to 1M unless `ANTHROPIC_DEFAULT_OPUS_MODEL` is pinned with `[1m]` — and the user has confirmed they want it pinned.

## Changes

### 1. `/Users/saurabhtyagi/.claude/settings.json` (lines 8–9)

Append `[1m]` to the Opus and Sonnet model IDs. Leave Haiku alone (1M is not offered for Haiku 4.5).

```json
"ANTHROPIC_DEFAULT_OPUS_MODEL": "eu.anthropic.claude-opus-4-7[1m]",
"ANTHROPIC_DEFAULT_SONNET_MODEL": "eu.anthropic.claude-sonnet-4-6[1m]",
```

No other keys in `settings.json` need to change. `model_options.max_tokens` (128000) stays as-is — it caps output tokens, not context.

### 2. `/Users/saurabhtyagi/cc-statusline/config/config.json` (`limits.context`)

Change `limits.context` from `200` to `1000`. The statusline reads this as the context ceiling in thousands of tokens (see `statusline.sh:163` and `statusline.sh:685–693`, where it is passed to `calculate_three_layer_metrics` against `CONTEXT_TOKENS` derived from the transcript). With the current value of 200, the bar would saturate at 20% real usage once 1M is enabled.

The `context_layer.layer{1,2,3}.threshold_multiplier` values can stay at their current defaults — they are multipliers against `CONTEXT_LIMIT`, so they scale automatically.

No statusline shell-script changes are needed. The model-name parser at `statusline.sh:412–422` will render `eu.anthropic.claude-sonnet-4-6[1m]` as `sonnet-4.6[1m]`, which is acceptable per the user's selection (they opted only for the context-limit bump, not a parser tweak).

## Verification

1. Reload Claude Code (new session) and confirm `/status` or the model picker shows the active model. The `[1m]` suffix should appear in the statusline model section, confirming the env var took effect.
2. Open a session with a large transcript (or run for a while) and confirm the context bar in the statusline scales against 1000k — e.g. a session at ~250k tokens should show roughly 25% rather than saturating at 100%.
3. Run a quick prompt against Opus and Sonnet to confirm Bedrock accepts the request without a `ValidationException` (which would indicate the 1M beta is not enabled on the AWS account / region — `eu-west-1`). If it fails, the fallback is to remove `[1m]` from that model only and request 1M access via the AWS Bedrock console.
