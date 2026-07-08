# skillz

Reusable Codex skills.

This repository stores generic skills: project-agnostic operating instructions
that another Codex instance can apply inside many repositories. A skill in this
repo should teach a workflow, review posture, boundary rule, or reusable
engineering habit. It should not encode facts about a specific project.

Project-specific knowledge belongs in the project that uses the skill, normally
under `AGENTS.md` and `.agents/facts/*.md`.

## Direction

The goal is to avoid one-off skill forks like "the review skill for project A"
and "the review skill for project B" when the underlying work is the same.
Instead, this repo should contain one generic skill that:

1. defines the reusable workflow
2. reads repo-local facts from the target project
3. falls back to repository evidence when facts are missing
4. captures or proposes missing facts for future runs

That pattern keeps shared behavior in one place while allowing each project to
keep its own product, architecture, docs, release, roadmap, safety, validation,
and git policy close to the code it describes.

## Layout

Skills live under `skills/<skill-name>/`.

Required:

- `skills/<skill-name>/SKILL.md`: the skill metadata and core instructions

Optional:

- `skills/<skill-name>/references/`: generic reference material that applies
  across projects, such as language-specific refactoring guidance
- `skills/<skill-name>/scripts/`: reusable, project-neutral helper scripts
- `skills/<skill-name>/assets/`: reusable, project-neutral templates or assets

Do not add extra docs inside a skill folder unless the skill needs them at run
time. Keep the top-level `README.md` as the human and LLM-readable map of the
repo.

Reusable prompts live under `prompts/`. Start with
`prompts/migrate-product-skills.md` when migrating a product repository from
legacy `.agents/skills/` to these shared skills plus tracked `.agents/facts/`.

## The Generic Skill Pattern

A generic skill should start by reading project context from the consuming
repository:

1. `AGENTS.md`
2. `.agents/facts/<skill-name>.md`
3. neighboring facts that affect the task, such as:
   - `.agents/facts/product.md`
   - `.agents/facts/architecture.md`
   - `.agents/facts/docs.md`
   - `.agents/facts/testing.md`
   - `.agents/facts/release.md`
   - `.agents/facts/roadmap.md`
   - `.agents/facts/git.md`
   - language facts such as `.agents/facts/go.md`
4. repository structure, scripts, package files, docs, and CI config when facts
   are missing

The skill should use facts for durable project policy and use repository
evidence for the current task. If a missing fact becomes repeatedly useful, the
skill should propose adding it to the target project's `.agents/facts/`
directory. If the missing fact blocks safe work, the skill should ask to run
`repo-setup` or create the relevant fact file before continuing.

## Project Facts

Facts are small, present-tense markdown files in the target project. They are
the durable memory layer for project-specific details.

Good facts describe:

- product shape, audience, and safety boundaries
- architecture and ownership boundaries
- documentation locations and update policy
- validation commands, test boundaries, and external prerequisites
- release, changelog, compatibility, and support policy
- roadmap, plan, and closure rules
- git, branch, commit, PR, and review policy
- skill-specific project rules, such as `.agents/facts/pre-pr-review.md`

Facts should distinguish decisions from unknowns. Use `Decision needed:` for
material choices the project has not made yet.

Facts should not become an implementation diary. Keep completed history, stale
branch names, old migration notes, and one-off task commentary out of
`.agents/facts/`.

## Rules For Skills In This Repo

- Never store project-related information inside skills in this repo.
- Do not hard-code project names, product language, package ownership, private
  workflows, branch policy, roadmap items, validation commands, release rules,
  docs paths, safety rules, or domain-specific behavior in shared skills.
- Put project-specific details in the consuming project's `.agents/facts/`
  files, then teach the skill how to find and apply those facts.
- Prefer one generic skill plus project facts over multiple project-specific
  copies of the same skill.
- Keep `SKILL.md` focused on reusable procedure. Move long but generic detail
  into `references/` only when progressive disclosure helps.
- Use scripts only for reusable, deterministic work that is not tied to one
  project's layout or private tooling.
- When facts are missing, infer carefully from the target repository and record
  the gap. Do not invent policy.
- When a skill repeatedly discovers the same project detail, propose capturing
  it in `.agents/facts/<skill-name>.md` or the relevant shared fact file.
- Keep examples generic. Use placeholders such as `<project>`, `<package>`, or
  `<validation-command>` when a concrete project value would leak into the
  shared skill.

## Adding Or Updating A Skill

Before adding a new skill, check whether an existing generic skill can cover
the workflow by reading additional project facts. Create a new skill only when
the reusable procedure is meaningfully different.

When updating a skill:

1. Identify which parts are reusable workflow and which parts are project facts.
2. Keep the reusable workflow in `SKILL.md`.
3. Route project-specific decisions through `.agents/facts/`.
4. Add a fact-capture section when the skill depends on project knowledge that
   may be missing.
5. Validate that the skill still makes sense in a different repository.

The intended shape is simple: shared skills stay portable, project facts stay
local, and Codex can combine the two without copying project policy into this
repo.
