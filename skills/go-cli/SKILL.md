---
name: go-cli
description: >
  Use when implementing, changing, refactoring, testing, or documenting Go
  command-line tools, including commands, subcommands, flags, config loading,
  startup wiring, stdout/stderr output, help text, prompts, dry-run or force
  behavior, exit codes, and CLI regression tests. Coordinator skill: combines
  cli-ux, structural-refactorer, go-testing, and docs-maintainer when relevant.
---

# Go CLI

Use this skill as the entrypoint for Go CLI implementation work. It coordinates
existing skills rather than replacing them.

## Project Facts

Before relying on repo-specific CLI conventions, package boundaries,
validation commands, documentation locations, release policy, or safety rules,
read:

1. `AGENTS.md`
2. `.agents/facts/go-cli.md`
3. `.agents/facts/cli.md` and `.agents/facts/cli-ux.md`
4. `.agents/facts/go.md`, `.agents/facts/testing.md`, and
   `.agents/facts/architecture.md` when implementation boundaries or tests
   matter
5. `.agents/facts/docs.md` and `.agents/facts/release.md` when user-facing
   command behavior, documented usage, changelog policy, or release impact
   matters
6. repository structure, scripts, package files, docs, and CI config when facts
   are missing

If a Go CLI convention is repeatedly useful, propose adding it to
`.agents/facts/go-cli.md`, `.agents/facts/cli.md`, `.agents/facts/go.md`, or
the relevant shared fact file.

If CLI, config, validation, safety, documentation, release, or package-boundary
policy is missing from both facts and established repository structure, do not
invent it. Ask to run `repo-setup` or create the relevant fact file first.

Missing facts do not block the self-contained documentation defaults in
`document-code-boundaries`; they do not decide the implementation boundary,
but they do require the discovered or chosen boundary to be documented.

## Coordinated Skills

When this skill is active, also read and apply these skills when available:

- `cli-ux` for command names, flags, help text, stdout/stderr, prompts,
  default output, machine-readable output, confirmations, dry-run behavior, and
  error messages
- `structural-refactorer` plus its Go reference for `cmd/`, `internal/`,
  package ownership, domain boundaries, adapters, and dependency direction
- `go-testing` for Go test placement, CLI behavior tests, output assertions,
  fixtures, fake dependencies, and validation commands
- `docs-maintainer` when command behavior, flags, config, local-server
  behavior, output formats, changelog policy, or documented usage changes
- `document-code-boundaries` plus its Go reference for concise mandatory
  `doc.go` files, package ownership discovery, and boundary updates

Do not duplicate detailed rules from those skills here. Use this skill to make
sure the right workflow is assembled for Go CLI work.

## Implementation Workflow

1. Classify the change: new command, changed command behavior, flag or config
   change, output change, destructive action, startup wiring, refactor, or
   test-only coverage.
2. Read the existing CLI entrypoint, command routing, config loading, every
   touched package's required `doc.go`, candidate owner packages' `doc.go`
   files, validation scripts, and user-facing docs that describe the touched
   behavior.
3. Define the package boundary before editing:
   - `cmd/<binary>/main.go` owns startup wiring and error-to-exit behavior.
   - the project-declared CLI package owns argument parsing, command dispatch,
     validation, user presentation, and process-facing exit decisions.
   - app or domain packages own business behavior.
   - adapter packages own filesystem, network, subprocess, browser, storage,
     or external-service interactions.
4. Preserve existing observable behavior unless the user asked to change it.
   Observable behavior includes command names, flags, config precedence,
   stdout, stderr, prompts, exit codes, writes, network calls, and generated
   files.
5. Keep command handlers thin. Move parsing, rendering, domain behavior,
   storage, filesystem safety, and external adapters behind focused packages
   or interfaces.
6. Update tests and docs in the same change when the user-facing CLI contract
   changes.
7. Create or update affected `doc.go` files in the same change when packages
   are added, touched without one, or change responsibility.

## Go CLI Design Rules

- Keep process-global state small and explicit. Prefer injected IO, environment,
  filesystem, clock, HTTP client, subprocess runner, or service clients for
  behavior that needs tests.
- Pass `context.Context` through blocking, IO, network, subprocess, browser, or
  long-running paths.
- Return errors from lower packages; let the CLI boundary map errors to user
  messages and exit codes.
- Keep stdout for command results and stderr for help, progress, warnings, and
  errors.
- Make config precedence testable and visible when it affects output, writes,
  network calls, credentials, host/port selection, or safety.
- Require explicit intent for destructive actions through confirmations,
  `--yes`, `--force`, or a project-approved equivalent. Prefer dry-run previews
  for file writes, remote changes, and durable local state changes.
- Keep human output readable by default. Add explicit machine-readable output,
  such as `--output json`, before promising scriptable contracts.
- Fail unknown commands, modes, flags, and config keys clearly. Do not fall
  through to unrelated behavior.

## Testing And Validation

- Test CLI behavior through package APIs with in-memory stdout and stderr.
- Assert exit codes, stdout, stderr, prompts, validation errors, and default
  output shape for changed behavior.
- Use table-driven tests for command parsing, flag validation, config
  precedence, output variants, destructive-action gating, and error mapping.
- Use `t.TempDir`, fake clocks, fake HTTP clients, fake filesystems, and fake
  subprocess runners instead of live dependencies where practical.
- Keep tests in the package that owns the behavior under test. Move tests when
  behavior moves to a more focused package.
- Prefer project validation scripts when they exist. For raw Go validation in
  Codex sandboxes, set a writable cache such as
  `GOCACHE="$PWD/.cache/go-build"`.

## Documentation And Release Surface

When a Go CLI change alters commands, flags, config, output, prompts,
local-server behavior, generated files, safety behavior, compatibility, or
support boundaries:

- update the relevant user, developer, reference, or release docs declared in
  project facts
- add a curated changelog entry when project facts declare a changelog policy
- state why no docs or changelog update is needed when no relevant behavior
  changed, no docs location exists, or no changelog policy is declared
