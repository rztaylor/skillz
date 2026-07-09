---
name: sqlrise-scripting
description: Use when writing, reviewing, refactoring, or designing SQLRise .sqlr scripts, SQLRise script libraries, built-in inspect scripts, notebook-safe SQL blocks that use SQLRise commands, substitution variables, provider dispatch, report formatting, spooling, export workflows, or destructive-operation guards.
---

# SQLRise Scripting

Use this skill for SQLRise script work without assuming the SQLRise source tree
is available. Treat SQLRise behavior as product-specific: do not research it on
the web, and do not invent behavior from memory when the bundled references or
repo-local facts do not cover it.

## Read First

When working inside any repository, read these files when present:

1. `AGENTS.md`
2. `.agents/facts/sqlrise-scripting.md`
3. `.agents/facts/product.md`
4. `.agents/facts/docs.md`
5. `.agents/facts/testing.md`
6. `.agents/facts/cli.md`

Use facts to route all repo-specific decisions: local docs paths, script-pack
locations, validation commands, test policy, changelog policy, release notes,
and CLI invocation details. If facts are missing, infer cautiously from the
repository and mention the gap; propose a fact update when the missing detail
will matter again.

Load bundled references only as needed:

- `references/script-patterns.md`: script design, examples, refactoring moves,
  guarded destructive workflows, report/spool/export workflows.
- `references/commands.md`: exact command syntax, command boundaries,
  metadata, substitution, reporting, and discovery cheat sheet.
- `references/notebook-safe-blocks.md`: notebook SQL block safe subset and
  visible-evidence rules.
- `references/inspect-packs.md`: built-in `@.` inspect script conventions,
  wrappers, provider children, exact-object tabs, and review checklist.

If repo-local SQLRise docs are available through facts, read the task-relevant
sections before changing behavior. Otherwise, use the bundled references as the
portable baseline.

## Core Heuristic

Design scripts as compositions of these roles:

- **Contract**: metadata, parameters, defaults, `.require`, destructive notes.
- **Decision**: `.if` over built-ins or one scalar captured fact.
- **Discovery**: SQL returns a work list for `.foreach`.
- **Fact capture**: `.capture` stores one row or selected provider columns.
- **Visible evidence**: ordinary SQL result, `.echo`, report output, export.
- **Provider syntax**: helper script, native command, raw identifier rewrite.
- **Safety**: `.fail`, `.error`, `.whenever error`, dry-run/default guards.

If a script turns into a cross-object `UNION ALL` knot, a hand-written state
machine, or a fake portability layer, stop and choose a script move that makes
the intent explicit.

## Default Workflow

1. Identify the surface: `.sqlr` script, shared script library, inspect pack,
   notebook SQL block, review-only task, or design proposal.
2. Read repo facts and any task-relevant local docs named by those facts.
3. Load the smallest bundled reference that covers the task.
4. Preserve the caller contract before editing SQL: metadata, parameters,
   named defaults, positional shorthand, and supported providers.
5. Keep provider-specific SQL in provider helpers when branches grow.
6. Prefer plain `${name}` or `$1` for SQL values; use raw `${!name}` only for
   trusted identifiers or script-built SQL fragments.
7. Make safety visible: `.require`, explicit mode or confirmation parameters,
   scoped error policy, bounded polling, and one-shot delimiters.
8. Validate with commands from facts. If no validation is specified, do a
   focused static review and explain what could not be run.

## Design Defaults

Prefer named parameters for shared scripts. Use positional `$1`, `$2`, and `$*`
only when shorthand makes prompt use better, and define how positional values
interact with named overrides.

Use `param: name default=""` for optional values. Defaults are text, not SQL
types; do not use `default=NULL` to mean SQL null. Represent "any", "is null",
and "present" with a mode parameter when needed.

Let SQL do set logic. Use `.capture` to turn a metadata query into one scalar,
then branch with `.if`. Use `.foreach` when a database query owns the work
list.

Use `.spool` plus report formatting for human plain-text evidence. Use
`.export QUERY TO ... FORMAT ... AS SELECT ...` for one structured result for
tools. Keep related report and export queries close together.

Default to stopping important scripts on SQL errors. Scope `.whenever error
continue` only around optional evidence, then restore the safer policy.

Use `.delimiter token FOR` for one procedural SQL statement with internal
semicolons. Keep delimiter changes narrow.

## Review Posture

When reviewing SQLRise scripts, look first for behavioral risk:

- missing `.require` or provider mismatch
- unsafe raw substitution or unchecked SQL fragments
- optional filters that confuse empty strings with SQL nulls
- `.if` trying to do set logic that belongs in SQL
- `.foreach` work lists that are too broad or invisible
- destructive SQL without preview, confirmation, or explicit apply mode
- `.whenever error continue` leaking into required checks
- report, spool, and export workflows mixed together
- notebook blocks using rejected script, file, host, report, or CLI commands
- inspect scripts that are not exact-object, read-only, or provider-owned

Name the risk, point to the script contract it violates, and suggest the
smallest fix consistent with repo facts.

