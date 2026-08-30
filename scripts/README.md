# Repository utilities

## `git-identity-rewrite.sh`

This utility safely rewrites author, committer, and tagger identities before a
repository is published or republished.

It is deliberately conservative:

- the default mode only inspects;
- `--rewrite` creates a mirror backup and rewrites a second mirror;
- backup and manifest permissions are restricted with a private process umask;
- the working checkout remains untouched;
- old email addresses must be supplied explicitly;
- the rewritten history is checked for old identities and missing refs;
- `--push` requires another confirmation and aborts if the remote changed after
  the backup was created;
- forced updates use per-ref leases, so the server rejects a push if a branch or
  tag changed during the final race window;
- branch and tag updates are requested atomically, preventing a server that
  supports atomic pushes from accepting only part of the rewritten ref set.

On macOS, install
[`git-filter-repo`](https://github.com/newren/git-filter-repo), then inspect the
target repository:

```bash
brew install git-filter-repo
scripts/git-identity-rewrite.sh .
```

Create a backup and validated rewritten mirror:

```bash
scripts/git-identity-rewrite.sh \
  --new-name github-user \
  --new-email 123456+github-user@users.noreply.github.com \
  --old-email old-address@example.com \
  --rewrite .
```

Repeat `--old-email` for every old address belonging to the same person. For an
end-to-end run that pauses after validation and before pushing, include
`--push`. Without it, the command exits after creating the rewritten mirror.

The backup contains the original identity and must remain private. To recover a
local working copy from it:

```bash
git clone /path/to/repository.identity-backup-TIMESTAMP.git recovered-repository
```

The script updates Git heads and tags. GitHub Release records, release assets,
immutable releases, pull-request refs, cached commits, forks, and existing
clones are outside its write scope and must be reviewed separately.

For `github.com` remotes, the inspection report also uses an authenticated
`gh` CLI, when available, to report fork counts, release and asset metadata,
email-shaped strings in release/PR metadata, immutable-release status, pull
request counts, and locally available `refs/pull/*` refs. These checks are
read-only. Release asset bytes and pull-request commit histories are not
downloaded by default, so the report marks those areas as unassessed.
