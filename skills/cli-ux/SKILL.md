---
name: cli-ux
description: Use when designing command names, startup flags, help text, prompts, output formats, confirmations, dry-run behavior, host/port disclosure, and error messages for command-line tools or local app launchers. Language-agnostic: uses repo-local project facts from AGENTS.md and .agents/facts/*.md when present.
---

## Project Facts

Before relying on repo-specific CLI conventions or safety constraints, read:

1. `AGENTS.md`
2. `.agents/facts/cli-ux.md`
3. `.agents/facts/cli.md`
4. repository structure and scripts when facts are missing

If a CLI UX fact is repeatedly useful, propose adding it to
`.agents/facts/cli.md` or `.agents/facts/cli-ux.md`.

If a CLI decision depends on durable docs, release, safety, or support policy
and neither facts nor established repository structure define that policy, do
not invent it. Ask to run `repo-setup` or create the relevant fact file first.

When this skill is active:
- choose command names that match common CLI conventions and user intent
- keep help text short, specific, and example-driven when examples clarify usage
- make defaults visible when they affect output, state, network calls, or writes
- keep human output readable in terminals and machine output deterministic
- use a human-first output hierarchy for default text: outcome or state first,
  short explanation second, smallest useful facts third, next action last, and
  detail pointers only when detail exists
- use headings, blank lines, and task-oriented grouping for multi-line prompts,
  warnings, errors, and summaries; keep action prompts visually isolated at the
  end
- keep hashes, adapter internals, cache identities, diagnostics, and
  other metadata out of leading default output unless they are the user's
  immediate decision point
- expose detailed technical metadata through explicit detail paths such as
  `--verbose`, inspection commands, cached reports, or future machine-readable
  output
- include `--output json` or a similar explicit switch before promising scriptable output
- use stdout for command results and stderr for help, warnings, progress, and errors
- require explicit user intent for destructive actions, such as a confirmation prompt, `--yes`, or `--force`
- prefer dry-run previews when commands modify files, remote resources, or durable local state
- include the invalid value, expected shape, and recovery path in validation errors when practical
- prompts should explain why the tool is asking, what the affirmative answer does,
  and what happens if the user stops
- keep default output scrollback-friendly; full-screen or TUI behavior must be explicit and opt-in
- keep ANSI/RGB color opt-in or capability-gated, and ensure plain text can be forced for scripts, tests, accessibility, and redirected output
- make network, host, port, credential, and filesystem defaults visible before
  they affect requests or local files
- preserve predictable command behavior for named modes or subcommands: unknown
  names should fail clearly instead of falling through to unrelated behavior
- maintain separate presentation paths for human output, diagnostics, dry-run
  previews, and future machine-readable output
- when a CLI UX decision changes user-facing command behavior, output
  contracts, safety prompts, or support boundaries, update the relevant docs
  and add a curated changelog entry for notable user-facing, release, safety,
  compatibility, packaging, support-policy, or validation changes when project
  facts declare a changelog policy; otherwise state why no changelog update is
  needed or why no changelog location is declared
