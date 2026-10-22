#!/bin/sh
# SPDX-License-Identifier: GPL-3.0-only
#
# Checks that the game repository's copy of the cps2recomp toolkit (cps2recomp/) is byte-for-byte the
# copy that was recorded in cps2recomp/COMMIT. Run by `make check-toolkit` and by CI.
#
#   tools/sync-toolkit.sh --check    fail if cps2recomp/ is not what COMMIT recorded
#   tools/sync-toolkit.sh --record   rewrite COMMIT's hashes from the copy as it is now (maintainers only)
#
# The copy is made from the upstream toolkit (v0.4.0-beta.4), with its games/ and example/ left out: a
# game repository keeps only the toolkit. Never change cps2recomp/ by hand. Change the toolkit upstream,
# copy it again, then run --record.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/.." && pwd)
dest="$root/cps2recomp"
record="$dest/COMMIT"

if command -v shasum > /dev/null; then sum="shasum -a 256"; else sum="sha256sum"; fi
hashes() {
    (cd "$dest" && find . -type f ! -path ./COMMIT | sed 's|^\./||' | LC_ALL=C sort | while read -r f; do
        printf '%s  %s\n' "$($sum < "$f" | cut -d' ' -f1)" "$f"
    done)
}

case "${1:-}" in
--check)
    [ -f "$record" ] || { echo "sync-toolkit: no $record; run tools/sync-toolkit.sh --record" >&2; exit 1; }
    commit=$(sed -n 's/^commit //p' "$record")
    if [ "$(hashes)" != "$(grep -v '^#' "$record" | grep -v '^commit ')" ]; then
        echo "sync-toolkit: cps2recomp/ is not what cps2recomp $commit gave (changed by hand?)." >&2
        echo "  Change the toolkit in its own repository, copy it again and run tools/sync-toolkit.sh --record." >&2
        exit 1
    fi
    echo "cps2recomp/: commit $commit"
    ;;
--record)
    [ -f "$record" ] || { echo "sync-toolkit: no $record to update" >&2; exit 1; }
    commit=$(sed -n 's/^commit //p' "$record")
    header=$(grep '^#' "$record" || true)
    {
        [ -n "$header" ] && printf '%s\n' "$header"
        echo "commit $commit"
        hashes
    } > "$record"
    echo "recorded $(hashes | wc -l | tr -d ' ') files for commit $commit"
    ;;
*)
    echo "usage: $0 --check | --record" >&2
    exit 2
    ;;
esac
