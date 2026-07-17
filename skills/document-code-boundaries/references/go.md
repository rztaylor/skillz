# Go Boundary Documentation

Read this reference when `document-code-boundaries` is active and the project
contains Go packages.

## Required File

Every hand-written Go package must contain `doc.go`. This includes `package
main` unless project facts explicitly exempt a trivial generated entrypoint.

The file must:

- contain the canonical `// Package <name> ...` package comment
- contain no implementation behavior beyond the package declaration
- state the package purpose, owned responsibilities, important
  non-responsibilities, and adjacent owners when non-obvious
- record important dependency-direction constraints when they clarify scope
- stay within the shared brevity budget unless project facts override it

Use concise prose such as:

```go
// Package config loads and validates startup configuration.
//
// It owns path resolution, document parsing, and runtime settings construction.
// Persistent storage and live connection management belong to their respective
// adapter packages; config must not open connections or retain session state.
package config
```

Do not turn `doc.go` into an API inventory, usage guide, design history, or
collection of symbol comments.

## Scope And Exemptions

- Generated-only and vendored packages are exempt.
- A package containing any hand-written behavior is not generated-only.
- External test packages such as `foo_test` do not require a separate
  non-test `doc.go`.
- Example or fixture packages are exempt only when project facts or established
  repository policy declare the exemption.

## Workflow

- Read `doc.go` before opening implementation files in a target package.
- Read candidate owner packages' `doc.go` files before placing or moving
  behavior or tests.
- Create `doc.go` in the same change as a new package.
- Add `doc.go` when touching an undocumented hand-written package.
- Update every affected `doc.go` when ownership, exclusions, or dependency
  direction changes.
- Treat missing, stale, contradictory, vague, or oversized `doc.go` files using
  the shared adoption and review classifications.
