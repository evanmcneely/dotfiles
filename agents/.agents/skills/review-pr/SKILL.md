---
name: review-pr
description: Collaboratively review a GitHub pull request: explain its changes visually, investigate the user's concerns, publish directive inline feedback, record the review disposition, and add the Sandcastle label. Use when the user asks to review a PR or invokes /review-pr.
---

# Review PR

Review a pull request with the user. First make the changes understandable, then help the user reason through specific concerns, and finally publish the feedback they choose as a GitHub review.

## Authorization

- Discussion, questions, tentative concerns, and recommendations are not authorization to write to GitHub.
- A direct instruction such as “leave that comment,” “post these comments,” or “do it” authorizes publishing the feedback already settled in the conversation. Do not add another approval round.
- Do not publish concerns whose direction or wording remains unresolved.
- Add the `Sandcastle` label only after the review feedback has been published successfully.

## 1. Identify And Read The PR

Resolve the pull request from a supplied URL or number. If neither is supplied, look for an open PR from the current branch. Ask for a URL or number only when no PR can be resolved.

Gather:

- Repository owner and name.
- PR number, URL, title, body, author, base branch, head branch, and head commit SHA.
- Complete changed-file list and patch.
- Existing discussion comments, review summaries, and inline comments.
- Linked issues when they clarify the intended behavior.
- Relevant cascading `AGENTS.md` guidance and accepted project ADRs for the changed code.

Useful commands:

```bash
gh repo view --json owner,name
gh pr view PR_NUMBER --json number,url,title,body,author,baseRefName,headRefName,headRefOid,files,comments,reviews,labels
gh pr diff PR_NUMBER --patch
gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments --paginate
```

Read relevant unchanged code, callers, tests, and contracts as needed. Avoid duplicating feedback already present on the PR.

## 2. Explain The Changes

Load and follow the `show-me` skill. Give the user a concise visual explanation of:

- The problem the PR addresses.
- Before and after behavior.
- Important control flow, data flow, ownership, lifecycle, or interface changes.
- Tests and supporting infrastructure introduced by the PR.
- The practical production scope of the changes.

Choose only the diagrams or code-shape sketches needed to make the PR understandable. Then pause for the user's feedback and concerns; do not immediately perform a broad independent review.

## 3. Investigate Concerns With The User

Treat the user's feedback as either:

- **A requested change:** ground it in the implementation and sharpen it into an actionable instruction.
- **A concern or question:** trace the relevant architecture and behavior, explain the tradeoff, and recommend whether any change is warranted.

Investigate nearby code and tests before agreeing with a concern. Distinguish necessary mechanisms from incidental scope. Make ownership explicit when a concern mixes caller, callee, adapter, or lifecycle responsibilities.

Keep a working set of feedback the user has chosen to leave. Do not silently turn every concern raised during discussion into a review comment.

## 4. Write Directive Feedback

Write comments for the implementing agent, not as open-ended questions. Prefer imperative language such as:

- `Replace ...`
- `Remove ...`
- `Inline ...`
- `Document ...`
- `Preserve ...`

Each comment should contain:

- The specific requested change.
- A concise reason it matters.
- Relevant implementation constraints or validation expectations.

Do not use phrases such as “Could we” or “Would you consider.” Do not over-prescribe names or file layout unless project conventions or the user's direction require it. Separate blocking changes from optional polish.

Prefer an inline comment on a specific changed line. Use a PR-level comment only when feedback is genuinely cross-cutting or no suitable diff line exists.

## 5. Publish One Review

When the user authorizes publishing, first refresh the PR head SHA, patch, reviews, and inline comments. Check that each target is still current and that no equivalent feedback has appeared.

Submit the comments together as one review when possible:

```bash
gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews \
  --method POST \
  --input REVIEW_PAYLOAD_FILE
```

Write payload files under the approved temporary directory outside the repository.

For changed or added lines, use `line` with `side: RIGHT`. For removed lines, use `line` with `side: LEFT`. Include the refreshed `commit_id` in the review payload. Use a multiline range only when the complete range is represented in the diff.

```json
{
  "commit_id": "HEAD_SHA",
  "event": "COMMENT",
  "body": "Approved once the inline feedback is implemented. No further review is required for those changes.",
  "comments": [
    {
      "path": "path/to/file.go",
      "line": 123,
      "side": "RIGHT",
      "body": "Directive inline comment."
    }
  ]
}
```

Use a `COMMENT` review for conditional approval; do not submit a formal `APPROVE` while requested changes remain. Set the review body to the disposition agreed with the user:

- `Approved once the inline feedback is implemented. No further review is required for those changes.`
- `Further review is required after the inline feedback is implemented.`

If the user has not stated whether another review is required, ask this one question before publishing. Do not infer that blocking feedback is self-approving.

If an inline target is no longer commentable, find the nearest relevant changed line. If none exists, include the path and line reference in the review body rather than posting an unrelated standalone PR comment.

If submission partially fails, re-fetch reviews and comments before retrying so no feedback is duplicated.

## 6. Verify And Report

Re-fetch the review, inline comments, and labels. Report:

- PR URL and review URL.
- Number of inline and PR-level comments published.
- Review disposition.
- Whether the `Sandcastle` label was added.
-
