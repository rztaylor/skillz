---
name: find-tech-debt
description: >
  Use when asked to find, review, register, or ticket project technical debt,
  especially "quick at the time, but should be made proper" code. Searches
  broadly across architecture, package ownership, CLI/server boundaries,
  frontend UI structure and reuse, domain logic, filesystem safety, tests,
  APIs, mobile lifecycle and platform boundaries, and maintainability. Uses
  repo-local project facts from AGENTS.md and .agents/facts/*.md when present.
---

# Find Technical Debt

Use this skill to identify and track project technical debt that works today
but should be made proper later.

## Trigger Phrases

Use this skill when the user asks for:

- "find tech debt"
- "technical debt review"
- "quick at the time but needs doing properly"
- "architectural debt"
- "cleanup tickets"
- "capture debt"
- "debt register"

## Default Output

Unless the user says "review only" or "do not create tickets", do both:

1. Produce a ranked technical debt register in the response.
2. Capture each `Track` finding as a Flashheart ticket through the `flashheart`
   skill, following the Ticket Capture Rules below.

The response is the register. Do not write debt registers, debt roadmap items,
or debt briefs into repository files. When the Flashheart tools are
unavailable, keep the register in the response and say which findings should
become tickets.

Do not change implementation code during a debt-finding pass unless the user
explicitly asks for fixes.

## Project Facts

Before relying on repo-specific architecture, planning, or debt policy, read:

1. `AGENTS.md`
2. `.agents/facts/find-tech-debt.md`
3. `.agents/facts/architecture.md`, `.agents/facts/planning.md`,
   `.agents/facts/testing.md`, and `.agents/facts/frontend-ui.md` when relevant
4. repository structure and scripts when facts are missing

If a debt, architecture, or planning fact is repeatedly useful, propose adding
it to the appropriate `.agents/facts/` file.

## Evidence Rules

- Use package names, file paths, exported/unexported routine names, command
  names, and documentation or spec names.
- Review responses and working notes may cite line numbers when that makes
  evidence easier to inspect.
- Do not use line numbers in tickets. Line numbers drift and make the ticket
  stale.
- Ticket text should use package names, file paths, exported/unexported routine
  names, command names, and documentation or spec names.
- Ground every finding in the current repo state. Do not invent debt from
  planned architecture unless current code or docs create the risk.

## Search Workflow

Start broad, then inspect likely hotspots.

Use project facts so the search matches the repository's actual product shape
and safety boundaries.

Read and apply `frontend-ui` when the debt surface includes browser or mobile
UI, components, styling, design tokens, frontend state, or interaction tests.

For Kotlin Multiplatform, Android, iOS, or Compose Multiplatform applications,
read and apply `references/kotlin-multiplatform-mobile.md`.

Use fast repo searches first:

```bash
rg -n "TODO|FIXME|HACK|temporary|for now|scaffold|compat|legacy|fallback|switch|panic\\(|interface\\{|map\\[string\\]|strings\\.Fields|Split|Parse|Handler|Validate|Redact|Move|Rename" .
rg --files
```

Then inspect by architectural surface:

- command parsing, startup flags, and local-server launch behavior
- API handlers, request/response contracts, and frontend/backend integration
- frontend routes, shared component layers, hooks/helpers, styling entrypoints,
  design tokens, and repeated loading/empty/error/permission UI
- domain parsing, rules engines, date handling, and file-format processing
- filesystem safety, path validation, destructive actions, and rollback/review
  behavior
- settings, environment variable loading, and override precedence
- storage, cache, generated assets, and persistence boundaries
- tests that exercise only final states instead of transitions
- documentation or specs declared in project facts that describe behavior not
  represented in code types

Read and apply `document-code-boundaries`. Discover and read canonical boundary
documents before broad implementation files. Record missing, stale,
contradictory, vague, duplicated, or oversized documents as candidate debt;
also flag implementations that exceed or conflict with their declared scope.

## What To Look For

Look broadly. Do not anchor only on centralized logic.

Flag code that has one or more of these traits:

- unclear package ownership or mixed responsibilities
- missing, stale, contradictory, duplicated, or overgrown canonical boundary
  documentation
- duplicated behavior, grammar, metadata, help text, or validation
- near-identical route/page markup, locally forked shared components, repeated
  interaction behavior, duplicated CSS declarations or raw design values, and
  page-local formatters, validators, API calls, or state handlers
- large procedural switches that hide a model or state machine
- hidden state machines with weak transition tests
- stringly typed API, settings, rules, or adapter contracts that should be typed or table-driven
- ad hoc parsing where a local parser or structured tokenizer exists
- package APIs that make invalid states easy to represent
- leaky abstractions between CLI, server, domain, storage, adapters, and rendering
  packages
- temporary compatibility or fallback paths that now obscure canonical behavior
- tests that verify happy paths but not cancellation, cycling, errors,
  boundary conditions, or state transitions
- documentation or specs declared in project facts that cannot be traced
  cleanly to package-owned behavior
- code that will likely regress when the next planned feature on the board
  lands
- secret, auth, filesystem, or destructive-action safety that relies on caller
  discipline instead of an owned boundary

## Ranking

Rank each finding with:

- **High**: likely to cause bugs, blocks planned work, or creates repeated
  regressions.
- **Medium**: increases maintenance cost or duplication but has contained
  behavior risk.
- **Low**: cleanup is worthwhile but not urgent.

Also mark timing:

- **Fix now**: small, low-risk, and directly blocking current work.
- **Track**: meaningful cleanup that deserves a ticket.
- **Watch**: real smell, but not enough evidence or payoff yet.

## Debt Register Format

Use this format in the response:

```markdown
**Debt Register**

1. **Title** - Severity: High, Timing: Track
   - **Where:** `internal/package`, routines `Name`, `otherName`
   - **What smells wrong:** ...
   - **Why it matters:** ...
   - **Proper shape:** ...
   - **Ticket:** New, or extends existing <ticket-id> ...

2. ...
```

Line numbers are fine in the response register but never in tickets.

## Ticket Capture Rules

When capturing `Track` debt on the board:

- Search open tickets first (`list_tickets` with `text`, `type=refactor`, or a
  tag). Extend a matching ticket with a note instead of creating a duplicate.
- Create one dedicated ticket per debt item rather than burying debt in
  unrelated feature tickets.
- Choose the type by what the fix is: `refactor` for structural or ownership
  cleanup, `test` for missing transition or boundary coverage, `bug` when the
  debt already produces wrong behavior (with a reproduction), and `docs` for
  missing or stale boundary documents.
- Map severity to priority: High to `high`, Medium to `medium`, Low to `low`.
- Create tickets in Backlog unless the user asks for them up next. Do not claim
  or start them.
- Tag them `tech-debt` unless project facts declare another tag.
- Use titles that make the ownership problem clear, for example
  `Rules engine boundary cleanup` or `Filesystem safety contract cleanup`.
- Group several findings that share one target shape into a workstream, and set
  `depends_on` only where one fix truly needs another first.
- If a debt item is too vague, keep it in the response as `Watch` rather than
  creating a ticket.

## Ticket Writing Template

Description:

```markdown
Goal: make <area> proper by <target architecture/ownership outcome>.

Debt source: <package/routine names and why this is not proper yet>.
Why it matters: <risk or cost>.
Target shape: <brief durable design>.
Scope: <what changes>; out of scope: <what does not>.
```

Acceptance criteria are testable statements, such as "the rules engine is the
only package that parses rule syntax" or "transition tests cover cancel and
retry for the import workflow". Refactor tickets include keeping behavior
unchanged, proven by tests, unless the user approves a behavior change.

## Testing Guidance

For review-only passes, do not run the full test suite unless needed to
understand current behavior.

For capture-only passes, run tests only if code was changed; confirm each
created ticket with `get_ticket` or `list_tickets`.

For any later fix pass derived from debt:

- add or improve tests before refactoring hidden state machines or parsers
- prefer transition-level tests for input parsing, adapter selection, API, and
  file-operation workflows
- keep behavior unchanged unless the user explicitly approves behavior changes

## Final Response

Summarize:

- highest-risk debt found
- tickets and workstreams created or extended, by id
- files changed
- validation performed
- anything intentionally left as `Watch`
