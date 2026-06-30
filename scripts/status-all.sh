#!/usr/bin/env bash
# Validate and link-check every linked vertical (summary only).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERTICALS=(
  climate-almanac
  health-almanac
  economy-almanac
  environment-almanac
  civic-almanac
)

failures=0
for vertical in "${VERTICALS[@]}"; do
  dir="${ROOT}/${vertical}"
  echo "========== ${vertical} =========="
  if [[ ! -d "$dir" ]]; then
    echo "SKIP — not linked" >&2
    failures=$((failures + 1))
    continue
  fi
  if ! (cd "$dir" && python scripts/validate.py); then
    failures=$((failures + 1))
    continue
  fi
  if ! (cd "$dir" && python scripts/check_links.py 2>&1 | tail -5); then
    failures=$((failures + 1))
  fi
  echo
done

if [[ "$failures" -gt 0 ]]; then
  echo "$failures vertical(s) had failures or were missing." >&2
  exit 1
fi
echo "All verticals OK."
