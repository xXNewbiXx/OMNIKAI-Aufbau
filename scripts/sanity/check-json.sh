#!/usr/bin/env bash
set -euo pipefail

fail=0
while IFS= read -r -d '' file; do
  if ! jq empty "$file" >/dev/null 2>&1; then
    echo "Missing or invalid JSON: $file"
    fail=1
  fi
done < <(find "${1:-.}" -type f -name '*.json' -print0)
exit $fail
