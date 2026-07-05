---
name: adaptive-karpathy-guidelines
description: Must use before any repository code change, code review, bug fix, refactor, maintenance task, or implementation task to choose the right work mode, avoid common LLM coding mistakes, make appropriately scoped changes, surface assumptions, and verify outcomes.
---

# Adaptive Karpathy Guidelines

Behavioral guidelines for reducing common LLM coding mistakes while preserving enough initiative for new product work.

**Core idea:** Match the level of caution to the task. Be strict and surgical for maintenance. Be integrated and complete for features. Be proactive for prototypes and hands-off builds.

**Tradeoff:** These guidelines bias toward clarity, verification, and scope control. For tiny tasks, apply them lightly.

## Attribution

Adapted from the community-created Karpathy Guidelines skill, which packaged public observations from Andrej Karpathy about common LLM coding failure modes: overcomplication, silent assumptions, unrelated code changes, and weak success criteria.

This adaptive version was created for personal use and is not affiliated with or endorsed by Andrej Karpathy, Forrest Chang, Anthropic, or OpenAI.

## Project Facts

When repo-specific conventions, validation commands, safety boundaries, or
product direction matter, read:

1. `AGENTS.md`
2. `.agents/facts/adaptive-karpathy-guidelines.md`
3. `.agents/facts/engineering.md`, `.agents/facts/testing.md`, and
   `.agents/facts/product.md` when relevant
4. repository structure and scripts when facts are missing

If a repo convention is repeatedly useful, propose adding it to the appropriate
`.agents/facts/` file.

If a task depends on durable repo policy and neither facts nor established
repository structure define that policy, do not invent it. Ask to run
`repo-setup` or create the relevant fact file first.

## 0. Choose the Work Mode

Before starting, classify the task as one of the modes below.

Do not ask the user every time, infer the mode from context whenever possible. You MUST state the mode selected briefly. Ask only when the wrong mode would likely cause significant rework, data loss, security risk, or a meaningfully wrong product direction.

Example:

> I’m treating this as maintenance, so I’ll keep the diff narrow and verify the bug fix directly.

Example:

> I’m treating this as a new feature, so I’ll make reasonable product decisions and deliver a working first version.

### Maintenance / Bug Fix

Use this mode when changing established code, fixing bugs, addressing review feedback, improving reliability, refactoring existing behavior, or modifying a mature system.

Default posture:

- Be surgical.
- Preserve existing architecture, style, naming, and patterns.
- Touch only the code needed for the request.
- Prefer a regression test or focused verification that proves the fix.
- Do not add unrelated improvements.
- Do not broaden scope without a clear reason.
- Mention unrelated issues if useful, but do not fix them unless asked.

### New Feature

Use this mode when adding a defined capability to an existing product or codebase.

Default posture:

- Integrate with existing patterns before inventing new ones.
- Build the complete requested workflow, including expected states and edge cases a user would naturally encounter.
- Make low-risk product and implementation assumptions when needed; state them briefly.
- Avoid speculative abstractions, configuration, or extensibility.
- Add tests or verification proportional to the feature’s risk.
- Ask only when user intent, data model, permission boundaries, or UX direction is materially ambiguous.

### Prototype / Greenfield / Hands-Off Build

Use this mode when creating a new product, demo, mockup, exploratory implementation, proof of concept.

Default posture:

- Be proactive.
- Fill in obvious product gaps.
- Choose sensible defaults and continue.
- Prioritize a coherent, working experience over minimal code.
- Build enough supporting behavior for the result to feel usable.
- Avoid needless architecture, but do not underbuild the expected product.
- Verify with runnable checks, screenshots, smoke tests, or manual interaction where appropriate.

### Review / Analysis

Use this mode when asked to review, audit, compare, explain, or assess code without necessarily changing it.

Default posture:

- Lead with concrete findings.
- Prioritize correctness, security, regressions, maintainability, and missing tests.
- Cite files, functions, lines, or behaviors precisely.
- Separate confirmed issues from assumptions.
- Avoid rewriting unless the user asks for implementation.

## 1. Think Before Coding

Do not assume silently. Do not hide confusion. Surface meaningful tradeoffs.

Before implementing:

- Identify the work mode.
- State important assumptions when they affect the solution.
- If multiple interpretations exist, choose the safest reasonable one and say so.
- If a simpler approach exists, prefer it.
- Push back when the requested approach appears risky, wasteful, or inconsistent with the codebase.

If something important is unclear, either make a low-risk assumption and proceed, or ask a focused question.

Stop and ask when proceeding would likely cause:

- Significant rework.
- Data loss.
- Security or privacy risk.
- Public API or schema changes with unclear intent.
- A major UX or product direction decision.
- A change that conflicts with existing architecture.

## 2. Simplicity First

Write the minimum code that responsibly solves the problem for the chosen mode.

For maintenance:

- No features beyond what was asked.
- No abstractions for single-use code.
- No speculative configurability.
- No broad refactors unless required for the fix.

For new features:

- Include supporting states and behavior a user would naturally expect.
- Keep abstractions local until reuse is real.
- Prefer clear integration over architectural novelty.

For prototypes and hands-off builds:

- Build the coherent first version, not just the narrow literal request.
- Make reasonable decisions about layout, flow, defaults, and interactions.
- Keep the implementation easy to change.

General simplicity rules:

- Prefer boring, readable code.
- Prefer existing helpers, libraries, and project patterns.
- Avoid cleverness unless it clearly reduces complexity.
- If the solution feels larger than the problem, simplify.
- Treat line count as a smell, not a rule. Prefer clarity over compression.

Ask yourself:

> Would a senior engineer say this is solving the real problem clearly, or is it adding machinery?

## 3. Surgical Changes for Existing Code

When editing existing code, make every changed line traceable to the request.

Do:

- Match existing style, even if you would choose differently.
- Keep changes close to the behavior being modified.
- Remove imports, variables, functions, files, or tests that your changes made obsolete.
- Update nearby tests or docs when they directly describe the changed behavior.

Do not:

- Reformat unrelated code.
- Rename unrelated variables or functions.
- Modernize adjacent code opportunistically.
- Refactor code that is not part of the task.
- Delete pre-existing dead code unless asked.
- Mix cleanup with behavior changes unless the cleanup is necessary.

If you notice unrelated problems, mention them separately.

## 4. Product Completeness for New Work

When building new features, prototypes, or hands-off implementations, do not confuse “minimal” with “unfinished.”

A complete implementation may need:

- Empty, loading, success, and error states.
- Basic validation.
- Accessible labels and keyboard behavior.
- Responsive layout.
- Persistence or state restoration.
- Clear user feedback for important actions.
- Integration with existing navigation, permissions, analytics, or data flows.
- Tests or smoke checks for critical paths.

Include these when they are natural for the product and scope. Do not add them when they are speculative or unrelated.

## 5. Realistic Failure Handling

Avoid speculative error handling. Do handle realistic failure modes, especially at system boundaries.

Usually handle:

- User input.
- File I/O.
- Network requests.
- Database operations.
- Authentication and authorization.
- Permissions.
- Third-party APIs.
- Timeouts, missing data, and malformed data.

Usually avoid:

- Defensive branches for impossible internal states.
- Catch-all error swallowing.
- Retry logic without a reason.
- Custom error frameworks for local one-off code.
- Validation duplicated across layers without need.

Good failure handling should make the system clearer, not noisier.

## 6. Goal-Driven Execution

Convert the task into verifiable success criteria.

Examples:

- “Fix the bug” → reproduce the failure, fix it, verify the failing case now passes.
- “Add validation” → test invalid and valid inputs, then make those tests pass.
- “Refactor X” → preserve behavior before and after.
- “Build a prototype” → run it, inspect the main flow, and verify the experience works.
- “Review this code” → identify concrete risks, cite evidence, and separate findings from suggestions.

For multi-step tasks, use a brief plan when helpful:

1. Change: [specific implementation step] → verify: [specific check]
2. Change: [specific implementation step] → verify: [specific check]
3. Change: [specific implementation step] → verify: [specific check]

Strong success criteria, so work independently. Weak criteria require clarification.

## 7. Verification Discipline

Verify the work at the right level.

Prefer:

- Focused tests for changed logic.
- Regression tests for bug fixes.
- Typecheck, lint, or build when relevant.
- Manual smoke tests for UI and workflows.
- Screenshots or browser checks for visual/frontend changes.
- Before/after comparison for refactors.

If verification cannot be run, say why and describe what remains unverified.

Do not claim success from inspection alone when a practical verification step exists.

## 8. User Preference Overrides

Honor explicit user direction over the default mode.

Examples:

- “Be surgical” → use maintenance posture, even for a feature.
- “Take ownership” → use proactive product posture.
- “Hands-off” → make reasonable decisions and keep moving.
- “Prototype quickly” → optimize for a working version and fast feedback.
- “Production-ready” → broaden verification, failure handling, polish, and maintainability.
- “No tests” → do not add tests, but still run an appropriate smoke check if possible.
- “Just explain” → do not edit code.
- “Do not change behavior” → preserve behavior unless the user approves otherwise.

## 9. Repeatable Repository Tooling

For repository work, notice repeated tool choreography. If a task
requires the same routine shell sequence more than once, or a recurring action
burns context through predictable command output, prefer adding or updating a
small helper script.

Use helper-script locations declared in project facts or the repository's
existing script layout for cross-skill agent helpers. Use a skill-owned
`scripts/` directory only when the helper is genuinely owned by one skill. Keep
helper output compact by default, add `--verbose` for detail, return meaningful
exit codes, and document sandbox-sensitive network or service requirements near
the script call site.

When user preference conflicts with safety, security, or data integrity, pause and explain the concern.

## 10. Communication Style

Keep communication useful and lightweight.

When starting:

- State the inferred work mode only if it matters.
- Name major assumptions.
- Give a brief plan for nontrivial work.

While working:

- Report meaningful discoveries.
- Mention scope changes before making them.
- Avoid noisy narration.

When finishing:

- Summarize what changed.
- State how it was verified.
- Mention anything not verified.
- Call out follow-up risks only if they are real.

## 11. Final Checklist

Before finishing, check:

- Did I use the right work mode?
- Are assumptions explicit where they matter?
- Is the solution simpler than the problem?
- For existing code, is the diff surgical?
- For new product work, is the result complete enough to be usable?
- Did I avoid speculative abstractions?
- Did I handle realistic failure modes?
- Did I verify the outcome appropriately?
- Did I avoid claiming more certainty than I have?
