# Set up a Pages release path

## Inspect and decide

1. Confirm the app is a static build and identify its package manager, locked install command, build command, output directory, required release checks, and any service worker or base-path assumptions. Reuse the project's established commands.
2. Ask for the Cloudflare account, base domain, and desired hostname or subdomain. Establish the Pages project name, production branch, and whether the DNS zone is managed by Cloudflare. A named deployment target is required when the repository has more than one.
3. Inspect existing Pages projects, custom-domain bindings, DNS records, GitHub workflows, repository secrets or environments, and release branch. Show collisions before changing resources. Never overwrite a record, take over a hostname, or reuse a project whose ownership is uncertain.
4. Choose Pages **Direct Upload** when GitHub Actions will build and deploy the site. This is the default for this skill. Use Cloudflare **Git integration** only when the user explicitly chooses Cloudflare-managed builds and deploy triggers. These modes cannot be switched in place; changing modes requires a new project, so confirm the intended mode before creating the project.

## Connect Cloudflare and configure resources

Cloudflare's API MCP endpoint is `https://mcp.cloudflare.com/mcp`; it is a server address, not a login page. For the installed Cloudflare plugin in Codex, use Settings > MCP servers (or Integrations and MCP) and select Authenticate or Reconnect. If an earlier grant only permits reads, disconnect that connection and authorize it again. For a separately configured Codex CLI server, `codex mcp add cloudflare-api --url https://mcp.cloudflare.com/mcp` registers it and `codex mcp login cloudflare-api` starts OAuth; do not add a duplicate server merely to refresh the plugin connection. On Cloudflare's consent screen, choose the intended account and grant account-level Cloudflare Pages Edit plus zone-level DNS Edit for the selected domain when this skill will manage its DNS. Verify account and zone access with reads before writes. Do not commit MCP credentials or OAuth state.

Create or reuse the Pages project in the selected account with the selected production branch. For Direct Upload, configure the project name and production branch, then attach the custom hostname. If Cloudflare manages its DNS zone, inspect the resulting DNS record and create the Pages CNAME only if the domain association did not create it. Never overwrite a conflicting DNS record. If DNS is elsewhere, give the user the CNAME details and wait for that provider's change. A CNAME without a Pages custom-domain association is not a completed setup. Verify the binding and certificate reach active status.

## Configure GitHub Actions

Create a narrowly scoped Cloudflare API token with account-level Cloudflare Pages Edit access to the selected account for CI at `https://dash.cloudflare.com/profile/api-tokens`. The interactive MCP OAuth credential is not a CI credential. Put the token in a GitHub Actions secret, preferably in the user's selected production environment (for example, `Live`) restricted to the release branch when that GitHub plan supports it. If the user says credentials already exist in an environment, use that exact environment and established secret name; do not request or print secret values. Use a repository secret only when no suitable environment exists. Keep the account ID in a fact or Actions variable; it is an identifier, not a password. Record only secret and variable names in tracked files.

Add a workflow in the app repository that:

- triggers on pushes to the chosen release branch and checks out that exact commit;
- uses the repo's locked install, release checks, and build commands;
- deploys only the verified build output using Wrangler or Cloudflare's maintained Wrangler action, passing the project name and `--branch=<production-branch>` explicitly;
- grants only needed `GITHUB_TOKEN` permissions and serializes production deployments so an older run cannot finish after a newer one;
- uses existing repository conventions for Node version, action versions, and workflow style.

Ensure the workflow file is present on the release branch before expecting a push to trigger it. Align branch protection and any GitHub environment branch restriction with the repository's promotion policy. Do not create a parallel Cloudflare Git integration that would publish the same commit twice. Before opening a PR, verify the workflow references the selected Actions environment and secret names, and that the selected Pages project is Direct Upload rather than Git-integrated.

## Record and verify

Write a small `.agents/facts/cloudflare-pages.md` with account ID, Pages project, `pages.dev` URL, custom hostname, production branch, workflow path, install/check/build commands, output directory, secret/variable names, and status of DNS and first deployment. Update `.agents/facts/release.md` and the established deployment docs to match. Distinguish configuration that is prepared from a site that is already live. Remove obsolete target selection code and docs only after the repository has a single unambiguous target and the user has chosen to retire those mappings. Deleting old remote hosting requires its own explicit request.

For the first publish, check the release branch commit, let CI deploy it, inspect the successful Pages deployment and commit, then check HTTPS at the `pages.dev` and custom URLs. Run any project-specific browser or offline smoke check that the release facts require. Report gaps such as missing GitHub secrets, inactive DNS, or a failed certificate without claiming the site is live.
