# Plan: Extend deep-code-reviewer agent with four new focus areas

## Context

The user wants the `deep-code-reviewer` agent (`/Users/saurabhtyagi/.claude/agents/deep-code-reviewer.md`) to explicitly cover four additional review dimensions that are currently either implicit, weakly worded, or missing entirely:

1. **Language-appropriate code formatting standards** — currently the agent's "Readability & Maintainability" section talks about naming and structure but does not call out formatter conventions (PEP 8 / Black for Python, gofmt for Go, prettier for JS/TS, terraform fmt for HCL, yamllint for YAML, etc.).
2. **Correct, narrow types instead of broad ones** — the agent mentions "type coercions" under correctness but does not push back on `Any`, `dict`, `str`-as-everything, untyped `interface{}`, or absence of dataclasses / Pydantic models / TypedDicts / Protocol buffers / proper structs. This is one of the highest-leverage review notes for Python/TS/Go and is currently missing.
3. **Redundant tests** — the agent's testing bullet only checks "is the code testable / are there obvious test cases that should exist." It does not look at the **inverse** problem: tests that duplicate coverage, near-identical parameterized cases that could be merged, or multiple test functions exercising the same branch.
4. **README drift** — when behavior, CLI flags, env vars, or public APIs change, the agent should verify the README (and any closely related docs like `docs/`, `examples/`) is updated. Currently nothing in the agent prompts this check.

These four additions sharpen the reviewer's signal without changing its overall structure.

## Approach

Edit `/Users/saurabhtyagi/.claude/agents/deep-code-reviewer.md` in place. Make four targeted insertions inside the existing Phase 3 dimensions — no restructuring, no new top-level phases. Keep wording terse and consistent with the existing bullet style.

### Change 1 — Code formatting standards (Section 3a: Readability & Maintainability)

Append a new bullet after the existing "Consistency" bullet at line 49:

> - **Formatting standards**: Verify the code conforms to the canonical formatter / linter for the language (e.g. Black + isort + Ruff for Python, gofmt/goimports for Go, Prettier/ESLint for JS/TS, `terraform fmt` for HCL, `yamllint` / 2-space indent for YAML, shfmt for shell). Flag inconsistent indentation, trailing whitespace, mixed quote styles, line-length violations, and import ordering issues. Prefer tooling-enforced rules over subjective preferences.

### Change 2 — Correct, narrow types (Section 3b: Correctness of Implementation)

Insert a new bullet immediately after the existing "Data types" bullet at line 54, before "Concurrency":

> - **Type precision**: Flag overly broad types where a narrower one is available — `Any`, untyped `dict`/`list`, `str` carrying structured data (JSON blobs, ARNs, comma-joined IDs), Go `interface{}` / `map[string]interface{}`, TS `any` / `object`. Recommend representing domain entities as proper types: `dataclass` / `pydantic.BaseModel` / `TypedDict` / `NamedTuple` in Python, structs in Go, `interface` / `type` aliases in TS, Pydantic or `attrs` for validated payloads. The bar: if a value has a known shape, it should have a typed shape.

### Change 3 — Redundant tests (Section 3e: Best Practices)

Replace the existing single "Testing" bullet at line 89 with two bullets that cover both the "missing tests" and "redundant tests" sides:

> - Testing — coverage: Is the code testable? Are there obvious test cases (happy path, error path, boundary, empty input) that are missing?
> - Testing — redundancy: Scan existing tests for redundancy. Flag near-duplicate test functions that exercise the same code path with trivially different inputs, multiple tests asserting the same invariant, and parameterizable cases that should be collapsed (`pytest.mark.parametrize`, table-driven tests in Go, `test.each` in Jest). Recommend merges with a concrete sketch of the consolidated test. Redundant tests slow CI and obscure which case actually broke when one fails.

### Change 4 — README synchronization (new bullet in Section 3e: Best Practices)

Append a new bullet at the end of Section 3e:

> - **Documentation drift**: If the project has a `README.md` (or `README.rst`, top-level `docs/`, `CHANGELOG.md`), check whether the changes under review require corresponding doc updates — new/renamed CLI flags, env vars, public API signatures, install steps, supported versions, configuration keys, or example snippets. Flag any change that alters user-visible behavior without a matching doc edit. Quote the stale section of the README and propose the corrected text.

## Files to modify

- `/Users/saurabhtyagi/.claude/agents/deep-code-reviewer.md` — four insertions inside Phase 3 (sections 3a, 3b, 3e). No frontmatter changes, no removal of existing content.

## Verification

After the edit:
1. Re-read the modified file and confirm the four new bullets appear in the correct sections and the surrounding bullets are still intact.
2. Confirm no other sections (Phase 1, 2, 4, 5, Behavioral Guidelines, Persistent Agent Memory) were touched.
3. The file should remain valid Markdown with the YAML frontmatter unchanged.

No code execution or tests are required — this is a prompt-definition edit.
