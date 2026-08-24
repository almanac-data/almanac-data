#!/usr/bin/env bash
# Print catalog.json entry counts for every almanac-data vertical (for profile/README.md).
set -euo pipefail

ORG="${ORG:-almanac-data}"
VERTICALS=(
  agriculture-almanac
  civic-almanac
  climate-almanac
  economy-almanac
  education-almanac
  energy-almanac
  environment-almanac
  health-almanac
  justice-almanac
  science-almanac
  transportation-almanac
)

printf "%-24s %s\n" "REPO" "COUNT"
printf "%-24s %s\n" "----" "-----"
total=0
for repo in "${VERTICALS[@]}"; do
  count="$(gh api "repos/${ORG}/${repo}/contents/catalog.json" --jq '.content' \
    | base64 -d \
    | python3 -c "import json,sys; print(json.load(sys.stdin)['count'])")"
  printf "%-24s %s\n" "$repo" "$count"
  total=$((total + count))
done
printf "%-24s %s\n" "TOTAL" "$total"
