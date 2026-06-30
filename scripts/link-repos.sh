#!/usr/bin/env bash
# Create symlinks from this workspace to sibling clones under ~/github/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PARENT="$(cd "$ROOT/.." && pwd)"

link() {
  local dest_name="$1"
  local src_name="${2:-$dest_name}"
  local target="${PARENT}/${src_name}"
  local dest="${ROOT}/${dest_name}"
  if [[ ! -d "$target" ]]; then
    echo "SKIP $dest_name — missing at $target" >&2
    return 0
  fi
  if [[ -L "$dest" ]]; then
    echo "OK   $dest_name (symlink exists)"
    return 0
  fi
  if [[ -e "$dest" ]]; then
    echo "WARN $dest_name — $dest exists and is not a symlink; not overwriting" >&2
    return 0
  fi
  ln -s "$target" "$dest"
  echo "LINK $dest_name -> $target"
}

link almanac-template
link climate-almanac
link health-almanac
link economy-almanac
link environment-almanac
link civic-almanac
link org-dotgithub almanac-data-dotgithub

echo "Done. Workspace root: $ROOT"
