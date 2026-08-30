# Kotlin Multiplatform Mobile Technical Debt

Use this reference for Kotlin Multiplatform, Compose Multiplatform, Android,
and iOS application debt reviews.

Inspect the source-set graph, Gradle/Xcode hosts, manifests and entitlements,
database schemas, platform adapters, shared UI/state, and test source sets.
Prioritise evidence in current behavior and declared product/platform contracts.

Look for:

- business rules, validation, repositories, or ViewModels duplicated between
  Android and iOS instead of shared deliberately
- Android or Apple framework types leaking into common contracts
- broad `expect`/`actual` surfaces, target switches, or platform conditionals
  where a narrow capability adapter would suffice
- lifecycle-sensitive state or timers tied to a screen, Activity, ViewController,
  or SwiftUI view instead of an appropriate durable/shared owner
- coroutines whose scope, cancellation, dispatcher, or error ownership is
  unclear; Flow/StateFlow collection that can duplicate work or lose state
- Compose screens that mix domain calculations, persistence, navigation,
  permissions, file access, notifications, or host setup with rendering
- phone-only assumptions, orientation/device-name checks, fixed dimensions, or
  duplicated tablet/foldable/iPad implementations instead of window-driven UI
- missing state restoration across backgrounding, process recreation, resize,
  fold/unfold, and route changes
- Room schema changes without exported schemas, explicit migrations, migration
  tests, stable identifiers, or immutable historical snapshots where required
- backup/restore formats without versioning, validation, atomic replacement,
  rollback, or corrupt-input coverage
- native capabilities implemented in common code, or platform adapters that
  silently diverge in semantics
- Android-only validation standing in for iOS compilation, or simulator-only
  claims standing in for required device behavior
- generated resources, KSP output, build caches, signing data, or developer-local
  configuration accidentally tracked or packaged

Treat absent cross-target coverage as high risk when the changed contract is
shared. Rank deferred physical-device, notification, background execution,
file-picker, signing, or store behavior according to the release surface rather
than assuming simulator success proves it.
