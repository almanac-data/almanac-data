# Fleet CI templates — python-product

Identical workflows and Dependabot config that every PyPI / release-please
repo in the fleet should carry. **Do not** put repo-specific tests here —
those stay in each repo's `tests.yml` / `ci.yml` / `pr-title.yml`.

## Contents

| Path | Purpose |
|------|---------|
| `.github/dependabot.yml` | Weekly pip + github-actions updates |
| `.github/workflows/dependabot-automerge.yml` | Arm auto-merge on Dependabot PRs (no `gh pr update-branch`) |

Canonical source: `Die-Namic-Systems/Nestor` (proven through repeated releases).

## Apply to a clone

```bash
REPO=~/github/homestead-affairs/homestead
cp -r fleet-ci-templates/python-product/.github/dependabot.yml "$REPO/.github/"
cp -r fleet-ci-templates/python-product/.github/workflows/dependabot-automerge.yml \
  "$REPO/.github/workflows/"
```

Then open a PR. Also enable **Allow auto-merge** on the repo if release-please
is used:

```bash
gh api -X PATCH repos/OWNER/REPO -F allow_auto_merge=true
# or: ./scripts/setup-fleet-org.sh --apply-auto-merge
```

## Intentionally not in this pack

- `pr-title.yml` — embeds a `PACKAGED = (...)` path unique per repo
- `release-please.yml` / `publish.yml` / `release.yml` — component names and
  workflow filenames differ (Nestor uses `publish.yml`)
- `tests.yml` / `ci.yml` — product-specific

Action pin bumps (`checkout@v7`, `setup-python@v7`) happen when you next edit
those files in each repo, not via this pack.
