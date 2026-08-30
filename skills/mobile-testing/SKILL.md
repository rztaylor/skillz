---
name: mobile-testing
description: >
  Use when adding, changing, reviewing, or running tests for Kotlin
  Multiplatform, Compose Multiplatform, Android, or iOS applications. Covers
  shared logic, coroutines and state, Room databases and migrations, Compose
  UI, native hosts and adapters, lifecycle restoration, adaptive windows,
  accessibility, simulator/device smoke tests, and honest cross-target evidence.
---

# Mobile Testing

Use this skill to choose and implement the smallest mobile test matrix that
gives credible evidence for the changed behavior across supported targets.

## Project facts

Read, in order:

1. `AGENTS.md`
2. `.agents/facts/testing.md`
3. `.agents/facts/mobile.md`, `.agents/facts/android.md`,
   `.agents/facts/ios.md`, `.agents/facts/frontend-ui.md`,
   `.agents/facts/architecture.md`, and `.agents/facts/release.md` when relevant
4. build files, source sets, test tasks, native hosts, CI, and existing test
   conventions when facts are incomplete

Use project-declared commands and supported target/device matrices. Do not
invent signing, physical-device, simulator, accessibility, or release policy.
Propose a durable testing fact when a repeatedly needed rule is absent.

For Kotlin Multiplatform and Compose Multiplatform projects, read and apply
`references/kotlin-multiplatform.md`.

## Workflow

1. Map the changed contract to its owner: common domain/state, persistence,
   shared UI, platform adapter, Android host, iOS host, packaging, or an
   end-to-end journey.
2. Identify failure modes, state transitions, lifecycle boundaries, target
   differences, and the cheapest layer that can prove each behavior.
3. Add focused deterministic tests at the owning layer. Prefer behavior and
   state-transition assertions over implementation details or screenshots
   alone.
4. Run narrow tests first, then compile and exercise every supported target
   affected by the contract.
5. Record exact commands, targets, virtual/physical devices, window sizes,
   accessibility modes, and unavailable checks. Never convert an unrun target
   into an implicit pass.

## General rules

- Keep common behavior tests in common test code when they do not need a native
  runtime. Do not duplicate the same contract per platform without a platform
  difference to prove.
- Test platform adapters at their narrow native boundary and keep shared
  contract tests reusable where practical.
- Control clocks, dispatchers, identifiers, locale, time zone, random values,
  and fixture dates. Avoid real sleeps and order-dependent shared state.
- Test cancellation, retry/error mapping, background/resume, restoration,
  process recreation, and duplicate-event prevention when relevant.
- For persistence, test transactions, constraints, migrations, corrupt input,
  rollback, idempotency, and immutable-history behavior required by product
  policy—not only DAO happy paths.
- For UI, test semantics and user-visible state transitions. Use screenshot or
  visual baselines for layout/rendering regressions, not as the sole assertion
  for workflow correctness.
- Keep fixture data recognisable as synthetic. Ensure development seed switches,
  test resources, logs, and secrets cannot enter release behavior.
- Do not add a test framework or device service when existing tools can prove
  the contract. Follow repository dependency policy.

## Result

Summarize changed coverage, commands and targets run, failures, skipped checks,
and remaining device/platform risk. Distinguish compilation, automated tests,
simulator/emulator smoke tests, and physical-device evidence.
