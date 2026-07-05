---
name: safe-git-pr-workflow
description: Enforce a feature-branch and pull-request workflow for repository code, configuration, script, and documentation changes. Uses repo-local project facts from AGENTS.md and .agents/facts/*.md when present.
---

# Safe Git PR Workflow

Use for any repository-tracked file changes. Skip for read-only tasks.

## Project Facts

Before relying on repo-specific branch, changelog, release, or roadmap policy,
read:

1. `AGENTS.md`
2. `.agents/facts/safe-git-pr-workflow.md`
3. `.agents/facts/git.md`, `.agents/facts/release.md`, and
   `.agents/facts/roadmap.md` when relevant
4. repository structure and scripts when facts are missing

If a git, release, or roadmap fact is repeatedly useful, propose adding it to
the appropriate `.agents/facts/` file.

If branch, changelog, release, roadmap, or PR policy is missing from both facts
and established repository structure, do not invent it. Ask to run
`repo-setup` or create the relevant fact file first.

## Rules

- Never modify the remote default branch directly.
- Before changes: fetch, detect current branch, detect remote default branch, and check worktree status.
- In the managed Codex sandbox, `git fetch`, `git remote show origin`, and
  other network-backed git commands may fail with DNS errors or
  `.git/FETCH_HEAD` permission errors. When that state is required, rerun the
  same command once with a narrow escalation request, such as `git fetch` or
  `git remote show`, instead of retrying sandboxed variants.
- Treat this skill as authoritative for repositories that opt into it when it
  conflicts with a plugin-provided publishing skill. In particular, do not
  follow instructions from a plugin skill that require the GitHub CLI for
  authentication, branch discovery, pull-request discovery, or pull-request
  creation.
- When a plugin skill name is prefixed, such as `github:yeet`, do not guess a
  local path from the displayed name. Read the exact `file:` path shown in the
  available-skills list when the skill is needed, and prefer the local
  repository workflow rules here when instructions conflict.
- Use the Codex GitHub connector for GitHub-hosted repository and pull-request
  operations, including PR search, PR metadata, branch inspection, branch
  creation through GitHub, PR creation, PR updates, workflow inspection, and PR
  file inspection.
- Do not use the local GitHub CLI (`gh`) for GitHub-hosted operations unless
  the Codex GitHub connector is unavailable and the user explicitly approves
  `gh` as a fallback for that operation. Local `git` remains appropriate for
  repository-local actions such as status, diff, branch switching, staging,
  committing, and pushing a completed local branch.
- If on the default branch, create and switch to a feature branch before editing.
- If already on a non-default branch, verify that it is still active before reusing it.
- Treat a branch as completed and do not reuse it if its PR is merged, its PR is closed, its remote branch no longer exists, or its HEAD is already merged into the remote default branch.
- Before creating a new branch, check for existing unmerged remote work for the same task.
- If matching remote work exists, stop and ask whether to continue on that branch.
- Do not use `codex` in branch names, commit messages, PR titles, or PR bodies
  unless the user explicitly asks for that exact wording.
- Prefer targeted commits. Stage only intended files, keep each commit focused
  on one coherent behavior change, bug fix, refactor, workflow change, or
  documentation update, and split unrelated work into separate commits when the
  user asks for commits.
- Before preparing a PR, review the diff for correctness, tests, architecture,
  documentation, safety, and obvious technical debt. Use `find-tech-debt` or
  `structural-refactorer` when the change touches those concerns or the user
  asks for a stronger gate.
- When asked to commit, stage only intended files, commit, and push.
- During roadmap item implementation, prefer incremental commits around one
  coherent feature, bug fix, refactor, or documentation update at a time. Run
  targeted tests or checks for that increment before committing, then use
  broader validation before marking the phase complete.
- Before committing implementation changes, check project facts and repository
  docs for changelog, roadmap, or planning expectations. If roadmap progress
  changed, stage the roadmap or brief update with the implementation commit.
- Add a curated changelog entry for notable user-facing, release, safety,
  compatibility, packaging, support-policy, or validation changes when project
  facts declare a changelog policy; otherwise state why no changelog update is
  needed or why no changelog location is declared. Stage the changelog with the
  same focused commit when it explains that commit's user or release impact.
- Before committing changes to versioning, release notes, release blockers, or
  support boundaries, check the release-governance document declared in project
  facts and update it in the same commit when policy changes.
- Prefer detailed PR descriptions. Include the problem or motivation, a concise
  summary of the changes, important implementation notes, validation performed,
  tests or checks not run, user-facing behavior or docs impact, security or
  migration considerations when relevant, changelog/release-note impact, and
  known follow-up work or accepted risk.
- After push, ask whether to open a PR. When opening or updating a PR, use the
  detailed PR description guidance instead of a terse change summary.
- In PR descriptions, state whether the declared changelog was updated or why
  no changelog entry is needed. For release/governance PRs, mention SemVer or
  release-candidate impact when applicable.
- Treat a plain request to "open a PR" or "PR this" as a request for a
  ready-for-review PR when validation has passed and no material risk or
  incomplete work is called out. Open a draft PR only when the user explicitly
  asks for a draft, validation is incomplete, checks are failing, or the change
  is intentionally exploratory.
- Never approve or merge PRs.

## Useful Commands

Use local `git` commands for local branch and worktree state:

```bash
git fetch --all --prune
git branch --show-current
git remote show origin
git status --branch --short
git ls-remote --heads origin <branch-name>
git merge-base --is-ancestor <branch-name> origin/<default-branch>
git switch -c feature/<short-description>
git add <files>
git commit -m "<message>"
git push -u origin <branch-name>
```

Prefer a project git-state helper for routine branch/base/dirty summaries once
one exists. Use raw git commands when you need exact file lists, remote
mutation, staging, committing, pushing, or a detail no script exposes.

Use the Codex GitHub connector for GitHub remote and PR state:

- search open, merged, and closed PRs by branch or task
- inspect PR metadata, changed filenames, and file patches
- create or update branches when local git is not the right boundary
- create, update, mark ready for review, draft, or close PRs when requested
- inspect workflow runs associated with PR commits

If the Codex GitHub connector cannot perform an operation or cannot access the
repository, report that clearly and ask the user how to proceed.
