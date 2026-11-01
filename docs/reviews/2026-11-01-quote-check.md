# Quote check, 2026-11-01

Every quotation in the catalog entries' `notes` was checked against a fresh copy of the page it was quoted from, using willow's `quotes` add-on (its `quote-check` and `misquote` underneath). Page copies were scratch material and are not kept anywhere.

## Method

- **Quotes:** straight double quotes of four words or more, paired strictly (a quote opens after a space or bracket and closes before a space or punctuation). An ellipsis splits a quote into parts, each checked on its own.
- **Pages:** each quote is credited to the nearest URL before it in its paragraph, otherwise the entry's canonical URL. If it isn't found there, every other page the entry's notes cite is searched.
- **Copies:** each page was fetched with a browser User-Agent. Anything blocked, thin or JavaScript-only was rendered in headless Chromium, and every page with a miss was rendered again, so both copies were searched.
- **Verdicts:**
  - **as written:** the same words, in the same order.
  - **almost:** at least half the words in order, with the differences listed.
  - **not there:** no passage holds even half of it.

## Results

726 quotes across 167 entries.

| verdict | quotes |
|---|---|
| as written | 421 |
| almost | 99 |
| not there | 200 |
| bot-wall | 2 |
| unfetched | 4 |

**Not there**, by what the copy held:

- **132 thin page:** the copy has under 400 words, a single-page app whose content didn't render. These are **unverifiable**, not wrong.
- **42 words mostly absent:** most of the quote's longer words aren't on the page at all. Many aren't page quotes: notes quote the Almanac's own earlier licence strings, or a search snippet. The rest may be text that has since left the page.
- **26 words present, not in order:** the closest thing to a misquote that "almost" didn't catch.

**Almost** is mostly page structure, not misquotes. Labelled fields ("Date Filed:") and table cells split a phrase, navigation text runs into it, and spacing varies ("non proprietary"). Read the differences before changing anything.

### By vertical

| vertical | as written | almost | not there | other |
|---|---|---|---|---|
| agriculture | 3 | 1 | 1 | 0 |
| civic | 23 | 2 | 1 | 0 |
| climate | 5 | 1 | 2 | 0 |
| economy | 1 | 0 | 11 | 0 |
| education | 20 | 10 | 5 | 2 |
| energy | 6 | 0 | 0 | 0 |
| environment | 3 | 1 | 4 | 4 |
| health | 1 | 1 | 0 | 0 |
| housing | 37 | 10 | 21 | 0 |
| justice | 35 | 18 | 26 | 0 |
| labor | 55 | 7 | 23 | 0 |
| migration | 60 | 12 | 21 | 0 |
| population | 55 | 10 | 14 | 0 |
| science | 9 | 2 | 1 | 0 |
| tech | 100 | 24 | 68 | 0 |
| transportation | 8 | 0 | 2 | 0 |

## A false positive worth knowing

`housing/cfpb-hmda-data` looked like a paraphrase in quotation marks: the closest passage was on
CFPB's HMDA page, which reads differently. But the notes credit the quote to FFIEC's
data-publication site. Fully rendered, that page reads "The HMDA data and reports are the most
comprehensive publicly available information on mortgage market activity", exactly as quoted. The
check's copy of the page had been taken before its content loaded.

So **no entry was changed** on the strength of this check. Every flag below needs a person, with a
browser, to read the live page before an entry is edited.

## For a steward to look at

Quotes where the page held the same words in a different order, or most of the words but not all. Sorted by vertical and entry. `kept/words` counts the quote's words found in order.

| entry | kept/words | quote | differences |
|---|---|---|---|
| agriculture/`amis-market-database` | 12/18 | "This work is made available under the Creative Commons Attribution-4.0 International license (CC BY 4.0)" | added: This work is made available; changed: license → licence |
| agriculture/`amis-market-database` | 0/7 | "Agricultural Market Information Systems (AMIS) – Market database" |  |
| civic/`european-parliament-election-results-2024` | 19/25 | "is authorised, for personal use or for further non-commercial or commercial dissemination, provided that the entire item is reproduced and …" | added: reproduced and the source is acknowledged |
| civic/`european-parliament-election-results-2024` | 0/14 | "the reuse of certain data may be subject to different conditions in some instances" |  |
| civic/`house-oversight-epstein-estate-records` | 2/4 | "approximately 65,000 pages" | added: approximately 65 |
| climate/`nsidc-north-american-snow-cover` | 15/16 | "the CDR data sets are nonproprietary, publicly available, and no restrictions are placed upon their use" | changed: nonproprietary → non proprietary |
| economy/`bis-data-portal` | 0/24 | "Users may use the statistics published in the BIS Data Portal in accordance with the terms set out under the heading 'About BIS statistics'" |  |
| education/`argentina-informacion-evaluacion-educativa` | 8/10 | "Datos abiertos: Bases de datos de Aprender y Relevamiento Anual" | added: Datos abiertos |
| education/`argentina-informacion-evaluacion-educativa` | 5/8 | "Reportes por escuela: Plataforma de microdatos por escuela" | added: Reportes por escuela |
| education/`argentina-informacion-evaluacion-educativa` | 8/15 | "Los contenidos de Argentina.gob.ar están licenciados bajo Creative Commons Atribución 4.0 Internacional" | added: Los; added: de Argentina gob ar están licenciados; dropped: la licencia |
| education/`brazil-inep-microdados` | 6/8 | "Microdados públicos do Censo Escolar da Educação Básica" | added: Microdados públicos |
| education/`mexico-inegi-caracteristicas-educativas` | 3/4 | "Términos de Libre Uso" | added: Libre |
| education/`unesco-uis` | 16/17 | "The work of the UIS is licensed under the Creative Commons Attribution-ShareAlike 4.0 International license" | changed: work → data; dropped: UNESCO Institute for Statistics; dropped: The data is available in different formats and… |
| education/`unesco-uis` | 6/11 | "Source: … UNESCO Institute for Statistics (UIS), complete URL, date of extraction" | changed: complete URL date → encourages the use; added: extraction |
| education/`uruguay-ineed-aristas` | 3/5 | "Bases de datos de Aristas" | added: Bases; changed: datos → trabajo Organigrama Convenios Preguntas frecuentes Nuestro Trabajo Informe sobre el esta… |
| education/`uruguay-ineed-aristas` | 3/5 | "Bases de datos de Aristas" | added: Bases; changed: datos → trabajo Organigrama Convenios Preguntas frecuentes Nuestro Trabajo Informe sobre el esta… |
| education/`wales-schools-census-results` | 3/5 | "Last updated: 5 August 2026" | added: Last updated |
| environment/`epa-superfund-sites` | 23/26 | "sites proposed to, currently on, and deleted from Superfund's National Priorities List (NPL) as well as sites being addressed under the Sup…" | added: Alternative Approach SAA |
| health/`who-gho` | 2/4 | "for public health purposes" | added: public; added: purposes |
| housing/`census-building-permits-survey` | 5/10 | "Annual data for 2025 was released on May 14, 2026" | changed: data → estimates; changed: 2025 was → 2022 were; added: 14 2026 |
| housing/`cfpb-hmda-data` | 10/10 | "the most comprehensive publicly available information on mortgage market activity" | dropped: source of; dropped: the U S; dropped: Learn more about mortgage |
| housing/`hud-annual-homelessness-assessment-report` | 19/30 | "based on Homeless Management Information Systems (HMIS) data ..., point-in-time counts of people experiencing homelessness on one day in Ja…" | added: in January and data about the inventory of shelter and housing |
| housing/`hud-fair-market-rents` | 0/18 | "are estimates of 40th percentile gross rents for standard quality units within a metropolitan area or nonmetropolitan county" |  |
| housing/`hud-fair-market-rents` | 0/11 | "at the start of the federal fiscal year (generally October 1)" |  |
| housing/`japan-housing-and-land-survey` | 15/17 | "is possible to use ... under the use condition based upon the "Public Data License (Version 1.0)" | dropped: being sent It s called contents in the following is reported by the Statistics Bureau home page It s called th… |
| housing/`mexico-inegi-vivienda` | 4/12 | "no considera a las viviendas colectivas ... y a la población sin vivienda" | changed: a → Sociedad Educación Características educativas de; changed: sin → Empleo y Ocupación Empleo y Ocupación Hog… |
| housing/`mexico-inegi-vivienda` | 5/8 | "Del libre uso de la información del INEGI" | changed: libre uso → sitio INEGI Temas Programas; added: la; dropped: Sistemas de Consulta Desarrollo social Infraestru… |
| housing/`mexico-inegi-vivienda` | 2/4 | "explotar comercialmente la información" | added: explotar comercialmente |
| housing/`statcan-housing-statistics` | 4/6 | "Homeownership rate - Canada (2021) 66.5%" | added: 66 5 |
| housing/`statcan-housing-statistics` | 0/9 | "Shelter - Canada (September 2026) 1.8% (12-month change)" |  |
| housing/`statcan-housing-statistics` | 9/17 | "a worldwide, royalty-free, non-exclusive licence to: use, reproduce, publish, freely distribute, or sell the Information" | added: a worldwide royalty free non exclusive licence to |
| housing/`un-habitat-urban-indicators-database` | 2/4 | "Global Monitoring of Slums" | added: Global Monitoring; dropped: COVID 19 and this is exacerbated b y their poor access to essential facilities and s… |
| justice/`doj-epstein-files-phase-1-2025` | 0/4 | "C. Contact Book_Redacted" |  |
| justice/`doj-epstein-files-phase-1-2025` | 0/14 | "Unless otherwise indicated, information on Department of Justice websites is in the public domain" |  |
| justice/`doj-epstein-files-transparency-act-disclosures` | 0/5 | "Freedom of Information Act (FOIA)" |  |
| justice/`doj-epstein-files-transparency-act-disclosures` | 4/4 | "Data Set 1 Files" | dropped: View |
| justice/`doj-epstein-files-transparency-act-disclosures` | 4/4 | "Data Set 12 Files" | dropped: View |
| justice/`doj-epstein-files-transparency-act-disclosures` | 4/5 | "nearly 3.5 million pages" | added: nearly; dropped: Responsive |
| justice/`doj-epstein-files-transparency-act-disclosures` | 0/11 | "an additional review protocol to ensure compliance with a Court order" |  |
| justice/`doj-epstein-files-transparency-act-disclosures` | 0/14 | "Unless otherwise indicated, information on Department of Justice websites is in the public domain" |  |
| justice/`doj-epstein-library` | 0/9 | "more than 2,000 videos and 180,000 images" |  |
| justice/`doj-epstein-library` | 0/14 | "Unless otherwise indicated, information on Department of Justice websites is in the public domain" |  |
| justice/`doj-epstein-library` | 0/28 | "If a source other than the Department of Justice or other federal government agency is indicated ... permission to copy these materials mus…" |  |
| justice/`doj-oig-bop-epstein-custody-report-23-085` | 3/5 | "Posted Date June 27, 2023" | added: Posted Date |
| justice/`doj-oig-bop-epstein-custody-report-23-085` | 2/4 | "Report Number 23-085" | added: 23 085 |
| justice/`doj-oig-bop-epstein-custody-report-23-085` | 4/5 | "Component Federal Bureau of Prisons" | added: Component |
| justice/`doj-opr-epstein-npa-report-executive-summary` | 2/4 | "Thu, 12 Nov 2020" | added: Thu; added: Nov |
| justice/`doj-opr-epstein-npa-report-executive-summary` | 0/14 | "Unless otherwise indicated, information on Department of Justice websites is in the public domain" |  |
| justice/`fbi-vault-epstein-investigative-holdings-review` | 0/4 | "PDF document, 1423 kB" |  |
| justice/`fbi-vault-jeffrey-epstein` | 2/4 | "Filed under: Frequently Requested" | added: Frequently Requested |
| justice/`sdny-giuffre-v-maxwell-15-cv-07433` | 3/5 | "Date Filed: Sept. 21, 2015" | added: Date Filed |
| justice/`sdny-giuffre-v-maxwell-15-cv-07433` | 3/5 | "Date Terminated: May 25, 2017" | added: Date Terminated |
| justice/`sdny-giuffre-v-maxwell-15-cv-07433` | 5/8 | "Date of Last Known Filing: Sept. 3, 2026" | added: Sept 3 2026 |
| justice/`sdny-giuffre-v-maxwell-15-cv-07433` | 4/10 | "December 18, 2023 ... following a particularized review of the documents" | added: following; changed: particularized review → service; dropped: Unites States Judiciary called PACER PACER is an a… |
| justice/`sdny-giuffre-v-maxwell-15-cv-07433` | 10/13 | "[redacted] v. Maxwell, No. 1:15-cv-07433 (S.D.N.Y. 2015)" | added: redacted; added: No; added: 2015 |
| justice/`sdny-united-states-v-maxwell-20-cr-330` | 3/5 | "Date Filed: June 29, 2020" | added: Date Filed |
| justice/`sdny-united-states-v-maxwell-20-cr-330` | 3/5 | "Date Terminated: June 29, 2022" | added: Date Terminated |
| justice/`sdny-united-states-v-maxwell-20-cr-330` | 5/8 | "Date of Last Known Filing: Oct. 22, 2026" | added: Oct 22 2026 |
| justice/`sdny-united-states-v-maxwell-20-cr-330` | 12/14 | "United States v. Maxwell, No. 1:20-cr-00330 (S.D.N.Y. 2020)" | added: No; added: 2020 |
| justice/`unodc-data-portal` | 22/24 | "for the User's personal, non-commercial use, without any right to resell or redistribute them or to compile or create derivative works ther…" | added: works therefrom |
| justice/`unodc-data-portal` | 0/16 | "may be copied freely, duplicated, and further distributed provided that UNODC is cited as the reference" |  |
| labor/`bls-ces` | 2/8 | "REQUEST_NOT_PROCESSED ... daily threshold ... has been reached" | added: reached |
| labor/`bls-jolts` | 2/8 | "REQUEST_NOT_PROCESSED ... daily threshold ... has been reached" | added: reached |
| labor/`dol-open-data-portal` | 22/47 | "Materials created by the federal government are generally part of the public domain and may be used, reproduced and distributed without per…" |  |
| labor/`mexico-inegi-enoe` | 6/12 | "Indicadores de Ocupación y Empleo — Publicación reciente: 22 de octubre de 2026" | added: Indicadores; changed: Publicación reciente 22 → ENOE población; changed: octubre → 15 años y más |
| labor/`oecd-employment-labour-market` | 4/5 | "Adequacy of minimum income benefits" | added: Adequacy; dropped: measure Household type Earnings of the spouse Claim social assistance or |
| labor/`osha-injury-tracking-application-data` | 10/15 | "Injury Tracking Application (ITA) Data: Establishment and Case Detail Work-related Injury and Illness Data" | added: Injury Tracking Application ITA Data |
| labor/`statcan-labour-force-survey` | 9/17 | "a worldwide, royalty-free, non-exclusive licence to: use, reproduce, publish, freely distribute, or sell the Information" | added: a worldwide royalty free non exclusive licence to |
| migration/`cbp-nationwide-encounters` | 2/4 | "by Area of Responsibility" | added: by Area; dropped: Professional |
| migration/`cbp-nationwide-encounters` | 5/10 | "Nationwide Encounters Dataset FY23-FY26 by Area of Responsibility - August" | added: Nationwide; changed: by Area of Responsibility → FYTD |
| migration/`cbp-nationwide-encounters` | 16/27 | "Data is extracted from live CBP systems and data sources. Statistical information is subject to change ... Final statistics are available a…" |  |
| migration/`dhs-ohss-yearbook-immigration-statistics` | 3/5 | "Last updated: August 11, 2026" | added: 11 2026 |
| migration/`doj-eoir-adjudication-statistics` | 0/35 | "Unless otherwise indicated, information on Department of Justice websites is in the public domain and may be copied and distributed without…" |  |
| migration/`ice-detention-statistics` | 6/11 | "as of December 31, 2024. The dashboards will be updated quarterly" | added: as of December 31 2024 |
| migration/`ice-detention-statistics` | 0/33 | "Information presented on the ICE Website is considered public information and may be distributed or copied. However, ICE does request that …" |  |
| migration/`idmc-global-internal-displacement-database` | 4/5 | "Global Internal Displacement Database (GIDD)" | added: GIDD |
| migration/`idmc-global-internal-displacement-database` | 52/53 | "Unless specified otherwise in particular terms of use, anyone may reproduce, distribute, adapt, translate and publicly perform the content …" | added: license |
| migration/`ircc-monthly-updates-open-data` | 8/9 | "Record Modified: Oct 22, 2026 ... Formats: HTML XLSX CSV" | added: Formats |
| migration/`oecd-international-migration-database` | 3/6 | "OECD Data Explorer • International migration database" | added: International migration database |
| migration/`unhcr-refugee-population-statistics` | 28/28 | "Except where otherwise provided, the datasets made available by UNHCR on the UNHCR Refugee Population Statistics Database are licensed unde…" | dropped: the Datasets |
| migration/`uscis-immigration-and-citizenship-data` | 6/10 | "Fiscal Year 2026: Quarter 3 Data Reports, April–June 2026" | changed: Data Reports April June → XLSX 21 99 KB September 08 |
| migration/`world-bank-remittance-prices-worldwide` | 2/4 | "Data Access and Licensing" | changed: Access → Catalog Home Data Collections Contact Us API FAQs Metadata last updated on Sep 28 2026 Compare Versio… |
| population/`hmd-human-mortality-database` | 4/18 | "will need to register again ... and accept the new user agreement before being able to download HMD data" | dropped: go through the registration process again see How do I; added: again |
| population/`ipums-international` | 40/60 | "Redistribution: You will not redistribute the data ... Under IPUMS International agreements with collaborating agencies, redistribution of …" | added: Usage You agree to use IPUMS International data for scholarly research and educational purposes only Commercial … |
| population/`statssa-census-2022` | 5/8 | "Welcome to the official Stats SA Census Portal" | added: Welcome; dropped: services that intensify; dropped: demand for credible independent and granular |
| population/`statssa-census-2022` | 5/8 | "Census 2022 was the first digital population count" | added: 2022; added: population count |
| population/`statssa-census-2022` | 6/6 | "Number of households: 17 828 778" | dropped: over the period 1996 2022 The increase depicts an increase in household formation Census 2022 recorded a total… |
| population/`statssa-census-2022` | 60/74 | "Users may apply or process this data, provided Statistics South Africa (Stats SA) is acknowledged as the original source of the data; that …" | added: or offered for sale in any form whatsoever without prior permission from Stats SA |
| population/`un-desa-international-migrant-stock` | 27/29 | "presents the latest United Nations estimates of the numbers and characteristics of international migrants around the world. Covering the pe…" | added: 2024; changed: 233 → countries with new empirical information from population censuses or registers and relative… |
| population/`un-desa-international-migrant-stock` | 10/11 | "United Nations Department of Economic and Social Affairs, Population Division (2024)." | dropped: in the; dropped: publishes datasets on the world s; changed: Division → and analyzes global demographic trends… |
| population/`un-desa-world-population-prospects` | 2/4 | "to the year 2100" | added: year 2100 |
| population/`unsd-demographic-yearbook` | 29/31 | "All data and metadata provided on UNdata's website are available free of charge and may be copied freely, duplicated and further distribute…" | changed: UNdata → UN data; changed: UNdata → UN data |
| science/`nasa-exoplanet-archive` | 2/4 | "6,451 Confirmed Planets" | added: 6 451 |
| science/`usgs-earthquake-catalog` | 5/9 | "an implementation of the FDSN Event Web Service Specification" | added: an implementation of the |
| tech/`caida-internet-datasets` | 4/6 | "for a period of one year" | dropped: reasonable; added: one year |
| tech/`cisa-kev` | 0/11 | "The KEV catalog is also available in these formats: CSV JSON" |  |
| tech/`cisa-kev` | 3/6 | "2026-10-30T17:02:45.3665Z" | changed: 30T17 → 30 Due Date 2026 11; added: 45 3665Z |
| tech/`common-crawl` | 0/43 | "is hosted by Amazon Web Services' Open Data Sets Sponsorships program on the bucket s3://commoncrawl/, located in the US-East-1 (Northern V…" |  |
| tech/`common-crawl` | 4/8 | "The latest crawl is: CC-MAIN-2026-43" | added: The latest crawl is |
| tech/`epo-bulk-data-sets` | 0/10 | "The EPO databases are available only on a subscription basis" |  |
| tech/`epo-bulk-data-sets` | 0/18 | "Where online access to and downloading of the EPO databases is free of charge, no payment is due" |  |
| tech/`epo-bulk-data-sets` | 6/11 | "This product contains data sourced from EPO databases, © European Patent Organisation" | added: This product contains; changed: sourced → is extracted; dropped: the |
| tech/`epo-bulk-data-sets` | 3/4 | "the data as such" | dropped: bulk; dropped: sets we offer EP bibliographic data EBD European Patent Register data EP full text data EPO wor… |
| tech/`first-epss` | 11/14 | "a gzip-compressed CSV containing three fields for every scored vulnerability: cve ... epss ... percentile" | added: cve |
| tech/`google-deps-dev` | 26/35 | "The deps.dev BigQuery dataset provides signals that both maintainers and consumers of open-source software (OSS) can use to improve the hea…" | added: The dataset is provided as a BigQuery public dataset |
| tech/`google-deps-dev` | 3/6 | "is hosted on Google Cloud Platform" | changed: hosted → described; dropped: this page as well as via gRPC For more information about accessing the API via gR… |
| tech/`google-deps-dev` | 2/4 | "is not open source" | added: is not |
| tech/`google-deps-dev` | 31/44 | "For details on using the data from these sources, please consult their documentation. As well as aggregating data, deps.dev generates addit…" | added: For details on using the data from these sources please consult their documentation |
| tech/`google-deps-dev` | 15/26 | "Use of the deps.dev API is subject to the Google API Terms of Service. Clients are expressly permitted to cache data served by the API." | added: Clients are expressly permitted to cache data served by the API |
| tech/`itu-datahub` | 2/4 | "terms of this licence" | added: this licence |
| tech/`libraries-io-package-data` | 24/36 | "Data provided by the Service is licensed to you under version 4.0 of the Creative Commons Attribution, Share Alike license (CC BY-SA). This…" | added: This license grants permissive rights for users to use the data commercially |
| tech/`npm-registry-replication-feed` | 5/8 | "npm, Inc. (npm) operates each of those services" | changed: Inc → Services may provide information and software that is inaccurate incomplete misleading illegal offensive… |
| tech/`oecd-broadband-telecom-database` | 4/7 | "OECD Data Explorer • Broadband and telecom databases" | changed: Broadband → Platform; added: telecom databases |
| tech/`openssf-scorecard-results` | 19/19 | "Results are available through the REST API. The BigQuery public dataset is no longer available; see Scorecard Infrastructure Changes" | dropped: REST API scorecard |
| tech/`openssf-scorecard-results` | 0/9 | "Copyright © OpenSSF Scorecard a Series of LF Projects, LLC" |  |
| tech/`psf-pypi-bigquery-datasets` | 9/14 | "is populated through the Linehaul project by streaming download logs from PyPI to BigQuery" | added: logs from PyPI to BigQuery |
| tech/`psf-pypi-bigquery-datasets` | 23/37 | "is meant to be a data dump of metadata from every release on PyPI, which means that the rows in this BigQuery table are immutable and are n…" | added: are immutable and are not removed even if a release or project is deleted |
| tech/`ripe-ncc-ripe-atlas` | 4/28 | "The RIPE NCC will publish the RIPE Atlas Data in various forms and make this available via http://www.ripe.net/ ... as well as the RIPE Atl…" | changed: well as → this is generally considered one of; dropped: largest IXPs on the planet we looked into this event f… |
| tech/`ripe-ncc-ripe-atlas` | 0/10 | "research, network monitoring, network debugging and alerting about network events" |  |
| tech/`software-heritage-graph-dataset` | 5/5 | "2026-06-04-history-hosting" | dropped: and newer starting with this graph the MPH changed from PTHash to FMPHGO swh graph v12 or newer is needed to r… |
| tech/`software-heritage-graph-dataset` | 17/33 | "By accessing the dataset, you agree with the Software Heritage Ethical Charter for using the archive data, the terms of use for bulk access…" | added: By accessing the dataset you agree with the Software Heritage Ethical Charter for using the archive |
| tech/`stanford-hai-ai-index` | 2/4 | "Access the Public Data" | added: Access the |
| tech/`statcan-canadian-internet-use-survey` | 9/17 | "a worldwide, royalty-free, non-exclusive licence to: use, reproduce, publish, freely distribute, or sell the Information" | added: a worldwide royalty free non exclusive licence to |
| tech/`uspto-open-data-portal` | 0/25 | "The legacy PatentsView website (www.patentsview.org) is migrating to the USPTO's Open Data Portal (https://data.uspto.gov) starting on Marc…" |  |
| tech/`uspto-open-data-portal` | 7/10 | "Source: United States Patent and Trademark Office, www.uspto.gov" | added: Source; changed: www uspto → Skip to main content An official website of the United States government Here s how… |

## Unverifiable here

Entries whose quoted page never rendered real content. A browser by hand, or a later run, settles these:

- economy/`bis-data-portal` (4)
- economy/`un-comtrade` (4)
- economy/`world-bank-world-development-indicators` (2)
- education/`college-scorecard` (1)
- education/`crdc-civil-rights-data-collection` (1)
- education/`mexico-inegi-caracteristicas-educativas` (1)
- education/`uk-dfe-explore-education-statistics` (1)
- environment/`eea-datahub` (4)
- housing/`abs-building-approvals` (4)
- housing/`cfpb-hmda-data` (2)
- housing/`mexico-inegi-vivienda` (3)
- housing/`oecd-house-price-indices` (3)
- justice/`doj-oig-bop-epstein-custody-report-23-085` (1)
- justice/`fbi-crime-data-explorer` (2)
- justice/`fbi-vault-jeffrey-epstein` (1)
- justice/`sdny-giuffre-v-maxwell-15-cv-07433` (2)
- labor/`abs-labour-force-australia` (4)
- labor/`brazil-ibge-pnad-continua` (2)
- labor/`dol-open-data-portal` (2)
- labor/`ilo-ilostat` (4)
- labor/`mexico-inegi-enoe` (4)
- labor/`oecd-employment-labour-market` (2)
- migration/`dhs-ohss-yearbook-immigration-statistics` (2)
- migration/`idmc-global-internal-displacement-database` (4)
- migration/`ircc-monthly-updates-open-data` (1)
- migration/`mexico-upmrip-boletines-estadisticos` (2)
- migration/`oecd-international-migration-database` (3)
- migration/`unhcr-refugee-population-statistics` (1)
- migration/`world-bank-remittance-prices-worldwide` (1)
- population/`abs-population` (5)
- population/`inegi-censo-poblacion-vivienda-2020` (4)
- population/`un-desa-world-population-prospects` (4)
- tech/`cloudflare-radar` (1)
- tech/`common-crawl` (3)
- tech/`enisa-euvd` (1)
- tech/`epo-bulk-data-sets` (1)
- tech/`first-epss` (1)
- tech/`google-osv-dev` (7)
- tech/`itu-datahub` (2)
- tech/`libraries-io-package-data` (3)
- tech/`mitre-cve-list` (6)
- tech/`nist-nvd` (6)
- tech/`npm-registry-replication-feed` (2)
- tech/`oecd-ai-policy-navigator` (5)
- tech/`oecd-broadband-telecom-database` (3)
- tech/`psf-pypi-bigquery-datasets` (1)
- tech/`ripe-ncc-ripe-atlas` (1)
- tech/`stanford-hai-ai-index` (4)
- tech/`uspto-open-data-portal` (2)
- transportation/`nhtsa-fars` (2)

## Rerun

Fetch the cited pages into a folder with willow's `snapshot` add-on, point a willow box at it, and run `quotes.py --box BOX --in <entry>.yaml` for each entry.
