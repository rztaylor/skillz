# React And TypeScript Guidance

Use this reference for React/TypeScript projects. For other frameworks, apply
the same boundary principles through that framework's established patterns.

## Orientation

- Read `package.json`, TypeScript config, bundler config, route files, state
  stores, API clients, CSS entrypoints, component library setup, and test setup
  before editing.
- Check React, framework, router, state, query, form, table, editor, and styling
  package versions before relying on version-specific APIs.
- If unsure about current APIs, read official documentation for the exact
  library and version family.

## Components

- Prefer function components, typed props, and existing component conventions.
- Keep route components focused on route data, workflow orchestration, and
  composition. Put reusable presentation and interaction contracts in the
  project's shared or feature component layer.
- Reuse or extend an existing component before creating a local alternative.
  Represent coherent differences with typed variants, slots, children, or
  composition rather than copied JSX forks.
- Keep render logic readable. Extract a child component when it clarifies a real
  responsibility, not just to shorten a file.
- Extract a shared component when multiple current or approved-scope consumers
  have the same semantic and interaction contract. Keep coincidentally similar
  domain components separate when sharing would require unrelated boolean flags
  or page-specific knowledge.
- Do not derive state with effects when it can be derived during render or from
  existing query/store/form state.
- Keep effects for synchronization with external systems, subscriptions,
  timers, focus management, measurements, imperative editor APIs, and browser
  APIs. Include cleanup when the effect owns a resource.
- Preserve stable keys, controlled input ownership, memoization conventions, and
  suspense/error-boundary patterns already used by the project.

## State And Data

- Use local component state for local interaction only.
- Use the established store, router data, query cache, context, or URL state
  when state is shared across routes/components, must survive navigation, or is
  part of the product workflow.
- Keep server state and client UI state separate when the project already uses a
  query/data layer.
- Model loading, empty, optimistic, stale, failed, and retry states explicitly
  when users can observe them.
- Put repeated stateful interaction or lifecycle behavior in a focused hook or
  the established store/query/form boundary. Put repeated pure formatting,
  validation, and view-model mapping in focused helpers.

## TypeScript

- Keep API response, domain, view-model, and component prop types at the
  boundary that owns them.
- Prefer narrow unions and explicit optional fields over loose dictionaries for
  UI modes, statuses, validation errors, and API results.
- Avoid `any` and non-null assertions unless the project already uses them for a
  documented boundary and runtime validation makes the assumption safe.
- Update generated or shared API types together with backend/API contract
  changes when the project uses typed contracts.

## Tests

- Follow the project's test tool: React Testing Library, Vitest, Jest,
  Playwright, Cypress, Storybook, or another established runner.
- Prefer user-observable assertions: accessible names, roles, visible text,
  validation messages, focus movement, disabled states, and API-boundary calls.
- Add regression coverage for bug fixes and for state transitions that are easy
  to break.
- Test shared components and hooks at their public contract. When the project
  uses Storybook or an equivalent component harness, add representative states
  and variants for reusable visible UI.
