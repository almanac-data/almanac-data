#!/usr/bin/env python3
"""List the licence and terms pages the verticals' catalog entries cite.

    python scripts/licence_urls.py [--from DIR]      # JSON on stdout

Reads each vertical's catalog.json (the list is VERTICALS in
scripts/propagate-engine.sh): from raw.githubusercontent.com, or from
DIR/<vertical>/catalog.json with --from. Takes every URL in a sentence of an
entry's notes that is about licensing (licence, license, terms, copyright,
legal, permitted use), and prints them once each with the entries citing them:

    [{"url": "https://...", "entries": ["climate/copernicus-era5-reanalysis"]}, ...]

The licence-watch workflow feeds these to willow's policy-watch.
"""
from __future__ import annotations

import json
import re
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RAW = "https://raw.githubusercontent.com/almanac-data/{v}/main/catalog.json"
URL = re.compile(r"https?://[^\s\"'<>)\],;]+")
ABOUT = re.compile(r"licen[cs]|terms|copyright|legal|permitted use|reuse|re-use", re.I)
SENTENCE = re.compile(r"(?<=[.!?])\s+(?=[A-Z(\"])")


def verticals() -> list[str]:
    text = (ROOT / "scripts" / "propagate-engine.sh").read_text()
    block = re.search(r"^VERTICALS=\((.*?)^\)", text, re.M | re.S)
    return block.group(1).split() if block else []


def catalog(v: str, src: Path | None) -> dict:
    if src:
        return json.loads((src / v / "catalog.json").read_text())
    req = urllib.request.Request(RAW.format(v=v), headers={"User-Agent": "almanac-licence-watch"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.loads(r.read())


def licence_urls(entries: list[dict], vertical: str) -> dict[str, set[str]]:
    found: dict[str, set[str]] = {}
    for e in entries:
        for sentence in SENTENCE.split(" ".join(str(e.get("notes") or "").split())):
            if not ABOUT.search(sentence):
                continue
            for u in URL.findall(sentence):
                found.setdefault(u.rstrip(".:"), set()).add(f"{vertical}/{e.get('id')}")
    return found


def main(argv: list[str]) -> int:
    src = Path(argv[argv.index("--from") + 1]) if "--from" in argv else None
    merged: dict[str, set[str]] = {}
    for v in verticals():
        try:
            entries = catalog(v, src).get("entries", [])
        except Exception as exc:  # noqa: BLE001 — one unreadable catalog never stops the rest
            print(f"skipped {v}: {exc}", file=sys.stderr)
            continue
        for u, ids in licence_urls(entries, v.removesuffix("-almanac")).items():
            merged.setdefault(u, set()).update(ids)
    print(json.dumps([{"url": u, "entries": sorted(ids)} for u, ids in sorted(merged.items())], indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
