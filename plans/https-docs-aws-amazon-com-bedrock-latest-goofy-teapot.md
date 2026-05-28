# Enable 1M Token Context Window in Claude Code (Bedrock)

## Context

Bedrock advertises a **1M-token context window** for both Claude Sonnet 4.6 and Claude Opus 4.7, but the running Claude Code session reports only **200k tokens**. The user wants to know why and how to unlock the full 1M window.

**Root cause** — confirmed against the official Claude Code Bedrock docs:

> *"Claude Opus 4.7, Opus 4.6, and Sonnet 4.6 support the 1M token context window on Amazon Bedrock. Claude Code automatically enables the extended context window when you select a 1M model variant. […] To enable it for a manually pinned model, **append `[1m]` to the model ID**."*
> — https://code.claude.com/docs/en/bedrock#1m-token-context-window

The user's `~/.claude/settings.json` pins models without the `[1m]` suffix, so Claude Code falls back to the default 200k-token variant:

```jsonc
// /Users/saurabhtyagi/.claude/settings.json (current)
"ANTHROPIC_DEFAULT_OPUS_MODEL":   "eu.anthropic.claude-opus-4-7",
"ANTHROPIC_DEFAULT_SONNET_MODEL": "eu.anthropic.claude-sonnet-4-6",
"ANTHROPIC_DEFAULT_HAIKU_MODEL":  "eu.anthropic.claude-haiku-4-5-20251001"
```

Haiku 4.5 does **not** support a 1M context window, so it should be left as-is.

## Recommended Change

Append the `[1m]` suffix to the Opus and Sonnet model pins. Edit `/Users/saurabhtyagi/.claude/settings.json`:

```jsonc
"env": {
  "CLAUDE_CODE_USE_BEDROCK": "1",
  "AWS_PROFILE": "claude-bedrock",
  "AWS_REGION": "eu-west-1",
  "ANTHROPIC_DEFAULT_OPUS_MODEL":   "eu.anthropic.claude-opus-4-7[1m]",     // + [1m]
  "ANTHROPIC_DEFAULT_SONNET_MODEL": "eu.anthropic.claude-sonnet-4-6[1m]",   // + [1m]
  "ANTHROPIC_DEFAULT_HAIKU_MODEL":  "eu.anthropic.claude-haiku-4-5-20251001" // unchanged — no 1M support
}
```

No other settings need to change. The existing `model_options.max_tokens: 128000` (output cap) and `effortLevel`, `model_aliases`, etc. are unaffected.

## Prerequisites & Caveats

1. **Bedrock model access** — your AWS account must have access to the 1M variant of each model. The `eu.anthropic.*` cross-region inference profile (Ireland geo) supports it; the user is already on `eu-west-1`.
2. **Pricing** — 1M-context requests on Bedrock are billed at a higher per-token rate above the 200k threshold. Check Bedrock pricing before rolling this out broadly.
3. **Latency** — large contexts increase TTFT. Use only when you actually need it.
4. **Restart required** — Claude Code reads `settings.json` `env` block at startup. Quit and relaunch `claude` after editing.

## Critical Files

| File | Change |
|---|---|
| `/Users/saurabhtyagi/.claude/settings.json` | Add `[1m]` suffix to `ANTHROPIC_DEFAULT_OPUS_MODEL` and `ANTHROPIC_DEFAULT_SONNET_MODEL` |

## Verification

1. Save the edit and restart Claude Code.
2. Inside Claude Code, run `/status` — confirm the provider line still reads `Amazon Bedrock` and the active model shows the `[1m]` variant.
3. Run `/model` — the picker should display the 1M-enabled Sonnet/Opus entries.
4. Sanity check: paste/load a context block >200k tokens (e.g. concatenate several large source files). The session should accept it without truncation. Without the fix, the same payload errors with a context-window-exceeded response.
5. Optional — confirm at the API layer by inspecting a Bedrock CloudTrail event for the next request: the `modelId` field should end with `:1m` (Bedrock's wire encoding of the `[1m]` suffix).

## Reference

- https://code.claude.com/docs/en/bedrock#1m-token-context-window
- https://docs.aws.amazon.com/bedrock/latest/userguide/model-card-anthropic-claude-sonnet-4-6.html (Context window: 1M tokens)
- https://docs.aws.amazon.com/bedrock/latest/userguide/model-card-anthropic-claude-opus-4-7.html (Context window: 1M tokens)
