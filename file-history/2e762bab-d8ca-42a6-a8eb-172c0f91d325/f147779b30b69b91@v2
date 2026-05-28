# Plan: Optimise `deep-code-reviewer.md` for Effectiveness

## Context

The current agent file is 519 lines. It is comprehensive but suffers from
three classes of issue that hurt review quality:

1. **Token bloat** — ~130 lines at the bottom (lines 385-518) restate the
   parent harness's memory framework verbatim, and the frontmatter
   `description` carries 6 long `<example>` blocks. Every byte costs context
   on every invocation, leaving less budget for the actual review.
2. **Missing calibration levers** — the file lists *what* to check across 13
   sub-dimensions, but is light on *how to decide what makes the cut*: no
   global severity rubric, no cap on findings, no "do-not-flag" guard list,
   no instruction to delegate format/lint checks to actual tools. Result:
   reviews drift toward exhaustive 30-finding dumps that nobody reads.
3. **Hallucination surface** — §3f tells the agent to "leverage your
   knowledge" of CVEs and deprecations. The §3d IAM rule already shows the
   user has been bitten by recall-based claims; that guard should be the
   default posture, not a one-off.

This plan keeps the substance (Phases 1-5, all 13 sub-dimensions, the SAM
serverless-access-manager institutional knowledge) and adds the missing
calibration levers while trimming pure duplication.

## Recommended Changes (Ranked by Effectiveness Gain ÷ Effort)

Each change cites the exact line range it touches.

---

### Tier 1 — High gain, low effort

#### 1. Add a global severity rubric (NEW section before §3a, after line 60)

Reviewers drift over time on what counts as Critical vs. High vs. Medium.
The file defines severity *per sub-dimension* (e.g. §3h calls type
imprecision Medium), so the same kind of issue gets graded differently
across sections. Anchor the agent with one explicit rubric:

```markdown
## Severity Rubric (anchor — applies across all sub-dimensions)

- **Critical**: data loss, RCE, credential exposure in source, IAM policy
  that grants `*:*`, silent data corruption in production path.
- **High**: silently wrong results (no runtime error), runtime
  AccessDenied, missing pagination on a list call that paginates in prod,
  unhandled error in a critical path, secret in a log line.
- **Medium**: correctness risk only under specific edge cases, paradigm
  violations that force a non-trivial refactor on next extension, README
  out of sync with public-facing change, type imprecision that obscures
  intent.
- **Low**: formatting, style, isolated cosmetic, single-occurrence
  cryptic construct outside critical path.
- **Info**: observation only — no action required.

When a finding straddles two levels, prefer the **lower** severity unless
the higher level is supported by a concrete failure mode you can name.
```

**Why first**: changes the *shape* of every future report, single paragraph,
no behavior risk.

#### 2. Cap the report (NEW, in Phase 5 or Behavioral Guidelines)

Add an explicit budget so the agent learns to prune:

```markdown
**Report budget**: emit every Critical and High finding. Cap Mediums at
the 5 most impactful. Group Lows into a single "Polish" subsection with
one line each — do not give Lows their own Issue [N] block. If you would
exceed this budget, prune; do not extend.
```

**Why second**: the existing "Prioritize ruthlessly" guideline (line 367)
is too soft to bind behavior. A numeric cap does.

#### 3. Generalise §3d's "fetch, don't recall" rule (modify §3f, lines 112-118)

§3d (lines 94-103) already enforces "fetch the AWS Service Authorization
Reference before flagging IAM mismatches at High". That guard should be
the default for *any* claim the agent makes about external state — CVEs,
deprecation notices, library bugs, default config values.

Replace §3f with:

```markdown
### 3f. External-Knowledge Claims

If you cite a CVE number, a deprecated API, a known bug in a specific
library version, or a default value for an external service, you MUST
fetch the authoritative source via WebFetch before including the
finding. Acceptable sources: official vendor docs, the project's own
CHANGELOG, the CVE database, the language's official deprecation notice.

If WebFetch is unavailable or the source cannot be reached, **either**
downgrade to Info with a "needs verification" caveat, **or** omit the
finding entirely. Do not flag from recollection — every recall-based CVE
or deprecation claim is a coin-flip on accuracy.
```

#### 4. Run available tooling (NEW, in Phase 1 step 1.5)

Insert after line 38:

```markdown
**Delegate mechanical checks to tools when present.** Before doing a
manual formatting/style/type read-through, check the project for and
invoke (read-only):

- Python: `ruff check`, `black --check`, `pyright` / `mypy`
- Scala: `scalafmt --test`, `scalafix --check`
- Terraform: `terraform fmt -check -recursive`, `tflint`
- CloudFormation/SAM: `cfn-lint`, `sam validate`
- GitLab CI: `gitlab-ci-lint` if available, otherwise schema-check the
  YAML structure manually.

If a tool runs cleanly, do not raise findings in its category — defer to
it. If a tool is configured but absent locally, mention it once as Info
and proceed manually. Tooling output replaces speculation.
```

**Why**: collapses §3g (formatting standards, lines 119-127) from
"check by reading" to "check by running", which is both faster and more
accurate. §3g still applies as a fallback when no tool is present.

---

### Tier 2 — High gain, medium effort

#### 5. Add a false-positive guard list (NEW, in Behavioral Guidelines)

§3d's IAM guard is the only one of its kind. Add a small set of common
FP categories:

```markdown
**Known false-positive categories — apply extra scrutiny before flagging:**

- Type imprecision in test fixtures and mocks (`Any` is often correct
  there; flag only if it leaks into production code).
- "Missing tests" for trivial passthroughs, dataclass `__init__`, and
  one-line getters.
- README sync on files clearly marked internal (`_internal/`, `tests/`,
  `scripts/dev/`) — only flag for user-facing surface.
- Performance findings without a measurement or an O-class change — do
  not flag "this could be faster" without naming the algorithmic class.
- Paradigm violations in legacy code clearly marked deprecated — flag at
  Info only, not Medium.
```

#### 6. Diff-first scope (modify Phase 1, lines 35-39)

Replace the soft "focus on recently written or modified files" with an
explicit anchor:

```markdown
1. **Identify the scope**: Default to the diff against the merge-base of
   the current branch (or `HEAD~1` if no base is obvious). Read the
   changed files in full, plus their direct callers/callees as needed
   for context. Do not review unchanged code unless the user explicitly
   asks for it.
```

#### 7. Compress the memory boilerplate (modify lines 385-518)

The agent has its own memory dir at
`/Users/saurabhtyagi/.claude/agent-memory/deep-code-reviewer/` and
already contains `MEMORY.md` + `user_role.md`. The 130-line memory
how-to (lines 385-518) duplicates the parent harness's framework and is
not needed at full length inside the agent prompt. Replace with:

```markdown
# Persistent Agent Memory

Memory dir: `/Users/saurabhtyagi/.claude/agent-memory/deep-code-reviewer/`
(already exists). Index lives at `MEMORY.md` in that dir.

**Save** when you discover: recurring repo-specific bug patterns,
established conventions per language, team-specific style preferences
surfaced during reviews, known technical-debt areas. Use frontmatter
`name`, `description`, `type` (one of: user / feedback / project /
reference). Add a one-line entry to `MEMORY.md`.

**Do not save**: code patterns derivable by reading current files, git
history, debugging fix recipes, ephemeral task state.

**Before recommending from memory**: if the memory names a file, path,
or symbol, verify it still exists. Memory is a snapshot, not ground
truth.

**Trigger**: at the end of every review, before exiting, ask yourself
"did I learn anything about this repo's conventions that future reviews
would benefit from?" If yes, write it.
```

This collapses ~130 lines to ~15 while preserving every operative
instruction.

#### 8. Compress description examples (modify frontmatter, lines 2-3)

Six `<example>` blocks at ~80-100 chars each = ~500 chars of frontmatter
the harness re-reads on every dispatch decision. Three are enough to
establish the pattern (one Python, one Terraform/IaC, one mixed
branch+file path). Drop the Scala, GitLab CI, and SAM-only examples —
the language list in the description body already covers them.

Keep the routing rule paragraph in full — that is the load-bearing
content for harness dispatch.

---

### Tier 3 — Moderate gain, medium effort

#### 9. Move serverless-access-manager (§3l) to a playbook file (lines 172-235)

§3l is ~65 lines of internal-team knowledge that only applies when the
SAM template uses `Custom::ServerlessAccessManager`. Most reviews don't
touch it. Two paths:

- **(a) Leave inline (current)** — every review pays ~65 lines.
- **(b) Move to `/Users/saurabhtyagi/.claude/agent-memory/deep-code-reviewer/playbook_serverless_access_manager.md`** and replace §3l with a 5-line stub: "When reviewing a SAM template that uses `Custom::ServerlessAccessManager`, read the playbook at &lt;path&gt; before producing findings."

Recommend (b). The agent already re-reads the upstream README at
`/Users/saurabhtyagi/ws/serverless-access-manager/README.md` per the
existing instruction at line 176, so adding one more conditional read
is consistent.

#### 10. Compress the §3m worked example (lines 267-310)

The before/after Python snippet is useful but ~45 lines for one example
is heavy. Trim the prose around it; keep the two code blocks. Saves
~20 lines.

#### 11. Compress Phase 5 (modify lines 343-359)

- Drop "Positive Observations" (line 348) or make it conditional ("only
  when there is a non-trivial pattern worth reinforcing"). In practice
  it adds boilerplate to most reviews.
- Keep the Scorecard table — it is high-signal.
- Compress "Overall Assessment" cap to one sentence.

#### 12. Reconcile the "do not ask questions" contradiction (lines 45 vs 54)

Line 45 says **"Do not ask clarifying questions."** Line 54 softens to
"Only ask if critical and unresolvable, max one." Replace line 45 with:
**"Default to inferring from code; ask at most one clarifying question,
and only when the answer would change a finding's severity."**

---

### Tier 4 — Nice-to-have

#### 13. Declare `tools:` in frontmatter

The agent currently inherits all tools. A reviewer needs `Read, Grep,
Glob, Bash, WebFetch, Write` (Write only for the agent-memory dir).
Narrow the toolset to prevent accidental edits to reviewed code. Low
priority — the agent's instructions already say it reviews, not edits.

#### 14. Drop the `memory: user` frontmatter key (line 6)

This key is not part of the standard agent frontmatter schema and likely
does nothing. Confirm and remove.

---

## Expected Token Savings

| Change | Lines removed | Lines added | Net |
|---|---|---|---|
| 7. Memory boilerplate | ~130 | ~15 | **-115** |
| 8. Description examples | ~6 | 0 | **-6** (frontmatter) |
| 9. Move §3l to playbook | ~60 | ~5 | **-55** |
| 10. §3m example | ~20 | 0 | **-20** |
| 11. Phase 5 trim | ~5 | 0 | **-5** |
| 1. Severity rubric | 0 | ~15 | **+15** |
| 2. Report budget | 0 | ~5 | **+5** |
| 3. §3f rewrite | ~7 | ~12 | **+5** |
| 4. Tooling delegation | 0 | ~12 | **+12** |
| 5. FP guard list | 0 | ~10 | **+10** |
| 6. Diff-first | ~3 | ~5 | **+2** |
| 12. Question reconcile | ~1 | ~1 | **0** |

Net: ~152 lines removed from the agent's per-invocation prompt,
calibration levers added.

## Critical Files

- `/Users/saurabhtyagi/.claude/agents/deep-code-reviewer.md` — the file
  under review, all changes apply here.
- (NEW, if change 9 accepted) `/Users/saurabhtyagi/.claude/agent-memory/deep-code-reviewer/playbook_serverless_access_manager.md`

## Verification

After applying the chosen changes:

1. Sanity-read the modified file end-to-end to confirm no section was
   dropped that has no replacement.
2. Confirm frontmatter still parses (YAML between `---` markers, valid
   keys).
3. Trigger the agent on a small Python diff and confirm:
   - It cites the new severity rubric implicitly (severities feel
     consistent across findings).
   - It honors the report budget (no >5 Mediums, Lows grouped).
   - It runs `ruff` / `pyright` if present rather than reading style
     manually.
   - It does not flag a CVE without WebFetching the source.
4. Trigger on a SAM diff that touches `Custom::ServerlessAccessManager`
   and confirm (if change 9 accepted) the agent reads the playbook
   before producing findings.

## Suggested Order of Application

If applying incrementally, do Tier 1 first (changes 1-4) — they are
high-leverage and independent. Then change 7 (memory trim) for the
biggest token win. Tier 2 and below at your discretion.
