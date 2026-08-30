# Kotlin Multiplatform Mobile Structural Refactoring

Use this reference for behavior-preserving refactors across Kotlin
Multiplatform, Compose Multiplatform, Android, and iOS code.

## Dependency direction

Prefer this direction unless project facts establish another:

```text
native Android/iOS hosts -> shared app/navigation/UI -> feature state/use cases
-> domain contracts <- data repositories <- platform persistence/adapters
```

Common domain code must not depend on Compose, Room entities, Android, or Apple
frameworks. Shared UI may depend on stable feature/domain state but not native
hosts. Hosts assemble lifecycle and adapters; they should not own parallel
business workflows.

## Refactoring rules

- Move duplicated platform business behavior to common code only when semantics
  are truly identical. Keep real platform differences behind a small common
  capability contract.
- Prefer ordinary common interfaces and dependency injection over `expect`/
  `actual`; reserve `expect`/`actual` for small language/platform primitives
  where it improves clarity.
- Separate Room entities/DAOs, repository mapping, domain models, migrations,
  database construction, and backup/import logic. Preserve schema and historical
  behavior during extraction.
- Keep composables stateless where practical. Move domain calculations, IO,
  timers, navigation decisions, permission flows, and long-lived coroutine work
  to their declared owners without creating a universal screen controller.
- Split large feature packages by coherent ownership—state/workflow, UI
  composition, reusable components, and data contracts—not by one file per
  class or arbitrary layer symmetry.
- Consolidate adaptive layout policy, design tokens, semantics, formatters, and
  repeated UI states at their narrowest shared owner. Preserve screen-specific
  composition and legitimate platform-native behavior.
- Keep Android Activity/Application and iOS Swift/SwiftUI hosts thin. Native
  adapters own framework calls, lifecycle translation, and result mapping, not
  domain policy.
- Preserve coroutine cancellation, dispatcher ownership, StateFlow identity,
  saved/restored state, navigation/back behavior, and background/resume behavior
  while moving code.
- Avoid changing Gradle/Xcode module or source-set topology unless the ownership
  benefit is explicit and every supported target still compiles.

Update boundary documents for every affected architectural unit. Validate
common behavior, Android compilation/tests, iOS framework/native-host
compilation, database migrations when touched, and representative adaptive UI
states. A desktop/JVM Compose check is useful but does not replace target checks.
