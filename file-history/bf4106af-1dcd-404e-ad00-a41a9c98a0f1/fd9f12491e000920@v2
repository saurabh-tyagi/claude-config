---
name: feedback_sam_skill_style_rule
description: "When working on SAM templates, use only recently-modified templates as the style reference; do not blindly follow older ones"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: bf4106af-1dcd-404e-ad00-a41a9c98a0f1
---

When authoring or editing SAM templates in dns-de-automation, use only templates modified in the last 6 months as the style reference. Cross-check against AWS SAM official documentation. Do not blindly follow older templates (python3.8, dns-de- prefix, missing tags, etc.).

**Why:** user explicitly asked 2026-05-21 — the repo has years of style drift and older templates should not be treated as canonical.
**How to apply:** every time the sam-template skill runs; re-derive the 6-month corpus when the stale date (2026-11-21) is reached.
