# Security Policy

## What this project is, and what that means for its threat surface

The Almanac catalogs public data; it does not host data, run services, accept uploads, or hold
user accounts. There is no server to compromise and no personal data to leak. That removes most
of what a security policy usually covers, and concentrates the real risk in two places:

1. **The tooling.** `validate.py`, `build_index.py`, `check_links.py`, `alert_on_dead_links.py`,
   and the GitHub Actions workflows run automatically, some on a schedule, some against
   contributor-supplied input. A crafted catalog entry that achieves anything beyond failing
   validation is a genuine vulnerability.
2. **The workflows' privileges.** Anything that lets a pull request from a fork execute with
   elevated permissions, reach repository secrets, or write to `main` is a genuine vulnerability,
   and a more serious one.

A dead link, a stale entry, or a source that has gone dark is **not** a security issue. That is
ordinary catalog maintenance — open a normal issue, or a PR flipping the entry's `status`.

## Reporting a vulnerability

Please report privately rather than in a public issue.

<!-- TODO(caretaker): enable GitHub Private Vulnerability Reporting on each repo
     (Settings → Code security and analysis → Private vulnerability reporting), then replace
     this comment with the standard line:
         Use GitHub's "Report a vulnerability" button on the affected repository's Security tab.
     If you would rather take reports by email, put a real monitored address here instead.
     Do not ship this file without one working private channel. -->

Useful reports include: the repository and file involved, what an attacker gains, and the
smallest input that demonstrates it. A proof-of-concept catalog entry or workflow trigger is
worth more than a description of one.

## What to expect

This is a volunteer-maintained project with no paid on-call rotation, so please read these as
intentions rather than guarantees:

| | |
|---|---|
| First response | within about a week |
| Assessment and plan | within about two weeks of the first response |
| Fix for a confirmed issue in the engine | released in `almanac-template`, then propagated to every vertical |

Engine fixes land upstream in `almanac-template` first and reach the verticals by propagation, so
a single fix may produce twelve pull requests. Expect the vertical repos to lag the template
slightly.

Reporters are credited by name or handle in the fix unless they prefer otherwise. There is no
bounty program.

## Supported versions

There are no releases or version branches. `main` is the only supported state of every
repository; fixes land there and nowhere else.

## Scope

**In scope:** the scripts, schema, tests, and GitHub Actions workflows in any
`almanac-data` repository.

**Out of scope:** the availability, accuracy, or content of the third-party sources the catalog
points at. Those belong to their publishers. If a *publisher's* site has a vulnerability, report
it to that publisher — not here.
