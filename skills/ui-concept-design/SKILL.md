---
name: ui-concept-design
description: >
  Establish and approve the visual and interaction direction for substantial
  new browser or mobile UI, including new user-facing features, screens,
  multi-step workflows, and redesigns that change hierarchy, navigation,
  information architecture, or primary interactions. Generates Editorial,
  Calm, and Precision concepts, synthesizes the strongest elements, and pauses
  for approval before implementation. Do not use for small visual tweaks,
  isolated controls, accessibility fixes, bug fixes, responsive corrections,
  refactors, or implementation of an already approved design.
---

# UI Concept Design

Use visual exploration to establish an implementable UI and UX direction before
substantial frontend work begins. This is a concept and approval gate, not an
implementation skill.

## Project Context

Before proposing a direction, read:

1. `AGENTS.md`
2. `.agents/facts/ui-concept-design.md`
3. `.agents/facts/product.md`, `.agents/facts/frontend-ui.md`, and relevant
   design-system, accessibility, architecture, roadmap, and platform facts
4. the feature brief, acceptance criteria, adjacent screens, existing design
   tokens and components, and representative current screenshots when present

Use repository evidence when facts are missing. If a durable visual or UX
decision is repeatedly useful, propose capturing it in the relevant fact file.
Do not invent missing product policy or let a generated concept override an
established product requirement.

## Activation Gate

Use this workflow when the work includes one or more of these conditions:

- a new user-facing feature introduces a screen, route, page, substantial
  surface, or multi-step workflow
- a redesign changes visual hierarchy, information architecture, navigation,
  primary interactions, or the composition of several coordinated components
- the product has no established pattern for the proposed experience
- the request explicitly calls for a new visual direction, design exploration,
  or a polished redesign

Do not activate it merely because work is frontend-related. Skip it for copy,
icon, color, spacing, or alignment tweaks; a local accessibility correction;
bug fixes that restore established behavior; an isolated field or control that
uses an existing pattern; responsive corrections with an established target;
refactoring without a user-visible redesign; or implementation of an already
approved mockup or specification.

For borderline work, reuse the existing product and design-system direction.
Do not spend image-generation time or pause for concept approval unless the
change materially benefits from divergent visual exploration.

## Concept Workflow

1. **Frame the experience.** Define the target user, job to be done, entry and
   exit points, primary action, content hierarchy, supported windows or form
   factors, and acceptance criteria. Account for realistic default, loading,
   empty, success, validation, recoverable-error, disabled, destructive, and
   large-content states even when they will not all appear in mockups.
2. **Inventory constraints.** Identify established components, tokens, brand
   rules, accessibility requirements, platform conventions, content and asset
   availability, and product behaviors that must remain unchanged. Use
   realistic product content rather than decorative placeholder copy.
3. **Prepare three directions.** Use the `imagegen` skill and its built-in
   image-generation path to produce a preview-only comparison board containing
   the same representative screen or workflow in three genuinely distinct
   directions:
   - **Editorial:** expressive typography, strong narrative hierarchy,
     purposeful imagery, and confident composition
   - **Calm:** spacious, reassuring, low-friction, restrained, and focused on
     cognitive ease
   - **Precision:** systematic, highly legible, task-oriented, and efficient
     with controlled information density
4. **Evaluate before converging.** Compare all three against user-task speed,
   clarity, accessibility, product fit, adaptive behavior, content resilience,
   consistency with adjacent surfaces, and implementation feasibility. Reject
   attractive elements that weaken the workflow. State which elements are
   being retained or rejected and why.
5. **Synthesize.** Use image generation again to create one final,
   higher-fidelity direction that combines the strongest compatible elements.
   It must be a coherent design, not a collage of styles. Generate separate
   high-resolution variants only when the comparison board leaves a material
   decision unresolved.
6. **Present the approval package.** Show the comparison board and final
   synthesis with a concise rationale, interaction notes, component and styling
   ownership implications, adaptive-layout notes, accessibility considerations,
   and any behavior that images cannot demonstrate.
7. **Pause for approval.** Do not edit implementation files, add production
   assets, or begin frontend implementation until the user approves the final
   direction. Approval authorizes only the already-scoped feature or redesign.

If image generation is unavailable or fails, explain the limitation and stop
at a structured text concept unless the user explicitly approves another path.
Do not silently substitute a coded mockup for the required concept gate.

## Image-Generation Guidance

- Classify the work as a `ui-mockup` and follow the selected image-generation
  skill's prompt, inspection, and preview rules.
- Prefer one three-direction comparison board followed by one final synthesis
  to control cost and latency.
- Anchor all directions to the same user task, content, device or viewport, and
  required controls so the comparison is meaningful.
- Tell image generation what text is structurally important, but treat rendered
  text as illustrative; preserve exact production copy separately in the UX
  contract.
- Include enough surrounding application context to judge navigation and
  hierarchy. Avoid glossy device frames or decorative scenery that obscures
  the interface.
- Do not place preview-only generated mockups into production asset folders.

## Implementation Handoff

After approval, hand the implementation phase to the relevant frontend skill
with:

- the approved final concept and comparison board
- the UX contract and required states
- the retained and rejected design decisions
- component, token, styling, and state ownership expectations
- supported viewport or adaptive-layout cases
- accessibility requirements and known image-generation inaccuracies

Implementation must use native or repository-standard components and preserve
the approved design intent rather than reproducing incidental raster artifacts.
Before completion, render the real interface at representative sizes, compare
it with the approved direction, and reconcile material differences in
hierarchy, spacing, typography, imagery, interaction affordances, and content
density.

## Completion Criteria

The concept phase is complete only when:

- Editorial, Calm, and Precision directions were generated and evaluated
- one coherent synthesis was generated
- the UX contract covers important states and non-visual behavior
- implementation implications and adaptive/accessibility constraints are clear
- the user explicitly approved the final direction
