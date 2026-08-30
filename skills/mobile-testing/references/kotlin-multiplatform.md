# Kotlin Multiplatform Test Matrix

Use this reference for Kotlin Multiplatform applications with shared Compose UI
and Android/iOS targets.

## Choose tests by owner

- `commonTest`: domain rules, validation, calculations, serialization, stable
  identifiers, ViewModel/presenter transitions, coroutine cancellation, and
  repository contracts that can use portable fakes
- JVM/desktop host tests: fast Room/SQLite integration and shared Compose tests
  when the repository declares this surrogate; never label them Android/iOS
  runtime evidence
- Android host/unit tests: Android database construction, lifecycle adapters,
  manifests/resources, Activity integration, WindowManager posture, permissions,
  notifications, files, and Android-specific error mapping
- Android instrumented/device tests: framework behavior that host tests cannot
  represent, process recreation, system UI, permissions, backgrounding, and
  representative adaptive-window journeys
- iOS tests/simulator: Kotlin/Native behavior, Room/SQLite integration, shared
  framework linkage, Swift/SwiftUI host integration, safe areas, back/navigation,
  background/resume, files, notifications, and platform adapters
- physical devices: capabilities whose correctness depends on hardware,
  provisioning, notification delivery, background execution, file providers,
  haptics, performance, or store-signed behavior

## Persistence and backup

For Room or SQLite changes, verify exported schema files, every supported
migration path, fresh creation, representative old data, constraints and
transactions, failed migration/restore behavior, and the repository's downgrade
policy. Backup tests should cover version detection, validation before mutation,
atomic replacement/rollback, unknown fields or versions according to policy,
stable identifiers, and immutable historical snapshots.

## Compose and adaptive UI

Test state and semantics separately from pixels. Cover compact, medium, and
expanded policy breakpoints; fold/hinge occlusion; rotation and live resize;
iPhone/iPad safe areas; large text; touch targets; focus and IME; screen-reader
labels/state; dialogs/sheets; system back; and preservation of active workflow
state. Use deterministic screenshots for representative visual contracts when
the project maintains baselines.

## Coroutines, lifecycle, and state

Use test dispatchers and virtual time. Assert cancellation and ownership of
long-lived jobs, one-off event consumption, no duplicated collectors or writes,
state restoration after host recreation, and correct behavior when the app
moves between foreground and background. Test timers against an injected clock
or absolute deadline rather than elapsed real sleeps.

## Evidence language

Report what each check proves:

- compilation proves source/API compatibility for that target
- unit tests prove the exercised contracts on their runtime
- emulator/simulator launch proves packaging and a bounded host journey
- physical-device checks prove only the exercised hardware/native behavior
- signing/archive/store validation is separate from debug installation

If a target cannot run, name the exact command or manual check and why it was
unavailable. Do not let JVM success stand in for Kotlin/Native compilation, or
simulator success stand in for device-only behavior.
