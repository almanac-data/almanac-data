#!/usr/bin/env python3
"""Watch every licence page the catalogs cite, with willow's policy-watch.

    python scripts/licence_watch.py --willow DIR --copies DIR --report FILE [--limit N]

For each URL from scripts/licence_urls.py, runs willow's
adapters/stdlib/policy-watch/policy_watch.py into COPIES/<hash of the URL>/.
policy-watch keeps a copy each run and compares it with the last one, sentence
by sentence. Writes a Markdown report: the pages whose wording changed (with
policy-watch's own diff and the entries that cite them), the pages it couldn't
fetch, and counts of the rest.

COPIES holds page copies between runs. In CI it lives in the Actions cache and is
never committed: the Almanac catalogs, it doesn't host. Exit 0 always; the
report says what happened, and `changed: N` on its first line drives the issue.
"""
from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MAX_DIFF_LINES = 40


def arg(argv: list[str], name: str, default: str | None = None) -> str | None:
    return argv[argv.index(name) + 1] if name in argv else default


def main(argv: list[str]) -> int:
    willow = Path(arg(argv, "--willow", "willow"))
    copies = Path(arg(argv, "--copies", "licence-copies"))
    report = Path(arg(argv, "--report", "licence-report.md"))
    limit = int(arg(argv, "--limit", "0") or 0)
    watch = willow / "adapters" / "stdlib" / "policy-watch" / "policy_watch.py"
    src = arg(argv, "--from")
    listing = subprocess.run([sys.executable, str(ROOT / "scripts" / "licence_urls.py")]
                             + (["--from", src] if src else []),
                             capture_output=True, text=True, check=True)
    pages = json.loads(listing.stdout)[: limit or None]
    copies.mkdir(parents=True, exist_ok=True)
    changed, failed, tally = [], [], {"first copy": 0, "unchanged": 0, "same words": 0}
    for p in pages:
        folder = copies / hashlib.sha256(p["url"].encode()).hexdigest()[:16]
        got = subprocess.run([sys.executable, str(watch), "--url", p["url"], "--to", str(folder)],
                             capture_output=True, text=True, timeout=300)
        out = got.stdout.strip()
        if "couldn't" in out or got.returncode == 2:
            failed.append((p, (out or got.stderr).splitlines()[-1:]))
        elif "\nchanged" in "\n" + out:
            changed.append((p, out.splitlines()))
        else:
            for key in tally:
                if f"\n{key}" in "\n" + out or out.startswith(key) or f" {key}" in out.splitlines()[-1]:
                    tally[key] += 1
                    break
    lines = [f"changed: {len(changed)}", "",
             f"# Licence watch: {len(changed)} changed, {len(failed)} not fetched, of {len(pages)} pages", "",
             "Every licence and terms page that the Almanac's catalog entries cite, compared with "
             "the copy from the last run by willow's `policy-watch`, sentence by sentence.", ""]
    if changed:
        lines += ["## Changed", "", "Check whether each entry's `license` still holds; the "
                  "diff is policy-watch's.", ""]
        for p, out in changed:
            lines += [f"### {p['url']}", "", "Cited by: " + ", ".join(f"`{e}`" for e in p["entries"]), "",
                      "```", *out[:MAX_DIFF_LINES], *(["…"] if len(out) > MAX_DIFF_LINES else []), "```", ""]
    lines += ["## Counts", "", f"- first copy (nothing to compare yet): {tally['first copy']}",
              f"- unchanged: {tally['unchanged']}",
              f"- same words (bytes differ, every sentence the same): {tally['same words']}",
              f"- not fetched: {len(failed)}", ""]
    if failed:
        lines += ["## Not fetched", "", "Blocked, timed out or erroring; nothing is compared for these:", ""]
        lines += [f"- {p['url']}: {' '.join(why)[:160]}" for p, why in failed] + [""]
    report.write_text("\n".join(lines))
    print(lines[2])
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
