# The Almanac

**Open, versioned indexes of public data — a catalog, not a warehouse.**

Public datasets go missing quietly. A URL changes, an agency reorganizes, a page starts serving
something different at the same address, and the citation in a paper from three years ago now
points at nothing. The Almanac exists to notice.

Each vertical here is an index of the authoritative sources in one domain: where a dataset
canonically lives, how to actually get it, whether it still resolves, and where the original can
be recovered if it stops. Every entry is one small YAML file, human-reviewed and
machine-validated. A scheduled job re-checks every link and opens an issue when one goes dark.

**We catalog; we don't host.** No dataset bytes live in these repos — only records pointing at
where the data lives. The catalog is small enough to read, diff, and trust.

## The verticals

| | | |
|---|---|---|
| [agriculture](https://github.com/almanac-data/agriculture-almanac) | [civic](https://github.com/almanac-data/civic-almanac) | [climate](https://github.com/almanac-data/climate-almanac) |
| [economy](https://github.com/almanac-data/economy-almanac) | [education](https://github.com/almanac-data/education-almanac) | [energy](https://github.com/almanac-data/energy-almanac) |
| [environment](https://github.com/almanac-data/environment-almanac) | [health](https://github.com/almanac-data/health-almanac) | [justice](https://github.com/almanac-data/justice-almanac) |
| [science](https://github.com/almanac-data/science-almanac) | [transportation](https://github.com/almanac-data/transportation-almanac) | |

All eleven run the same engine — one schema, one validator, one reachability monitor — maintained
in [`almanac-template`](https://github.com/almanac-data/almanac-template). Verticals differ in
contents, not machinery.

## Contributing

You do not need to write code. Every vertical takes **dataset suggestions** as issues: name the
dataset and its canonical source, and a curator turns it into an entry.

If you would rather do it yourself, one dataset is one file and one pull request. The vertical's
`CONTRIBUTING.md` has the checklist; entries good enough to merge tend to be the ones where
someone actually opened the URL first.

Two principles govern every entry:

- **Authoritative sources only** — the publisher's canonical home, never a reposting.
- **Accuracy over coverage** — a small, correct, current catalog beats a large stale one. Where
  something cannot be verified, the catalog under-claims rather than over-claims.

Stewardship is earned rather than assigned: land a couple of clean entries and you have already
done the job. Say so on a PR if you would like to own a vertical.

## Licensing

Catalog contents (`catalog/`, `catalog.json`) are **CC0** — public domain, use them for anything.
Tooling (schema, scripts, CI) is **MIT**. Entries credit their publishers in an `attribution`
field regardless, because provenance is the point.
