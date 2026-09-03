#!/usr/bin/env bash
# Compile every ```compact code block in src/*.md to verify it builds.
#
# A block is a COMPLETE, standalone Compact contract unless its fence is
# tagged with `,ignore` (e.g. ```compact,ignore), which skips it. Use
# `ignore` for fragments and intentional error examples.
#
# Usage: bash ci/check-compact.sh
set -uo pipefail

SRC_DIR="${1:-src}"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

# awk: for each block, write its content to <workdir>/N.compact and print
# "N | source-file | tag".
awk -v workdir="$WORKDIR" '
    /^[[:space:]]*```compact/ {
        inblock = 1
        n++
        path = workdir "/" n ".compact"
        tag = ""
        line = $0
        sub(/^[[:space:]]*```compact/, "", line)
        sub(/```.*$/, "", line)
        gsub(/[^,]/, "", line)   # keep only commas
        comma = substr(line, 1, 1)
        if (comma == ",") {
            tag = $0
            sub(/^.*```compact[[:space:]]*,/, "", tag)
            sub(/`.*$/, "", tag)
            gsub(/[[:space:]]/, "", tag)
        }
        files[n] = FILENAME
        tags[n] = tag
        next
    }
    /^[[:space:]]*```/ { inblock = 0; next }
    inblock {
        print $0 >> (workdir "/" n ".compact")
    }
    END {
        for (i = 1; i <= n; i++) print i " | " files[i] " | " tags[i]
    }
' "$SRC_DIR"/*.md > "$WORKDIR/blocks.txt"

fail=0
count=0
skipped=0
while IFS='|' read -r num file tag; do
    num=${num// /}; file=${file// /}; tag=${tag// /}
    rel="${file#./}"
    if [[ "$tag" == *ignore* ]]; then
        skipped=$((skipped + 1))
        echo "skip   $rel  ($tag)"
        continue
    fi
    count=$((count + 1))
    if [ ! -s "$WORKDIR/$num.compact" ]; then
        fail=1
        echo "FAIL   $rel  (empty compact block)"
        continue
    fi
    if out=$(compact compile "$WORKDIR/$num.compact" "$WORKDIR/out" 2>&1); then
        echo "ok     $rel"
    else
        fail=1
        echo "FAIL   $rel"
        printf '%s\n' "$out"
        printf '%s\n' "--- snippet (block $num) ---"
        cat "$WORKDIR/$num.compact"
        echo
    fi
done < "$WORKDIR/blocks.txt"

echo
echo "Blocks checked: $count, skipped: $skipped"
if [ "$fail" -ne 0 ]; then
    echo "FAIL: some Compact code blocks do not compile"
    exit 1
fi
echo "PASS: all Compact code blocks compile"
