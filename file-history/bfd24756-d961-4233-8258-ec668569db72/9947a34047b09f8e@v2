---
name: feedback-pyright-ignores
description: Fix the underlying type before adding pyright ignore comments — widening to Any is never acceptable
metadata: 
  node_type: memory
  type: feedback
  originSessionId: bfd24756-d961-4233-8258-ec668569db72
---

Fix the underlying type before reaching for `# pyright: ignore`. Widening a
return type to `Any` to silence `reportAny` or `reportExplicitAny` is never
acceptable.

**Why:** Ignores compound — a single `Any` return forces a `# pyright:
ignore[reportAny]` at every call site. The real fix is a precise type at the
source. Past incident: MR !60 review explicitly called out the `Any`-typed
`_make_stub_s3` test helper as a smell, and the initial fix attempt left
cascading ignores across a dozen call sites before the root cause was fixed.

**How to apply:** When pyright flags `reportAny` / `reportExplicitAny` /
`reportUnknownMemberType` / `reportUnknownVariableType`, prefer in order:

1. A domain `dataclass`, `TypedDict`, or `Protocol` that accurately models the
   shape.
2. A typed stub class implementing the subset of the interface the code
   actually uses.
3. `typing.Self` for `classmethod` returns that construct an instance of the
   enclosing class.
4. `cast(T, value)` at a single, narrow boundary (e.g. handing a `MagicMock`
   to production code typed as `S3Client`) so ignores stay localised.

Only resort to `# pyright: ignore[<rule>]` when the type genuinely cannot be
expressed — e.g. accessing a non-required `TypedDict` key (`["S"]` on
`AttributeValueTypeDef`). Always pair the ignore with a one-line comment
explaining why.

The canonical correct examples in this repo are `_item_to_entry` in
`audit_logging.py` and `response_to_request` in `request_repository.py`.
