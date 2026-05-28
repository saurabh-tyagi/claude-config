# Prevent Claude from preferring `# pyright: ignore` over fixing the underlying type

## Context

While addressing MR !60 review feedback (comment 4), I initially added
typed casts and stub types but several rounds of edits still left
`# pyright: ignore[reportAny]` cascades scattered across the test
suite. The root cause is a default tendency to silence a pyright
diagnostic with an ignore comment instead of tightening the underlying
type. The user wants two durable mitigations so future sessions don't
need this same correction:

1. A repo-scoped instruction in `CLAUDE.md` that is loaded into every
   session for this project.
2. A user-scope feedback memory that carries across all projects.

## Changes

### 1. Repo-scoped rule in `CLAUDE.md`

File: `/Users/saurabhtyagi/Documents/workspace/dns-de-rte-orchestrator/CLAUDE.md`

Add a short subsection under the existing "Code Quality" section (after
the `prek` block) titled "Type checking rule" with this rule:

> When `basedpyright` reports a type error, fix the underlying type
> first — narrow `Any`/`object`, add a precise `TypedDict` /
> `Protocol` / `dataclass`, use `typing.Self`, or `cast(T, ...)` at the
> boundary. `# pyright: ignore[<rule>]` is a last resort and must be
> accompanied by a one-line comment explaining why the type cannot be
> tightened. Never silence diagnostics by widening a return type to
> `Any`.

Also add an example pointer to `request_repository.py` and the
`audit_logging.py` `_item_to_entry` pattern as the canonical example
of using `# pyright: ignore[reportTypedDictNotRequiredAccess]` only
where the underlying type genuinely cannot be tightened further.

Note: `CLAUDE.md` was edited in the editor (the file currently starts
with `How t# AGENTS.md` due to a stray prefix). Preserve that as-is —
only append the new subsection in the appropriate place.

### 2. User-scope feedback memory

Directory:
`/Users/saurabhtyagi/.claude/projects/-Users-saurabhtyagi-Documents-workspace-dns-de-rte-orchestrator/memory/`

Create a new feedback memory file `feedback_pyright_ignores.md` with
frontmatter (`type: feedback`) and body structured as:

- **Rule**: Fix the underlying type before reaching for `# pyright:
  ignore`. Widening a return type to `Any` to silence `reportAny` is
  never acceptable.
- **Why**: Ignores compound — one `Any` return forces a cascade of
  `# pyright: ignore[reportAny]` at every call site. Real fix is a
  precise type at the source. Past incident: MR !60 review explicitly
  called out the `Any`-typed test stub as a smell.
- **How to apply**: When pyright flags `reportAny` /
  `reportExplicitAny` / `reportUnknownMemberType`, prefer (in order)
  a domain `dataclass` / `TypedDict` / `Protocol`, a typed stub class,
  `typing.Self`, or `cast(T, ...)` at a single boundary. Use ignores
  only when the type genuinely cannot be expressed (e.g. accessing
  optional `TypedDict` keys); pair with a one-line `why` comment.

Then add a one-line entry to `MEMORY.md` in the same directory:
`- [Pyright ignores](feedback_pyright_ignores.md) — fix the underlying
type before silencing diagnostics`.

Check `MEMORY.md` for an existing related entry first; update in place
rather than duplicating if one is present.

## Files modified

- `/Users/saurabhtyagi/Documents/workspace/dns-de-rte-orchestrator/CLAUDE.md`
- `/Users/saurabhtyagi/.claude/projects/-Users-saurabhtyagi-Documents-workspace-dns-de-rte-orchestrator/memory/feedback_pyright_ignores.md` (new)
- `/Users/saurabhtyagi/.claude/projects/-Users-saurabhtyagi-Documents-workspace-dns-de-rte-orchestrator/memory/MEMORY.md`

## Verification

1. Reload the project (open a new session) and confirm the new
   "Type checking rule" appears in the system prompt context (it will,
   since `CLAUDE.md` is auto-loaded).
2. Confirm the new memory file is listed in `MEMORY.md` and the body
   uses the `name` / `description` / `metadata.type: feedback`
   frontmatter.
3. No code or test changes — `prek` / `pytest` not required.
