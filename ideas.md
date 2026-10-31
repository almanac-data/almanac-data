# Ideas

A working list of where the Almanac could grow: new verticals, and kinds of
entry beyond datasets. Nothing here is a commitment. An idea moves to
**Decided** when its scope is settled (that section appears only while something is in
it), and leaves this file once its repository exists and has entries, noted under **Built**.

*Started 2026-10-31, when the eleven verticals reached 132 entries.*

## Decided

### `migration-almanac`

Decided 2026-10-31. Migration flows, asylum and refugees, internal displacement, remittances,
and enforcement and border data. Next step: the repository, then **Adding a vertical**.

- **Why.** This is the clearest fit with the Almanac's reason for existing. US immigration
  statistics are politically exposed, and their loss would be noticed only if someone had
  written down where they were.
- **Boundary with population.** Stocks and demographic change stay in population, which
  holds the UN DESA International Migrant Stock. Flows, asylum, refugees, displacement and
  enforcement come here.
- **Seed candidates.**
  - International: UNHCR, IOM (Migration Data Portal and the Displacement Tracking Matrix),
    IDMC, the OECD International Migration Database, Eurostat asylum statistics, World Bank
    remittances data, Frontex, the UK Home Office, IRCC.
  - US: DHS OHSS (the Yearbook and monthly tables), CBP encounters, ICE detention
    statistics, USCIS, EOIR, State Department refugee admissions.

## Built

Ideas that left this file because their repository exists and has entries.

- **2026-10-31: `tech-almanac` (20 entries).**
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

## Candidate verticals

### Other candidates

Not yet ranked.

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
holds them all and verticals become tags. Every one of the 132 entries is a `dataset`. The
other types are where "other types of data" can start without engine work.

- **`document`.** Methodology and series documentation, so a discontinuation can be shown
  next to the series it ended:
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

## Open questions

- **The old requests.** ACS (economy #4, civic #1) and BLS CPI, CES and LAUS (economy #1 to
  #3) are now cataloged in population-almanac and labor-almanac, but the issues are still
  open. Close them with a pointer to the new entries?
- **CPI in economy.** CPI is cataloged in labor. Should economy's notes cross-reference it?
- **Cross-vertical entries.** When one dataset clearly serves two verticals (CPI, ACS), the
  rule today is one home. Is a cross-reference field worth an engine change, or are notes
  enough?
