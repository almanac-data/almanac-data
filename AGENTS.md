# Agent guide — Almanac org workspace

Instructions for AI agents working **across** The Almanac (`github.com/almanac-data`).
Read this before making changes. For catalog-only work inside one vertical, that vertical's
own `AGENTS.md` still applies when you are editing `catalog/`.

## What this workspace is

The Almanac is an **open org of catalog-not-host verticals** sharing one engine:

| Piece | Repo | Who owns changes |
|-------|------|------------------|
| **Engine** | `almanac-template` | Engine caretaker (schema, scripts, CI) |
| **Vertical** | `climate-almanac`, `health-almanac`, … | Stewards (catalog contents) |
| **Org profile** | `almanac-data/.github` (`org-dotgithub/` here) | Engine caretaker |
| **This folder** | `almanac-data` (local meta-repo) | Propagation scripts, org agent context |

**Catalog, don't host.** Never commit dataset bytes. Entries point at authoritative sources.

## Where to work

| Task | Open / edit |
|------|-------------|
| Schema, `check_links.py`, CI workflows, shared tests | `almanac-template/` → PR there **first** |
| Fan out a merged engine change | `./scripts/propagate-engine.sh` then one PR per vertical |
| Add or fix one dataset | One vertical's `catalog/<id>.yaml` only |
| Steward onboarding, org landing page | `org-dotgithub/` |
| Cross-vertical status | `./scripts/status-all.sh` |

Default session root: **`almanac-data/`** (this folder), not `climate-almanac/`.

## Engine propagation (critical)

Engine changes **do not auto-sync**. After `almanac-template` merges to `main`:

```bash
./scripts/propagate-engine.sh --dry-run   # review diff
./scripts/propagate-engine.sh --apply     # copy engine files to all verticals
```

Then, **per vertical**: `python scripts/build_index.py` if `build_index.py` changed,
`python scripts/validate.py`, `ruff check .`, open a PR. Never copy `catalog/` or
`almanac.config.yml` identity fields — only engine paths listed in `propagate-engine.sh`.

`reachability.headless` in each vertical's `almanac.config.yml` is vertical-specific
(civic/economy: `true`; climate/health/environment: usually `false`).

## Invariants (all repos)

1. Schema is the contract — `python scripts/validate.py` before commit.
2. Filename equals `id` (`catalog/foo.yaml` → `id: foo`).
3. Regenerate `catalog.json` after catalog edits; never hand-edit it.
4. Verify URLs before asserting `live`; set honest `status` and `last_checked`.
5. Blocked ≠ dead — bot protection is `blok`, not a dead-link flag.

## Fleet development

If `.mcp.json` is present (gitignored), you have Willow MCP, Kart, and Grove.
Inherited conventions:

- Worktree + PR for every change; no direct commits to `main`.
- Shell work via Kart (`willow_run` / `agent_task_submit`), not raw agent Bash.
- Handoffs and KB use `project: almanac-data` when working from this workspace.

See [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md) for overlay setup.

## Tone

Accuracy beats coverage. The org proves the engine generalizes; vertical stewards own contents.
Community good-first-issues are for contributors — enable, don't implement, unless asked.
