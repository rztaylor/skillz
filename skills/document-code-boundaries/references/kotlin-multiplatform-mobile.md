# Kotlin Multiplatform Mobile Boundaries

Use this reference for Kotlin Multiplatform, Compose Multiplatform, Android,
and iOS application code.

## Architectural units

Treat these as likely architectural units when they own coherent behavior:

- shared domain, data, repository, use-case, ViewModel, navigation, design-system,
  feature, and resource packages in `commonMain`
- platform adapters and platform-specific implementations in `androidMain` and
  `iosMain`
- Android application hosts and iOS Swift/SwiftUI hosts
- database modules, migration ownership, import/export formats, notification,
  haptic, file, window/posture, and other native-service adapters

Do not create a boundary document for every source set, screen file, composable,
expect/actual pair, generated Room/KSP output, resource directory, or Xcode
group. Document the coherent owner, not build-system taxonomy.

## Placement

Use `BOUNDARY.md` beside the owning package or host directory unless project
facts declare another canonical filename. A shared unit's document should state
which behavior is common and which adjacent platform adapter owns native work.
A platform unit's document should state the native capability it exposes and
must not claim shared domain or UI policy.

Record dependency direction where relevant:

- common code must not depend on Android or Apple frameworks
- shared domain code should not depend on Compose, Room entities, or host UI
- Compose screens may depend on shared state/contracts, not native hosts
- platform hosts should assemble lifecycle and native services, not reimplement
  shared workflows
- platform adapters should remain narrow and expose common contracts

When ownership differs by target, name both owners explicitly. Keep generated
code exempt, but document the hand-written schema, migration, or processor owner
that produces or consumes it.
