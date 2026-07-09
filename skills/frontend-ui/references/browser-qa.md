# Browser QA Guidance

Use this reference for visible UI changes, browser workflow changes,
responsive behavior, accessibility, visual QA, or browser smoke tests.

## Setup

- Use the project-declared dev server and smoke-test commands from facts or
  package scripts.
- Check prerequisites before launching heavyweight services, browsers, Docker,
  databases, external APIs, or live network workflows.
- Prefer existing Playwright, Cypress, Webdriver, Storybook, axe, or screenshot
  tooling. Add tooling only when project facts allow it and the task needs it.

## Smoke Checks

Cover the changed user path:

- initial render and route entry
- loading, empty, success, validation-error, recoverable-error, and permission
  states when applicable
- form submission and cancellation
- dialog/menu/popover open, keyboard navigation, focus return, and close
- table/grid overflow, sorting/filtering/pagination, row actions, and empty
  results when applicable
- editor focus, selection, keyboard shortcuts, validation, and persistence when
  applicable
- API-boundary success and failure behavior using project-approved mocks or
  fixtures when live services are not required

## Accessibility

- Target controls by role and accessible name in browser tests when practical.
- Verify every interactive element has an accessible name.
- Check tab order, focus visibility, escape behavior, focus trapping for modal
  UI, focus return after closing overlays, and keyboard access to toolbar,
  menu, table, and editor actions.
- Use ARIA only when native semantics or the project's component primitives do
  not already provide correct behavior.

## Visual And Responsive QA

- Inspect at least one desktop width and one mobile or narrow width for visible
  UI changes, unless project facts define a different support matrix.
- Check that text does not overlap, clip unexpectedly, sit under sticky
  headers/footers, or overflow buttons, tabs, cards, dialogs, sidebars, tables,
  editors, or toolbars.
- Check long labels, empty states, errors, loading placeholders, disabled
  controls, and dynamic data lengths.
- Prefer screenshots or browser automation for layout-sensitive work. Compare
  before/after screenshots when fixing visual regressions.
- Verify color, spacing, focus rings, hover/active/disabled states, and
  responsive collapse behavior against the existing design system.

## Reporting

Record:

- browser/dev-server command used
- test or smoke command used
- viewport sizes checked
- screenshots or traces captured, if any
- accessibility checks performed
- any skipped checks and why
