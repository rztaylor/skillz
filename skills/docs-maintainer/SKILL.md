---
name: docs-maintainer
description: Use when adding or updating project docs, specs, decisions, implementation plans, planning-docs housekeeping, command or local-server references, configuration docs, release governance, changelog entries, or release notes. Uses repo-local project facts from AGENTS.md and .agents/facts/*.md when present.
---

# Docs Maintainer

## Project Facts

Before relying on repo-specific documentation paths or policy, read:

1. `AGENTS.md`
2. `.agents/facts/docs-maintainer.md`
3. `.agents/facts/architecture.md`, `.agents/facts/docs.md`,
   `.agents/facts/release.md`, and `.agents/facts/planning.md` when relevant
4. repository structure and scripts when facts are missing

If a docs, release, or planning fact is repeatedly useful, propose adding it to
the appropriate `.agents/facts/` file.

If a documentation, plan, changelog, release, or decision-log location is
missing from both facts and established repository structure, do not invent
it. Ask to run `repo-setup` or create the relevant fact file first.

This location gate does not block the self-contained canonical code-boundary
defaults in `document-code-boundaries`; those files live with the code units
they document rather than in a project documentation tree.

Do not assume default locations for user docs, developer docs, specs, plans,
release governance, decision logs, or changelogs. Use the locations and
policies declared in project facts or already established by the repository.

## What Belongs In The Repository

Repository docs hold durable truth: product scope and direction, specs,
architecture and boundary docs, decisions, user and developer docs, command
and configuration references, the changelog, and release governance.

Day-to-day work lives on the Flashheart board, not in repository docs. Do not
write or extend roadmap indexes, roadmap-item briefs, backlogs, feature or bug
lists, idea lists, TODO lists, or debt registers in the repository. Create or
update tickets through the `flashheart` skill instead, or, when its tools are
unavailable, list the follow-ups in the response or PR body. User-facing
"known limitations" in user docs or release notes are documentation, not a
backlog, and stay.

If the repository still has a legacy roadmap index or briefs, do not extend
them; offer the planning migration in `repo-setup`.

## When This Skill Is Active

- keep docs grounded in current repository state
- update docs when commands, flags, local-server behavior, API shape, output
  formats, config, file safety behavior, packaging, or architecture change
- follow user-doc, reference-doc, syntax, and example style rules declared in
  project facts before editing user-facing documentation
- route content to the user, developer, reference, spec, plan, release, or
  decision locations declared in project facts; when a location is missing,
  inspect the existing repository structure and propose adding the fact before
  creating a new durable docs tree
- read and apply `document-code-boundaries` when package, module, service, or
  component responsibilities, boundaries, or ownership move; keep canonical
  boundary documents concise and prevent API inventories, examples, history,
  planning, setup guidance, or implementation detail from accumulating there
- keep product direction short and durable in the location declared in project
  facts, normally a Direction section of the product doc; concrete sequencing
  belongs in Flashheart workstream and ticket dependencies
- when a ticket, brainstorm, or review produces a durable product,
  architecture, compatibility, or keep/reject decision, record it in the
  declared decision log; the board is not in git, so rationale that only lives
  on a ticket is lost to other checkouts, CI, and collaborators
- add a curated changelog entry for notable user-facing, release, safety,
  compatibility, packaging, support-policy, or validation changes when project
  facts declare a changelog policy; otherwise state why no changelog update is
  needed or why no changelog location is declared
- user docs should show friendly default examples that lead with outcomes,
  recovery paths, and next actions; keep low-level internals in
  inspection/detail docs unless they are the user's immediate decision point
- use Keep a Changelog categories: `Added`, `Changed`, `Deprecated`,
  `Removed`, `Fixed`, and `Security`; write curated entries, not raw commit
  subjects
- when a change adjusts versioning, support boundaries, release blockers, or
  changelog policy, update the release-governance and durable decision
  locations declared in project facts
- document secret handling and destructive-action behavior where relevant
- avoid documenting planned behavior as implemented unless the status is explicit

## Implementation Plans

Detailed implementation plans, such as ExecPlans, are short-lived repository
files. They never go into Flashheart.

- use the plan location, naming, and complex-change triggers declared in
  `.agents/facts/planning.md`; name each plan after its ticket, such as
  `<ticket-id>-short-kebab-title.md`, and link the plan path in a ticket note
- keep acceptance criteria, status, and follow-ups on the ticket; the plan
  holds only the detailed steps, design notes, and validation approach needed
  to implement it
- delete the plan once the ticket's work is done and any durable decisions,
  implemented behavior, validation requirements, and follow-up work have moved
  into durable docs or follow-up tickets
- delete stale or abandoned plans; keep a plan only while it is active

## Planning Docs Housekeeping

Housekeeping is part of ordinary documentation maintenance, not a separate
someday cleanup bucket:

- keep `.agents/facts/` present-tense and policy-oriented; do not store project
  history, completed migration notes, stale branch strategy, task lists, or
  implementation journals there
- move completed outcomes, durable rationale, compatibility decisions, and
  release-impact summaries into the changelog, specs, decisions, release
  governance, or user/developer docs as appropriate
- delete completed or stale implementation plans as described above
- before finishing a PR or docs-maintenance pass, search docs and facts for
  stale branch names, completed implementation history, task or bug lists that
  belong on the board, obsolete command names, superseded architecture, and old
  validation gates
