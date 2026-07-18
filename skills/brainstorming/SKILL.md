---
name: brainstorming
description: >
  Use when brainstorming product, roadmap, architecture, UX, dependency,
  naming, documentation, implementation scope, or before implementing any
  roadmap item, phase, or large scoped feature. Uses repo-local project facts
  from AGENTS.md and .agents/facts/*.md when present.
---

## Project Facts

Before relying on repo-specific direction or constraints, read:

1. `AGENTS.md`
2. `.agents/facts/brainstorming.md`
3. `.agents/facts/product.md`, `.agents/facts/roadmap.md`, and
   `.agents/facts/architecture.md` when relevant
4. repository structure and scripts when facts are missing

If a product, roadmap, or architecture fact is repeatedly useful, propose
adding it to the appropriate `.agents/facts/` file.

If a decision depends on durable product, roadmap, docs, release, or
architecture policy and neither facts nor established repository structure
define that policy, do not invent it. Ask to run `repo-setup` or create the
relevant fact file first.

When this skill is active:

- treat the conversation as decision work, not implementation work; do not edit
  files unless the user explicitly moves from brainstorming to execution
- first identify the decision type: product direction, roadmap scope, UX,
  architecture, dependency choice, naming, refactor, docs, or implementation
  sequencing
- restate the actual decision and constraints in a few bullets before generating options
- when discussing a roadmap item, read the linked brief path declared in
  project facts and treat it as scoped backlog context, not as current
  implementation truth
- when adding or materially changing roadmap work, compare it against every
  active item in the roadmap index declared in project facts, then update the
  execution sequence, dependency notes, and linked brief rather than appending
  by chronology alone
- for roadmap items, use short, unique, kebab-case text IDs instead of phase
  numbers or sequential numbers
- before implementing any roadmap item, phase, or large scoped feature, restate
  the goal, acceptance criteria, expected implementation scope, dependencies,
  likely deferrals, and what would be out of scope
- for new or substantially changed multi-screen browser UI, include the
  proposed component and styling ownership, shared versus feature-specific
  boundaries, reusable state and helper boundaries, and cross-screen
  consistency criteria in the acceptance criteria; sequence the minimum shared
  foundation before feature slices that consume it
- for phase gates, give blunt product and engineering feedback on whether the
  phase still makes sense as written before asking for implementation
  greenlight
- do not start implementation files during a phase gate until the user has
  answered the greenlight question
- after greenlight, switch to the relevant execution skills for the approved
  work, such as frontend UI, testing, documentation, CLI UX, or structural
  refactoring skills
- ground claims in the project's current docs, specs, code, roadmap, or linked
  roadmap item brief when repo facts matter
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
- flag when an idea would require an ExecPlan, spec update, user-doc update,
  roadmap decision, or security review before implementation
- prefer keeping the roadmap index lean and block-based; put detailed backlog
  notes in linked briefs and durable keep/defer/reject rationale in the
  decision log declared in project facts
- keep answers concise by default; use tables or short bullets when they make tradeoffs easier to scan
- default output shape: decision, options, recommendation, open questions, greenlight point
- end with a concrete approval choice, such as "approve A", "choose B vs C", or "greenlight drafting the spec"
