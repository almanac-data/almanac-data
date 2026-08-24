# Org setup playbook — almanac-data (template for the other six)

How to bring a GitHub organization from "repos exist" to "fully configured" using
`gh` from this workspace. **almanac-data** is the practice org; repeat the same
steps for each sibling org once this one is green.

## What `gh` can do from here

Authenticated as **`rudi193-cmd`** — org **admin** on `almanac-data`.

| Capability | Works today? | Token / role needed |
|------------|--------------|---------------------|
| List/view repos, PRs, issues, reviews | Yes | `repo` |
| Push branches, open PRs | Yes | `repo` |
| Patch org profile (description, blog, …) | Yes | org admin |
| Edit `almanac-data/.github` (local: `dotgithub/`) | Yes | `repo` + ADMIN on `.github` |
| Attach/enforce code security configs | **No** — 403 | `admin:org` |
| Set org defaults (2FA, member permissions) | **Browser** | org owner in Settings UI |

Refresh scopes when you need org security APIs:

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
│  almanac-data/.github  (local: dotgithub/)              │
│  profile/, CODE_OF_CONDUCT, SECURITY, SUPPORT, …        │
│  Org-wide defaults — fallback for repos without locals  │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│  Per-repo files (verticals, template, meta)             │
│  CONTRIBUTING, ISSUE_TEMPLATE, CI — owned by engine     │
└─────────────────────────────────────────────────────────┘
```

**Key rule:** org-level `CONTRIBUTING.md` never overrides vertical copies. Org-level
`CODE_OF_CONDUCT.md`, `SECURITY.md`, and `SUPPORT.md` apply everywhere because
verticals don't ship their own.

## Checklist — almanac-data current state (2026-08-23)

### A. Org profile (Settings → General)

| Item | Current | Target |
|------|---------|--------|
| Display name | The Almanac | ✓ |
| Description | profile tagline | ✓ |
| Social links (blog, location, email) | empty | optional |
| Default repository permission | read | ✓ |
| Default branch name | main | ✓ |
| Member repo creation | all types allowed | tighten if desired |
| 2FA requirement | off | **enable** for other orgs with collaborators |
| Dependabot/secret scanning for new repos | off at org level | handled by security config (below) |

Patch description from CLI:

```bash
gh api -X PATCH orgs/almanac-data \
  -f description='A community-maintained commons for public data — catalogs that map where authoritative datasets live, and monitor whether they stay reachable.'
```

### B. Code security (Settings → Code security → Configurations)

A **"GitHub recommended"** configuration (id `17`) already exists with
`private_vulnerability_reporting: enabled` — but **`enforcement: unenforced`**
and **not attached** to any repo. Civic-almanac still shows secret scanning
disabled.

**Do this once** (after `gh auth refresh -s admin:org`):

```bash
./scripts/setup-almanac-org.sh --apply-security
```

The org's existing **"GitHub recommended"** config (id `17`) is a **global** preset —
GitHub does not allow PATCHing global configs (`400 Global configurations are not
allowed to be updated`). The script attaches it to all repos and sets it as the
default for new public repos. That enables PVR, secret scanning, and Dependabot
alerts without needing enforcement.

To **enforce** (block repos from opting out), either:
- **Browser:** Settings → Code security → Configurations → GitHub recommended → Enforce
- **API:** create an org-owned configuration (`target_type: organization`) with
  `enforcement: enforced`, then attach that instead

Or manually in the browser:

1. **Organization settings → Code security → Configurations**
2. Open **GitHub recommended** → **Enforce configuration**
3. **Apply to all repositories** (or attach per-repo)
4. Set as **default for new public repositories**

This enables the **Report a vulnerability** button that `SECURITY.md` and
`CODE_OF_CONDUCT.md` route reporters to.

### C. Community health files (`dotgithub/` → PR to `almanac-data/.github`)

| File | Status | Notes |
|------|--------|-------|
| `profile/README.md` | live, counts stale | sync from `catalog.json` |
| `CODE_OF_CONDUCT.md` | **missing** | publish from `docs/org-dotgithub-draft/` |
| `SECURITY.md` | **missing** | publish from draft; requires step B first |
| `SUPPORT.md` | live, short | replace with draft (full routing table) |
| `CONTRIBUTING.md` | live, short | replace with draft (org-scope note) |
| `pull_request_template.md` | ✓ | |
| `ISSUE_TEMPLATE/` | ✓ | fix security contact link |
| `FUNDING.yml` | skipped | no funding channels |

Workflow:

```bash
cd dotgithub
git checkout -b org/setup-community-health
# … edit files …
git add -A && git commit -m "…"
git push -u origin HEAD
gh pr create --repo almanac-data/.github --title "…" --body "…"
```

### D. Org profile README — dataset counts

Counts must match each vertical's `catalog.json`. Refresh:

```bash
./scripts/org-profile-counts.sh
```

Edit `dotgithub/profile/README.md` table, commit in the same PR.

### E. Per-repo defaults (optional, scriptable)

Reasonable defaults for almanac verticals:

| Setting | Current (sample) | Suggested |
|---------|------------------|-----------|
| `delete_branch_on_merge` | false | **true** |
| `has_wiki` | true | **false** |
| `allow_merge_commit` | true | false (squash-only) or keep all three |
| Branch protection on `main` | varies | require CI + 1 review for template |

```bash
./scripts/setup-almanac-org.sh --apply-repo-defaults   # after script exists
```

### F. What verticals own (not org setup)

- `catalog/*.yaml`, `catalog.json` — stewards
- `CONTRIBUTING.md`, `ISSUE_TEMPLATE/` — engine via `almanac-template` propagation
- `.github/workflows/` — engine

Do **not** duplicate vertical issue templates at org level unless you want them
on `almanac-data` and `almanac-template` only.

## Fleet script (all seven orgs)

Prefer this over looping `setup-almanac-org.sh` by hand:

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

## Repeat for the other six orgs

1. `gh auth status` — confirm account has org admin
2. `gh auth refresh -s admin:org` if automating security
3. Clone or link `ORG/.github` locally (names starting with `.` need a non-dot
   folder name, same pattern as `dotgithub/`)
4. Copy community health files; adjust conduct contact and org name
5. Run security configuration attach + enforce
6. Open org profile PR
7. Spot-check one vertical repo: Security tab shows **Report a vulnerability**

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

# Community health score (GitHub UI is more informative than API here)
gh repo list almanac-data --limit 20
```
