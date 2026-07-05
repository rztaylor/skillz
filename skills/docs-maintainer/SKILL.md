---
name: docs-maintainer
description: Use when adding or updating project docs, specs, plans, command or local-server references, configuration docs, release governance, changelog entries, or release notes. Uses repo-local project facts from AGENTS.md and .agents/facts/*.md when present.
---

# Docs Maintainer

## Project Facts

Before relying on repo-specific documentation paths or policy, read:

1. `AGENTS.md`
2. `.agents/facts/docs-maintainer.md`
3. `.agents/facts/docs.md`, `.agents/facts/release.md`, and
   `.agents/facts/roadmap.md` when relevant
4. repository structure and scripts when facts are missing

If a docs, release, or roadmap fact is repeatedly useful, propose adding it to
the appropriate `.agents/facts/` file.

If a documentation, roadmap, plan, changelog, release, or decision-log location
is missing from both facts and established repository structure, do not invent
it. Ask to run `repo-setup` or create the relevant fact file first.

Do not assume default locations for user docs, developer docs, specs, roadmap
indexes, roadmap briefs, plans, release governance, decision logs, or
changelogs. Use the locations and policies declared in project facts or already
established by the repository.

When this skill is active:

- keep docs grounded in current repository state
- update docs when commands, flags, local-server behavior, API shape, output
  formats, config, file safety behavior, packaging, or architecture change
- follow user-doc, reference-doc, syntax, and example style rules declared in
  project facts before editing user-facing documentation
- route content to the user, developer, reference, spec, plan, roadmap, release,
  or decision locations declared in project facts; when a location is missing,
  inspect the existing repository structure and propose adding the fact before
  creating a new durable docs tree
- keep language-level package, module, or component documentation current when
  responsibilities, boundaries, or ownership move; use language facts for
  language-specific conventions such as Go package documentation files
- use the project's declared planning workflow for complex changes before
  implementation; preserve its naming, numbering, and closure rules
- when the project has roadmap docs, keep the roadmap index small and focused
  on direction, dependencies, status, and future work, not as a changelog,
  implementation journal, or archive of completed scope
- use roadmap item identifiers, statuses, execution ordering, dependency rules,
  and brief locations declared in project facts
- when adding or materially changing roadmap work, compare it against every
  active roadmap item, update dependency notes, and update the linked brief when
  the project uses briefs
- do not rename existing roadmap IDs unless the team explicitly chooses to
  change identifiers; if renaming happens, update every related filename, link,
  plan, spec, and textual reference in the same change
- preserve unresolved follow-up planning value in the project's declared brief,
  backlog, or decision locations instead of burying it in the roadmap index
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

## Roadmap Item Discussion Gate

For roadmap items, phases, and large scoped features, discuss the phase shape
with the user before implementation when the scope would change product
direction, safety boundaries, packaging, data handling, or the release timeline.
Keep small documentation and implementation-support changes moving with
reasonable assumptions.

## Roadmap Progress Tracking

When changes implement, complete, defer, or materially alter roadmap work:
- update the roadmap index declared in project facts
- update the linked roadmap item brief while it carries active planning or
  follow-up context
- cross-check implemented specs, changelog entries, workflows, command names,
  package names, and roadmap IDs against declared roadmap, brief, and plan
  locations before leaving a roadmap item active
- treat roadmap item and brief deletion as destructive documentation cleanup:
  prefer marking an item `Partial` when any scope is uncertain, and rely on the
  project's roadmap closure audit as the authoritative deletion gate before PR
  publication when the project uses roadmap docs
- delete completed or stale ExecPlans once the work is done and any durable
  decisions, implemented behavior, validation requirements, or follow-up work
  have moved into the appropriate durable docs
- update the relevant roadmap item block
- keep active roadmap statuses limited to `Pending`, `Partial`, or `Blocked`;
  use `Done` only as a short transition while moving durable content elsewhere,
  then remove the completed item from the active roadmap index
- do not leave an item as `Pending` when repository-owned implementation,
  specs, and release notes already describe a slice as implemented; mark it
  `Partial` with explicit remaining scope unless completion is unambiguous
- do not keep preservation buckets at the front of the execution sequence:
  active roadmap items should be executable next slices, while broad or
  mostly-deferred context belongs in preserved briefs or successor items
- do not list `Preserved` briefs in the active roadmap execution sequence
- remove completed items from the active roadmap index once durable decisions,
  implemented behavior, validation requirements, and release notes have moved
  to long-lived docs and no unresolved scope remains; perform a roadmap closure
  audit before approving item or brief deletion
- do not add completed task logs, per-commit history, or detailed outcomes to
  the roadmap index; use the declared changelog for user-facing change summaries
  and the declared decision log for durable rationale
- keep remaining roadmap item briefs when they are active, still needed to
  guide future work, explicitly linked to unresolved follow-ups, or marked
  `Preserved` to retain recovered context, completed foundation slices,
  deferred ideas, or successor links
- keep remaining ExecPlans only when they are active or still needed to guide
  future implementation
