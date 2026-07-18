---
name: pre-pr-review
description: >
  Use before creating, publishing, or handing off a pull request to decide
  whether the current branch is ready. Performs a rigorous diff-first PR gate
  for correctness, tests, architecture, maintainability, documentation, safety,
  release readiness, and technical debt. Uses repo-local project facts from
  AGENTS.md and .agents/facts/*.md for project-specific review areas, required
  context, validation commands, roadmap closure, and safety rules; captures or
  proposes missing pre-PR facts when a project lacks them.
---

# Pre-PR Review

Use this skill before creating, publishing, or handing off a pull request.

The purpose is to answer one question: is it responsible to create a PR for
the current branch now?

## Project Facts

Before relying on repo-specific PR policy, validation, docs, safety, release,
or roadmap rules, read:

1. `AGENTS.md`
2. `.agents/facts/pre-pr-review.md`
3. `.agents/facts/git.md`, `.agents/facts/testing.md`,
   `.agents/facts/docs.md`, `.agents/facts/roadmap.md`,
   `.agents/facts/release.md`, `.agents/facts/architecture.md`,
   `.agents/facts/product.md`, and detected language facts when relevant
4. repository structure, docs, package files, scripts, and CI config when facts
   are missing

Use `.agents/facts/pre-pr-review.md` for project-specific details such as:

- whether the gate is mandatory and its exact boundary
- project-specific scope categories and domain risk areas
- required docs, specs, package comments, or planning artifacts to read
- project helper scripts for git state, validation summaries, or PR readiness
- complex-change triggers that require an ExecPlan, design note, or spec
- roadmap, brief, changelog, release, or planning-doc closure rules
- security, privacy, secret-redaction, destructive-action, and persistence rules
- validation commands and external prerequisites to check or skip

If pre-PR facts are missing, infer only what is needed for the current review
from existing repository evidence. If the same project-specific detail becomes
useful more than once, propose adding it to `.agents/facts/pre-pr-review.md`.
When the user asks to capture project setup or when the missing facts block a
reliable PR gate, create or update the facts before continuing unless the user
asked for review-only output.

Do not invent PR, roadmap, release, validation, or safety policy. If policy is
missing from both facts and established repository structure, ask to run
`repo-setup` or create the relevant fact file first.

## Mandatory Gate

Complete this gate before opening or publishing a PR. If project facts require
the gate before staging, committing, pushing, or another handoff point, honor
the stricter project rule.

Do not treat passing tests, release checks, build scripts, visual smoke checks,
or CI status as a substitute for this review. They are validation inputs, not
the PR readiness decision.

Before declaring readiness:

1. Read and apply `find-tech-debt`.
2. Read and apply `structural-refactorer`.
3. Read and apply `document-code-boundaries` for every review with a code,
   test, fixture, package, module, service, or component surface.
4. Read and apply `frontend-ui` when the review includes browser UI, frontend
   behavior, components, styling, design tokens, or browser tests.
5. Inspect the committed branch diff and any relevant uncommitted diff.
6. Apply project-specific scope and context from `.agents/facts/`.
7. Run the roadmap, release, and planning closure audit required by project
   facts.
8. Classify findings using this skill's readiness levels.
9. Fix all `Blocking` findings, or stop before PR creation.
10. Re-run targeted validation for any fixes made during the review.
11. End with `PR gate: pass`, `PR gate: pass with accepted risk`, or
   `PR gate: fail`.

If a PR is docs-only or otherwise has no implementation surface, still record
the tech-debt and structural-refactor checks explicitly and mark code quality
portions as not applicable with a short reason.

## Default Mode

Review only by default.

Do not edit files, stage files, commit, push, or create a PR unless the user
explicitly asks for that action after the review findings are known.

If the user asks to "fix before PR" or similar, first complete the review,
then make the smallest safe set of fixes for blocking findings. Preserve
observable behavior unless the user explicitly approves behavior changes.

## Relationship To Other Skills

Always use `safe-git-pr-workflow` for repository-tracked file changes and PR
operations.

When both skills are active, finish this review gate before opening or
publishing a PR. `safe-git-pr-workflow` governs branch, commit, push, and PR
operations.

Read and apply `find-tech-debt` for every pre-PR review. Keep the current diff
as the center of gravity. For tiny or docs-only PRs, a lightweight debt pass is
acceptable, but the result must still be recorded.

Read and apply `structural-refactorer` for every pre-PR review that includes
code, tests, fixtures, scripts, generated assets, package boundaries, API
contracts, or UI behavior. For docs-only PRs, record that there is no
implementation surface to assess.

Read and apply `frontend-ui` for every pre-PR review that changes browser UI,
frontend behavior, component structure, styling, design tokens, or browser
tests. Include its reuse and UI-architecture audit in the readiness decision.

Read and apply `document-code-boundaries` for every review with architectural
code units or changes that may affect their ownership. Missing facts do not
block its self-contained defaults. Keep untouched legacy gaps as migration
debt, but enforce its blocking classifications for new and touched units.

Read and apply `release-checks` for PRs that prepare a release candidate, touch
packaging, changelog or release notes, versioning, release governance, hosted
release workflows, artifact generation, publish/tag behavior, support
boundaries, compatibility policy, or release-blocker policy. If `release-checks`
blocks because required release facts are missing, treat that as a PR readiness
blocker rather than inferring release policy from repository evidence.

Pre-PR review overrides their defaults:

- keep the current diff as the center of gravity
- do not automatically edit roadmap or debt-tracking files during review-only
  passes
- when using `find-tech-debt`, report broader debt as `Can track` or `Watch`;
  record it only after the user approves follow-up documentation changes
- classify findings by PR readiness, not only by long-term debt severity
- prefer fixing blockers in the current PR over broad cleanup
- track broader debt only when it is meaningful and the user agrees

## Git Orientation

Before reviewing, determine the branch and base. Use project helper scripts
declared in facts first, then raw git commands for missing details:

```bash
git status --short --branch
git branch --show-current
git remote show origin
```

In the managed Codex sandbox, remote git commands may fail with DNS errors or
`.git/FETCH_HEAD` permission errors. If branch or base discovery requires
remote state, rerun the same git command once with a narrow escalation request
rather than repeatedly probing from inside the sandbox.

If the user does not specify a base branch, compare against the remote default
branch. For local review, use the merge base between the current branch and
`origin/<default-branch>`.

Then inspect:

```bash
git diff --stat <base>...HEAD
git diff --name-only <base>...HEAD
git status --short
```

If there are uncommitted changes, include both committed branch diff and
working-tree diff in the review. Clearly distinguish unrelated dirty files from
files relevant to the PR.

If the base branch cannot be determined, ask the user for the intended PR base
before continuing.

## Fact Capture

When `.agents/facts/pre-pr-review.md` is missing and the user asks to capture
project-specific review behavior, create it with durable, present-tense facts.
Mark unknowns with `Decision needed:` instead of guessing.

Use this compact shape:

```markdown
# Pre-PR Review Facts

- Gate boundary: ...
- Project-specific scope categories: ...
- Required context: ...
- Planning and roadmap closure: ...
- Validation commands: ...
- Safety and security checks: ...
- External prerequisites and skipped-validation policy: ...
- Final response or PR readiness quirks: ...
```

Capture facts from evidence such as `AGENTS.md`, README files, docs, specs,
roadmaps, plans, package comments, scripts, CI config, existing PR helpers, and
the current code layout. Keep completed history, stale branch names, and one-off
implementation notes out of facts.

## Scope Classification

Classify changed files using project-specific categories from facts. When no
project categories exist yet, start with these generic areas and refine from
the repository:

- CLI, UI, API, command behavior, flags, help, output, or exit codes
- domain parsing, validation, business rules, workflow state, or report output
- storage, database, provider, external-service, filesystem, or network IO
- config, environment variables, local state, credentials, or persistence
- docs, specs, roadmap, changelog, release governance, or command references
- tests, fixtures, development scripts, CI, packaging, or generated assets
- security-sensitive behavior, secrets, destructive actions, or permissions

Use the classification to choose targeted docs, package comments, tests,
fixtures, validation commands, and safety checks.

## Required Context

For every review, read the current repository guidance declared by facts. If
facts are incomplete, inspect established repository docs before relying on
defaults.

Common context sources include:

- `README.md`
- `AGENTS.md`
- product, architecture, coding-standard, testing, roadmap, release, and docs
  facts
- relevant specs, plans, roadmap item briefs, changelog entries, and release
  governance docs
- canonical boundary documents for touched units and adjacent candidate owners
- helper scripts and CI workflows used for validation

For complex features, major refactors, external integrations, persistence,
credential handling, destructive-action policy changes, output contracts,
exit-code contracts, packaging, release changes, or project-specific risk areas
declared by facts, check whether an ExecPlan, design note, or spec was
required. If required and absent, report that as a PR readiness finding.

## Review Gates

Review the diff for each gate below. Findings must be grounded in changed
files, affected routines, package boundaries, tests, docs, project facts, or
observed command output.

### Correctness

- changed behavior matches the request, spec, roadmap item, or documented
  intent
- user-facing output follows project tone, hierarchy, and contract rules
- errors are returned, classified, redacted, and surfaced at the right boundary
- cancellation, timeouts, and abort paths are preserved for long-running IO
- resource lifecycles are explicit for files, responses, rows, connections,
  subprocesses, goroutines, browser/server state, and other project resources
- invalid states are hard to represent or are rejected early
- edge cases and failure modes are handled deliberately

### Architecture And Maintainability

- command handlers, UI handlers, API handlers, and process entrypoints stay thin
- parsing, validation, IO, output formatting, storage, and business rules are
  separated
- package, module, component, or service responsibilities remain consistent
  with project facts
- canonical boundary documents exist for new and touched hand-written units,
  remain concise, and agree with implemented ownership, exclusions, adjacent
  owners, and dependency direction
- interfaces stay small and live near consumers
- provider-specific, dialect-specific, platform-specific, or transport-specific
  behavior stays behind the appropriate boundary
- no new broad type switch, hidden state machine, or fallback path appears
  without ownership, tests, and tracking
- duplication is removed only when the helper reduces real maintenance cost
- temporary compatibility or scaffold paths are justified and tracked

For browser UI changes, also verify:

- affected routes reuse established primitives, shared patterns, layouts,
  tokens, hooks, helpers, API boundaries, and UI-state conventions
- route and page components remain focused on data/workflow orchestration and
  composition rather than owning alternate visual or interaction systems
- repeated semantic visual or interaction contracts have one clear owner;
  intentional local duplication has a concrete difference in semantics,
  lifecycle, or dependency boundary
- variants, slots, and composition preserve coherent component APIs instead of
  accumulating page-specific flags or copied forks
- repeated CSS declarations and raw visual values use the established token,
  theme, utility, or component-variant owner
- loading, empty, error, validation, permission, and confirmation states stay
  consistent across affected screens

### Code Quality, Tech Debt, And Refactoring

This gate is required for every PR review.

- `find-tech-debt` has been applied to the current diff and relevant dirty files
- `structural-refactorer` has been applied to changed implementation surfaces,
  or marked not applicable for docs-only changes
- no new "works for now" code, hidden state machine, broad fallback path, or
  stale compatibility branch is introduced without tests and tracking
- no helper, parameter, interface, component, or package boundary was added
  speculatively after the final implementation shape changed
- duplicated behavior is either intentionally local or replaced by an existing
  project helper when that reduces real maintenance cost
- duplicated page-local UI introduced across a new or substantially changed
  multi-screen flow is `Blocking`; a contained duplicated UI contract is at
  least `Should fix` unless the diff demonstrates why sharing would couple
  different semantics or lifecycles
- broader debt is classified as `Can track` or `Watch`; it must not obscure a
  current-PR `Blocking` or `Should fix` finding

### Tests

- changed behavior has practical regression coverage
- parsers, validators, command dispatch, completion, formatting, API contracts,
  and output variants use table-driven or equivalent coverage where useful
- state machines have transition tests, not only final-state tests
- output contract changes update golden tests, snapshots, or equivalent
  assertions
- error paths, boundary inputs, cancellation, empty inputs, ambiguous inputs,
  and provider or platform variants are covered when relevant
- tests use temporary directories, fakes, fixtures, and in-memory IO instead of
  live dependencies where possible
- bug fixes include a regression test unless there is no practical test surface

### Documentation And Contracts

- `document-code-boundaries` has been applied to new and touched architectural
  units, or marked not applicable for changes without such a surface
- new units have their required canonical boundary documents
- responsibility or dependency changes update every affected boundary document
- missing documents in untouched legacy units are recorded as non-blocking
  migration debt rather than expanding the current PR
- user-facing behavior changes update user docs and command references
- API, CLI, config, safety, output, persistence, release, or report contract
  changes update specs or developer docs
- roadmap items, briefs, plans, and facts reflect completed, deferred, or
  changed scope according to project policy
- active roadmap indexes remain current planning surfaces, not completed-task
  logs or implementation journals
- completed, stale, deferred, or superseded plans and briefs are deleted,
  preserved, or moved only according to project facts
- changelog or release notes are updated for notable user-facing, release,
  safety, compatibility, packaging, support-policy, or validation changes when
  project facts declare a changelog policy
- docs describe implemented behavior, not aspirational behavior unless clearly
  marked planned

### Safety And Security

- raw secrets are not logged, stored, printed, persisted, exposed in fixtures,
  or committed
- endpoints, connection strings, passwords, tokens, and secret sources remain
  redacted in errors, diagnostics, history, dry-run output, reports, saved
  files, and generated artifacts
- destructive actions require explicit user intent and keep dry-run,
  confirmation, rollback, or review behavior where applicable
- script, prompt, plugin, provider, or file resolution remains transparent;
  ambiguous definitions are not silently run
- overwrite behavior remains explicit and documented
- local servers, notebooks, browsers, IPC, and background jobs remain scoped,
  bounded, and protected according to project facts

### PR Hygiene

- branch is not the remote default branch
- changed files belong together as one coherent PR
- unrelated dirty files are identified and excluded from review conclusions
- generated files, embedded assets, fixtures, docs, and tests are consistent
- formatting has been applied where appropriate
- validation is strong enough for the blast radius

## Finding Levels

Use PR readiness levels:

- **Blocking**: PR should not be created until fixed.
- **Should fix**: PR can proceed only if the user explicitly accepts the risk.
- **Can track**: acceptable for PR if captured as a roadmap or debt follow-up,
  or explicitly acknowledged.
- **Watch**: real smell or uncertainty, but not enough evidence or payoff for
  action now.

When a finding is also technical debt, optionally include the `find-tech-debt`
severity and timing:

- Severity: High, Medium, or Low
- Timing: Fix now, Track, or Watch

## Validation

Run the narrowest useful validation first, then broaden before declaring a PR
ready.

Validation commands support the review result, but they do not replace the
mandatory code quality, tech-debt, and refactoring gates.

Prefer project scripts and helpers declared in facts. Common examples include:

```bash
scripts/agent/validation-summary.sh --diff-check
scripts/format.sh
scripts/build.sh
scripts/check.sh
```

For language-specific tests, follow the relevant language skill and project
facts. For Go in Codex, use a writable cache for raw commands, for example
`GOCACHE="$PWD/.cache/go-build" go test ./internal/app -count=1`.

Docker-backed validation, browser automation, integration tests, live network
calls, local model calls, or external-service checks should be run only when
required by scope or requested by the user. Check prerequisites first when
availability is unclear, and record unavailable prerequisites as skipped
validation rather than retrying sandboxed commands.

For docs-only skill or markdown changes, lightweight validation may be enough:

```bash
rg "new skill or item name" .agents docs
git diff --check
```

Do not claim `Ready for PR` if material validation was skipped, failed, or
could not run. Use `Ready with noted risks` only when the remaining risk is
minor and explicit.

## Fix Mode

When the user asks to fix findings:

1. Fix only `Blocking` and user-approved `Should fix` items.
2. Keep changes scoped to the PR's purpose.
3. Add or update tests before refactoring parsers, state machines, renderers,
   provider boundaries, safety behavior, persistence, or public contracts.
4. Preserve observable behavior unless the user approves behavior changes.
5. Re-run targeted validation after each coherent fix.
6. Re-run the pre-PR review summary before declaring readiness.

Do not use pre-PR review as permission for broad opportunistic cleanup.

## Final Response

Use this format:

```markdown
**Verdict:** Ready for PR | Ready with noted risks | Not ready for PR

**Blocking Findings**
1. **Title**
   - **Where:** `path/package`, routine or command names
   - **Problem:** ...
   - **Why it blocks PR:** ...
   - **Required fix:** ...

**Should Fix**
...

**Can Track**
...

**Watch**
...

**Validation**
- Ran: ...
- Not run: ...
- Result: ...

**Quality/Debt/Refactor Gate**
- `find-tech-debt`: applied / not applicable because ...
- `structural-refactorer`: applied / not applicable because ...
- `frontend-ui`: applied / not applicable because ...
- `document-code-boundaries`: applied / not applicable because ...
- Fix-now items: ...
- Can track / Watch items: ...

**PR Readiness**
- Scope: coherent / mixed
- Tests: sufficient / incomplete
- Docs: sufficient / incomplete / not needed
- Security: clear / risk noted
- Architecture: clear / risk noted
- Debt: none added / tracked / unresolved
```

If there are no findings in a section, say `None`.

End with the exact gate result:

- `PR gate: pass`
- `PR gate: pass with accepted risk`
- `PR gate: fail`

Only create a PR after `PR gate: pass`, or after the user explicitly accepts
all remaining `Should fix` and `Can track` items.
