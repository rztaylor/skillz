# Compose Multiplatform Mobile UI

Use this reference for shared Compose UI targeting Android and iOS. Preserve
repository product, design-system, navigation, and platform-host decisions.

## Ownership and state

- Keep domain rules, persistence, import/export, timers, and native services out
  of composables. Composables render state and emit user intent.
- Hoist screen state to the established ViewModel/presenter owner. Use saveable
  UI state only for genuinely local presentation details; do not mistake it for
  durable workflow or database state.
- Collect lifecycle-aware state using the established cross-platform pattern.
  Avoid starting duplicate collectors or long-lived work from recomposition.
- Keep navigation state and deep-link/back behavior in the declared navigation
  owner. Verify Android system back and iOS host/navigation expectations.
- Put native permissions, notifications, haptics, file pickers, share sheets,
  window posture, and other platform APIs behind narrow adapters.

## Adaptive and accessible UI

- Drive composition from available window size and posture, not device names or
  orientation. Compact, medium, and expanded layouts should preserve workflow
  state while resizing, rotating, folding, or changing iPad window size.
- Wide layouts should add bounded context or panes rather than stretch compact
  content. Keep critical actions reachable and avoid hinge/occlusion regions.
- Use semantic roles, labels, state descriptions, traversal order, minimum touch
  targets, scalable text, sufficient contrast, and non-color state cues.
- Verify keyboard/IME behavior, focus, dialogs/sheets, system bars, safe areas,
  insets, and gesture conflicts on both platforms.
- Prefer shared semantic components and tokens. Allow platform-specific UI only
  when native behavior materially differs; keep the shared contract explicit.

## Required states and validation

Cover loading, empty, content, validation, recoverable error, destructive
confirmation, background/resume, and restored-state behavior as applicable.

Use project-declared commands. For meaningful visible changes, combine:

- common unit and Compose UI tests for shared behavior
- Android unit/instrumented or host tests and a debug build
- iOS simulator compilation and launch through the native host
- compact phone, foldable/resizable, tablet, iPhone, and iPad-window checks
  required by project facts
- large-font, screen-reader semantics, focus/IME, dark/light theme, and screenshot
  or visual-baseline checks relevant to the change

Do not claim iOS readiness from JVM or Android tests alone. Record exactly which
targets, window classes, accessibility modes, and native behaviors were not run.
