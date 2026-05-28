---
name: feedback_no_coauthored_by
description: Do not add Co-Authored-By Claude trailer to git commit messages
metadata: 
  node_type: memory
  type: feedback
  originSessionId: bf4106af-1dcd-404e-ad00-a41a9c98a0f1
---

Never include `Co-Authored-By: Claude ...` lines in git commit messages.

**Why:** user explicitly asked to remove it.
**How to apply:** every time a git commit is created in this repo — omit the Co-Authored-By trailer entirely.
