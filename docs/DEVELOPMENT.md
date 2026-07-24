# Development — org workspace

This meta-repo is **local-first**. It is not required for public contributors; vertical repos
clone and run with Python alone.

## Symlinks

Repos are expected as siblings under `~/github/`:

```
~/github/almanac-data/          # this workspace (git clone)
~/github/almanac-template/
~/github/climate-almanac/
…
```

After cloning `almanac-data`, run:

```bash
./scripts/link-repos.sh
```

## Fleet overlay

```bash
cp .mcp.json.example .mcp.json
```

Edit absolute paths if your home directory differs. The overlay wires Willow MCP, Kart, and
Grove; it never ships in git.

Register with Willow (once per machine, from `willow-2.0`):

```bash
./willow.sh project sync \
  almanac-data almanac-data-dotgithub almanac-template \
  climate-almanac health-almanac economy-almanac environment-almanac civic-almanac
./willow.sh project check almanac-data   # verify wiring
```

All ids must exist in `willow/fylgja/config/mcp_projects.seed.json`. Sync materializes
`.cursor/hooks.json`, `.mcp.json`, and scoped `WILLOW_HANDOFF_PROJECT` per repo (local only;
gitignored on verticals and org profile).

## Propagate engine changes

Template merges first, then:

```bash
./scripts/propagate-engine.sh --dry-run
./scripts/propagate-engine.sh --apply
```

Open one PR per vertical with the propagated diff. Run `build_index.py` in each vertical if
the index builder changed.
