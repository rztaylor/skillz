# Kotlin Multiplatform Mobile Repository Foundation

Use this reference when creating or restructuring a Kotlin Multiplatform mobile
repository targeting Android and iOS. Preserve an established layout; these are
defaults for new/sparse foundations or explicit standardization work.

## Facts to establish

Capture durable policy in `.agents/facts/` for:

- Kotlin, Gradle, Android Gradle Plugin, Compose, KSP, persistence, Android SDK,
  Xcode, Swift, and deployment-target compatibility
- shared modules/source sets and dependency direction
- Android and iOS native host ownership
- platform adapter capabilities and where `expect`/`actual` is allowed
- adaptive window/posture policy, navigation, design-system, and accessibility
- database schemas, migrations, seed data, stable identifiers, and backup format
- common, Android, iOS, simulator/device, visual, accessibility, and release
  validation commands plus required host tools
- application/bundle identifiers, signing ownership, secrets/local config,
  artifact targets, store/TestFlight/Play policy, and release prerequisites

## Default shape

- Keep domain models, rules, repositories/contracts, ViewModels/presenters, and
  reusable Compose UI in common code when semantics are genuinely shared.
- Keep Android Activity/application setup and iOS Swift/SwiftUI app hosting
  small; hosts assemble shared UI and native capabilities.
- Put notifications, haptics, files, permissions, database construction, window
  posture, and other native APIs behind narrow common contracts with platform
  implementations.
- Use source sets intentionally. Do not add an intermediate source set until two
  or more targets share real code that does not belong in `commonMain`.
- Keep generated KSP/Room output and build products untracked. Commit exported
  database schemas and migrations when persistence is part of the product.
- Use a pinned version catalog and checked-in Gradle Wrapper when consistent with
  project policy. Keep personal SDK, device, signing, and team configuration in
  ignored local files or secure CI secrets.
- Package shared resources through the established Compose resource pipeline;
  separate canonical source assets from optimized distribution assets when
  size or licensing requires it.

## Validation foundation

Provide discoverable commands for common tests, database/migration tests,
Android debug/release builds, Android UI/host tests, iOS simulator compilation
and launch, iOS archive/device compilation when applicable, formatting/static
checks, and representative adaptive/accessibility smoke tests.

Do not make iOS a declared target without a buildable native host and a command
that compiles it. Do not make Android-only tests the sole gate for shared code.
Document host-tool and signing prerequisites without storing credentials.
