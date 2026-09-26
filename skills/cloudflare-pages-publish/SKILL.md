---
name: cloudflare-pages-publish
description: Set up and operate Cloudflare Pages publishing for an existing static site, including a custom domain and a GitHub Actions release branch. Use for Pages deployment setup, migration, publishing, or troubleshooting; read project release facts before changing hosting.
---

# Cloudflare Pages Publish

Keep this skill reusable. Store each site's account, hostname, build, branch, and release decisions in its own repository, normally `.agents/facts/cloudflare-pages.md` and `.agents/facts/release.md`. Never put credentials in either file.

## Choose the task

- **Set up or migrate:** Read [setup](references/setup.md). This may change Cloudflare resources, DNS, GitHub settings, and repository files.
- **Publish, verify, or recover:** Read [release](references/release.md). Inspect the configured release path before taking action.

Read `AGENTS.md`, `.agents/facts/cloudflare-pages.md` if present, `.agents/facts/release.md`, `.agents/facts/git.md`, `.agents/facts/testing.md`, and the package or build configuration. If facts are missing, inspect the repository and record decisions before setting up automation. Follow the repository's branch, PR, and release rules.

Default to Pages Direct Upload with a GitHub Actions deployment workflow. Use Cloudflare Pages Git integration only when the user explicitly chooses Cloudflare-managed builds and deploy triggers; Pages projects cannot switch modes in place. Use the connected Cloudflare API MCP for account, Pages, and DNS inspection or setup when available. Its interactive OAuth session is separate from the scoped API token that GitHub Actions needs. If the MCP server is unavailable, guide the user through connecting it; do not assume its tools or permissions exist.

For a user-requested publish, resolve the exact target, branch, commit, and URL from repository facts. Report the deployed commit and domain status after publishing. Treat a hostname change, deployment, and deletion of old hosting as separate operations.
