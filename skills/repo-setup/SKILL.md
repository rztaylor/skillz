---
name: repo-setup
description: >
  Use when creating or restructuring a repository foundation, bootstrapping
  repo-local facts, project documentation, helper scripts, CI/release
  scaffolding, or development workflow. Language-aware: uses repo-local project
  facts from AGENTS.md and .agents/facts/*.md, applies the standard new-project
  foundation for brand-new repos, detects the project stack, and loads matching
  references such as references/go.md before applying language-specific
  defaults.
---

## Project Facts

Before relying on repo-specific layout or workflow policy, read:

1. `AGENTS.md`
2. `.agents/facts/repo-setup.md`
3. `.agents/facts/architecture.md`, `.agents/facts/docs.md`,
   `.agents/facts/release.md`, `.agents/facts/frontend-ui.md` for frontend
   foundations, and detected language facts such as `.agents/facts/go.md` when
   relevant
4. repository structure, package-manager files, and scripts when facts are
   missing

If a setup, layout, language, docs, or release fact is repeatedly useful,
propose adding it to the appropriate `.agents/facts/` file.

When this skill is active:
- classify the repository before changing durable structure:
  - brand-new or sparse: no established docs, facts, source layout, or workflow
  - existing: source layout, docs, scripts, package-manager files, or facts
    already establish project conventions
  - standardization request: the user explicitly asks to adopt the shared
    project foundation in an existing repository
- for a brand-new or sparse repository, read
  `references/default-project-foundation.md` before creating facts, docs,
  roadmap, planning, changelog, release, or git workflow files
- for an existing repository with missing facts, create or update facts that
  describe the current repository before changing durable structure; propose a
  standardization plan before moving existing docs or workflow files
- when another skill needs durable docs, roadmap, release, validation, or layout
  policy and neither facts nor established structure exist, bootstrap the
  relevant facts first using this skill
- infer the project stack from project facts and repo files such as
  `go.mod`, `package.json`, `pyproject.toml`, `Cargo.toml`, `pom.xml`,
  `build.gradle`, `Makefile`, `Dockerfile`, frontend folders, and existing
  scripts
- read and apply `document-code-boundaries` when creating or restructuring
  packages, modules, crates, services, feature components, or other code
  ownership boundaries; its defaults apply even when project facts are absent
- load the relevant language reference before applying language-specific
  defaults:
  - Go: `references/go.md`
  - for unsupported stacks, follow the existing project conventions and avoid
    inventing language-specific layout rules; add a new reference only when the
    user asks or repeated work justifies it
- if project facts are missing, infer carefully from package-manager files,
  source layout, and scripts; create or propose `.agents/facts/<domain>.md`
  before scattering durable project facts across multiple skills or docs
- preserve any root repository layout described by project facts
- use documentation paths declared in `.agents/facts/docs.md`; when absent,
  inspect the repository and propose adding docs path facts before creating new
  documentation trees
- place language entrypoints, packages, modules, tests, and generated assets
  according to the loaded language reference or established project layout
- record project-specific architectural-unit definitions, boundary-document
  filenames, exemptions, size limits, and validation commands in
  `.agents/facts/architecture.md`; do not require facts merely to use the
  shared defaults
- add or update helper scripts in `scripts/` when repeated validation or release
  commands become part of the workflow
- when creating or changing release foundations, write the release facts that
  `release-checks` requires before relying on release validation, packaging, or
  publish behavior
- keep frontend, server, plugin, or desktop scaffolding aligned with the project
  facts; do not assume every repository is CLI-only
- when creating or restructuring a frontend foundation, read and apply
  `frontend-ui`; record component-layer locations and dependency direction,
  token/theme ownership, styling mechanism, application shell and shared
  layouts, component variant conventions, shared UI-state patterns, API/state
  boundaries, and component-test or story tooling in
  `.agents/facts/frontend-ui.md`
- add repo-local lint, style, or import-boundary checks only when the selected
  stack supports reliable enforcement; record the commands and scope in facts
- update the coding-standards document declared in project facts when
  foundational tooling or required checks change
- add a curated changelog entry for notable foundational, release, safety,
  compatibility, packaging, support-policy, or validation changes when project
  facts declare a changelog policy; otherwise state why no changelog update is
  needed or why no changelog location is declared
- update the release-governance document declared in project facts when
  foundational workflow, validation, packaging, versioning, release, or support
  policy changes alter release governance

## Standard Foundation

Use `references/default-project-foundation.md` only for brand-new or sparse
repositories, or when the user explicitly asks to standardize an existing repo.
After applying those defaults, write the resulting paths and policies into
`.agents/facts/` so other skills can rely on repo-local facts instead of shared
skill defaults.

## Release Foundation

Use this section when creating or restructuring release policy, release facts,
release validation scripts, package artifacts, changelog/release-note flow, or
hosted publish workflows.

`repo-setup` owns creating and restructuring the release foundation.
`release-checks` owns auditing readiness against that foundation. Do not bury
release policy in shared skills or one-off prompts.

Create or update `.agents/facts/release.md` before adding release automation.
Capture:

- release maturity, versioning, tag format, and support boundaries
- changelog and release-note locations and style
- release-governance, blocker policy, known-limits, and migration-note paths
- default validation and release-candidate validation commands
- external prerequisites and skipped-validation policy
- artifact targets, archive/package naming, checksums, signing, notarization,
  SBOM, or attestation decisions
- hosted release workflow path, trigger rules, publish conditions, permissions,
  and required secrets
- manual release, prerelease, re-run, rollback, and failure handling rules

When adding GitHub Actions, package registry publishing, GitHub Releases,
container publishing, installers, or other hosted release automation:

- keep workflow permissions as narrow as practical
- make tag and manual-publish behavior explicit
- generate release notes from the declared source rather than raw commit logs
- generate checksums or signatures when facts require them
- make artifact retention, clobber/re-run behavior, prerelease handling, and
  target platforms visible in facts and release-governance docs
- avoid requiring live credentials for ordinary local validation

For established repositories, first capture the current release behavior in
facts, then propose any standardization or automation changes separately.

## GitHub Repository Bootstrap

Use this section when configuring a new or existing GitHub repository for
the project's development workflow.

Before using `gh` for repository settings:

- Ask the user for explicit permission to use the local `gh` CLI and define the
  exact repository scope, for example `owner/repository`.
- Do not ask the user to paste tokens, passwords, or PATs into chat. Prefer
  credentials already configured on the machine, or ask the user to run
  `gh auth login` themselves if `gh auth status` shows no usable session.
- Verify the authenticated account can administer the target repo with
  `gh repo view <owner>/<repo> --json viewerCanAdminister,viewerPermission`.
- Treat comparison repositories as read-only unless the user explicitly
  authorizes mutation of that exact repository.
- Never mutate a repository whose `owner/name` does not exactly match the
  approved target.

For a brand-new or empty GitHub repository:

- Confirm the intended default branch, normally `main`.
- Fetch and inspect local/remote state per `safe-git-pr-workflow`.
- If the remote has no usable default branch or `origin` HEAD is unknown,
  inspect the local files before bootstrapping:
  - list files with `rg --files -uu -g '!.git/**'`
  - scan for likely secrets, credentials, cookies, tokens, and private keys
  - stage only intended bootstrap files
- Create the initial `main` commit only after the file and secret scan looks
  clean, then push `main` and set it as the remote default branch.

Recommended repository settings for a small private repository:

- `default_branch`: `main`
- `delete_branch_on_merge`: enabled
- issues and projects: enabled when useful for roadmap work
- wiki and discussions: disabled unless the project explicitly needs them
- Actions: enabled
- workflow token default permission: read-only
- Actions may not approve pull requests
- Dependabot vulnerability alerts: enabled
- Dependabot security updates: enabled

Add `.github/dependabot.yml` when dependency or workflow updates should be
managed by pull request. Choose package ecosystems from detected package
manager files and the loaded language reference. Include `github-actions` when
Actions are used, and keep a small `open-pull-requests-limit`.

Prefer repository rulesets for default-branch protection when GitHub allows
them. If rulesets are unavailable, try classic branch protection. Target
`main` with:

- require pull requests before merge
- require at least one approval once collaborators exist
- dismiss stale reviews
- require conversation resolution
- block force pushes and deletions
- add required status checks only after the relevant CI jobs exist and are
  stable

For private repositories on plans where rulesets or branch protection are
gated, record the exact GitHub error and continue with the supported settings.
Do not silently claim branch protection was configured when GitHub returned a
plan or permission error.
