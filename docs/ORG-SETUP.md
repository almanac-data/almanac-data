# Org setup playbook — fleet (seven orgs)

How to bring a GitHub organization from "repos exist" to "fully configured" using
`gh` from this workspace. **almanac-data** was the practice org; the same pattern
applies to the six siblings.

**As of 2026-08-24:** all seven orgs have live profiles, community health files,
`FUNDING.yml` → Sponsors (`rudi193-cmd`), GitHub-recommended code security
**enforced**, and 2FA **required**. Almanac verticals are under `almanac-data`.
Remaining placement work (product transfers into empty shells) is listed at the
end — not org-profile setup.

## What `gh` can do from here

Authenticated as **`rudi193-cmd`** — org **admin** on all seven, with `admin:org`
+ `repo` scopes.

| Capability | Works today? | Token / role needed |
|------------|--------------|---------------------|
| List/view repos, PRs, issues, reviews | Yes | `repo` |
| Push branches, open PRs | Yes | `repo` |
| Patch org profile (description, blog, …) | Yes | org admin |
| Edit `ORG/.github` (local: `dotgithub/` for Almanac) | Yes | `repo` + ADMIN on `.github` |
| Attach/enforce code security configs | Yes | `admin:org` |
| Set org 2FA / some member defaults | Partial — prefer **Browser** for 2FA | org owner in Settings UI |

Refresh scopes when security APIs return 403:

```bash
gh auth refresh -h github.com -s admin:org
gh auth status   # confirm admin:org appears
```

## Architecture (three layers)

```
┌─────────────────────────────────────────────────────────┐
│  GitHub org settings (browser or admin:org API)         │
│  PVR, secret scanning, 2FA, member permissions, …       │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│  ORG/.github  (Almanac local: dotgithub/)               │
│  profile/, CODE_OF_CONDUCT, SECURITY, SUPPORT, …        │
│  Org-wide defaults — fallback for repos without locals  │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│  Per-repo files (verticals, products, template)         │
│  CONTRIBUTING, ISSUE_TEMPLATE, CI — product or engine   │
└─────────────────────────────────────────────────────────┘
```

**Key rule (Almanac):** org-level `CONTRIBUTING.md` never overrides vertical copies.
Org-level `CODE_OF_CONDUCT.md`, `SECURITY.md`, and `SUPPORT.md` apply everywhere
because verticals don't ship their own.

## Checklist — fleet current state (2026-08-24)

### A. Org profile (Settings → General)

| Item | Status |
|------|--------|
| Display name + description | ✓ all seven |
| Social links (blog, location, email) | empty — optional |
| Default repository permission | read |
| Default branch name | `main` (some products still use `master`) |
| Member repo creation / deletion | still open — **tighten when collaborators join** |
| 2FA requirement | ✓ **enabled** on all seven |
| Dependabot / secret scanning for new repos | via security config (below) |

Patch description from CLI (example):

```bash
gh api -X PATCH orgs/almanac-data \
  -f description='A community-maintained commons for public data — catalogs that map where authoritative datasets live, and monitor whether they stay reachable.'
```

### B. Code security (Settings → Code security → Configurations)

**Done fleet-wide:** attach **GitHub recommended** (global id `17`) to all repos,
set as default for new public repos, and **Enforce** in the browser (API cannot
PATCH global configs: `400 Global configurations are not allowed to be updated`).

Re-run attach / default if a new org appears:

```bash
./scripts/setup-fleet-org.sh --apply-security   # needs admin:org
```

Enforce URL pattern (per org):

`https://github.com/organizations/ORG/settings/security_products/configurations/view/17`

This enables the **Report a vulnerability** button that `SECURITY.md` and
`CODE_OF_CONDUCT.md` route reporters to.

### C. Community health files (`ORG/.github`)

| File | Status |
|------|--------|
| `profile/README.md` | ✓ live on all seven |
| `CODE_OF_CONDUCT.md` | ✓ |
| `SECURITY.md` | ✓ |
| `SUPPORT.md` | ✓ |
| `CONTRIBUTING.md` | ✓ |
| `pull_request_template.md` / `ISSUE_TEMPLATE/` | ✓ where drafted |
| `FUNDING.yml` | ✓ → `github: [rudi193-cmd]` |

Almanac local clone: `dotgithub/` (gitignored name for the `.github` repo).

```bash
cd dotgithub
git checkout -b org/…
# … edit files …
git push -u origin HEAD
gh pr create --repo almanac-data/.github --title "…" --body "…"
```

### D. Org profile README — Almanac dataset counts

Counts must match each vertical's `catalog.json`. Refresh:

```bash
./scripts/org-profile-counts.sh
```

Edit `dotgithub/profile/README.md` table, commit in the profile PR.

### E. Per-repo defaults

Applied fleet-wide where appropriate:

| Setting | Target |
|---------|--------|
| `delete_branch_on_merge` | **true** |
| `has_wiki` | **false** |
| Auto-merge | on for release-please product repos |
| Branch ruleset requiring check `test` | release product repos |

```bash
./scripts/setup-fleet-org.sh --apply-repo-defaults
./scripts/setup-fleet-org.sh --apply-auto-merge
./scripts/setup-fleet-org.sh --apply-branch-protection
```

### F. What Almanac verticals own (not org setup)

- `catalog/*.yaml`, `catalog.json` — stewards
- `CONTRIBUTING.md`, `ISSUE_TEMPLATE/` — engine via `almanac-template` propagation
- `.github/workflows/` — engine

Do **not** duplicate vertical issue templates at org level unless you want them
on `almanac-data` and `almanac-template` only.

### G. Package metadata after transfers

`pyproject.toml` `[project.urls]` often still pointed at `rudi193-cmd/…` after
repo transfer. Keep Homepages/Repository/Issues on the **org** path so PyPI and
docs resolve. Intentional exceptions (e.g. a Rubric URL into a still-personal
`willow-seed`) can remain until that upstream moves.

## Fleet script (all seven orgs)

```bash
./scripts/setup-fleet-org.sh --audit              # org + repo defaults table
./scripts/setup-fleet-org.sh --report-ci          # dependabot / workflow inventory
./scripts/setup-fleet-org.sh --apply-repo-defaults
./scripts/setup-fleet-org.sh --apply-security     # needs admin:org
./scripts/setup-fleet-org.sh --apply-auto-merge   # release-please product repos
./scripts/setup-fleet-org.sh --apply-branch-protection  # require check "test"
```

Identical Dependabot + auto-merge workflows live in
[`fleet-ci-templates/python-product/`](../fleet-ci-templates/README.md).

## Repeat for a new org

1. `gh auth status` — confirm account has org admin + `admin:org` if automating security
2. Clone or link `ORG/.github` locally (names starting with `.` need a non-dot folder)
3. Copy community health files; adjust conduct contact and org name
4. Run security configuration attach + **Enforce** in browser
5. Open org profile PR; add `FUNDING.yml` if Sponsors apply
6. Spot-check one product repo: Security tab shows **Report a vulnerability**
7. After transferring repos in, fix `pyproject.toml` Homepages (see G)

## Still open (placement / policy — not profile setup)

| Item | Notes |
|------|--------|
| Transfer `rudi193-cmd/Forge` → `forge-play` | org is profile-only today |
| Transfer `rudi193-cmd/terpsi-music` → `terpsi-programs` | same |
| Optional: `willow-grove` → `willow-memory` | still personal |
| Tighten member create/delete | when orgs are no longer solo |
| Org teams | only if you want role separation |

## Local workspace wiring

```bash
./scripts/link-repos.sh          # creates org-dotgithub → dotgithub symlink
cd dotgithub && git pull
```

Fleet sync (when Willow overlay is active):

```bash
cd ~/github/willow-2.0
./willow.sh project sync almanac-data-dotgithub
```

## Quick audit commands

```bash
# Org metadata
gh api orgs/almanac-data --jq '{name, description, default_repository_permission, two_factor_requirement_enabled}'

# Security config
gh api orgs/almanac-data/code-security/configurations \
  --jq '.[] | {id, name, enforcement, private_vulnerability_reporting}'

# Sample repo security features
gh api repos/almanac-data/civic-almanac --jq '.security_and_analysis'

# Dataset counts for profile table
./scripts/org-profile-counts.sh

# Fleet defaults
./scripts/setup-fleet-org.sh --audit

# Community health score (GitHub UI is more informative than API here)
gh repo list almanac-data --limit 20
```
