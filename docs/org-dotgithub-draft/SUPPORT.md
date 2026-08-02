# Support

Everything here runs on volunteer time. Filing in the right place is most of what makes a
question answerable.

## Where to go

| What you have | Where it goes |
|---------------|---------------|
| A dataset that should be cataloged | An issue on the relevant vertical — "Suggest a dataset" |
| A source that has gone dark, moved, or changed | An issue on the vertical holding that entry, or a PR flipping its `status` |
| An entry that is wrong — bad URL, wrong publisher, over-claimed coverage | An issue or PR on that vertical. Evidence beats assertion: a status code, a redirect chain, an archive capture |
| A question about the schema, or a validator that rejects a valid entry | An issue on [`almanac-template`](https://github.com/almanac-data/almanac-template) |
| Standing up your own almanac from the template | `SETUP.md` in `almanac-template`, then an issue there |
| A security vulnerability in the tooling | **Not an issue** — see `SECURITY.md` |

When in doubt, file it on the vertical you were looking at. Moving an issue is easy; finding one
nobody filed is not.

## Which repository is which

- **A vertical** (`health-almanac`, `climate-almanac`, and nine siblings) holds the catalog
  entries for one domain. Stewards own the contents.
- **`almanac-template`** is the shared engine: schema, validation, reachability monitoring, CI.
  Changes here reach every vertical by propagation.
- **`almanac-data`** is the org meta-repo — propagation scripts and cross-vertical tooling.
- **`.github`** holds these org-wide documents.

If your issue is about *what a catalog says*, it belongs on a vertical. If it is about *how the
machinery works*, it belongs on the template.

## What to expect

No response-time guarantee. Issues with a concrete, checkable claim get handled fastest —
"`https://example.gov/data` now 404s, Wayback's last good capture is 2024-11-03" can be acted on
immediately; "some links seem broken" needs a conversation before anything can happen.

Dead-link alerts opened automatically by the monitor are triaged by the vertical's stewards. If
one is a false positive — bot protection refusing the checker rather than the source actually
being gone — saying so on the issue is a real contribution. Blocked is not dead, and an entry
should not be flipped to `dark` because a crawler got a 403.
