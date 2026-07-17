---
name: go-testing
description: Use when adding or changing Go tests, frontend-adjacent Go validation, fixtures, test harnesses, CI checks, or regression coverage. Uses repo-local project facts from AGENTS.md and .agents/facts/*.md when present.
---

## Project Facts

Before relying on repo-specific validation commands or test policy, read:

1. `AGENTS.md`
2. `.agents/facts/go-testing.md`
3. `.agents/facts/go.md` and `.agents/facts/testing.md`
4. repository structure and scripts when facts are missing

If a Go testing or validation fact is repeatedly useful, propose adding it to
`.agents/facts/go.md`, `.agents/facts/testing.md`, or
`.agents/facts/go-testing.md`.

If validation, fixture, generated-asset, service, or CI policy is missing from
both facts and established repository structure, do not invent it. Ask to run
`repo-setup` or create the relevant fact file first.

When this skill is active:
- read and apply `document-code-boundaries` and its Go reference when tests
  create, touch, or reveal ownership questions in Go packages
- before adding or moving tests for a Go package, read its required `doc.go`
  and the `doc.go` files of candidate owner packages; align tests with the
  documented responsibility
- prefer project validation scripts such as `scripts/test.sh` and
  `scripts/check.sh` once they exist; until then, use targeted raw Go commands
  with writable caches in the Codex sandbox
- prefer a compact project validation helper when one exists; otherwise keep
  raw `go test` output focused on the changed packages
- check prerequisites before broader validation when local services, browsers,
  external tools, network, or generated frontend assets are uncertain
- when running raw `go test`, `go test -cover`, or `go build` commands in
  Codex, set a writable cache such as `GOCACHE="$PWD/.cache/go-build"` first;
  the default Go cache under the user home directory may be outside the
  sandbox write boundary
- do not start integration tests, live network calls, destructive filesystem
  flows, or heavyweight local services unless the task scope requires them or
  the user asks for release/integration validation; verify prerequisites first
  and report unavailable services as skipped validation gaps
- add `doc.go` when a touched hand-written Go package lacks it; missing project
  facts do not block the shared default, while explicit exemptions belong in
  architecture or Go facts
- place tests in the package that owns the behavior under test; do not keep tests in an orchestration package after behavior has moved to a focused package
- if test placement reveals unclear, drifting, or contradictory package
  responsibilities, update every affected `doc.go` or flag the unresolved
  boundary issue before adding broad coverage
- use table-driven tests for parsing, validation, and output variants
- test CLI behavior through package APIs with in-memory stdout and stderr
- use `t.TempDir` for filesystem tests and keep fixtures small
- fake HTTP clients, clocks, filesystems, and external services instead of using live dependencies in CI
- assert exit codes and user-facing messages for CLI errors
- add focused golden, snapshot, or equivalent string-shape tests for default
  human CLI output when changing prompts, warnings, summaries, or errors; cover
  line order, blank-line grouping, action-prompt wording, and metadata noise
  budget
- add regression tests for bug fixes when the behavior has a practical test surface
- keep tests deterministic and safe to run with `go test ./...`
- keep fixtures small and scrubbed; never commit real cookies, authorization
  headers, API keys, personal documents, or private user data
