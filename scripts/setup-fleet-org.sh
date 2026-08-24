#!/usr/bin/env bash
# Fleet-wide GitHub org hygiene for the seven Die-Namic faces.
# Requires: gh authenticated; admin:org for --apply-security.
set -euo pipefail

FLEET_ORGS=(
  almanac-data
  Die-Namic-Systems
  willow-memory
  hornbook-knowledge
  homestead-affairs
  forge-play
  terpsi-programs
)

CONFIG_ID="${CONFIG_ID:-17}"   # "GitHub recommended"
DRY_RUN=0
ACTION=""
ORG="${ORG:-}"

usage() {
  cat <<'EOF'
Usage: ./scripts/setup-fleet-org.sh <action> [options]

Actions:
  --audit                 Org + repo defaults + security enforcement table
  --report-ci             Workflow inventory across product repos
  --apply-repo-defaults   delete_branch_on_merge, no wiki, merge+rebase only (no squash)
  --apply-security        Attach GitHub recommended config (#17) to all repos
  --apply-auto-merge      Enable allow_auto_merge on release-please product repos
  --apply-branch-protection  Ruleset: PR required + status check "test" on default branch

Options:
  ORG=<name>              Limit to one org (default: all seven)
  --dry-run               Print commands without executing mutating ones

Examples:
  ./scripts/setup-fleet-org.sh --audit
  ORG=homestead-affairs ./scripts/setup-fleet-org.sh --apply-repo-defaults
  ./scripts/setup-fleet-org.sh --apply-security --dry-run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --audit) ACTION=audit; shift ;;
    --report-ci) ACTION=report_ci; shift ;;
    --apply-repo-defaults) ACTION=repos; shift ;;
    --apply-security) ACTION=security; shift ;;
    --apply-auto-merge) ACTION=auto_merge; shift ;;
    --apply-branch-protection) ACTION=branch_protection; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$ACTION" ]]; then
  usage
  exit 1
fi

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "DRY-RUN: $*"
  else
    echo "+ $*"
    "$@" >/dev/null
  fi
}

orgs() {
  if [[ -n "$ORG" ]]; then
    echo "$ORG"
  else
    printf '%s\n' "${FLEET_ORGS[@]}"
  fi
}

require_admin_org() {
  if ! gh auth status 2>&1 | grep -q 'admin:org'; then
    echo "Need admin:org scope. Run:" >&2
    echo "  gh auth refresh -h github.com -s admin:org" >&2
    exit 1
  fi
}

# Release-please / PyPI product repos that should have auto-merge on.
RELEASE_REPOS=(
  Die-Namic-Systems/Nestor
  willow-memory/willow-mcp
  willow-memory/kartikeya
  hornbook-knowledge/Jeles
  homestead-affairs/homestead
  homestead-affairs/homestead-law
  homestead-affairs/homestead-health
  homestead-affairs/homestead-ledger
)

audit() {
  printf '%-22s %-12s %-10s %-10s %s\n' "ORG" "2FA" "SEC_ENF" "DESC?" "DEFAULT_PERM"
  printf '%-22s %-12s %-10s %-10s %s\n' "---" "---" "---" "---" "---"
  while IFS= read -r org; do
    meta="$(gh api "orgs/$org" --jq '[.two_factor_requirement_enabled, .default_repository_permission, (.description != null and .description != "")] | @tsv')"
    enf="$(gh api "orgs/$org/code-security/configurations" --jq '[.[] | select(.id==17) | .enforcement] | first // "none"' 2>/dev/null || echo none)"
    tfa="$(cut -f1 <<<"$meta")"
    perm="$(cut -f2 <<<"$meta")"
    has_desc="$(cut -f3 <<<"$meta")"
    printf '%-22s %-12s %-10s %-10s %s\n' "$org" "$tfa" "$enf" "$has_desc" "$perm"
  done < <(orgs)

  echo
  printf '%-40s %-8s %-6s %-10s\n' "REPO" "DEL_BR" "WIKI" "AUTO_MERGE"
  printf '%-40s %-8s %-6s %-10s\n' "----" "------" "----" "----------"
  while IFS= read -r org; do
    gh repo list "$org" --limit 100 \
      --json name,deleteBranchOnMerge,hasWikiEnabled,nameWithOwner \
      --jq '.[] | [.nameWithOwner, (.deleteBranchOnMerge|tostring), (.hasWikiEnabled|tostring)] | @tsv' \
      | while IFS=$'\t' read -r full del wiki; do
          auto="$(gh api "repos/$full" --jq '.allow_auto_merge' 2>/dev/null || echo '?')"
          printf '%-40s %-8s %-6s %-10s\n' "$full" "$del" "$wiki" "$auto"
        done
  done < <(orgs)
}

report_ci() {
  printf '%-40s %-12s %-12s %s\n' "REPO" "DEPENDABOT" "AUTOMERGE" "WORKFLOWS"
  printf '%-40s %-12s %-12s %s\n' "----" "----------" "---------" "---------"
  while IFS= read -r org; do
    while IFS= read -r name; do
      [[ -z "$name" || "$name" == ".github" ]] && continue
      full="$org/$name"
      dep="no"
      auto="no"
      if gh api "repos/$full/contents/.github/dependabot.yml" --jq .name >/dev/null 2>&1; then
        dep="yes"
      fi
      if gh api "repos/$full/contents/.github/workflows/dependabot-automerge.yml" --jq .name >/dev/null 2>&1; then
        auto="yes"
      fi
      wfs="$(gh api "repos/$full/contents/.github/workflows" --jq '[.[].name] | join(",")' 2>/dev/null || echo "(none)")"
      printf '%-40s %-12s %-12s %s\n' "$full" "$dep" "$auto" "$wfs"
    done < <(gh repo list "$org" --limit 100 --json name -q '.[].name')
  done < <(orgs)
}

apply_repo_defaults() {
  while IFS= read -r org; do
    echo "==> Repo defaults for ${org}"
    while IFS= read -r name; do
      [[ -z "$name" ]] && continue
      echo "  ${name}"
      run gh api -X PATCH "repos/${org}/${name}" \
        -f delete_branch_on_merge=true \
        -F has_wiki=false \
        -F allow_squash_merge=false \
        -F allow_merge_commit=true \
        -F allow_rebase_merge=true
    done < <(gh repo list "$org" --limit 100 --json name -q '.[].name')
  done < <(orgs)
}

apply_security() {
  require_admin_org
  while IFS= read -r org; do
    echo "==> Security config ${CONFIG_ID} for ${org}"
    target_type="$(gh api "/orgs/${org}/code-security/configurations/${CONFIG_ID}" --jq '.target_type')"
    name="$(gh api "/orgs/${org}/code-security/configurations/${CONFIG_ID}" --jq '.name')"
    if [[ "$target_type" == "global" ]]; then
      echo "    Global (${name}): attach only — enforce in browser:"
      echo "    https://github.com/organizations/${org}/settings/security_analysis"
    else
      run gh api -X PATCH "/orgs/${org}/code-security/configurations/${CONFIG_ID}" \
        -f enforcement=enforced
    fi
    run gh api -X POST "/orgs/${org}/code-security/configurations/${CONFIG_ID}/attach" \
      -f scope=all
    run gh api -X PUT "/orgs/${org}/code-security/configurations/${CONFIG_ID}/defaults" \
      -f default_for_new_repos=public
  done < <(orgs)
}

apply_auto_merge() {
  for full in "${RELEASE_REPOS[@]}"; do
    if [[ -n "$ORG" && "$full" != "$ORG/"* ]]; then
      continue
    fi
    echo "  ${full}"
    run gh api -X PATCH "repos/${full}" -F allow_auto_merge=true
  done
}

# Idempotent: skip if any ruleset already requires the aggregate "test" check.
repo_has_test_check() {
  local full="$1" id
  while IFS= read -r id; do
    [[ -z "$id" ]] && continue
    if gh api "repos/$full/rulesets/$id" \
      --jq '[.rules[]? | select(.type=="required_status_checks")
             | .parameters.required_status_checks[]?.context] | any(.=="test")' \
      | grep -q true; then
      return 0
    fi
  done < <(gh api "repos/$full/rulesets" --jq '.[].id')
  return 1
}

apply_branch_protection() {
  for full in "${RELEASE_REPOS[@]}"; do
    if [[ -n "$ORG" && "$full" != "$ORG/"* ]]; then
      continue
    fi
    echo "==> ${full}"
    if repo_has_test_check "$full"; then
      echo "  already requires check 'test' — skip"
      continue
    fi
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "DRY-RUN: create ruleset require-test-for-merge on $full"
      continue
    fi
    echo "+ create ruleset require-test-for-merge"
    gh api -X POST "repos/$full/rulesets" --input - >/dev/null <<'EOF'
{
  "name": "require-test-for-merge",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] }
  },
  "rules": [
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": false,
        "allowed_merge_methods": ["merge", "rebase"]
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": true,
        "do_not_enforce_on_create": false,
        "required_status_checks": [{ "context": "test" }]
      }
    },
    { "type": "non_fast_forward" }
  ]
}
EOF
  done
}

case "$ACTION" in
  audit) audit ;;
  report_ci) report_ci ;;
  repos) apply_repo_defaults ;;
  security) apply_security ;;
  auto_merge) apply_auto_merge ;;
  branch_protection) apply_branch_protection ;;
esac
