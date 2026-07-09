---
name: frontend-ui
description: >
  Use when implementing, changing, reviewing, or testing browser frontend UI:
  components, state, API integration, forms, dialogs, tables, editors,
  responsive layout, accessibility, CSS/design-system conventions, visual QA,
  browser smoke tests, and frontend build/test validation. Framework-agnostic
  with strong React/TypeScript support; uses repo-local project facts from
  AGENTS.md and .agents/facts/*.md for product tone, UI boundaries,
  local-only/security behavior, validation commands, dependency policy, and
  testing expectations.
---

# Frontend UI

Use this skill for browser UI implementation and review across projects. Prefer
the target repository's established frontend framework, component library,
styling system, state model, test tools, and API boundaries.

## Project Facts

Before relying on project-specific UI behavior, read:

1. `AGENTS.md`
2. `.agents/facts/frontend-ui.md`
3. `.agents/facts/product.md`, `.agents/facts/node.md`, and
   `.agents/facts/testing.md`
4. project-specific UI facts when present, such as
   `.agents/facts/notebook-ui.md`, `.agents/facts/web-ui.md`,
   `.agents/facts/design-system.md`, or other relevant `.agents/facts/*ui*.md`
   and `.agents/facts/*frontend*.md` files
5. repository structure, package files, scripts, frontend docs, test config,
   and CI config when facts are missing

Use facts for durable project policy:

- product audience, design tone, information density, and UX priorities
- local-only, hosted, authentication, authorization, secret-handling, or other
  security boundaries
- frontend source roots, package manager, validation commands, smoke-test
  commands, and external prerequisites
- dependency policy and approved component, table, editor, chart, icon, form,
  router, state, and styling libraries
- API boundary rules, including typed clients or generated clients

If a UI, validation, dependency, or API-boundary fact is repeatedly useful,
propose adding it to `.agents/facts/frontend-ui.md` or the relevant project UI
fact. If safe implementation depends on durable policy that facts and repo
evidence do not define, ask to run `repo-setup` or create the missing fact file
before continuing.

## Reference Routing

- Read `references/react.md` when the project uses React/TypeScript, the user
  asks for React work, or React-specific review guidance is needed.
- Read `references/browser-qa.md` when changing visible UI behavior, browser
  workflows, responsive layout, accessibility, visual rendering, smoke tests,
  or screenshot-based validation.

When current framework, component-library, browser API, or test-runner behavior
matters and local docs are insufficient, research official documentation only.
Prefer primary sources such as framework, library, W3C/WHATWG/MDN, and test
runner docs. Do not use secondary posts as authority for current APIs.

## Workflow

1. Classify the work: new UI, behavior change, API integration, state change,
   visual polish, accessibility fix, browser-test change, or review-only pass.
2. Find the frontend root, build scripts, test scripts, component boundaries,
   state stores, API clients, route structure, styling entrypoints, and existing
   visual or browser-test setup.
3. Define the user flow and required states before editing: default, loading,
   empty, success, validation error, recoverable error, permission/auth state,
   and any destructive or security-sensitive confirmation.
4. Implement or review against existing project patterns. Add abstractions only
   when they remove real duplication or match established local conventions.
5. Verify with the narrowest useful checks first, then broaden according to
   risk and project facts: typecheck, lint, unit/component tests, build,
   browser smoke tests, accessibility checks, screenshots, and responsive
   desktop/mobile inspection.

## Implementation Rules

- Keep API calls behind the project-declared frontend API boundary when one
  exists, such as a typed client, generated client, route module, service
  wrapper, query layer, or framework loader/action boundary. Do not scatter raw
  `fetch`, GraphQL calls, RPC calls, or SDK calls through components unless the
  project already owns that pattern.
- Preserve existing framework and design-system choices. Do not add a
  framework, router, component library, table library, editor, charting package,
  state library, CSS system, icon set, or test runner unless the feature needs
  it and project facts allow the dependency.
- Keep component boundaries aligned with responsibility: shell/navigation,
  route/page, data boundary, form, dialog, table, editor, visualization,
  shared controls, state/store, API client, and styling tokens.
- Keep state as close as practical, but use the established store, query cache,
  route data, URL state, or form state boundary when behavior must be shared,
  persisted, undoable, or coordinated across components.
- Route product-specific tone, density, copy style, safety copy, privacy
  behavior, local-only behavior, and destructive-action confirmations through
  facts and existing docs rather than shared-skill defaults.
- Follow established CSS/design-system conventions. Prefer tokens, variables,
  theme primitives, utility conventions, or component variants already used by
  the project before one-off colors, shadows, spacing, or bespoke controls.
- Forms must have labels, validation, error messages, disabled/submitting
  behavior, keyboard submission where appropriate, and recovery paths.
- Dialogs, popovers, menus, tabs, comboboxes, and toolbars must have keyboard
  behavior, focus management, accessible names, escape/close behavior, and
  screen-reader semantics that match the project's interaction primitives.
- Tables and grids must handle empty data, loading, overflow, column sizing,
  keyboard reachability, sorting/filtering/pagination state when present, and
  mobile or narrow-width behavior.
- Editors and rich inputs must preserve focus, selection, keyboard shortcuts,
  controlled/uncontrolled ownership, validation, and autosave or persistence
  behavior defined by project facts.
- Every interactive control needs an accessible label or name. Icon-only
  buttons need visible or programmatic labels that browser tests can target.
- Check for no incoherent text overlap, clipped labels, broken wrapping,
  unexpected layout shift, or controls resizing from dynamic content across
  supported desktop and mobile widths.
- Treat secrets, tokens, connection strings, private data, and retained outputs
  according to project facts. Never expose them in browser state, URLs, logs,
  localStorage/sessionStorage, test fixtures, screenshots, diagnostics, or API
  responses unless facts explicitly allow the field and redaction behavior.

## Review And QA

For review-only tasks, lead with concrete findings, ordered by severity, and
cite files, components, routes, tests, or screenshots. Focus on correctness,
accessibility, API boundaries, state consistency, validation, responsive
behavior, security/privacy, regressions, and missing tests.

For implementation tasks, finish with:

- files changed and the user-visible behavior
- facts and project conventions applied
- validation commands run and their result
- browser, screenshot, responsive, or accessibility checks performed
- checks that could not be run and the remaining risk

Do not claim visual correctness from code inspection alone when a practical
browser or screenshot check is available.
