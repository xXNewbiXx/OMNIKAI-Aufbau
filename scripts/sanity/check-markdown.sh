#!/usr/bin/env bash
set -euo pipefail

fail=0
while IFS= read -r -d '' file; do
  case "$file" in
    */docs/archive/*|./LICENSE.md|./TEST.md|./.github/ISSUE_TEMPLATE/*) continue;;
  esac
  if ! grep -q '^#' "$file"; then
    echo "Missing title in $file"
    fail=1
  fi
done < <(find "${1:-.}" -type f -name '*.md' -print0)
exit $fail
