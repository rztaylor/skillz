---
name: ticket-implementation
description: >
  Must use when implementing, continuing, auditing, or closing work tracked as
  a Flashheart ticket or workstream, such as a feature, bug, refactor, or
  tech-debt ticket named by an id like ABC-42. Coordinator skill: assembles
  scope, execution, git, documentation, validation, dependency, and closure
  workflows from the flashheart skill, existing specialist skills, and
  repository-local facts.
---

# Ticket Implementation

Use this skill as the entrypoint for executing work already tracked on the
Flashheart board. It coordinates existing skills rather than replacing their
detailed rules.

Do not use it for unrelated maintenance or for ideation with no
implementation request. Use `brainstorming` alone for pure option or scope
design work, and use `pre-pr-review` at the PR readiness boundary.

## Where Work Lives

- Flashheart holds day-to-day work: the ticket's scope, acceptance criteria,
  dependencies, status, handoff, review, and follow-ups. Workstreams group
  tickets that share a goal.
- The repository holds durable truth: product scope and direction, specs,
  architecture and boundary docs, decisions, user docs, changelog, and release
  governance.
- A detailed implementation plan, when the work needs one, lives in the
  repository plan location declared in `.agents/facts/planning.md`, is named
  after its ticket, and is deleted at closure. Never copy a plan into the
  ticket; link its path in a ticket note instead.

Do not create or update roadmap indexes, roadmap-item briefs, backlog files,
or bug lists in the repository. If the repository still has a legacy roadmap
index or briefs, do not extend them; offer the planning migration in
`repo-setup` instead.

## Project Facts

Before relying on project-specific scope, documentation, validation, release,
or git policy, read:

1. `AGENTS.md`, including any Flashheart section
2. `.agents/facts/ticket-implementation.md` when present
3. `.agents/facts/planning.md`, `.agents/facts/docs.md`,
   `.agents/facts/testing.md`, and `.agents/facts/git.md`
4. `.agents/facts/product.md`, `.agents/facts/architecture.md`,
   `.agents/facts/release.md`, and language or platform facts when relevant
5. the ticket with `get_ticket`, its workstream and `depends_on` tickets, any
   linked plan, requirements or specifications, repository status, and current
   implementation evidence

If plan locations, decision-log locations, or validation expectations are
absent from both facts and established repository structure, do not invent
them. Ask to use `repo-setup` or create the missing facts before writing
durable docs.

## Coordinated Skills

At the start, name the coordinated skills being used and read each selected
`SKILL.md` completely before applying it. Use:

- `flashheart` for every board action: claiming, checkpoints, ticking
  criteria, questions for the human, reviews, follow-up tickets, and moving
  the ticket to review
- `adaptive-karpathy-guidelines` for work mode, assumptions, scope discipline,
  implementation completeness, and verification
- `brainstorming` for the preflight, acceptance shape, dependencies,
  deferrals, changed sequencing, or any unresolved product or architecture
  decision; a direct implementation request counts as greenlight only for the
  scope already established by project facts and the ticket
- `safe-git-pr-workflow` for every repository-tracked change
- `docs-maintainer` whenever the work changes durable docs, decisions, specs,
  the changelog, or an implementation plan
- `document-code-boundaries` when packages, modules, services, feature
  components, or other ownership boundaries are created or changed
- the applicable language, UI, CLI, testing, refactoring, security, release, or
  domain skill for the actual implementation surface

Use `repo-setup` only when repository foundations or required facts are missing
or the user asks to standardize them. Do not run `pre-pr-review` merely because
implementation finishes; use it when a PR or handoff gate is requested.

When the Flashheart tools are unavailable, such as in CI or an agent without
the MCP server, continue the repository work and report the ticket updates,
ticked criteria, and follow-ups in the response or PR body for the human to
record. Never fall back to writing them into repository files.

## Preflight Gate

Before editing implementation files:

1. Claim the ticket. Compare its description and acceptance criteria with
   current code, tests, docs, branch, and worktree state. Ticket status is not
   proof of implementation state.
2. Restate the goal, acceptance criteria, expected implementation scope,
   dependencies, likely deferrals, and explicit out-of-scope work.
3. Identify applicable functional, quality, policy, migration, security,
   accessibility, and release constraints from project facts and canonical
   requirements.
4. Check every `depends_on` ticket and workstream dependency. Do not start
   dependent implementation while a prerequisite is incomplete or ambiguous.
   If the user explicitly changes sequencing, update the ticket's dependencies
   before starting, and claim a blocked ticket only with `force` and the
   user's reason.
5. Reconcile stale ticket state before continuing. Work that has started must
   not sit in Backlog or Up next; criteria without evidence must not be ticked.
6. Create a plan that includes implementation, focused validation, acceptance
   audit, and documentation reconciliation. A build or test step alone is not
   a closure plan. Write a repository plan file only when the work needs a
   detailed plan that must survive context loss or be reviewed.

Stop for a user decision when scope, dependency order, safety boundaries,
public behavior, data handling, or release direction would materially change.
Ask it with the flashheart `ask_human` tool as well as in chat.

## Execution Discipline

- Keep the ticket and repository truth aligned as progress changes: checkpoint
  at milestones and tick criteria as they pass; do not postpone it to a later
  cleanup task.
- Keep requirement and policy identifiers traceable in the narrow durable
  artifacts declared by project facts.
- Preserve unrelated worktree changes and separate premature or out-of-scope
  implementation from the active ticket.
- Treat external, device, performance, accessibility, migration, security, and
  recovery evidence as real acceptance work when the ticket requires it.
- Report a newly discovered blocker or scope change before implementing around
  it. Record it on the ticket, and create a follow-up ticket for out-of-scope
  work instead of a TODO comment or a repository backlog note.
- Do not begin the next ticket in the same workflow merely because the current
  one builds. Finish the closure gate first and require user authorization for
  the next ticket, including follow-up tickets you created.

## Closure Gate

Before declaring the ticket complete:

1. Audit every acceptance criterion and mapped requirement against concrete
   evidence. Tick only criteria that pass; record failures and unavailable
   checks in a ticket note.
2. Run the focused and broad validation declared by project facts. Skipped or
   blocked validation remains unfinished work and is never counted as passing.
3. Review architecture and boundary documentation for every affected unit.
4. Move durable outcomes into the repository according to `docs-maintainer`:
   decisions to the decision log, behavior to specs and user or developer docs,
   user-facing impact to the changelog. Then delete the ticket's
   implementation plan, if any.
5. Create follow-up tickets for remaining scope instead of leaving it in docs.
   Keep the ticket out of review while required scope or evidence remains,
   unless the user agrees to split it.
6. Write the review, checkpoint, and move the ticket to review as the
   `flashheart` skill describes. Never move a ticket to done.
7. Report what changed, validation performed, remaining evidence or risk,
   follow-up tickets, and the exact ticket state. Do not describe one ticket as
   completing a broader workstream unless every ticket in it is complete.

The outcome of this skill is not merely code. It is implementation, evidence,
board state, and durable docs that agree about what is actually complete.
