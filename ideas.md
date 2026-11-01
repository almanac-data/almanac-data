# Ideas

A working list of where the Almanac could grow: new verticals, and kinds of
entry beyond datasets. Nothing here is a commitment. An idea moves to
**Decided** when its scope is settled (that section appears only while something is in
it), and leaves this file once its repository exists and has entries, noted under **Built**.

*Started 2026-10-31, when the eleven verticals reached 132 entries.*

## How an idea moves

- **Add one:** use the [idea form](https://github.com/almanac-data/almanac-data/issues/new?template=idea.yml)
  (labelled `idea`), or open a pull request that adds it to this file. A single dataset goes to its
  vertical's own "Suggest a dataset" form instead. Those become `[dataset]` issues labelled
  `dataset-suggestion`, and anyone can turn one into an entry.
- **Pick one up:** no permission is needed. Open a draft pull request that names the idea and links
  the tracking issue, "Pick up an idea", in this repository. For a vertical, follow **Adding a vertical**
  below. For a dataset, follow the vertical's CONTRIBUTING.md.
- **When it's done:** an idea leaves **Decided** or **Candidate verticals** for **Built**. A dataset
  issue closes when its entry merges.
- **Never:**
  - Host data. The Almanac catalogs where data lives; `recovery[]` points to copies.
  - State a licence the publisher doesn't. Write `unverified` and say what you found.
  - Let a machine set `status`. Automation records facts in `observed`; a person changes the label.

## Built

Ideas that left this file because their repository exists and has entries.

- **2026-10-31: `migration-almanac` (17 entries).**
  - **Scope:** flows, asylum, refugees, displacement, remittances, and enforcement and
    border data. Stocks stay in population.
  - **First link check:** 16 reachable. Frontex was blocked by bot protection, which isn't
    counted as dead.
  - **Delays the US pages state themselves, quoted in the notes:**
    - The DHS Yearbook's 2023 and 2024 editions show "Download coming soon".
    - The DHS monthly tables are "delayed while it is under review", with November 2024 the
      last one posted.
  - **Still to add:**
    - State Department visa statistics and the IOM Migration Data Portal. Both were blocked
      on 2026-10-31.
  - **Left out on purpose:** TRAC Immigration. Its terms forbid storing its data in another
    database or collecting it with automated tools.
- **2026-10-31: `tech-almanac` (29 entries: 20 at launch, plus 9 on the software ecosystem).**
  - **Scope:** digital access, patents, internet measurement, security, and public-sector
    AI data only. Company-hosted training sets and model cards are out.
  - **First link check:** all 20 reachable.
  - **Licences:** several sources are deliberately not open. WIPO, the EPO, RIPE Atlas
    and CAIDA have explicit but restrictive terms, and the ITU DataHub and Cloudflare Radar
    are non-commercial. Each entry's notes quote the terms.
  - **Still to add:**
    - Ofcom Connected Nations and the FCC National Broadband Map. Both were blocked by their
      CDNs on 2026-10-31.
    - The Internet Archive's crawl data.
    - A NIST AI dataset, if one exists as data rather than guidance.
    - crates.io's database dumps. They were added and then removed the same day. The Data
      Access Policy page exists only inside crates.io's JavaScript app, so the server returns
      404 to every non-browser request, and the link checker escalates to headless only on
      block codes, never on a 404. The entry can come back if crates.io serves the page, or
      if the checker learns to try a browser on a 404 for hosts known to be single-page apps.
- **2026-10-31: `population-almanac` (15 entries), `labor-almanac` (16) and
  `housing-almanac` (14).** Labor is its own vertical, not part of economy, and holds CPI.
  All 40 entries outside BLS answered on the first link check.
  - **Fixed after launch:** bls.gov refused the link checker's headless browser.
    almanac-template #57 launches full Chromium's new headless mode, which bls.gov serves.
  - **Still to add:**
    - Statistics Canada's census and IBGE's Censo 2022. Both sites were behind Cloudflare
      on 2026-10-31.
    - The American Housing Survey and HUD CHAS. Both were reachable but left out to keep the
      first seed small.
    - BLS QCEW and OEWS.
    - The OECD Affordable Housing Database, once www.oecd.org can be reached.

## Willow and the Almanac

Willow (willow-memory/Willow) already does much of what the Almanac's upkeep needs. The Almanac,
in turn, gives willow a curated map of where public data lives. Done on 2026-11-01:

- **Willow → Almanac:**
  - **Quote check** (almanac-data #12): every quotation in the catalog notes was checked with
    willow's new `quotes` add-on against a fresh copy of its page. See
    docs/reviews/2026-11-01-quote-check.md.
    - Results: 421 of 726 as written. 132 are unverifiable because their pages never rendered.
      125 are flagged for a steward.
    - No entry was edited on the check alone: its one apparent misquote was right once the page
      fully rendered.
  - **Licence watch** (almanac-data #13): willow's `policy-watch` runs weekly on the 110
    licence pages the catalogs cite, and opens an issue when one's wording changes. The first
    run saved 93 copies; 17 pages were blocked.
- **Almanac → willow:** one willow PR, built here as a patch (willow-almanac-pr.patch, on
  willow main 40442ab), because this session can't push to willow.
  - `almanac` passages carry fingerprints, archived copies, kind and collection.
  - `quotes` checks every quote in a document.
  - `almanac-keep` fetches an entry's best permitted copy into your own folder. The Almanac
    points; willow keeps.
- **Next:**
  - A steward pass over the quote review's flags.
  - Moving the licence watch's willow pin once the willow PR merges.
  - `ro-crate` or `ids` releases of each catalog, and `foia` beside dark entries.

## Adding a vertical

The steps the 2026-10-31 verticals took, in order. Each one was missed or found the hard way
at least once.

1. **The repository.** An org admin creates it from `almanac-template`. In its settings,
   turn on *Actions → General → "Allow GitHub Actions to create and approve pull
   requests"*, so the link checker can open its observed-refresh PRs. If the willow-ci app
   is installed on selected repositories only, add the new one, or engine propagation to it
   fails on authentication.
2. **Every list of verticals.** The name goes in, alphabetically:
   - `VERTICALS` in `scripts/propagate-engine.sh`. willow-bot reads its vertical list from
     this script, so it covers the new one with no change of its own.
   - `status-all.sh`, `org-profile-counts.sh`, `link-repos.sh` and `.gitignore`.
   - The README layout.
   - The draft org profile's table and count.
   - The `propagate` matrix in almanac-template's `.github/workflows/propagate-engine.yml`.
3. **The bootstrap PR** in the new repository, following its `SETUP.md`:
   - `almanac.config.yml`, set `reachability.headless: true` if any source is behind bot
     protection.
   - The README from `docs/README.vertical.md`.
   - The issue-form links and `CODEOWNERS`.
   - Remove the 17 template-only files no other vertical carries. Left in, the template's
     own `propagate-engine.yml` tries to fan out from the new repository on every push.
   - The first real entry in place of `example-dataset.yaml`. Validation fails on an empty
     catalog.
4. **Jeles.** Add the name to `ALMANAC_VERTICALS` in `jeles/sources.py`, then let
   release-please publish, so search reaches it.
5. **Seed entries.** One PR per entry, international-first, each licence quoted from the
   publisher's own terms page. Then run the link-check workflow once by hand.

## Gaps

From a review of all sixteen verticals on 2026-10-31: 234 entries, 168 of them from national
agencies, 34 multilateral, 19 regional-bloc and 13 international NGOs.

### Across the catalog

1. **It is overwhelmingly American.**
   - 134 of the 168 national-agency entries are US. Outside the US (134) and the UK (11),
     only 11 countries appear: Mexico 5, Canada 4, Australia 3, Brazil, Japan and South
     Africa 2 each, and Argentina, Costa Rica, Peru, Uruguay and Colombia 1 each.
   - Seven verticals have no national publisher outside the US at all: agriculture, civic,
     economy, energy, environment, health and science.
   - Countries with no entries: China, India, Indonesia, Nigeria, Egypt, the Gulf states,
     South Korea, and every continental-European national statistics office, such as
     Destatis, INSEE and Istat. Those are reached only through Eurostat.
   - Next step: one national publisher from outside the US in each of the seven US-only
     verticals.
2. **The "data at risk" machinery is mostly idle.**
   - Only 3 entries record archived copies in `recovery[]`.
   - None of the 234 has a `fingerprint` baseline, so the template's revision-drift
     checker cannot notice a page that changes while its URL still answers.
   - The entries whose own pages state delays have neither: the DHS monthly tables and the
     2023 and 2024 Yearbooks, ICE's newest spreadsheet (July 2026), and NOAA's billion-dollar
     disasters database (climate's thesis entry).
   - **Done on 2026-10-31 for 22 entries:** the 6 US migration entries, the 11 Epstein
     releases, climate's billion-dollar disasters, Climate at a Glance and Sea Ice Index, and
     environment's GHGRP.
     - Each got a `recovery[]` Wayback capture with a date (`timestamped`), apart from DOJ's
       Epstein Library, which has no capture.
     - Each got a `lead_hash` baseline where the drift checker's plain fetch succeeds, plus a
       `sha256` for actual files.
     - Sites that refuse a plain request (DHS, CBP, ICE, USCIS, the FBI Vault, CourtListener)
       got no fingerprint, on purpose.
     - The billion-dollar disasters entry also records a capture from 2025-01-01, before
       NOAA's retirement announcement.
   - **EPA EJScreen** (environment #44) is the first catalogued takedown. It is `dark` since
     2025-02-05, with Wayback captures from just before removal, EPA's own 2021 snapshot,
     and two community reconstructions.
   - **Still to do:**
     - **New captures: built.** `scripts/capture_archives.py` and its weekly workflow (template
       #60, in every vertical since 2026-11-01) run on GitHub's runners.
       - Each run asks Save Page Now to capture up to 10 live or frozen entries whose newest
         capture is missing or older than 90 days, oldest first.
       - Each capture is recorded as a dated `recovery[]` candidate, `hash-verified` when a
         file's capture matches its `sha256`.
       - Captures land in one rolling `monitor/archive-refresh` PR, the same way the
         link checker's observed-refresh PR works.
       - First run (justice #55): one fresh capture; one existing capture used because Save
         Page Now timed out; one with no capture at all (the DOJ Epstein Library, which Save
         Page Now timed out on).
       - Save Page Now's 180-second timeout may need raising.
       - Like the observed-refresh PR, an Actions-opened PR gets no CI, so it needs a
         validation run before merging.
     - **Promoting the drift checker.** `lead_hash` baselines are inert until the template's
       revision-drift checker reaches the verticals (template idea 16).
     - **The rest of the US federal entries.**
3. **Licences.** About 48 entries are unverified, restricted or non-commercial, 13 of them in
   tech and 6 in migration. That is honest, but a share worth re-checking on a schedule:
   publishers do relicense, as Copernicus did in July 2025.
4. **Issue hygiene.** On 2026-10-31, twelve open issues asked for work already done and were
   closed with pointers: economy #1 to #5, civic #1 and #2, and climate #10, #16, #21, #23 and
   #34.
   - Climate still carries most of the backlog. It has nine catalog requests (#7 to #15,
     minus #10) and its pre-engine tooling and epic issues, such as ruff in CI (#22) and a
     PR template (#24).
5. **Reachability.** Three entries currently read unreachable:
   - climate's billion-dollar disasters: expected, it is frozen.
   - justice's FBI Crime Data Explorer: timeouts.
   - population's Human Mortality Database: it answered on recheck, so this looks like a
     transient timeout.

### Inside the verticals

- **health** (11: 9 CDC, 2 WHO): ClinicalTrials.gov; FDA (adverse events, approvals);
  SAMHSA's National Survey on Drug Use and Health; ECDC; Eurostat and OECD health statistics;
  any national agency outside the US.
- **transportation** (9, the smallest): open requests for the National Transit Database
  (#43), the Freight Analysis Framework (#44) and ITF/UNECE (#45). Nothing on maritime or
  ports, on aviation outside the US, or on EV charging (the DOE's Alternative Fuels Data
  Center).
- **science** (10): the scholarly infrastructure jeles already queries (OpenAlex, Crossref,
  ORCID), Zenodo, ESA (Gaia), and the IPCC Data Distribution Centre.
- **climate** (18): the nine open catalog requests. No national weather services beyond the
  Met Office (DWD, JMA, BoM). No emissions inventories (UNFCCC GHG data, EDGAR, Climate
  TRACE).
- **environment** (12, 10 of them EPA): open requests for OpenAQ, Clean Air Markets,
  EJScreen and SDWIS (#2 to #5). Nothing on biodiversity or forests (Global Forest Watch),
  and no publishers outside the US.
- **economy** (12): open requests for FRED (#37) and IMF (#38). No central banks (ECB data
  portal, Bank of England), no inequality data (World Inequality Database), no OECD
  statistics.
- **energy** (11): open requests for IRENA (#45), IEA (#46) and NREL (#47). Nothing on
  nuclear (the IAEA's reactor database, PRIS).
- **civic** (13): open requests for data.gov (#4) and Regulations.gov (#3). No lobbying data
  (US lobbying disclosures, the EU Transparency Register). No elections outside the US
  beyond the 2024 European Parliament.
- **justice** (17): nothing outside the US except UK police data. No state-court statistics,
  and no police use-of-force data. The Palm Beach County grand jury records are still to add.
- **agriculture** (10): nothing on food security (FEWS NET), fisheries (FAO FishStat) or food
  assistance (SNAP).
- **population, labor, housing, tech, migration:** see each one's "still to add" under
  **Built**.

## Candidate verticals

### Other candidates

Not yet ranked.

- **Disasters and hazards.** FEMA disaster declarations and assistance data, ReliefWeb,
  GDACS, USGS hazard programs, and EM-DAT (whose licence is restrictive). Today this is
  scattered: climate's thesis entry is a disaster dataset. FEMA's data is the at-risk kind.
- **Public records and declassified collections.** The Epstein releases proved the
  `document` type works. A vertical could hold the National Archives' JFK, RFK and MLK
  records, FOIA reading rooms, unsealed court records and congressional releases. It
  could start inside justice and civic.
- **Public spending and procurement.** EU public tenders (TED), Open Contracting data,
  national budgets. USAspending sits in civic today and could move with it.
- **Space.** The UN register of objects launched into outer space, satellite catalogues, ESA
  open data. Some of this is in science and tech today.
- **Indigenous data.** Worth naming, but only under the CARE principles for Indigenous data
  governance and with a steward from those communities. Never seed it with an agent.
- **Geography.** Base layers: Census TIGER/Line, the USGS National Map and GNIS, Eurostat
  GISCO, Natural Earth. These are infrastructure rather than findings, but every vertical's
  `coverage.spatial` points at them.
- **Biodiversity.** GBIF, the US Fish and Wildlife species database (ECOS), OBIS. It overlaps
  environment; it may be better as a tag there than as a vertical.
- **Oceans.** Argo, NOAA tides and currents, Copernicus Marine. Overlaps climate and
  environment.
- **Culture and heritage.** Library of Congress collections, Smithsonian Open Access,
  Europeana, national archives' open data.
- **Finance.** Markets and financial stability. Today this is economy's; split it out only if
  economy grows past what one steward can keep current.

## Other kinds of entry

The schema's `type` already allows `dataset`, `paper`, `textbook` and `document`, so one schema
holds them all and verticals become tags. The other types are where "other types of data"
can start without engine work.

- **`document`.** In use since 2026-10-31: eleven official Epstein record releases, nine in
  justice and two in civic, grouped by `collection: epstein-records`. Next candidates:
  - Other public records releases: declassified collections such as the JFK, RFK and MLK
    records at the National Archives, FOIA reading rooms, unsealed court records, and
    congressional document releases. If they grow, they could become their own vertical.
  - Methodology and series documentation, so a discontinuation can be shown next to the
    series it ended:
    - a census's technical documentation
    - NOAA's notice retiring the billion-dollar disasters database (climate's thesis entry)
    - a statistics agency's revision policy
- **`paper`.** The canonical paper behind a dataset, the one its publisher asks users to cite.
  For example, Christiansen et al. 2025 for the NASA Exoplanet Archive, or Brown & Robinson
  2011 for the snow cover record. One option is a cross-reference from the dataset entry
  rather than an entry of its own.
- **`textbook`.** Open textbooks, such as OpenStax, LibreTexts and the Open Textbook Library.
  They fit education most naturally.
- **Beyond the schema.** These would need new `type` values, so they are engine changes made
  in `almanac-template` and propagated, never added in one vertical:
  - **APIs as first-class entries.** Today an API is a property of a dataset
    (`access.method: api`).
  - **Code lists and classifications.** NAICS, ISCO, ICD, ISO 3166. These are the shared
    vocabularies that make datasets joinable.
  - **Registries.** Lists of entities rather than measurements, such as company registers or
    school directories.
  - **`software`: individual code libraries.** Raised 2026-10-31. Data *about* the software
    ecosystem (package registries, dependency graphs, Software Heritage, OSV) went into tech
    as datasets. Entries for individual libraries, such as NumPy or React, need decisions
    first:
    - **A new `type`.** That is an engine change, made in the template and propagated.
    - **The publisher.** A library's publisher is its maintainers, and its canonical home is a
      repository or registry page. That loosens "publisher of record" a lot.
    - **A cutoff.** There are millions of candidates and no natural cutoff.
    - **A middle ground:** research software that a body already curates, such as the
      Astrophysics Source Code Library, the Research Software Directory and Zenodo's
      software records. It could live in science.

## Open questions

- **CPI in economy.** CPI is cataloged in labor. Should economy's notes cross-reference it?
- **Cross-vertical entries.** When one dataset clearly serves two verticals (CPI, ACS), the
  rule today is one home. Is a cross-reference field worth an engine change, or are notes
  enough?
