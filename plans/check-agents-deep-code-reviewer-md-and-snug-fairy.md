# Plan: Tighten `deep-code-reviewer` agent to a fixed language set with new review focuses

## Context

The current `deep-code-reviewer` agent at `/Users/saurabhtyagi/.claude/agents/deep-code-reviewer.md` is positioned as a generic, language-agnostic reviewer that happens to mention Python and IaC. The user wants it narrowed to a specific tech stack (matching their day-to-day work as a Python/AWS ETL developer per `agent-memory/deep-code-reviewer/user_role.md`) and wants six new review focuses baked into the agent's behavior so they are applied automatically on every review.

The intended outcome: a sharper, more opinionated reviewer that (a) refuses out-of-scope languages, and (b) consistently checks formatting, type precision, test redundancy, README drift, and extensibility — none of which are guaranteed by the current agent prompt.

## Scope of edits

Only one file is modified:

- `/Users/saurabhtyagi/.claude/agents/deep-code-reviewer.md`

No code, settings, or memory changes.

## Changes

### 1. Frontmatter `description` — narrow the language list

Replace the current "Python code (any kind: ETL, scripts, services, utilities), GitLab CI pipelines, or infrastructure-as-code (Terraform, CloudFormation, SAM, CDK, Ansible)" phrasing with the fixed supported set:

> **Python, Scala, Terraform, CloudFormation, SAM, and GitLab CI (`.gitlab-ci.yml` and CI templates).**

Remove mentions of CDK and Ansible as in-scope languages. Shell and SQL are **out of scope** — the agent should not perform deep review on standalone `.sh` / `.sql` files. (Embedded shell snippets inside GitLab CI `script:` blocks are reviewed only as part of the CI pipeline review, not as a Shell-language review.) Keep GitLab CI YAML as a first-class supported target (its own dimension — pipeline structure, secrets handling, runner tags, `rules`/`needs` correctness). Keep the routing rule (prefer this agent over the `review` skill for branch/local-file reviews; only use `review` skill for PR/MR numbers).

Keep the existing GitLab CI `<example>` block. Add a Scala/Spark example so the trigger surface matches the new scope. Keep the Python ETL, Terraform, and SAM examples.

### 2. New "Supported Languages and Out-of-Scope Handling" section (top of body, before Phase 1)

Add an explicit hard-scope section:

- **Supported**: Python, Scala, Terraform (HCL), CloudFormation (YAML/JSON), AWS SAM, and GitLab CI (`.gitlab-ci.yml` files and CI templates).
- **Out-of-scope** (explicit): Shell scripts (`.sh`/`.bash`/`.zsh`), SQL (any dialect), JS/TS, Go, Java, Rust, Ruby, C#, etc. Embedded shell inside GitLab CI `script:` blocks is reviewed only as part of the CI pipeline review.
- **Out-of-scope behavior** (user-confirmed: **hard reject with redirect**): If the review target is in a non-supported language, the agent must decline with a one-paragraph explanation naming the supported set and suggesting a different tool/agent. No partial review, no best-effort.
- **Mixed-language repos**: If the changeset spans supported and unsupported files, review only the supported files and explicitly list the skipped files with the reason (`skipped: <language> not in supported set`).

### 3. Phase 3 additions — six new analysis dimensions

Extend the existing Phase 3 ("Deep Analysis") with these new sub-sections, alongside the current 3a–3f:

#### 3g. Code Formatting Standards (NEW)
The agent must check that code conforms to the canonical formatter/style for its language and flag deviations. Per-language expectations:

- **Python**: PEP 8, plus `black` (line length 88 or project-configured), `isort` for imports, and type-hint formatting per PEP 484/604. Flag tabs vs. spaces inconsistency, missing trailing newlines, and import ordering.
- **Scala**: `scalafmt` defaults (or repo's `.scalafmt.conf` if present). Flag inconsistent 2-space indent, missing/extra braces in single-expression methods, import grouping.
- **Terraform**: `terraform fmt` canonical style (2-space indent, aligned `=`, alphabetized arguments where idiomatic). Flag unaligned blocks and inconsistent quoting.
- **CloudFormation / SAM**: 2-space YAML indent, no tabs, consistent intrinsic-function form (short `!Ref` vs long `Fn::Ref` — pick one and stay consistent within a file). Flag mixed forms.
- **GitLab CI**: 2-space YAML indent, no tabs, consistent ordering of job keys (`stage`, `image`, `rules`/`only`, `needs`, `variables`, `before_script`, `script`, `after_script`, `artifacts`). Flag inline multi-line shell that should be extracted to a script file, and inconsistent anchor/extends usage.

For each formatting violation, severity is **Low** unless it materially harms readability, in which case **Medium**.

#### 3h. Type Precision (NEW)
Flag broad/loose typing where a precise type would be clearer and safer:

- **Python**: Avoid `Any`, bare `dict`, bare `list`, bare `tuple`, `Optional[Any]`, and `**kwargs: Any` when the shape is known. Recommend `TypedDict`, `dataclass`, `pydantic.BaseModel`, `NamedTuple`, `Literal`, or precise generics (`dict[str, int]`, `list[UserId]`). Flag `str` used as a stand-in for an ID, ARN, or enum — recommend `NewType` or `Enum`.
- **Scala**: Flag `Any`, `AnyRef`, `String` used as a domain ID, and over-broad `Map[String, Any]`. Recommend `case class`, `sealed trait` ADTs, opaque types (Scala 3) / value classes (Scala 2), and `Refined` where applicable.
- **Terraform**: Flag `type = any` on variables. Require explicit `object({...})`, `list(string)`, `map(...)`, etc.
- **CloudFormation/SAM**: Flag `Type: String` parameters that should be `AWS::EC2::VPC::Id`, `AWS::SSM::Parameter::Value<...>`, `Number`, `List<...>`, etc. Flag missing `AllowedValues` / `AllowedPattern` for constrained inputs.
- **GitLab CI**: Flag untyped `variables:` where GitLab supports typed/described variables (`description`, `value`, `options`, `expand`). Flag string `"true"`/`"false"` where boolean semantics are intended in shell — recommend explicit guards.

The principle: **the type system should encode domain meaning** (entities, IDs, enums), not just primitive carriers. Severity ranges Medium → High depending on whether the loose type masks a real correctness risk.

#### 3i. Test Redundancy (NEW)
Scan the test suite (or test files in the changeset) for:

- Multiple tests asserting the same behavior with trivially different inputs that don't add coverage (candidates for parametrization — `pytest.mark.parametrize`, ScalaTest table-driven).
- Setup/fixture duplication that could be hoisted to a shared fixture.
- Tests that only differ by the assertion message but exercise the same path.
- Over-mocked tests that no longer exercise real logic and duplicate a higher-level integration test.

For each cluster of redundancy, list the test names + files, recommend a merged/parametrized form, and estimate the reduction (e.g., "5 tests → 1 parametrized test with 5 cases"). Severity is **Low** (maintenance), unless redundancy is masking a missing edge case (then **Medium**).

#### 3j. README Synchronization (NEW)
User-confirmed scope: **root README + nearest README above each changed file**.

Procedure:
1. If a `README.md` / `README.rst` exists at the repo root, read it.
2. For each changed file, walk up the directory tree and read the first README found (if any).
3. Cross-check the README against the changes for stale references: command examples, environment variables, configuration keys, IAM permissions, deployment steps, supported regions/dialects, listed features, install/setup instructions, and architecture diagrams' file paths.
4. Flag mismatches as **Medium** severity with the exact README line and the corresponding code/config change.

If no README is present anywhere relevant, note this once in the summary as **Info** ("no README found in scope; skipping doc-sync check"). Do **not** demand a README be created — that's a project decision.

#### 3k. Paradigm Adherence and Extensibility (NEW)
Flag deviations from each language's idiomatic paradigm and structural choices that will block future extension without major refactoring:

- **Python**: Prefer composition over inheritance; prefer pure functions for data transforms; flag God classes, deep inheritance chains, and mixing IO with business logic. Recommend Strategy / Protocol-based polymorphism for points likely to vary (sources, sinks, serializers).
- **Scala**: Prefer immutable case classes, ADTs (sealed traits) for closed sets, and pure functions. Flag mutable `var` in shared state, side effects in `map`/`flatMap`, and missing `sealed` on traits intended as ADTs.
- **Terraform / CFN / SAM**: Flag hardcoded resource names, account IDs, regions, and copy-pasted resource blocks that should be modules / nested stacks / SAM transforms. Flag missing `for_each` / `count` where the resource set will clearly grow.
- **GitLab CI**: Flag copy-pasted job definitions that should use `extends:` / YAML anchors / `include:` templates. Flag hardcoded image tags, runner tags, or environment names that should be CI variables. Flag missing `needs:` where DAG parallelism would replace serial `stages`. Flag secrets passed via plain `variables:` rather than `CI/CD variables` (masked/protected) or a secrets manager.

The lens for this section is **"if a new variant of this entity is added in 6 months, how invasive is the change?"**. Severity: **Medium** when the structure will force a non-trivial refactor on the next addition; **High** if the next addition would require touching unrelated modules.

### 4. Update Phase 5 (Summary)

Add to the summary template:
- **Formatting compliance score** (Pass / Minor issues / Major issues) per language touched.
- **Type-precision score** (Pass / Loose-types-found).
- **Test-suite health note** (redundancy clusters found, if any).
- **README sync status** (In sync / Out of sync / N/A).
- **Extensibility risk** (Low / Medium / High) with one-sentence justification.

### 5. Update the "what to record in agent memory" examples (lines ~152–160)

Add language-specific recurring-pattern examples that match the new scope (e.g., "this repo's Terraform consistently uses `for_each` over `count`", "this repo's Python ETL consistently uses pydantic for record schemas"). Drop generic-language examples.

## What is NOT changing

- The existing Phases 1, 2, 4 structure and the issue-report format.
- The IAM-action-vs-API-method-name rule in 3d.
- The external-API-query-semantics and manual-parsing rules in 3b.
- The persistent-memory section and its file format.
- The `model: opus`, `color: green`, `memory: user` frontmatter fields.

## Verification

After the edit, the agent file should:
1. State the supported language set in both the frontmatter `description` and a top-of-body section.
2. Contain six clearly-labeled new sub-sections (3g–3k) with per-language guidance.
3. Have an updated Phase 5 summary template that includes the five new scorecard lines.
4. Have at least one in-scope `<example>` per major language family (Python, IaC, Scala or SQL).

Manual verification (no code execution needed): re-read the file end-to-end and confirm (a) no leftover mentions of CDK / Ansible / generic "any language" framing, (b) the hard-reject behavior is unambiguous, (c) the new Phase 3 sub-sections are concrete enough that a future review will actually apply them rather than skip them.

A live verification can be done by invoking the agent on a small mixed Python+Terraform changeset and confirming the output includes the new scorecard section and per-language formatting checks.
