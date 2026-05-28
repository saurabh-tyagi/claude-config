---
name: feedback_sam_skill_style_rule
description: "When working on SAM templates in dns-de-automation, use only recently-modified templates as the style reference; do not blindly follow older ones"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 8ab8f42b-46cd-44cd-b864-c684692a2407
---

When authoring or editing SAM `template.yaml` files in `dns-de-automation`, use only templates modified in the last 6 months as the style reference. Cross-check against AWS SAM official documentation and use official best practices as the fallback where recent templates are silent. Do not blindly follow older templates (e.g. `python3.8`, `dns-de-` prefix, missing tags, inline `Policies:` blocks).

When editing an existing template, mirror its style choices (prefix, runtime, role-attachment style, tag keys) but flag deviations from the 6-month baseline with a one-line note — do not silently rewrite.

**Why:** User explicitly asked 2026-05-21 — the repo has years of style drift and older templates should not be treated as canonical.
**How to apply:** Every time the `sam-template` skill runs. Re-derive the 6-month corpus when the stale date (2026-11-21) is reached. [[sam_dns_de_conventions]]
