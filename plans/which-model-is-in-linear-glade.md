# Ensure deep-code-reviewer uses Opus 4.8

## Context

The user wants to be sure the `deep-code-reviewer` subagent
(`~/.claude/agents/deep-code-reviewer.md`) runs on **Opus 4.8**. The agent's
frontmatter (line 4) sets `model: opus`, which is an *alias*, not a fixed
version — so the concern is whether it actually resolves to 4.8.

## Finding: it already resolves to Opus 4.8 — no change needed

This environment runs Claude Code on **AWS Bedrock** (`CLAUDE_CODE_USE_BEDROCK=1`,
`AWS_REGION=eu-west-1`). The resolution chain is:

```
agent frontmatter  model: opus
        │  (alias)
        ▼
settings.json:8    ANTHROPIC_DEFAULT_OPUS_MODEL = eu.anthropic.claude-opus-4-8[1m]
        │
        ▼
Bedrock inference profile  →  Opus 4.8 (1M context), EU region
```

The `opus` alias is mapped to `ANTHROPIC_DEFAULT_OPUS_MODEL` in
`~/.claude/settings.json:8`, which is pinned to `eu.anthropic.claude-opus-4-8[1m]`.
So the agent is already on Opus 4.8.

The user chose to **keep the alias** (`model: opus`) rather than hard-pin the
Bedrock ID into the agent. Rationale: the alias is portable across environments
and stays correct as long as `ANTHROPIC_DEFAULT_OPUS_MODEL` points at 4.8. The
only "drift" risk is intentionally editing that env var later.

## Action required

**None.** `~/.claude/agents/deep-code-reviewer.md` is left unchanged
(`model: opus` at line 4). The desired outcome (agent on Opus 4.8) is already
satisfied via `settings.json`.

> Optional hardening (NOT chosen): set
> `model: eu.anthropic.claude-opus-4-8[1m]` directly in the agent frontmatter to
> guarantee 4.8 independent of env defaults — rejected because it ties the agent
> to this specific Bedrock/EU setup.

## Verification

To confirm the agent picks up Opus 4.8 at invocation:

1. Confirm the env mapping is live:
   `env | grep ANTHROPIC_DEFAULT_OPUS_MODEL`
   → expect `eu.anthropic.claude-opus-4-8[1m]`.
2. Invoke the agent on a trivial supported-language change (e.g. a small Python
   diff) and ask it to state the model it is running as in its first line of
   output → expect it to report Opus 4.8.
3. If you ever want to make 4.8 explicit, edit `settings.json:8` (single source
   of truth for the `opus` alias) rather than the agent file.
