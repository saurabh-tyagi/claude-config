# Fix: statusline session cost always shows $0

## Context

The statusline session segment always renders `$0/$50 [░░░░░░░░░░] 0%`. The cost
never moves off zero even during active, expensive sessions.

The session cost is produced by `get_session_cost()` in
`/Users/saurabhtyagi/cc-statusline/src/statusline-utils.sh` (lines 475-513),
called from `/Users/saurabhtyagi/cc-statusline/src/statusline.sh` (lines 456 and 562).
It sums `costUSD` from `ccusage blocks --json --offline` for blocks belonging to
the current session.

### Real root cause (verified)

`ccusage` prices the Bedrock model IDs correctly — recent blocks report real
costs (~$27.54). The bug is the **block-selection filter**, not pricing.

- `ccusage` returns **5-hour aggregated windows** with quantized start times
  (e.g. block starts at `15:00:00Z`, ends `20:00:00Z`).
- `get_session_cost()` derives the session start from the transcript's first
  timestamp (e.g. `18:11:11Z`) and filters with `select(.startTime >= $start)`.
- A session almost always begins *inside* an already-open 5-hour block, so the
  block's `startTime` (`15:00`) is earlier than the session start (`18:11`).
  The `>=` test fails, the active block is dropped, and the sum is `0`.

Verified directly: with session start `2026-05-28T18:11:11Z`, the old filter
sums to `0`; filtering on `endTime > start` (and excluding gap blocks) sums to
`$27.54`, the active block.

> Note: an earlier automated diagnosis blamed Bedrock model IDs / `--offline`
> pricing. That was wrong — pricing works fine. Do not change the ccusage
> invocation or add model-ID normalization.

## Change

Single targeted edit in `get_session_cost()`
(`/Users/saurabhtyagi/cc-statusline/src/statusline-utils.sh`, the jq filter at
lines 505-510).

Replace:

```jq
[.blocks[] |
 select(.startTime >= $start) |
 .costUSD
] | add // 0
```

with a filter that keeps any non-gap block whose window overlaps the session
(i.e. ends after the session start):

```jq
[.blocks[] |
 select((.isGap // false) | not) |
 select(.endTime > $start) |
 .costUSD
] | add // 0
```

Rationale:
- `endTime > $start` includes the in-progress block the session began inside,
  plus any later blocks — matching "cost since this session started".
- `select((.isGap // false) | not)` skips ccusage's synthetic gap blocks
  (they carry `costUSD: 0` but pollute the set and have misleading time ranges).

No other files change. `statusline.sh` call sites, `settings.json`
(`statusLine.command`), and `config/config.json` (`limits.cost = 50`) are all
correct and untouched.

## Verification

1. Pipe a realistic stdin payload through the statusline and confirm a non-zero
   session cost:

   ```bash
   LATEST=$(find ~/.claude/projects -name '*.jsonl' -type f -mmin -120 \
     | xargs ls -t 2>/dev/null | head -1)
   printf '{"workspace":{"current_dir":"%s"},"transcript_path":"%s","model":{"id":"eu.anthropic.claude-sonnet-4-6[1m]"}}' \
     "$HOME/.claude" "$LATEST" | ~/.claude/statusline.sh
   ```

   Expect the session segment to read e.g. `$28/$50 [█████░░░░░] 55%` instead of
   `$0/$50 ... 0%`.

2. Spot-check the function's filter in isolation:

   ```bash
   START=$(head -20 "$LATEST" | grep -o '"timestamp":"[^"]*"' | head -1 \
     | sed 's/"timestamp":"//; s/"//')
   npx --yes ccusage blocks --json --offline 2>/dev/null | awk '/^{/,0' \
     | jq -r --arg start "$START" \
       '[.blocks[] | select((.isGap // false)|not) | select(.endTime > $start) | .costUSD] | add // 0'
   ```

   Expect this to match the dollar figure shown in the statusline (> 0).
