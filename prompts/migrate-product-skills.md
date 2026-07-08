# Product Skill Migration Prompt

Use this prompt inside a product repository when migrating from legacy
repo-local `.agents/skills/` to the shared skills in this repository.

Recommended temporary setup:

1. Symlink this repository into the product repo as `skillz/` for comparison.
2. Run the prompt below.
3. Resolve blocking or important concerns.
4. Remove the temporary `skillz/` symlink.
5. Point the product repo's ignored `.agents/skills` path at the shared
   `skillz/skills` directory.

Keep `.agents/facts/` tracked because facts are project-specific. Keep
`.agents/skills` ignored when developers should be free to use their own local
skills checkout.

## Prompt

```markdown
You are in the product repository.

This repo currently has product-specific legacy skills under `.agents/skills/`.

The shared skills repo has been symlinked into this repo as `./skillz/` for
comparison. Treat `./skillz/` as read-only. Do not edit, move, delete, or
reformat anything under `./skillz/`.

Goal:
Migrate the durable product-specific behavior from `.agents/skills/` into
`.agents/facts/*.md` so this product repo can use the shared skills from
`./skillz/skills/`.

Do not delete `.agents/skills/` yet.

Read first:
1. `AGENTS.md`, if present.
2. Existing `.agents/facts/*.md`, if present.
3. Legacy `.agents/skills/**`.
4. `skillz/README.md`.
5. Every `skillz/skills/*/SKILL.md`.
6. Any directly referenced `skillz/skills/*/references/*.md` needed to
   understand coverage.

For every legacy skill in `.agents/skills/`, classify each meaningful
instruction as one of:

- `covered-by-skillz`: already handled by a shared skill.
- `project-fact`: product-specific behavior that belongs in
  `.agents/facts/*.md`.
- `missing-shared-behavior`: reusable behavior that may need a change in
  `skillz`.
- `conflict`: legacy behavior conflicts with the shared skill model.
- `obsolete`: duplicated, stale, or no longer useful.

Create or update only files under `.agents/facts/`.

Preferred fact files:
- `.agents/facts/product.md`
- `.agents/facts/architecture.md`
- `.agents/facts/engineering.md`
- `.agents/facts/testing.md`
- `.agents/facts/docs.md`
- `.agents/facts/release.md`
- `.agents/facts/roadmap.md`
- `.agents/facts/git.md`
- `.agents/facts/cli.md`
- language facts such as `.agents/facts/go.md`, `.agents/facts/node.md`, or
  `.agents/facts/python.md`
- skill-specific facts such as `.agents/facts/pre-pr-review.md`,
  `.agents/facts/docs-maintainer.md`, `.agents/facts/repo-setup.md`,
  `.agents/facts/safe-git-pr-workflow.md`,
  `.agents/facts/structural-refactorer.md`,
  `.agents/facts/find-tech-debt.md`, `.agents/facts/release-checks.md`,
  `.agents/facts/brainstorming.md`, `.agents/facts/cli-ux.md`,
  `.agents/facts/go-cli.md`, or `.agents/facts/go-testing.md`

Fact-writing rules:
- Facts must be durable, present-tense, repo-specific markdown.
- Do not include migration commentary inside fact files.
- Do not write "from old skill X" inside fact files.
- Do not invent policy.
- If something important is unknown, write `Decision needed: ...`.
- Preserve existing fact content unless it is clearly stale or contradicted by
  stronger repo evidence.
- Keep facts concise and actionable.

After creating or updating facts, report:

## Files Changed
List every `.agents/facts/*.md` file created or updated.

## Legacy Skill Coverage
Create a table with:
- Legacy skill path
- Matching `skillz` skill or skills
- Fact file destination
- Coverage status

## Concerns
List behavior from `.agents/skills/` that is not fully captured by
`skillz + .agents/facts`.

For each concern include:
- Severity: `Blocking`, `Important`, or `Watch`
- Legacy behavior
- Why it is not captured
- Recommended action

## Migration Recommendation
Say one of:
- `Safe to switch to skillz`
- `Safe with caveats`
- `Not safe yet`

Do not remove `.agents/skills/` unless explicitly asked later.
```
