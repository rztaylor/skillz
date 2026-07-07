---
name: release-checks
description: >
  Use when preparing, reviewing, or auditing a release candidate, version tag,
  downloadable artifact, package, release notes, changelog, release-governance
  change, or CI-backed release workflow. Blocks until required repo-local
  project facts exist; uses AGENTS.md and .agents/facts/*.md for project
  release policy, validation commands, artifact targets, changelog rules,
  support boundaries, security checks, and publish/tag behavior.
---

# Release Checks

Use this skill to decide whether a project is ready to ship, tag, package, or
publish release artifacts. Release readiness is broader than passing tests: it
also covers versioning, changelog and release notes, packaging, CI release
workflows, support boundaries, security posture, and explicitly reported gaps.

## Project Facts Gate

Before doing release readiness work, read:

1. `AGENTS.md`
2. `.agents/facts/release.md`
3. `.agents/facts/testing.md`
4. `.agents/facts/docs.md`
5. `.agents/facts/git.md` when the task involves tags, branches, CI release
   publishing, GitHub Releases, package registries, or manual publish steps
6. language or platform facts when release commands depend on them, such as
   `.agents/facts/go.md`, `.agents/facts/node.md`, or
   `.agents/facts/python.md`

Block if `AGENTS.md` or the required fact files are missing. Do not infer
release policy from repository evidence as a substitute for missing release,
testing, docs, or publish facts. Stop and ask to run `repo-setup` or create the
missing facts first. If the user asks to bootstrap facts, inspect the repository
only enough to draft those facts before returning to the release gate.

Repository evidence can confirm or refine facts after the fact files exist.
Use scripts, CI config, package files, docs, changelogs, and release workflows
to check whether the repository still matches the declared policy.

## Release Fact Shape

Expect `.agents/facts/release.md` to declare project-specific release policy:

- release maturity and supported surfaces
- versioning and tag format
- changelog location and release-note source
- release-governance or blocker-policy docs
- default validation and release-candidate validation commands
- external prerequisites, heavyweight services, and skipped-validation policy
- artifact targets, package formats, checksums, signing, notarization, or
  installer status
- CI or hosted release workflow paths, triggers, publish conditions, and
  required permissions
- manual release, prerelease, rollback, or re-run rules
- support, compatibility, migration, and known-limits policy
- security, secrets, and destructive-action release blockers

If these details are missing from an existing release fact, report the gap as a
release-readiness blocker before making a ship/no-ship decision.

## Scope

Classify the requested work before running checks:

- **Default verification**: ordinary pre-merge or pre-handoff checks.
- **Release-candidate gate**: deciding whether a release candidate is ready.
- **Packaging readiness**: building, signing, checksumming, or uploading
  artifacts.
- **Publish path audit**: checking tag triggers, CI release workflows,
  registry publishing, GitHub Releases, or manual publish steps.
- **Release policy change**: versioning, support boundaries, blocker policy,
  changelog policy, or release-governance changes.

Run only the checks needed for the scope, but always report skipped or
unavailable release checks as explicit risk.

## Validation

Use validation commands declared in project facts. Prefer project scripts or
compact agent helpers over raw tool commands when they exist.

For release-candidate, packaging, and publish-path checks:

- run prerequisite checks before heavyweight validation that needs Docker,
  browsers, databases, cloud credentials, network access, signing keys, package
  registry credentials, or other local services
- stop retrying when prerequisites, credentials, Docker, network access, or
  sandbox permissions are unavailable; report the skipped validation clearly
- use raw language commands only when project or language facts declare them as
  acceptable fallbacks
- keep command output compact unless failure details are needed for diagnosis

Do not create tags, publish releases, upload artifacts, modify registries, or
mutate remote release state unless the user explicitly asks for that action.

## CI And Release Publishing

When facts declare a CI-backed release or publish path, inspect the configured
workflow before declaring release readiness. Confirm that it matches facts for:

- tag, branch, manual, or scheduled triggers
- release version and prerelease derivation
- artifact target matrix, platform support, package names, and archive contents
- build reproducibility metadata such as version, commit, date, or provenance
- checksum, signing, notarization, SBOM, or attestation steps declared by facts
- release-note source, especially changelog-derived notes
- GitHub Release, package registry, container registry, or other publish steps
- workflow permissions and secret exposure
- artifact retention, idempotent re-runs, clobber behavior, and failure modes

If no hosted release workflow exists but facts say one should exist, block. If
facts say releases are manual, check the documented manual procedure instead.

## Documentation And Policy

Before marking a release gate ready, confirm facts and repository evidence agree
on:

- changelog entries for notable user-facing, release, safety, compatibility,
  packaging, support-policy, and validation changes
- release notes derived from the declared source
- user docs, migration notes, known limits, and support boundaries
- release-governance docs for versioning, blocker, artifact, or support-policy
  changes
- roadmap or planning closure rules when the project uses roadmap docs

Do not invent missing changelog or release-note policy. Missing facts block the
release gate.

## Safety And Quality Gate

For release candidates, packaging readiness, or publish-path changes:

- read and apply `find-tech-debt`
- read and apply `structural-refactorer` when the release surface includes code,
  scripts, generated assets, package boundaries, API contracts, or UI behavior
- confirm there are no unresolved release-relevant `Fix now` or equivalent
  findings
- confirm fixtures, logs, docs, generated artifacts, examples, committed config,
  and release notes do not expose secrets or private data
- verify destructive or compatibility-breaking behavior is documented and
  explicitly intentional

## Result

End with one of:

- `Release gate: pass`
- `Release gate: pass with accepted risk`
- `Release gate: blocked`
- `Release gate: fail`

Include:

- fact files read and any missing or incomplete facts
- validation commands run, skipped, or unavailable
- CI or publish workflow inspected, if any
- artifact, changelog, release-note, and docs status
- security, secret, support, compatibility, and blocker findings
- remaining release risk and the owner decision needed to proceed
