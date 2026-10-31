# Ideas

A working list of where the Almanac could grow: new verticals, and kinds of
entry beyond datasets. Nothing here is a commitment. An idea moves to
**Decided** when it has an owner and a next step, and leaves this file once
its repository exists and has entries.

*Started 2026-10-31, when the eleven verticals reached 132 entries.*

## Decided

The next three verticals, in order. Each needs, in sequence:

1. The repository, created in the org from `almanac-template` (an org admin's step).
2. Its name added to `VERTICALS` in `scripts/propagate-engine.sh`, so it receives engine
   changes. willow-bot reads its vertical list from there, so it starts checking the new
   one with no other change.
3. Its name added to `ALMANAC_VERTICALS` in jeles' `jeles/sources.py`, then a jeles release,
   so search reaches it.
4. Seed entries, one PR per entry, international-first, with each licence checked against
   the publisher's own terms page.

### `population-almanac`

Counts and characteristics of people: censuses, population estimates, projections, vital
registration as a population input.

- **Why first.** The American Community Survey was requested twice, in economy-almanac #4 and
  civic-almanac #1, and neither vertical took it. It belongs to neither of them. Population
  is the denominator for most per-capita figures elsewhere in the Almanac.
- **Seed candidates.** US Census Bureau: decennial census, ACS, population estimates. UN
  World Population Prospects. Eurostat demography. National statistics offices: Statistics
  Canada (its Open Licence was checked on 2026-10-31: commercial use is allowed, with a
  required source line and a ban on re-identification), UK ONS, INEGI, IBGE.
- **Boundary with health.** Vital statistics as health outcomes (CDC NVSS, the WHO mortality
  database) stay in health. Births and deaths as components of population change belong here.

### `labor-almanac`

Work, employment, wages, prices as they bear on workers, and labour conditions.

- **Decided:** its own vertical, not part of economy. Economy keeps national accounts, trade,
  finance and business; labour has its own publishers and readers.
- **Why.** BLS CPI, CES and LAUS have been open requests since economy-almanac's first issues
  (#1 to #3). The US currently has no labour statistics in the catalog.
- **Seed candidates.** BLS: CPI, CES, LAUS, JOLTS, CPS. ILOSTAT. OECD employment database.
  Eurostat labour force survey. UK ONS labour market statistics.
- **To settle.** CPI is a price index the economy vertical could equally claim. Proposal:
  CPI lives here, and economy cross-references it in notes rather than duplicating it.
- **To check first.** Whether bls.gov answers the link checker. If it filters non-browser
  clients, the entry may need `reachability.headless` in `almanac.config.yml`.

### `housing-almanac`

Shelter: housing stock, costs, tenure, lending, homelessness.

- **Why.** Several federal housing series are exactly what the Almanac exists to track: data
  under pressure, whose loss would be noticed only if someone had written down where it was.
- **Seed candidates.** HUD: Fair Market Rents, the Annual Homeless Assessment Report and
  Point-in-Time counts. Census: American Housing Survey, Housing Vacancies and Homeownership.
  CFPB: HMDA mortgage data. Eurostat housing statistics. English Housing Survey.

## Candidate verticals

### Technology (`tech-almanac`?)

The idea is the data about technology and the digital world, not data that merely happens to
be digital. The scope needs drawing before any repository exists.

- **Digital access.** The FCC National Broadband Map, ITU ICT indicators, Eurostat digital
  economy and society statistics, Ofcom Connected Nations.
- **Research and invention.** USPTO patent data (PatentsView), the EPO's open patent services,
  WIPO statistics.
  - **Overlap.** Science already holds NSF NCSES, which covers R&D spending; patents are a
    clean addition next to it.
- **Software and the web.** Open measurement of the internet itself: M-Lab, RIPE Atlas, the
  Internet Archive's crawl metadata, Common Crawl.
  - **To check.** Licences vary widely. Who counts as a "publisher" here also needs a
    steward's rule.
- **Security.** The NIST National Vulnerability Database, CISA's Known Exploited
  Vulnerabilities catalog, MITRE CVE.
  - **Note.** These are US Government or federally funded, are cited constantly, and have had
    funding scares, so they fit the at-risk thesis well.
- **Open question.** Should AI evaluation datasets and model cards be in scope? They change
  fast and many are hosted by companies rather than publishers of record, which strains
  catalog-not-host.

### Other candidates

Not yet ranked.

- **Geography.** Base layers: Census TIGER/Line, the USGS National Map and GNIS, Eurostat
  GISCO, Natural Earth. These are infrastructure rather than findings, but every vertical's
  `coverage.spatial` points at them.
- **Migration.** UNHCR refugee statistics, the DHS Yearbook of Immigration Statistics, IOM's
  migration data portal. This is politically exposed data, so it fits the at-risk thesis.
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

- **Numbering of the new verticals' first issues.** Should the old requests (ACS, BLS) be
  moved into the new repositories' issues once they exist, and closed in economy and civic
  with a pointer?
- **Cross-vertical entries.** When one dataset clearly serves two verticals (CPI, ACS), the
  rule today is one home. Is a cross-reference field worth an engine change, or are notes
  enough?
