# UI Architecture And Reuse

Use this reference to decide where browser UI markup, styling, behavior, and
state belong. Follow stronger project-local conventions when they exist.

## Ownership Layers

Keep dependencies flowing down this list:

1. **Tokens and theme** own color, typography, spacing, radii, elevation,
   motion, breakpoints, and other repeated visual decisions.
2. **Primitives** own basic interaction and accessibility contracts such as
   buttons, fields, links, text, icons, and surfaces.
3. **Shared patterns** compose primitives into recurring product UI such as
   form rows, search controls, empty states, error notices, toolbars, cards,
   tables, and dialogs.
4. **Feature components** own domain-specific presentation and behavior that
   may be reused within one feature.
5. **Routes and pages** own data boundaries, workflow orchestration, and
   composition. They must not become alternate design systems.

Shared layers must not import routes or features. Keep project-specific domain
semantics out of primitives.

## Choose The Narrowest Shared Owner

- Reuse an existing component, hook, helper, token, or variant when its contract
  already matches.
- Extend an existing owner when the new case is a coherent variant of the same
  semantic and interaction contract.
- Create a shared owner when the same contract has two or more current or
  approved-scope consumers. Do not wait for copied implementations to
  accumulate.
- Keep code local when similarity is incidental, the semantics or lifecycle
  differ, or sharing would require page names and unrelated boolean flags.
- Prefer composition, slots, typed variants, and injected content over forks.
  Split a component when its consumers no longer share one understandable
  contract.

Judge duplication by knowledge and behavior, not only identical text. Repeated
validation, formatting, accessibility behavior, responsive rules, state
transitions, and visual decisions can have one owner even when their markup is
slightly different.

## Reuse Beyond Components

- Use hooks or the established state/query/form boundary for repeated stateful
  behavior and lifecycle management.
- Use pure helpers for repeated formatting, parsing, mapping, and validation.
- Use configuration or data-driven rendering for repeated fields, actions,
  navigation entries, columns, cards, and status mappings when the structure
  is stable and the data varies.
- Keep API access behind the declared client or data boundary rather than
  hiding duplicate requests in page components.
- Centralize recurring loading, empty, error, permission, and confirmation UI
  in established patterns while allowing feature-specific content.

## Ownership Map

Before substantial implementation, record a compact map such as:

```text
Route/page: orchestration and composition
Feature: domain-specific components and view models
Shared patterns: reusable product interactions and states
Primitives/tokens: visual and accessibility foundation
Hooks/helpers/API: shared behavior and data boundaries
Local exceptions: unique pieces and why they remain local
```

Update the map when implementation reveals a different boundary. At completion,
search the full changed surface for repeated contracts and confirm that each
has one clear owner or an explicit reason to remain local.
