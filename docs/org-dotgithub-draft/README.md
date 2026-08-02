# Draft: org-level community health files

Staging area for files destined for **`almanac-data/.github`** (the `org-dotgithub/` symlink
in this workspace). They live here only because that repo cannot be attached to an agent
session — GitHub repository names beginning with `.` are refused as clone targets — so drafts
are prepared here and moved across by hand.

## Where each file goes

Paths are relative to the root of the `almanac-data/.github` repo:

| Draft here | Goes to | Effect |
|------------|---------|--------|
| `profile-README.md` | `profile/README.md` | The org landing page at `github.com/almanac-data` |
| `CODE_OF_CONDUCT.md` | `CODE_OF_CONDUCT.md` | Org-wide default |
| `SECURITY.md` | `SECURITY.md` | Org-wide default |
| `SUPPORT.md` | `SUPPORT.md` | Org-wide default |
| `CONTRIBUTING.md` | `CONTRIBUTING.md` | Org-wide default |

Note the rename on the first row: the org profile page must be at `profile/README.md`, but a
file by that name here would be read as this directory's own readme.

## What "org-wide default" actually means

GitHub uses an org-level community health file **only for repos that do not define their own**.
It is a fallback, never an override.

This matters for `CONTRIBUTING.md`: all eleven verticals ship their own, so the org-level copy
will never render on `health-almanac` or any sibling. It covers only repos with no local file —
today `almanac-data`, `almanac-template`, and `.github` itself. Correcting the contributor guide
that verticals actually show is a separate job, handled by propagation from `almanac-template`.

`CODE_OF_CONDUCT.md`, `SECURITY.md`, and `SUPPORT.md` are different: no vertical defines those
locally, so the org copies apply everywhere immediately.

## Before publishing

Each file below carries `TODO(caretaker)` markers where a real value is needed — reporting
contacts, mainly. Nothing invents an address, so every marker must be resolved or deliberately
removed first. They are HTML comments and will not render, which means an unresolved one fails
quietly rather than loudly.

## Not included

- `ISSUE_TEMPLATE/` — org-level defaults apply only to repos with no templates of their own.
  Every vertical has them, so org-level templates would reach only the meta and template repos.
  Worth adding if those repos should take structured issues; skipped as speculative for now.
- `FUNDING.yml` — no funding channels are known to exist. Not invented.
