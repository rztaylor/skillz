---
name: document-code-boundaries
description: >
  Use when creating, restructuring, refactoring, reviewing, testing, or
  documenting packages, modules, crates, services, feature components, or
  other code ownership boundaries. Creates and audits concise, dedicated
  boundary documents that let humans and agents understand purpose, owned
  responsibilities, non-responsibilities, adjacent owners, and dependency
  direction without loading implementation files.
---

# Document Code Boundaries

Maintain a small, canonical boundary document for each hand-written
architectural code unit. Treat the document as the first-read ownership
contract, not as an API reference or implementation guide.

## Project Facts And Defaults

Read relevant guidance in this order:

1. explicit user instructions
2. `AGENTS.md` and `.agents/facts/architecture.md`
3. detected language facts such as `.agents/facts/go.md`
4. established repository conventions
5. the defaults in this skill and its language references

Missing facts do not block this skill when the defaults apply. Use facts to
record project-specific unit definitions, filenames, exemptions, size limits,
or validation commands. Propose capturing a convention only when it differs
from the defaults or becomes repeatedly useful.

An architectural code unit owns a coherent responsibility or dependency
boundary. It may be a package, crate, service, feature component, or standalone
module. Do not treat every source directory or leaf file as a separate unit.
Use language conventions, manifests, public entrypoints, imports, and existing
architecture to identify the obvious units. If ambiguous granularity would
materially change the documentation surface, proceed with obvious units and
ask for or record the remaining decision.

## Required Boundary Document

Every hand-written architectural code unit must have one canonical boundary
document that:

- is dedicated to documentation and contains no implementation behavior
- can be read without loading implementation-heavy files
- states the unit's purpose and owned responsibilities
- states important non-responsibilities
- names adjacent owners when excluded behavior would otherwise be ambiguous
- records important dependency-direction constraints when they are not obvious
- describes current behavior rather than planned or historical behavior

Use a dedicated language-native file when one exists. Otherwise use:

- `BOUNDARY.md` for a directory-level unit
- `<name>.boundary.md` for a significant standalone unit

Embedded comments or docstrings may supplement the boundary document. They do
not replace it when they live in an implementation-heavy file. Keep the full
ownership contract in one canonical location; link to it instead of copying it
into READMEs or developer guides.

Generated-only and vendored units are exempt by default. Declare additional
project exemptions in architecture or language facts rather than deciding them
ad hoc. A unit containing both generated and hand-written behavior is not
generated-only.

## Brevity Budget

Prefer 5-15 lines and no more than about 150 words. The default hard limit is
2 KiB unless project facts declare another limit.

Keep API inventories, symbol documentation, usage examples, setup instructions,
implementation details, change history, roadmap content, and general developer
guidance elsewhere. A boundary document should answer "does this behavior
belong here?" quickly.

## Workflow

1. Discover canonical boundary documents before opening implementation files.
   Start with `rg --files -g 'doc.go' -g 'BOUNDARY.md' -g '*.boundary.md'` and
   add project-declared filenames when present.
2. Read the target unit's document before changing its code, tests, or public
   surface. Read adjacent candidate owners before deciding where behavior
   belongs.
3. Create the boundary document with every new architectural unit.
4. Update all affected boundary documents when responsibilities, exclusions,
   dependencies, or ownership move.
5. Compare each touched document against the implementation. Resolve vague,
   stale, contradictory, duplicated, or overgrown descriptions.

For Go repositories or Go components, read and apply `references/go.md`.

## Adoption And Review

Apply the requirement immediately to new repositories, new units, and touched
units. Treat missing documents in untouched legacy units as migration debt;
do not expand an unrelated change into a repository-wide backfill unless the
user asks for standardization.

When implementing changes, add or repair required documents within the touched
scope. When reviewing only, report findings without editing. Classify:

- a new unit without its document as blocking
- moved responsibility without corresponding document updates as blocking
- a document that contradicts implementation as blocking
- a touched legacy unit without its required document as blocking unless it has
  an explicit exemption
- missing documents in untouched legacy units as non-blocking migration debt
- minor verbosity that does not obscure ownership as non-blocking cleanup
