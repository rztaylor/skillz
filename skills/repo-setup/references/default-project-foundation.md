# Default Project Foundation

Use this reference when `repo-setup` is initializing a brand-new or sparse
repository, or when the user explicitly asks to standardize an existing
repository around the shared project structure.

Do not apply these defaults silently to an established repository. If existing
docs, facts, scripts, or source layout already define conventions, write facts
that describe the current state first, then propose any migration separately.

## Required Foundation

Create or update these repository files early:

- `AGENTS.md`: broad repository guidance for Codex and other agents.
- `.agents/facts/product.md`: product name, audience, product shape, safety
  boundaries, and explicit unknowns.
- `.agents/facts/architecture.md`: current architecture, intended ownership
  boundaries, generated assets, data/storage locations, and integration points.
- `.agents/facts/docs.md`: documentation locations, style, and update policy.
- `.agents/facts/roadmap.md`: roadmap index, item brief, ExecPlan, status, and
  closure policy.
- `.agents/facts/testing.md`: validation commands, test boundaries, external
  service requirements, and local sandbox notes.
- `.agents/facts/release.md`: changelog, release-governance, packaging,
  support, compatibility, and versioning policy.
- `.agents/facts/git.md`: default branch, feature branch, PR, and commit
  policy.
- language facts such as `.agents/facts/go.md` when the stack is known.

Facts should distinguish decisions from unknowns. Use `Decision needed:` for
material choices that the user has not made yet. Do not bury project policy in
shared skills when it can be recorded in facts.

## Default Paths

Use this structure for new projects unless the user chooses otherwise:

- `README.md`: project orientation, installation, running, and primary
  workflows.
- `CHANGELOG.md`: curated user-facing and release-impact entries, with an
  `Unreleased` section.
- `docs/dev/roadmap.md`: active roadmap index and execution sequence.
- `docs/dev/roadmap-items/`: linked roadmap item briefs and preserved planning
  context.
- `docs/dev/plans/`: active ExecPlans and implementation plans.
- `docs/dev/specs/`: durable feature and API specs.
- `docs/dev/guides/`: contributor and implementation guides.
- `docs/dev/ops/`: development environment, validation, release, and security
  operations notes.
- `docs/dev/ops/release-governance.md`: versioning, release-candidate,
  support, compatibility, changelog, and release-blocker policy.
- `docs/dev/decisions.md`: durable product and architecture decisions.
- `docs/user/`: user-facing docs only when the project needs docs beyond the
  README.

Create `README.md` files inside docs directories only when they help navigate
real content or define a workflow. Empty directories do not need placeholder
files unless the repository cannot preserve empty directories and the directory
is immediately useful.

## Roadmap Defaults

For new projects that need roadmap tracking:

- Keep the roadmap index small: direction, active items, execution order,
  dependencies, and status.
- Put detailed scope, acceptance, context, and hardening notes in linked item
  briefs.
- Use short, unique, kebab-case text IDs. Avoid phase numbers as durable IDs.
- Use active statuses `Pending`, `Partial`, and `Blocked`.
- Use `Done` only as a short transition while moving durable outcomes into
  long-lived docs, then remove completed items from the active roadmap.
- Keep preserved briefs outside the active execution sequence.

## ExecPlan Defaults

For new projects that use ExecPlans:

- Store active plans in `docs/dev/plans/`.
- Use filenames like `NNN-short-kebab-title.md`, where `NNN` is a zero-padded
  incrementing identifier.
- Before creating a plan, list existing plans, choose one greater than the
  highest identifier, and do not renumber existing plans.
- Delete completed or stale plans after durable decisions, implemented
  behavior, validation requirements, and follow-up work have moved to the
  appropriate long-lived docs.

## Changelog And Release Defaults

For new projects:

- Use `CHANGELOG.md` for user-facing, release, safety, compatibility,
  packaging, support-policy, and validation-impact changes.
- Keep entries curated. Do not paste raw commit subjects.
- Use Keep a Changelog categories: `Added`, `Changed`, `Deprecated`,
  `Removed`, `Fixed`, and `Security`.
- Record release policy in `docs/dev/ops/release-governance.md`.
- Record durable release, compatibility, and support decisions in
  `docs/dev/decisions.md` when they matter beyond one release.

## Git Defaults

For new projects:

- Use `main` as the default branch unless the user chooses otherwise.
- Use feature branches and pull requests for repository changes.
- Keep commits focused on one coherent behavior, refactor, workflow, or docs
  change.
- Stage facts, roadmap, changelog, or release-governance updates with the code
  change they explain.

## Language Defaults

Detect the stack from package-manager files and source layout. When a language
reference exists, load it before creating language-specific layout. For Go,
load `references/go.md` and then write `.agents/facts/go.md` with the chosen
entrypoints, packages, generated assets, and validation commands.

For unsupported stacks, create only generic facts and follow obvious ecosystem
conventions from the files present. Add a new language reference after repeated
work proves the convention is reusable.
