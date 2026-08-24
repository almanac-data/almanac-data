#!/usr/bin/env bash
# Apply org-level GitHub settings for almanac-data.
# Requires: gh authenticated, org admin; admin:org scope for --apply-security.
set -euo pipefail

ORG="${ORG:-almanac-data}"
CONFIG_ID="${CONFIG_ID:-17}"   # "GitHub recommended" as of 2026-08-23
DRY_RUN=1

usage() {
  sed -n '2,20p' "$0"
  echo
  echo "Usage: $0 [--dry-run|--apply-security|--apply-repo-defaults]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --apply-security) DRY_RUN=0; ACTION=security; shift ;;
    --apply-repo-defaults) DRY_RUN=0; ACTION=repos; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "DRY-RUN: $*"
  else
    echo "+ $*"
    "$@"
  fi
}

require_admin_org() {
  if ! gh auth status 2>&1 | grep -q 'admin:org'; then
    echo "Need admin:org scope. Run:" >&2
    echo "  gh auth refresh -h github.com -s admin:org" >&2
    exit 1
  fi
}

apply_security() {
  require_admin_org

  local target_type name
  target_type="$(gh api "/orgs/${ORG}/code-security/configurations/${CONFIG_ID}" --jq '.target_type')"
  name="$(gh api "/orgs/${ORG}/code-security/configurations/${CONFIG_ID}" --jq '.name')"

  if [[ "$target_type" == "global" ]]; then
    echo "==> Attach global security config ${CONFIG_ID} (${name})"
    echo "    Global configs cannot be PATCHed via API — skipping enforcement."
    echo "    Features (PVR, secret scanning, …) still apply once attached."
    echo "    To enforce: Settings → Code security → Configurations → ${name} → Enforce"
  else
    echo "==> Enforce org security config ${CONFIG_ID} (${name})"
    run gh api -X PATCH "/orgs/${ORG}/code-security/configurations/${CONFIG_ID}" \
      -f enforcement=enforced
  fi

  run gh api -X POST "/orgs/${ORG}/code-security/configurations/${CONFIG_ID}/attach" \
    -f scope=all
  run gh api -X PUT "/orgs/${ORG}/code-security/configurations/${CONFIG_ID}/defaults" \
    -f default_for_new_repos=public
  echo "Attach is async (HTTP 202). Check Settings → Code security after a minute."
}

apply_repo_defaults() {
  echo "==> Repo defaults for ${ORG} public repos"
  repos="$(gh repo list "$ORG" --limit 100 --json name -q '.[].name')"
  while IFS= read -r name; do
    [[ -z "$name" ]] && continue
    echo "  ${name}"
    run gh api -X PATCH "repos/${ORG}/${name}" \
      -f delete_branch_on_merge=true \
      -f has_wiki=false
  done <<< "$repos"
}

case "${ACTION:-}" in
  security) apply_security ;;
  repos) apply_repo_defaults ;;
  *)
    echo "No action selected. Showing current state:"
  gh api "orgs/${ORG}" --jq '{name, description, default_repository_permission, two_factor_requirement_enabled}'
  echo
  gh api "orgs/${ORG}/code-security/configurations" \
    --jq '.[] | {id, name, enforcement, private_vulnerability_reporting}'
  echo
  echo "Run with --apply-security or --apply-repo-defaults (drops dry-run)."
  ;;
esac
