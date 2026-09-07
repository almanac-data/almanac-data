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
  --audit-protection      Ruleset / PR rule / status check / legacy classic protection, per repo
  --report-ci             Workflow inventory across product repos
  --apply-repo-defaults   delete_branch_on_merge, no wiki, merge+rebase only (no squash)
  --apply-security        Attach GitHub recommended config (#17) to all repos
  --apply-auto-merge      Enable allow_auto_merge on release-please product repos
  --apply-branch-protection  Ruleset "require-test-for-merge" on EVERY non-archived repo:
                             PR required + non_fast_forward, plus status check "test" where
                             the repo actually emits one. Idempotent; archived repos skipped.

Options:
  ORG=<name>              Limit to one org (default: all seven)
  --dry-run               Print commands without executing mutating ones

Examples:
  ./scripts/setup-fleet-org.sh --audit
  ./scripts/setup-fleet-org.sh --audit-protection
  ORG=forge-play ./scripts/setup-fleet-org.sh --apply-branch-protection --dry-run
  ORG=homestead-affairs ./scripts/setup-fleet-org.sh --apply-repo-defaults
  ./scripts/setup-fleet-org.sh --apply-security --dry-run
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --audit) ACTION=audit; shift ;;
    --audit-protection) ACTION=audit_protection; shift ;;
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

# How many rulesets does this repo have? -1 means "could not tell".
#
# The distinction matters and cost a bug to learn. `--jq length` on the error
# object GitHub returns for an inaccessible repo (a private one on Free, where
# repo rules need Pro) counts its KEYS, not rulesets — three of them — so the
# repo reported as protected when nothing had been read at all. An audit that
# answers "yes" where it means "I could not look" hides exactly the gap it
# exists to find. Guard on the type, not the count.
repo_ruleset_count() {
  local out
  out="$(gh api "repos/$1/rulesets" --jq 'if type == "array" then length else -1 end' 2>/dev/null)" || { echo -1; return 0; }
  [[ -z "$out" ]] && out=-1
  echo "$out"
}

repo_has_ruleset() {
  [[ "$(repo_ruleset_count "$1")" -gt 0 ]]
}

# Can this repo actually produce a check named "test"?
#
# This decides which variant it gets, and getting it wrong is not cosmetic:
# requiring a check a repo never emits leaves every PR permanently unmergeable.
# Ten repos in the fleet are in that position today — the seven `.github`
# repos plus almanac-data, willow-data-vault and oakenscrolls-office — and
# they carry the pull_request rule without the status check for this reason.
#
# The evidence is the default branch's own check runs. A repo that has run CI
# has told us the answer; a repo that has not gets the no-check variant and a
# note, and gains the check on a later run of this action.
repo_offers_test_check() {
  local full="$1" def
  def="$(gh api "repos/$full" --jq '.default_branch' 2>/dev/null)" || return 1
  [[ -z "$def" ]] && return 1
  gh api "repos/$full/commits/$def/check-runs" \
    --jq '[.check_runs[]?.name] | any(. == "test")' 2>/dev/null | grep -q true
}

# The fleet standard, emitted to stdout. $1 = "checks" | "no-checks".
#
# Kept byte-identical to what the 36 provisioned repos carry, including the
# two fields an earlier version of this script omitted: bypass_actors, without
# which an org admin cannot bypass the rule, and
# require_extra_approval_for_unattributed_changes. A repo provisioned by the
# old version did not match its neighbours, and nothing reported the drift.
ruleset_json() {
  local checks_rule=""
  if [[ "$1" == "checks" ]]; then
    checks_rule='{
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": true,
        "do_not_enforce_on_create": false,
        "required_status_checks": [{ "context": "test" }]
      }
    },'
  fi
  cat <<JSON
{
  "name": "require-test-for-merge",
  "target": "branch",
  "enforcement": "active",
  "bypass_actors": [
    { "actor_id": null, "actor_type": "OrganizationAdmin", "bypass_mode": "always" }
  ],
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
        "require_extra_approval_for_unattributed_changes": true,
        "allowed_merge_methods": ["merge", "rebase"]
      }
    },
    ${checks_rule}
    { "type": "non_fast_forward" }
  ]
}
JSON
}

# Report which repos are protected and how. The audit that would have caught
# forge-play/Forge and forge-play/forge-workshop sitting on classic branch
# protection with required_pull_request_reviews null — the test check
# required, and a direct push to the default branch permitted anyway.
audit_protection() {
  printf '%-40s %-8s %-9s %-8s %-7s %s\n' "REPO" "ARCHIVED" "RULESET" "PR" "CHECKS" "CLASSIC"
  printf '%-40s %-8s %-9s %-8s %-7s %s\n' "----" "--------" "-------" "--" "------" "-------"
  while IFS= read -r org; do
    while IFS=$'\t' read -r full arch def; do
      [[ -z "$full" ]] && continue
      local types pr checks classic rs count
      count="$(repo_ruleset_count "$full")"
      if [[ "$count" -lt 0 ]]; then
        # Not readable — say so. Never report an unread repo as protected.
        printf '%-40s %-8s %-9s %-8s %-7s %s\n' "$full" "$arch" "?" "?" "?" "unreadable (private on Free? needs Pro)"
        continue
      fi
      [[ "$count" -gt 0 ]] && rs=yes || rs="NO"
      types="$(gh api "repos/$full/rules/branches/$def" --jq '[.[].type] | unique | join(",")' 2>/dev/null || echo "?")"
      case "$types" in *pull_request*) pr=yes ;; *) pr=NO ;; esac
      case "$types" in *required_status_checks*) checks=yes ;; *) checks=no ;; esac
      if gh api "repos/$full/branches/$def/protection" >/dev/null 2>&1; then
        classic="PRESENT (legacy — two sources of truth)"
      else
        classic="-"
      fi
      printf '%-40s %-8s %-9s %-8s %-7s %s\n' "$full" "$arch" "$rs" "$pr" "$checks" "$classic"
    done < <(gh api "orgs/$org/repos?per_page=100" --paginate \
               --jq '.[] | [.full_name, (.archived|tostring), (.default_branch // "-")] | @tsv')
  done < <(orgs)
}

apply_branch_protection() {
  local scope_desc="every non-archived repo"
  [[ -n "$ORG" ]] && scope_desc="every non-archived repo in $ORG"
  echo "Scope: ${scope_desc}. Idempotent — a repo that already has a ruleset is skipped."
  while IFS= read -r org; do
    while IFS=$'\t' read -r full arch; do
      [[ -z "$full" ]] && continue
      if [[ "$arch" == "true" ]]; then
        echo "==> ${full}"
        echo "  archived — skip"
        continue
      fi
      echo "==> ${full}"
      local count
      count="$(repo_ruleset_count "$full")"
      if [[ "$count" -lt 0 ]]; then
        # Could not read the existing rulesets. Creating one blind risks a
        # duplicate on a repo that is already protected, so refuse and say why.
        echo "  cannot read rulesets (private on Free? needs Pro) — skip, not guessing"
        continue
      fi
      if [[ "$count" -gt 0 ]]; then
        echo "  already has a ruleset — skip"
        continue
      fi
      local variant note
      if repo_offers_test_check "$full"; then
        variant=checks
        note="requires check 'test'"
      else
        variant=no-checks
        note="no 'test' check seen on the default branch; PR rule only. Re-run after its first CI run to add the check."
      fi
      if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "DRY-RUN: create ruleset require-test-for-merge (${variant}) — ${note}"
        continue
      fi
      echo "+ create ruleset require-test-for-merge (${variant}) — ${note}"
      ruleset_json "$variant" | gh api -X POST "repos/$full/rulesets" --input - >/dev/null
    done < <(gh api "orgs/$org/repos?per_page=100" --paginate \
               --jq '.[] | [.full_name, (.archived|tostring)] | @tsv')
  done < <(orgs)
}

case "$ACTION" in
  audit) audit ;;
  audit_protection) audit_protection ;;
  report_ci) report_ci ;;
  repos) apply_repo_defaults ;;
  security) apply_security ;;
  auto_merge) apply_auto_merge ;;
  branch_protection) apply_branch_protection ;;
esac
