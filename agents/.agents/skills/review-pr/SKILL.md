---
name: review-pr
description: Use when reviewing a GitHub pull request with the user.
---

Use `show-me` to explain the changes and their practical scope. Leave room for the user's questions and concerns to guide the review.

Investigate concerns before endorsing them. Keep discussion separate from feedback the user has chosen to leave.

Write comments as directives for the implementing agent: the requested change, why it matters, and any essential constraints. Prefer inline comments. Distinguish blocking changes from optional polish.

Publish agreed feedback when the user asks. A direct instruction to post is sufficient authorization; do not add another approval round. Submit the comments together as one review, anchored to the current diff.

Use a `COMMENT` review for conditional approval. Reserve `APPROVE` for approval without outstanding changes. `REQUEST_CHANGES` is reserved for serious blocking findings.

Share the review URL after successful publication.
