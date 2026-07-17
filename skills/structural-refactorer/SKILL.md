---
name: structural-refactorer
description: 'Enforces modularity, Single Responsibility Principle, and DRY principles when cleaning up repository structure or decoupling CLI, server, domain, storage, rendering, and adapter logic. Language-aware: uses repo-local project facts from AGENTS.md and .agents/facts/*.md, detects the project stack, and loads matching references such as references/go.md before applying language-specific boundaries.'
---

# Structural Refactoring Instructions

Use this skill for refactors that improve structure without changing behavior.

## Project Facts

Before relying on repo-specific package ownership or boundaries, read:

1. `AGENTS.md`
2. `.agents/facts/structural-refactorer.md`
3. `.agents/facts/architecture.md`, `.agents/facts/cli.md`, and detected
   language facts such as `.agents/facts/go.md` when relevant
4. repository structure, package-manager files, and scripts when facts are
   missing

If an architecture, package-boundary, CLI, or language fact is repeatedly
useful, propose adding it to the appropriate `.agents/facts/` file.

If architecture, package-boundary, entrypoint, planning, or layout policy is
missing from both facts and established repository structure, do not invent it.
Ask to run `repo-setup` or create the relevant fact file first.

Missing facts do not block the self-contained documentation defaults in
`document-code-boundaries`; use them to document boundaries established by
repository evidence or user direction, not to invent the boundaries themselves.

## Core Directives

1. Identify monolithic modules, packages, handlers, components, services, and mixed UI/API/domain/adapter logic.
2. Extract domain behavior into focused modules, packages, or services that match the project's language conventions.
3. Keep interfaces small and defined near the consumer.
4. Separate parsing, validation, IO, output formatting, and business rules.
5. Remove meaningful duplication with helpers only when it reduces real maintenance cost.
6. Preserve observable behavior, inputs, outputs, and exit codes unless the user explicitly asks to change them.
7. Read and apply `document-code-boundaries` before deciding package, module,
   service, or component ownership; create or update the canonical boundary
   documents for every affected unit.

Add or update tests when extraction touches behavior or public contracts.

## Boundary Rules

- Detect the project stack from project facts and repo files such as `go.mod`,
  `package.json`, `pyproject.toml`, `Cargo.toml`, and existing source layout.
- Load the relevant language reference before applying language-specific
  boundaries:
  - Go: `references/go.md`
  - for unsupported stacks, follow the existing project conventions and apply
    only the generic boundary rules here
- Read the target and adjacent candidate owners' canonical boundary documents
  before opening broad implementation surfaces or moving behavior.
- Keep process argument parsing in the project-declared CLI or entrypoint
  boundary; do not let command handlers own domain processing, rendering,
  persistence, server handlers, or external adapters.
- Keep HTTP/API handlers thin: request parsing, auth/permission checks,
  dependency wiring, and error mapping only.
- Keep local filesystem safety, path validation, and destructive operations in
  an owned boundary rather than scattered across handlers.
- Keep domain rules, parsing, rendering, storage, and external tool/library
  adapters in focused packages.
- Keep file-format-specific, platform-specific, or external-adapter behavior
  behind small interfaces or registries. Avoid broad type switches in generic
  orchestration code.
- Keep terminal UI and browser UI concerns behind rendering or API boundaries so
  one presentation path does not leak into another.
- Remove temporary scaffold helpers once the real package boundary exists. For
  example, do not keep direct adapter helpers after parser, domain, and
  renderer interfaces are in use.
- Do not finish a refactor with missing, stale, contradictory, duplicated, or
  overgrown boundary documents in the touched units.

## ExecPlan Boundary Requirements

For features spanning multiple packages, include a short package ownership and
dependency section in the ExecPlan or plan before implementation when the
project uses planned changes. If the refactor comes from a linked roadmap item,
read the linked brief declared in project facts before drafting that section.
It should name:

- which module/package/component parses input
- which module/package/component owns state
- which module/package/component performs IO or external calls
- which module/package/component renders output
- which interfaces or contracts connect the boundaries
- which boundary is allowed to know about file-format-specific,
  platform-specific, external-adapter, or transport-specific behavior
