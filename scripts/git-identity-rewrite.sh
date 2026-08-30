#!/usr/bin/env bash

# Safely rewrite Git author, committer, and tagger identities.
#
# The source checkout is never rewritten. A normal invocation only inspects.
# --rewrite creates a backup mirror and rewrites a second mirror.
# --push is separately confirmed and only runs after validation.

set -euo pipefail

# Backups and manifests contain the identity being removed. Do not make them
# readable by other users through a permissive process umask.
umask 077

SCRIPT_NAME="$(basename "$0")"
REMOTE_NAME="origin"
NEW_NAME=""
NEW_EMAIL=""
BACKUP_DIR=""
DO_REWRITE=0
DO_PUSH=0
OLD_EMAILS=()
REPO_ARG=""
TEMP_DIR=""
GITHUB_REPO=""

usage() {
  cat <<EOF
Usage:
  $SCRIPT_NAME [options] [repo]

Without --rewrite, the command is inspection-only.

Required for rewriting:
  --new-name NAME          New commit/tag identity name
  --new-email EMAIL        New commit/tag identity email
  --old-email EMAIL        Email to replace; repeat for multiple addresses

Actions:
  --rewrite                Back up and rewrite an isolated mirror
  --push                   Also offer to force-push validated heads and tags

Other options:
  --remote NAME            Remote to use (default: origin)
  --backup-dir DIR         Explicit path for the backup mirror
  -h, --help               Show help

Examples:
  $SCRIPT_NAME .

  $SCRIPT_NAME --new-name github-user --new-email NOREPLY_ADDRESS --old-email OLD_ADDRESS --rewrite .

Add --push only after reviewing a successful local rewrite.

For github.com remotes, the inspection report also performs read-only GitHub
metadata checks when the authenticated gh CLI is available.

Requirements:
  git
  git-filter-repo (https://github.com/newren/git-filter-repo)
EOF
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

section() {
  printf '\n%s\n' "$*"
}

ensure_temp_dir() {
  if [ -z "$TEMP_DIR" ]; then
    TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/git-identity-rewrite.XXXXXX")"
    trap 'rm -rf "$TEMP_DIR"' EXIT
  fi
}

email_shapes_in_file() {
  if command -v rg >/dev/null 2>&1; then
    (rg -o -i '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$1" || true)
  else
    (grep -Eo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$1" || true)
  fi | awk 'tolower($0) != "git@github.com"' | sort -fu |
    awk 'NF { count++ } END { print count + 0 }'
}

extract_github_repo() {
  remote_path=""
  case "$REMOTE_URL" in
    https://github.com/*|http://github.com/*)
      remote_path="${REMOTE_URL#*github.com/}"
      ;;
    git@github.com:*)
      remote_path="${REMOTE_URL#git@github.com:}"
      ;;
    ssh://git@github.com/*)
      remote_path="${REMOTE_URL#ssh://git@github.com/}"
      ;;
    *)
      return 1
      ;;
  esac
  remote_path="${remote_path%/}"
  remote_path="${remote_path%.git}"
  case "$remote_path" in
    */*)
      GITHUB_REPO="$remote_path"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

github_report() {
  if [ -z "$REMOTE_URL" ]; then
    printf 'GitHub report: skipped (no remote configured).\n'
    return 0
  fi
  if ! extract_github_repo; then
    printf 'GitHub report: skipped (remote is not a github.com URL).\n'
    return 0
  fi
  if ! command -v gh >/dev/null 2>&1; then
    printf 'GitHub report: unavailable (gh CLI is not installed).\n'
    return 0
  fi
  if ! gh auth status >/dev/null 2>&1; then
    printf 'GitHub report: unavailable (gh CLI is not authenticated).\n'
    return 0
  fi

  ensure_temp_dir
  github_dir="$TEMP_DIR/github"
  mkdir -p "$github_dir"
  printf 'GitHub report: %s (read-only API checks)\n' "$GITHUB_REPO"

  repo_json="$github_dir/repository.json"
  if ! gh api "repos/$GITHUB_REPO" > "$repo_json" 2>/dev/null; then
    printf '  repository metadata: unavailable (check token permissions)\n'
    return 0
  fi

  visibility="$(gh api "repos/$GITHUB_REPO" --jq '.visibility' 2>/dev/null || printf 'unknown')"
  fork_file="$github_dir/forks.txt"
  if gh api --paginate "repos/$GITHUB_REPO/forks?per_page=100" \
    --jq '.[].full_name' > "$fork_file" 2>/dev/null; then
    fork_count="$(awk 'NF { count++ } END { print count + 0 }' "$fork_file")"
    if [ "$fork_count" -gt 0 ]; then
      printf '  visibility: %s; forks: %s (WARNING: fork history will not be rewritten)\n' "$visibility" "$fork_count"
    else
      printf '  visibility: %s; forks: 0\n' "$visibility"
    fi
  else
    printf '  visibility: %s; forks: unknown (API check failed)\n' "$visibility"
  fi

  release_file="$github_dir/releases.json"
  release_tags="$github_dir/release-tags.txt"
  asset_ids="$github_dir/release-assets.txt"
  if gh api --paginate "repos/$GITHUB_REPO/releases?per_page=100" > "$release_file" 2>/dev/null; then
    gh api --paginate "repos/$GITHUB_REPO/releases?per_page=100" \
      --jq '.[].tag_name' > "$release_tags" 2>/dev/null || :
    gh api --paginate "repos/$GITHUB_REPO/releases?per_page=100" \
      --jq '.[].assets[]?.id' > "$asset_ids" 2>/dev/null || :
    release_count="$(awk 'NF { count++ } END { print count + 0 }' "$release_tags")"
    asset_count="$(awk 'NF { count++ } END { print count + 0 }' "$asset_ids")"
    release_email_count="$(email_shapes_in_file "$release_file")"
    printf '  releases: %s; asset metadata records: %s\n' "$release_count" "$asset_count"
    if [ "$release_email_count" -gt 0 ]; then
      printf '  release metadata email-shaped strings: %s (WARNING: review release notes and asset metadata)\n' "$release_email_count"
    else
      printf '  release metadata email-shaped strings: 0\n'
    fi
    if [ "$asset_count" -gt 0 ]; then
      printf '  release asset bytes: not downloaded (binary contents are not assessed)\n'
    fi
    if [ "${#OLD_EMAILS[@]}" -gt 0 ]; then
      for old_email in "${OLD_EMAILS[@]}"; do
        if grep -Fq -- "$old_email" "$release_file"; then
          printf '  old identity in release metadata: YES (WARNING: %s)\n' "$old_email"
        fi
      done
    fi
  else
    printf '  releases: unknown (API check failed)\n'
  fi

  immutable_file="$github_dir/immutable-releases.txt"
  if gh api --include "repos/$GITHUB_REPO/immutable-releases" > "$immutable_file" 2>&1; then
    immutable_state="$( (grep -Eo '"enabled"[[:space:]]*:[[:space:]]*(true|false)' "$immutable_file" || true) | tail -1 | awk -F: '{ gsub(/[[:space:]]/, "", $2); print $2 }')"
    case "$immutable_state" in
      true)
        printf '  immutable releases: ENABLED (BLOCKER: associated tags cannot be moved/deleted)\n'
        ;;
      false)
        printf '  immutable releases: disabled\n'
        ;;
      *)
        printf '  immutable releases: unknown (API response was not understood)\n'
        ;;
    esac
  else
    immutable_status="$( (grep -Eo 'HTTP/[0-9.]+[[:space:]]+[0-9]+' "$immutable_file" || true) | tail -1 | awk '{ print $2 }')"
    case "$immutable_status" in
      404) printf '  immutable releases: disabled or unavailable to this API token\n' ;;
      *) printf '  immutable releases: unknown (HTTP %s)\n' "${immutable_status:-unknown}" ;;
    esac
  fi

  pulls_file="$github_dir/pulls.json"
  pull_numbers="$github_dir/pull-numbers.txt"
  if gh api --paginate "repos/$GITHUB_REPO/pulls?state=all&per_page=100" > "$pulls_file" 2>/dev/null; then
    gh api --paginate "repos/$GITHUB_REPO/pulls?state=all&per_page=100" \
      --jq '.[].number' > "$pull_numbers" 2>/dev/null || :
    pull_count="$(awk 'NF { count++ } END { print count + 0 }' "$pull_numbers")"
    pull_email_count="$(email_shapes_in_file "$pulls_file")"
    local_pull_refs="$(repo_git for-each-ref --format='%(refname)' refs/pull | awk 'NF { count++ } END { print count + 0 }')"
    printf '  pull requests: %s; local refs/pull refs: %s\n' "$pull_count" "$local_pull_refs"
    if [ "$pull_count" -gt 0 ]; then
      printf '  pull-request commit histories: not fetched by default (review separately; refs are outside the push)\n'
    fi
    if [ "$pull_email_count" -gt 0 ]; then
      printf '  pull-request metadata email-shaped strings: %s (WARNING: review PR bodies/titles)\n' "$pull_email_count"
    else
      printf '  pull-request metadata email-shaped strings: 0\n'
    fi
  else
    printf '  pull requests: unknown (API check failed)\n'
  fi
}

confirm() {
  local prompt answer
  prompt="$1"
  printf '%s Type YES to continue: ' "$prompt"
  read -r answer || die "No confirmation received."
  [ "$answer" = "YES" ] || die "Confirmation not received; stopping safely."
}

valid_name() {
  case "$1" in
    ""|*$'\n'*|*$'\r'*|*'<'*|*'>'*) return 1 ;;
    *) return 0 ;;
  esac
}

valid_email() {
  case "$1" in
    ""|*[[:space:]]*|*'<'*|*'>'*) return 1 ;;
    *@*) return 0 ;;
    *) return 1 ;;
  esac
}

line_count() {
  if [ -z "$1" ]; then
    printf '0'
  else
    printf '%s\n' "$1" | wc -l | tr -d ' '
  fi
}

repo_git() {
  git -C "$REPO_ROOT" "$@"
}

mirror_git() {
  local mirror_path
  mirror_path="$1"
  shift
  git --git-dir="$mirror_path" "$@"
}

local_identity_count() {
  local email commit_count tag_count
  email="$1"
  commit_count="$(
    repo_git log --all --format='%ae%n%ce' |
      awk -v wanted="$email" '$0 == wanted { count++ } END { print count + 0 }'
  )"
  tag_count="$(
    repo_git for-each-ref --format='%(taggeremail)' refs/tags |
      awk -v wanted="$email" '
        { gsub(/^</, ""); gsub(/>$/, "") }
        $0 == wanted { count++ }
        END { print count + 0 }
      '
  )"
  printf '%s' "$((commit_count + tag_count))"
}

mirror_identity_count() {
  local mirror_path email commit_count tag_count
  mirror_path="$1"
  email="$2"
  commit_count="$(
    mirror_git "$mirror_path" log --all --format='%ae%n%ce' |
      awk -v wanted="$email" '$0 == wanted { count++ } END { print count + 0 }'
  )"
  tag_count="$(
    mirror_git "$mirror_path" for-each-ref --format='%(taggeremail)' refs/tags |
      awk -v wanted="$email" '
        { gsub(/^</, ""); gsub(/>$/, "") }
        $0 == wanted { count++ }
        END { print count + 0 }
      '
  )"
  printf '%s' "$((commit_count + tag_count))"
}

heads_and_tags() {
  mirror_git "$1" for-each-ref \
    --format='%(refname)' refs/heads refs/tags |
    sort
}

mirror_commit_messages_contain() {
  mirror_git "$1" log --all --format='%B' |
    awk -v wanted="$2" '
      index($0, wanted) { found = 1 }
      END { exit(found ? 0 : 1) }
    '
}

mirror_tag_messages_contain() {
  mirror_git "$1" for-each-ref --format='%(contents)' refs/tags |
    awk -v wanted="$2" '
      index($0, wanted) { found = 1 }
      END { exit(found ? 0 : 1) }
    '
}

mirror_content_contains() {
  mirror_git "$1" log --all --pickaxe-all -S"$2" --format='%H' |
    awk '
      NF { found = 1 }
      END { exit(found ? 0 : 1) }
    '
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --new-name)
        [ "$#" -ge 2 ] || die "--new-name needs a value."
        NEW_NAME="$2"
        shift 2
        ;;
      --new-email)
        [ "$#" -ge 2 ] || die "--new-email needs a value."
        NEW_EMAIL="$2"
        shift 2
        ;;
      --old-email)
        [ "$#" -ge 2 ] || die "--old-email needs a value."
        OLD_EMAILS+=("$2")
        shift 2
        ;;
      --remote)
        [ "$#" -ge 2 ] || die "--remote needs a value."
        REMOTE_NAME="$2"
        shift 2
        ;;
      --backup-dir)
        [ "$#" -ge 2 ] || die "--backup-dir needs a value."
        BACKUP_DIR="$2"
        shift 2
        ;;
      --rewrite)
        DO_REWRITE=1
        shift
        ;;
      --push)
        DO_REWRITE=1
        DO_PUSH=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      --)
        shift
        break
        ;;
      -*)
        die "Unknown option: $1"
        ;;
      *)
        [ -z "$REPO_ARG" ] || die "Only one repository path may be supplied."
        REPO_ARG="$1"
        shift
        ;;
    esac
  done

  if [ "$#" -gt 0 ]; then
    [ -z "$REPO_ARG" ] || die "Only one repository path may be supplied."
    REPO_ARG="$1"
    shift
  fi
  [ "$#" -eq 0 ] || die "Unexpected arguments: $*"
}

parse_args "$@"

REPO_ARG="${REPO_ARG:-.}"
[ -d "$REPO_ARG" ] || die "Repository path does not exist: $REPO_ARG"
REPO_ROOT="$(cd "$REPO_ARG" && pwd -P)"

repo_git rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
  die "Not a working-tree Git repository: $REPO_ROOT"
[ "$(repo_git rev-parse --is-bare-repository)" = "false" ] ||
  die "A bare repository cannot be used as the source checkout."
repo_git rev-parse --verify HEAD >/dev/null 2>&1 ||
  die "Repository has no commits."

if [ "$DO_REWRITE" -eq 1 ]; then
  FILTER_REPO="$(command -v git-filter-repo || true)"
  [ -n "$FILTER_REPO" ] ||
    die "git-filter-repo is required: https://github.com/newren/git-filter-repo"
  [ -n "$NEW_NAME" ] || die "--new-name is required with --rewrite."
  [ -n "$NEW_EMAIL" ] || die "--new-email is required with --rewrite."
  [ "${#OLD_EMAILS[@]}" -gt 0 ] ||
    die "At least one --old-email is required with --rewrite."
  valid_name "$NEW_NAME" || die "--new-name contains unsupported characters."
  valid_email "$NEW_EMAIL" ||
    die "--new-email must be a simple email address."
  for old_email in "${OLD_EMAILS[@]}"; do
    valid_email "$old_email" ||
      die "--old-email must be a simple email address: $old_email"
    [ "$old_email" != "$NEW_EMAIL" ] ||
      die "An old email cannot be the same as --new-email."
  done
fi

WORKTREE_STATUS="$(repo_git status --porcelain --untracked-files=all)"
if [ -z "$WORKTREE_STATUS" ]; then
  WORKTREE_STATE="clean"
else
  WORKTREE_STATE="dirty"
fi

REMOTE_URL="$(repo_git remote get-url "$REMOTE_NAME" 2>/dev/null || true)"
HEAD_NAME="$(repo_git symbolic-ref --quiet --short HEAD 2>/dev/null || printf 'detached HEAD')"
LOCAL_HEADS="$(repo_git for-each-ref --format='%(refname)' refs/heads)"
LOCAL_TAGS="$(repo_git for-each-ref --format='%(refname)' refs/tags)"
REMOTE_REFS="$(repo_git for-each-ref --format='%(refname)' refs/remotes)"

section "Repository inspection"
printf 'Repository: %s\n' "$REPO_ROOT"
printf 'Current branch: %s\n' "$HEAD_NAME"
printf 'Remote %s: %s\n' "$REMOTE_NAME" "${REMOTE_URL:-<not configured>}"
printf 'Local heads: %s | tags: %s | remote-tracking refs: %s\n' \
  "$(line_count "$LOCAL_HEADS")" \
  "$(line_count "$LOCAL_TAGS")" \
  "$(line_count "$REMOTE_REFS")"
printf 'Working tree: %s\n' "$WORKTREE_STATE"
github_report

if [ "$DO_REWRITE" -eq 0 ]; then
  section "Inspection complete"
  printf 'No backup, rewrite, or push was performed.\n'
  printf 'Run with --rewrite and explicit identity options to continue.\n'
  exit 0
fi

[ -z "$WORKTREE_STATUS" ] ||
  die "Source checkout is not clean. Commit or stash changes first."

section "Proposed identity mapping"
printf 'New identity: %s <%s>\n' "$NEW_NAME" "$NEW_EMAIL"
for old_email in "${OLD_EMAILS[@]}"; do
  printf 'Old email: %s (local author/committer occurrences: %s)\n' \
    "$old_email" "$(local_identity_count "$old_email")"
done
printf '\nThe source checkout will remain unchanged.\n'
printf 'GitHub Releases, release assets, forks, and other clones are outside this script.\n'

confirm "The repository and identity mapping above are correct."

TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
REPO_PARENT="$(dirname "$REPO_ROOT")"
REPO_BASE="$(basename "$REPO_ROOT")"

if [ -z "$BACKUP_DIR" ]; then
  BACKUP_DIR="$REPO_PARENT/${REPO_BASE}.identity-backup-$TIMESTAMP.git"
else
  BACKUP_PARENT="$(cd "$(dirname "$BACKUP_DIR")" && pwd -P)"
  BACKUP_DIR="$BACKUP_PARENT/$(basename "$BACKUP_DIR")"
fi

case "$BACKUP_DIR" in
  "$REPO_ROOT"|"$REPO_ROOT"/*)
    die "Backup must be outside the source checkout: $BACKUP_DIR"
    ;;
esac
[ ! -e "$BACKUP_DIR" ] || die "Backup path exists: $BACKUP_DIR"

if [ -n "$REMOTE_URL" ]; then
  CLONE_SOURCE="$REMOTE_URL"
  section "Creating a mirror backup from the canonical remote"
else
  CLONE_SOURCE="$REPO_ROOT"
  section "Creating a mirror backup from the local checkout"
fi

REMOTE_SNAPSHOT_BEFORE="$BACKUP_DIR.remote-heads-and-tags.before.txt"
REMOTE_SNAPSHOT="$BACKUP_DIR.remote-heads-and-tags.txt"
if [ -n "$REMOTE_URL" ]; then
  git ls-remote --heads --tags "$REMOTE_URL" |
    sort > "$REMOTE_SNAPSHOT_BEFORE"
else
  : > "$REMOTE_SNAPSHOT_BEFORE"
fi

git clone --mirror "$CLONE_SOURCE" "$BACKUP_DIR"

if [ -n "$REMOTE_URL" ]; then
  git ls-remote --heads --tags "$REMOTE_URL" | sort > "$REMOTE_SNAPSHOT"
  if ! cmp -s "$REMOTE_SNAPSHOT_BEFORE" "$REMOTE_SNAPSHOT"; then
    die "Remote heads or tags changed during backup. The backup was preserved, but nothing was rewritten or pushed."
  fi
else
  : > "$REMOTE_SNAPSHOT"
fi

section "Checking the canonical backup"
for old_email in "${OLD_EMAILS[@]}"; do
  backup_occurrences="$(mirror_identity_count "$BACKUP_DIR" "$old_email")"
  [ "$backup_occurrences" -gt 0 ] ||
    die "The canonical backup contains no identity fields for: $old_email"
  printf '%s: %s author/committer/tagger occurrences\n' \
    "$old_email" "$backup_occurrences"
done

MANIFEST="${BACKUP_DIR%.git}.manifest.txt"
{
  printf 'identity rewrite backup\n'
  printf 'created_utc=%s\n' "$TIMESTAMP"
  printf 'source_checkout=%s\n' "$REPO_ROOT"
  printf 'clone_source=%s\n' "$CLONE_SOURCE"
  printf 'remote_name=%s\n' "$REMOTE_NAME"
  printf 'remote_url=%s\n' "$REMOTE_URL"
  printf 'new_name=%s\n' "$NEW_NAME"
  printf 'new_email=%s\n' "$NEW_EMAIL"
  for old_email in "${OLD_EMAILS[@]}"; do
    printf 'old_email=%s\n' "$old_email"
  done
  printf 'filter_repo_version=%s\n' \
    "$("$FILTER_REPO" --version 2>/dev/null || printf 'unknown')"
} > "$MANIFEST"

ensure_temp_dir
MAILMAP="$TEMP_DIR/identity.mailmap"
for old_email in "${OLD_EMAILS[@]}"; do
  printf '%s <%s> <%s>\n' \
    "$NEW_NAME" "$NEW_EMAIL" "$old_email" >> "$MAILMAP"
done

REWRITE_DIR="$REPO_PARENT/${REPO_BASE}.identity-rewritten-$TIMESTAMP.git"
[ ! -e "$REWRITE_DIR" ] || die "Rewrite path exists: $REWRITE_DIR"
git clone --mirror "$BACKUP_DIR" "$REWRITE_DIR"

BACKUP_REFS="$(heads_and_tags "$BACKUP_DIR")"

section "Rewriting the isolated mirror"
(
  cd "$REWRITE_DIR"
  "$FILTER_REPO" --force --mailmap "$MAILMAP"
)

section "Validating the rewritten mirror"
for old_email in "${OLD_EMAILS[@]}"; do
  remaining="$(mirror_identity_count "$REWRITE_DIR" "$old_email")"
  [ "$remaining" -eq 0 ] ||
    die "Old identity remains in rewritten mirror: $old_email"

  if mirror_commit_messages_contain "$REWRITE_DIR" "$old_email"; then
    die "Old email remains in a commit message. Nothing was pushed; review trailers and messages manually: $old_email"
  fi
  if mirror_tag_messages_contain "$REWRITE_DIR" "$old_email"; then
    die "Old email remains in an annotated tag message. Nothing was pushed: $old_email"
  fi
  if mirror_content_contains "$REWRITE_DIR" "$old_email"; then
    die "Old email remains in repository content history. Nothing was pushed: $old_email"
  fi
done

new_occurrences="$(mirror_identity_count "$REWRITE_DIR" "$NEW_EMAIL")"
[ "$new_occurrences" -gt 0 ] ||
  die "New identity was not found in rewritten history."

REWRITTEN_REFS="$(heads_and_tags "$REWRITE_DIR")"
[ "$BACKUP_REFS" = "$REWRITTEN_REFS" ] ||
  die "Head or tag names changed. Backup and rewritten mirrors were preserved for review."

section "Rewrite validated"
printf 'Backup mirror: %s\n' "$BACKUP_DIR"
printf 'Backup manifest: %s\n' "$MANIFEST"
printf 'Rewritten mirror: %s\n' "$REWRITE_DIR"
printf 'New identity occurrences: %s\n' "$new_occurrences"
printf 'The source checkout is unchanged.\n'
printf 'The backup contains the original identity; keep it private.\n'

if [ "$DO_PUSH" -eq 0 ]; then
  printf '\nNo push was requested. Review the rewritten mirror before using --push.\n'
  exit 0
fi

[ -n "$REMOTE_URL" ] ||
  die "Remote $REMOTE_NAME has no URL; cannot push."

CURRENT_REMOTE_SNAPSHOT="$TEMP_DIR/current-remote-heads-and-tags.txt"
git ls-remote --heads --tags "$REMOTE_URL" |
  sort > "$CURRENT_REMOTE_SNAPSHOT"

if ! cmp -s "$REMOTE_SNAPSHOT" "$CURRENT_REMOTE_SNAPSHOT"; then
  die "Remote heads or tags changed after backup. Nothing was pushed; rerun from a fresh state."
fi

printf '\nThe next step force-updates all remote heads and tags at:\n  %s\n' "$REMOTE_URL"
printf 'The backup remains at:\n  %s\n' "$BACKUP_DIR"
printf 'Review immutable releases and signed tags before continuing.\n'
confirm "The validated rewritten mirror should replace the remote heads and tags."

git ls-remote --heads --tags "$REMOTE_URL" |
  sort > "$CURRENT_REMOTE_SNAPSHOT"

if ! cmp -s "$REMOTE_SNAPSHOT" "$CURRENT_REMOTE_SNAPSHOT"; then
  die "Remote heads or tags changed while awaiting confirmation. Nothing was pushed; rerun from a fresh state."
fi

LEASE_ARGS=()
while read -r expected_sha expected_ref; do
  case "$expected_ref" in
    refs/heads/*|refs/tags/*)
      case "$expected_ref" in
        *'^{}') continue ;;
      esac
      LEASE_ARGS+=("--force-with-lease=$expected_ref:$expected_sha")
      ;;
  esac
done < "$REMOTE_SNAPSHOT"

git --git-dir="$REWRITE_DIR" push --atomic "${LEASE_ARGS[@]}" "$REMOTE_URL" \
  'refs/heads/*:refs/heads/*' \
  'refs/tags/*:refs/tags/*'

section "Push completed"
printf 'Keep the backup until GitHub history, tags, and releases are verified.\n'
printf 'The backup contains the removed identity and must remain private.\n'
printf 'Do not push from the old checkout; re-clone the rewritten repository.\n'
