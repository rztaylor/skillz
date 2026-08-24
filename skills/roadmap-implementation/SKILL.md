---
name: roadmap-implementation
description: >
  Must use when implementing, continuing, auditing, or closing work represented
  by a project roadmap item, phase, milestone, or linked implementation brief.
  Coordinator skill: assembles scope, execution, git, documentation, validation,
  dependency, and closure workflows from existing specialist skills and
  repository-local facts.
---

# Roadmap Implementation

Use this skill as the entrypoint for executing already-roadmapped work. It
coordinates existing skills rather than replacing their detailed rules.

Do not use it for unrelated maintenance or for roadmap ideation with no
implementation request. Use `brainstorming` alone for pure option or roadmap
design work, and use `pre-pr-review` at the PR readiness boundary.

## Project Facts

Before relying on project-specific scope, status, dependency, documentation,
validation, release, or git policy, read:

1. `AGENTS.md`
2. `.agents/facts/roadmap-implementation.md` when present
3. `.agents/facts/roadmap.md`, `.agents/facts/docs.md`,
   `.agents/facts/testing.md`, and `.agents/facts/git.md`
4. `.agents/facts/product.md`, `.agents/facts/architecture.md`,
   `.agents/facts/release.md`, and language or platform facts when relevant
5. the active roadmap, linked brief or plan, requirements or specifications,
   repository status, and current implementation evidence

If roadmap locations, status meanings, dependency rules, closure policy, or
validation expectations are absent from both facts and established repository
structure, do not invent them. Ask to use `repo-setup` or create the missing
facts before changing durable roadmap state.

## Coordinated Skills

At the start, name the coordinated skills being used and read each selected
`SKILL.md` completely before applying it. Use:

- `adaptive-karpathy-guidelines` for work mode, assumptions, scope discipline,
  implementation completeness, and verification
- `brainstorming` for the roadmap preflight, acceptance shape, dependencies,
  deferrals, changed sequencing, or any unresolved product or architecture
  decision; a direct implementation request counts as greenlight only for the
  scope already established by project facts and the active brief
- `safe-git-pr-workflow` for every repository-tracked change
- `docs-maintainer` whenever work begins, advances, completes, defers, blocks,
  or materially changes a roadmap item
- `document-code-boundaries` when packages, modules, services, feature
  components, or other ownership boundaries are created or changed
- the applicable language, UI, CLI, testing, refactoring, security, release, or
  domain skill for the actual implementation surface

Use `repo-setup` only when repository foundations or required facts are missing
or the user asks to standardize them. Do not run `pre-pr-review` merely because
implementation finishes; use it when a PR or handoff gate is requested.

## Preflight Gate

Before editing implementation files:

1. Compare the roadmap and linked brief with current code, tests, docs, branch,
   and worktree state. Planning status is not proof of implementation state.
2. Restate the goal, acceptance criteria, expected implementation scope,
   dependencies, likely deferrals, and explicit out-of-scope work.
3. Identify applicable functional, quality, policy, migration, security,
   accessibility, and release constraints from project facts and canonical
   requirements.
4. Check every declared dependency. Do not start dependent implementation while
   a prerequisite is incomplete or ambiguous. If the user explicitly changes
   sequencing, update the roadmap decision and dependency state before starting.
5. Reconcile stale status before continuing. Work that has started must not
   remain represented as untouched; incomplete evidence must not be represented
   as complete. Use the project's declared status vocabulary and closure rules.
6. Create a plan that includes implementation, focused validation, acceptance
   audit, and roadmap/document reconciliation. A build or test step alone is not
   a closure plan.

Stop for a user decision when scope, dependency order, safety boundaries,
public behavior, data handling, or release direction would materially change.

## Execution Discipline

- Keep the active brief and repository truth aligned as progress changes; do
  not postpone all roadmap maintenance until a later cleanup task.
- Keep requirement and policy identifiers traceable in the narrow durable
  artifacts declared by project facts.
- Preserve unrelated worktree changes and separate premature or out-of-scope
  implementation from the active item.
- Treat external, device, performance, accessibility, migration, security, and
  recovery evidence as real acceptance work when the brief requires it.
- Report a newly discovered blocker or scope change before implementing around
  it. Update the roadmap or brief when the change is durable.
- Do not begin the next roadmap item in the same workflow merely because the
  current slice builds. Finish the closure gate first and require user
  authorization for the next item.

## Closure Gate

Before declaring the item or slice complete:

1. Audit every acceptance criterion and mapped requirement against concrete
   evidence. Record passes, failures, and unavailable checks.
2. Run the focused and broad validation declared by project facts. Skipped or
   blocked validation remains unfinished work and is never counted as passing.
3. Review architecture and boundary documentation for every affected unit.
4. Reconcile the roadmap index, linked brief, active plans, specs, decisions,
   facts, developer or user docs, and changelog according to `docs-maintainer`
   and project policy.
5. Use an incomplete or blocked status when any required scope or evidence
   remains. Use the project's completion and removal workflow only after the
   closure audit is unambiguous.
6. Report what changed, validation performed, remaining evidence or risk, and
   the exact roadmap state. Do not describe a first slice as completion of a
   broader item unless the brief defines it that way.

The outcome of this skill is not merely code. It is implementation, evidence,
and planning state that agree about what is actually complete.
