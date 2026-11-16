#!/usr/bin/env bash
# Usage: check-citations.sh <markdown-file> [repo-root]
# Prints every `path:line` or `path:start-end` citation in backticks that does
# not resolve to a real line of a real file. Exits 1 when any citation fails.
set -euo pipefail

doc="${1:?usage: check-citations.sh <markdown-file> [repo-root]}"
root="${2:-.}"
bad=0
total=0

while IFS= read -r cite; do
  total=$((total + 1))
  path="${cite%%:*}"
  range="${cite#*:}"
  last="${range##*-}"
  file="$root/$path"
  if [ ! -f "$file" ]; then
    echo "missing file: $cite"
    bad=$((bad + 1))
    continue
  fi
  lines=$(wc -l < "$file")
  # A final line with no newline is still a line.
  if [ -n "$(tail -c 1 "$file")" ]; then lines=$((lines + 1)); fi
  if [ "$last" -gt "$lines" ]; then
    echo "line out of range: $cite ($path has $lines lines)"
    bad=$((bad + 1))
  fi
done < <(grep -oE '`[^` ]+:[0-9]+(-[0-9]+)?`' "$doc" | tr -d '`' | grep -v '://' | sort -u || true)

echo "$total citations checked, $bad failed"
[ "$bad" -eq 0 ]
