# Kotlin Multiplatform Mobile Pre-PR Review

Use this reference when a PR changes Kotlin Multiplatform, Compose
Multiplatform, Android, or iOS code, resources, build configuration, or native
host behavior.

## Scope map

Classify changed files across common source sets, Android and iOS source sets,
Android host, Swift/SwiftUI host, Gradle/version catalog, Xcode project and
configuration, Compose resources, Room schemas/migrations, platform adapters,
tests, manifests, entitlements, and packaging.

## Review gates

Verify that:

- shared contracts remain free of Android/Apple framework leakage and native
  work stays behind narrow adapters
- domain, persistence, lifecycle, and navigation behavior has one clear owner;
  platform hosts do not reimplement shared workflows
- coroutine scopes, dispatchers, cancellation, Flow collection, and background/
  foreground transitions cannot duplicate work or lose user state
- UI state survives relevant navigation, process recreation, resize, rotation,
  fold/unfold, and iPad window changes
- adaptive UI is window-driven and accessible at large text sizes; semantics,
  touch targets, focus/IME, insets, safe areas, back behavior, and destructive
  confirmations remain correct
- Room schema changes include exported schemas, explicit migrations, stable
  identifiers, and migration/restore evidence required by project facts
- backups, files, notifications, haptics, permissions, and other native services
  behave consistently or document intentional platform differences
- resources are packaged rather than loaded from undeclared network paths, and
  generated/build/developer-local/signing artifacts are not accidentally tracked
- Android manifests, iOS plist/entitlements, privacy declarations, deployment
  targets, bundle/application IDs, and dependency versions match project facts

## Validation evidence

Choose commands from project facts. Shared changes normally need common tests
plus compilation for every supported target. Android UI/host changes need the
relevant Android build and tests; iOS/shared-framework changes need an Xcode or
declared simulator build. Database changes need DAO and migration tests.

For visible changes, require the project-declared compact, foldable/resizable,
tablet, iPhone, iPad-window, large-font, accessibility, and screenshot/smoke
matrix. Do not treat desktop/JVM Compose rendering as Android or iOS evidence.

Report each unrun target or device-only capability explicitly. Physical-device,
notification, background execution, file picker, signing, and store checks may
remain accepted risk only when project policy permits it.
