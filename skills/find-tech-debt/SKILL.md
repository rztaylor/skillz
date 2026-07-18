---
name: find-tech-debt
description: >
  Use when asked to find, review, register, or roadmap project technical debt,
  especially "quick at the time, but should be made proper" code. Searches
  broadly across architecture, package ownership, CLI/server boundaries,
  frontend UI structure and reuse, domain logic, filesystem safety, tests,
  APIs, and maintainability. Uses repo-local project facts from AGENTS.md and
  .agents/facts/*.md when present.
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
- "roadmap cleanup items"
- "capture debt"
- "debt register"

## Default Output

Unless the user says "review only" or "do not edit docs", do both:

1. Produce a ranked technical debt register in the response.
2. When project facts declare a roadmap or debt-tracking workflow, update the
   declared roadmap, debt register, and linked brief locations with dedicated
   pending technical-debt items when the item needs durable tracking.

Do not change implementation code during a debt-finding pass unless the user
explicitly asks for fixes.

## Project Facts

Before relying on repo-specific architecture, roadmap, or debt policy, read:

1. `AGENTS.md`
2. `.agents/facts/find-tech-debt.md`
3. `.agents/facts/architecture.md`, `.agents/facts/roadmap.md`,
   `.agents/facts/testing.md`, and `.agents/facts/frontend-ui.md` when relevant
4. repository structure and scripts when facts are missing

If a debt, architecture, or roadmap fact is repeatedly useful, propose adding it
to the appropriate `.agents/facts/` file.

If durable debt capture depends on roadmap, brief, register, docs, or release
policy and neither facts nor established repository structure define that
policy, do not invent it. Ask to run `repo-setup` or create the relevant fact
file first.

## Evidence Rules

- Use package names, file paths, exported/unexported routine names, command
  names, and documentation or spec names.
- Review responses and working notes may cite line numbers when that makes
  evidence easier to inspect.
- Do not use line numbers in durable debt entries, roadmap items, or roadmap
  briefs. Line numbers drift and make the register stale.
- Durable output and roadmap text should use package names, file paths,
  exported/unexported routine names, command names, and documentation or spec
  names.
- Ground every finding in the current repo state. Do not invent debt from
  planned architecture unless current code or docs create the risk.

## Search Workflow

Start broad, then inspect likely hotspots.

Use project facts so the search matches the repository's actual product shape
and safety boundaries.

Read and apply `frontend-ui` when the debt surface includes browser UI,
components, styling, design tokens, frontend state, or browser tests.

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
- code that will likely regress when the next feature in the roadmap lands
- secret, auth, filesystem, or destructive-action safety that relies on caller
  discipline instead of an owned boundary

## Ranking

Rank each finding with:

- **High**: likely to cause bugs, blocks roadmap work, or creates repeated
  regressions.
- **Medium**: increases maintenance cost or duplication but has contained
  behavior risk.
- **Low**: cleanup is worthwhile but not urgent.

Also mark timing:

- **Fix now**: small, low-risk, and directly blocking current work.
- **Track**: meaningful cleanup that deserves a roadmap item.
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
   - **Roadmap:** Add/extend item ...

2. ...
```

Do not include line numbers in durable roadmap or debt-register entries.

## Roadmap Capture Rules

When capturing debt in the roadmap or debt register declared in project facts:

- Add dedicated cleanup items rather than burying debt in unrelated feature
  work.
- Use names that make the ownership problem clear, for example:
  - `D01 - Rules Engine Boundary Cleanup`
  - `D02 - Filesystem Safety Contract Cleanup`
  - `D03 - API Response Shape Coverage`
- Status should normally be `Pending`.
- Keep the roadmap block concise: status, why or promotion trigger, and an
  optional brief link.
- Put Goal, Scope, Acceptance, Status, and Important details in the declared
  linked-brief location when the item deserves durable detail.
- Keep roadmap text durable. Use package/routine names, not line numbers.
- If a debt item is too vague, keep it in the response as `Watch` rather than
  adding a roadmap item or brief.

## Roadmap Brief Writing Template

```markdown
# <id> - <Debt Item Name>

Status: Pending.

Goal: make <area> proper by <target architecture/ownership outcome>.

Scope:
- ...

Acceptance:
- ...

Status: Pending.

Important details:
- Debt source: <package/routine names and why this is not proper yet>.
- Target shape: <brief durable design>.
```

## Testing Guidance

For review-only passes, do not run the full test suite unless needed to
understand current behavior.

For roadmap-only documentation edits:

- run lightweight checks such as `rg` for inserted item names
- check that roadmap links to any new brief resolve
- run tests only if code was changed

For any later fix pass derived from debt:

- add or improve tests before refactoring hidden state machines or parsers
- prefer transition-level tests for input parsing, adapter selection, API, and
  file-operation workflows
- keep behavior unchanged unless the user explicitly approves behavior changes

## Final Response

Summarize:

- highest-risk debt found
- roadmap items and briefs added or updated
- files changed
- validation performed
- anything intentionally left as `Watch`
