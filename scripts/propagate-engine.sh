#!/usr/bin/env bash
# Copy engine files from almanac-template into every vertical.
#
# Usage:
#   ./scripts/propagate-engine.sh --dry-run   # show what would change (default)
#   ./scripts/propagate-engine.sh --apply     # write files
#
# After --apply: in each vertical run validate.py (+ build_index.py if the index
# builder changed), then open one PR per vertical. Never auto-commits.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="${ROOT}/almanac-template"
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

# Paths shared by template and all verticals (identity + catalog excluded).
ENGINE_PATHS=(
  schema/catalog-entry.schema.json
  scripts/validate.py
  scripts/build_index.py
  scripts/check_links.py
  scripts/alert_on_dead_links.py
  scripts/migrate_v1_v2.py
  requirements.txt
  requirements-headless.txt
  pyproject.toml
  tests/test_catalog.py
  .github/workflows/ci.yml
  .github/workflows/link-check.yml
)

APPLY=0
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=1 ;;
    --dry-run) APPLY=0 ;;
    -h|--help)
      sed -n '2,10p' "$0"
      exit 0
      ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done

if [[ ! -d "$TEMPLATE" ]]; then
  echo "Missing template: $TEMPLATE (run ./scripts/link-repos.sh)" >&2
  exit 1
fi

copy_file() {
  local rel="$1" dest_root="$2"
  local src="${TEMPLATE}/${rel}"
  local dst="${dest_root}/${rel}"
  if [[ ! -f "$src" ]]; then
    echo "  SKIP missing in template: $rel" >&2
    return 0
  fi
  if [[ -f "$dst" ]] && cmp -s "$src" "$dst"; then
    echo "  = $rel"
    return 0
  fi
  if [[ "$APPLY" -eq 1 ]]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  + $rel"
  else
    echo "  ~ $rel (would update)"
  fi
}

for vertical in "${VERTICALS[@]}"; do
  dest="${ROOT}/${vertical}"
  if [[ ! -d "$dest" ]]; then
    echo "SKIP $vertical — not linked at $dest" >&2
    continue
  fi
  echo "=== $vertical ==="
  for rel in "${ENGINE_PATHS[@]}"; do
    copy_file "$rel" "$dest"
  done
  echo
done

if [[ "$APPLY" -eq 0 ]]; then
  echo "Dry run only. Re-run with --apply to write files."
else
  echo "Applied. Next per vertical: python scripts/validate.py && python scripts/build_index.py"
  echo "Then ruff check . and open a PR."
fi
