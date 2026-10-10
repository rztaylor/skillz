---
name: brainstorming
description: >
  Use when brainstorming product direction, scope, architecture, UX,
  dependency, naming, documentation, implementation scope, or before
  implementing any workstream, large ticket, or large scoped feature. Uses
  repo-local project facts from AGENTS.md and .agents/facts/*.md and the
  Flashheart board when present.
---

## Project Facts

Before relying on repo-specific direction or constraints, read:

1. `AGENTS.md`
2. `.agents/facts/brainstorming.md`
3. `.agents/facts/product.md`, `.agents/facts/planning.md`, and
   `.agents/facts/architecture.md` when relevant
4. repository structure and scripts when facts are missing

If a product, planning, or architecture fact is repeatedly useful, propose
adding it to the appropriate `.agents/facts/` file.

If a decision depends on durable product, planning, docs, release, or
architecture policy and neither facts nor established repository structure
define that policy, do not invent it. Ask to run `repo-setup` or create the
relevant fact file first.

When this skill is active:

- treat the conversation as decision work, not implementation work; do not edit
  files unless the user explicitly moves from brainstorming to execution
- first identify the decision type: product direction, work scope, UX,
  architecture, dependency choice, naming, refactor, docs, or implementation
  sequencing
- restate the actual decision and constraints in a few bullets before generating options
- when discussing tracked work, read the ticket or workstream through the
  `flashheart` skill and treat it as scoped backlog context, not as current
  implementation truth
- when proposing new or materially changed work, search the board for
  overlapping, duplicate, or dependent tickets and workstreams first
  (`list_tickets`, `board_context`); extend, depend on, or reject against
  them rather than adding work by chronology alone
- before implementing any workstream, large ticket, or large scoped feature, restate
  the goal, acceptance criteria, expected implementation scope, dependencies,
  likely deferrals, and what would be out of scope
- for new or substantially changed multi-screen browser UI, include the
  proposed component and styling ownership, shared versus feature-specific
  boundaries, reusable state and helper boundaries, and cross-screen
  consistency criteria in the acceptance criteria; sequence the minimum shared
  foundation before feature slices that consume it
- for scope gates, give blunt product and engineering feedback on whether the
  workstream or ticket still makes sense as written before asking for
  implementation greenlight
- do not start implementation files during a scope gate until the user has
  answered the greenlight question
- after greenlight, switch to the relevant execution skills for the approved
  work, such as frontend UI, testing, documentation, CLI UX, or structural
  refactoring skills
- for substantial new browser or mobile UI, new screens or workflows, or
  redesigns that change hierarchy, navigation, information architecture, or
  primary interactions, route through `ui-concept-design` after UX scope is
  clear and before implementation greenlight; do not apply that visual concept
  gate to small tweaks, established-pattern additions, fixes, or refactors
- ground claims in the project's current docs, specs, code, decisions, or
  tracked tickets when repo facts matter
- preserve the product direction and safety boundaries described by project
  facts; do not import assumptions from another repository
- separate divergent thinking from convergence: list viable options first, then evaluate, then recommend
- include "defer", "do nothing", or "reject" when those are realistic options
- evaluate options by user value, implementation cost, maintenance cost,
  safety/security risk, testability, dependency impact, and fit with the
  product model in project facts
- be blunt; call out scope creep, weak product fit, fragile custom code, vague
  requirements, or ideas that fight the architecture
- prefer mature, maintained open source libraries for commodity edge-case-heavy
  domains; keep project-specific semantics in project-owned code
- flag when an idea would require an implementation plan, spec update,
  user-doc update, recorded decision, or security review before implementation
- after the user approves an outcome, record it where it belongs: new or
  changed work as Flashheart tickets, grouped in a workstream when several
  tickets share a goal, with real `depends_on` links; deferred ideas as
  low-priority Backlog tickets; rejected ideas in the Rejected status with the
  reason in a note; durable keep/defer/reject rationale that shapes the product
  in the decision log declared in project facts
- never record ideas, backlog notes, or sequencing in repository roadmap or
  brief files; product direction belongs in the declared product doc only when
  it changes
- keep answers concise by default; use tables or short bullets when they make tradeoffs easier to scan
- default output shape: decision, options, recommendation, open questions, greenlight point
- end with a concrete approval choice, such as "approve A", "choose B vs C",
  "greenlight creating these tickets", or "greenlight drafting the spec"
