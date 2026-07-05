# Go Structural Refactoring Reference

Read this file when `structural-refactorer` is active and the project is a Go
repository or the touched code is Go.

## Package Ownership

- Keep `cmd/<binary-name>/main.go` small and focused on startup flags,
  dependency wiring, and error-to-exit behavior.
- Keep process argument parsing in `internal/cli` or the project-declared CLI
  package.
- Put application orchestration in `internal/app` or another focused package.
- Put domain behavior, storage, rendering, filesystem safety, and external
  adapters in focused `internal` packages unless a public API is intentional.
- Add or update `doc.go` when package responsibility or boundaries are
  non-obvious or change.

## Boundaries

- Define interfaces near the consuming package.
- Pass `context.Context` through blocking, IO, network, subprocess, or
  long-running paths.
- Return errors from packages; let `main` or the top-level adapter decide user
  presentation and process exit behavior.
- Keep HTTP handlers, CLI handlers, and background jobs thin; move shared
  behavior behind domain/application services.

## Tests

- Place tests in the package that owns the behavior under test.
- Use table-driven tests for parsing, validation, routing decisions, and output
  variants.
- Use `t.TempDir`, in-memory IO, fake clocks, fake clients, and small fixtures
  instead of live dependencies where practical.
