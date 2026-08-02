# Contributing to The Almanac

> **Scope note.** GitHub shows this file only for repositories in this organization that do not
> ship their own `CONTRIBUTING.md` — today the meta and template repos. Every vertical
> (`health-almanac`, `climate-almanac`, and their siblings) has its own, which takes precedence.
> **If you came here wanting to add a dataset, read that vertical's `CONTRIBUTING.md` instead** —
> it carries the field-by-field checklist this file deliberately does not duplicate.

## The one rule

**Catalog, don't host.** These repositories map where public data lives; they never store the
data itself. No CSVs, no NetCDF, no GeoTIFFs, no PDFs of the source. An entry points at the
publisher's canonical home and records how to get there.

If a change tempts you to commit a data file, the answer is almost always a catalog entry
pointing at where that file already lives.

## Which repository takes your change

| Change | Repository |
|--------|-----------|
| Add or fix one dataset entry | The relevant vertical, `catalog/<id>.yaml` only |
| Schema, validation, link checking, CI | [`almanac-template`](https://github.com/almanac-data/almanac-template) — merges there first, then propagates |
| Propagation scripts, cross-vertical tooling | [`almanac-data`](https://github.com/almanac-data/almanac-data) |
| These org-wide documents | `.github` |

Engine changes do not auto-sync. A merged change in `almanac-template` reaches the verticals only
when a caretaker runs propagation, which opens one pull request per vertical. Expect the lag.

## How entries are judged

- **Authoritative sources only.** The publisher's canonical home, never a reposting or a
  mirror-of-convenience.
- **Verify before you assert.** Open the URL. An entry claiming a source is reachable when nobody
  checked is worse than no entry, because it will be believed.
- **Under-claim.** Where coverage, cadence, or lineage is uncertain, state the narrower thing you
  can defend. An entry that says less and is right beats one that says more and is not.
- **Honest status.** `live`, `revised`, `moved`, `redirected`, `superseded`, `dark`, `frozen` —
  set from what was actually observed, never from what would be tidier.
- **Machine facts stay machine-written.** The `observed` block records what a probe saw. Set
  `observed.checked` and leave `reachable`, `http_status`, and `final_url` for the reachability
  script to fill. Your own verification belongs in the pull request description, where a human
  wrote it and it reads as one.
- **Attribution is mandatory.** Every entry credits its publisher, even though the index itself
  is CC0.

## Mechanics

One dataset is one file and one pull request. Small changes get reviewed; large ones wait.

Before opening a pull request, run the checks the CI will run anyway:

```bash
pip install -r requirements.txt
python scripts/validate.py       # schema, filename==id, uniqueness
python scripts/build_index.py    # regenerate catalog.json, commit it in the same change
```

`catalog.json` is generated. Never hand-edit it — edit the YAML and rebuild, or CI's staleness
guard will catch the difference.

## If you would rather not write YAML

Every vertical accepts dataset suggestions as issues. Name the dataset and its canonical source;
a curator turns it into an entry. That is a genuine contribution, not a lesser one — knowing
which dataset matters is the harder half.

## Conduct, support, security

See [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md), [`SUPPORT.md`](SUPPORT.md), and
[`SECURITY.md`](SECURITY.md). Disagreements about whether an entry is *accurate* are not conduct
matters — argue them on the pull request with evidence.
