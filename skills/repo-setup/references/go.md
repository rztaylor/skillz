# Go Repository Setup Reference

Read this file when `repo-setup` is active and the project is a Go repository
or is adding a Go component.

## Layout

- Put binary entrypoints under `cmd/<binary-name>/`.
- Keep `main` small: parse startup flags, wire dependencies, call package code,
  and map returned errors to process exits.
- Put implementation packages under `internal/` unless a public Go API is
  intentional.
- Use `pkg/` only for packages that are intended to be imported by external
  users.
- Keep generated assets and vendored/generated code clearly separated from
  hand-written source.

## Documentation

- Add or update package `doc.go` files when package ownership or boundaries are
  non-obvious or change.
- Document required validation commands and local development prerequisites in
  project docs, not only in CI config.

## Tooling

- Prefer repeatable scripts in `scripts/` for common format, test, build, and
  release workflows once raw commands recur.
- In Codex sandboxes, raw Go validation should set a writable cache, for
  example `GOCACHE="$PWD/.cache/go-build" go test ./...`.
- For Dependabot, use `gomod` at `/`; include `github-actions` when workflows
  exist.
- Prefer `gofmt` for formatting and project-approved lint/vet checks when they
  already exist.
