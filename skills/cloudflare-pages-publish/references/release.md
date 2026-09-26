# Publish, verify, and recover

Read the repository's Cloudflare Pages and release facts. Resolve the requested target and confirm the source commit is ready under its Git and validation policy. A push to the configured production branch can publish automatically, so show the exact commit and destination before promotion.

For a release, use the repository's established branch and PR promotion path. Inspect the resulting GitHub Actions run, Pages deployment, production branch, and deployed commit. Confirm the custom domain is active and serves the expected build over HTTPS. A successful build alone does not prove that DNS, TLS, or an offline-capable app works.

For a rerun, determine whether the same commit was already deployed and whether the run would change production. For recovery, inspect the last known good deployment and the repository's rollback policy before promoting or restoring anything. Do not guess a rollback branch or delete deployments. Keep any corrective repository changes on a feature branch and update release facts when the durable workflow changes.
