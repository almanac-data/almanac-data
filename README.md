# Almanac org workspace

Local jump-in point for [The Almanac](https://github.com/almanac-data) — the engine,
verticals, and org tooling in one Cursor workspace.

This folder is **not** a vertical and **not** the public template. It is a thin meta-repo for
the engine caretaker: propagate engine changes, check reachability across verticals, and keep
fleet handoffs tagged `almanac-data` instead of a single domain repo.

## Layout

Sibling clones are linked here (not copied):

```
almanac-data/                 ← open Cursor here
  almanac-template/           → engine source (PRs merge here first)
  agriculture-almanac/        → vertical
  civic-almanac/
  climate-almanac/
  economy-almanac/
  education-almanac/
  energy-almanac/
  environment-almanac/
  health-almanac/
  justice-almanac/
  science-almanac/
  transportation-almanac/
  org-dotgithub/              → almanac-data/.github org profile repo
  scripts/
    link-repos.sh             # (re)create symlinks after clone
    propagate-engine.sh       # template → all verticals
    status-all.sh             # validate + link-check every vertical
```

Repos live as siblings under `~/github/`. Run `./scripts/link-repos.sh` if a symlink is missing.

## Quick start

```bash
cd ~/github/almanac-data
./scripts/link-repos.sh
# Open almanac.code-workspace in Cursor (or open this folder)
```

Fleet overlay: copy `.mcp.json.example` → `.mcp.json` and adjust paths if needed.

## Workflow

1. **Engine change** → PR to `almanac-template`, merge, then `./scripts/propagate-engine.sh --dry-run` and `--apply`.
2. **Catalog change** → PR to the relevant vertical only (`catalog/*.yaml` + regenerated `catalog.json`).
3. **Org profile** → PR to `org-dotgithub` (GitHub repo `almanac-data/.github`).

Read [`AGENTS.md`](AGENTS.md) before any agent session.
