#!/usr/bin/env bash
# Usage: join-research.sh <planning-dir>
# Joins <planning-dir>/research/*.md, in name order, into <planning-dir>/research.md.
set -euo pipefail

dir="${1:?usage: join-research.sh <planning-dir>}"
sections=("$dir"/research/*.md)
if [ ! -e "${sections[0]}" ]; then
  echo "no section files in $dir/research" >&2
  exit 1
fi

commit="$(git rev-parse --verify -q HEAD || true)"
branch="$(git symbolic-ref -q --short HEAD || true)"
out="$dir/research.md"
tmp="$(mktemp "$out.XXXXXX")"
{
  echo "---"
  echo "date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "git_commit: ${commit:-unknown}"
  echo "branch: ${branch:-detached}"
  echo "questions: questions.md"
  echo "---"
  echo
  echo "# Research"
  echo
  echo "This file describes the codebase at the commit above. It contains no recommendations."
  for f in "${sections[@]}"; do
    echo
    cat "$f"
  done
} > "$tmp"
mv "$tmp" "$out"
echo "wrote $out from ${#sections[@]} section files"
