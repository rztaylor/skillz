# Kotlin Multiplatform Mobile Release Checks

Use this reference for Android/iOS release candidates built from Kotlin
Multiplatform or Compose Multiplatform projects. Repository release facts remain
authoritative for supported platforms, stores, signing, and rollout policy.

## Shared release contract

Confirm pinned compatible Kotlin, Gradle, Android Gradle Plugin, Compose, KSP,
Room/SQLite, Xcode, and deployment-target versions. Verify the checked-in
wrapper and lock/version catalog policy, common tests, all supported target
compilations, exported database schemas, migrations, seed/resource packaging,
and versioned backup compatibility.

Ensure release builds reject development fixtures, debug flags, test endpoints,
developer-local configuration, and unsigned or unintended resources. Check that
offline/local-first claims remain true when declared by product facts.

## Android

Check application ID, version code/name, min/target/compile SDK policy, release
variant, manifest permissions/components, backup rules, network-security config,
shrinker/obfuscation behavior, baseline/startup profiles when required, APK/AAB
contents and size budgets, signing source, and Play policy declarations.

Build and inspect the declared release artifact. Install/smoke-test it on the
required API/device matrix without assuming a debug build is equivalent. Never
request or print keystore passwords or signing secrets.

## iOS

Check bundle ID, marketing/build versions, deployment target, architectures,
framework embedding/linkage, Info.plist usage descriptions, entitlements,
privacy manifest, capabilities, icons/launch assets, signing team/profile, and
archive/export configuration.

Build the declared simulator and archive/device targets. Validate the native
Swift/SwiftUI host as well as the shared framework. Never request or print
certificates, provisioning data, API keys, or signing secrets.

## Distribution evidence

Store upload, notarization, signing, physical-device behavior, notifications,
background execution, file access, and restore flows are distinct evidence.
Do not infer them from unit tests or simulator launch. Report exactly which were
performed, blocked, skipped by policy, or accepted as pre-release risk.

Publishing to Play Console, App Store Connect, TestFlight, or any registry is a
separate external mutation and requires explicit user authorization.
