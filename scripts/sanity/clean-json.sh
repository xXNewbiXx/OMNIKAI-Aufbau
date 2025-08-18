#!/usr/bin/env bash
set -euo pipefail
dir="${1:-.}"
find "$dir" -maxdepth 1 -type f -name '*.json' -print0 | while IFS= read -r -d '' file; do
  python3 - <<'PY' "$file"
import sys, json
from pathlib import Path

def strip_comments(s):
    out=[]; i=0; in_str=False
    while i < len(s):
        c=s[i]
        if in_str:
            if c=='\\':
                out.append(c); i+=1
                if i < len(s): out.append(s[i]); i+=1; continue
            if c=='"':
                in_str=False
            out.append(c); i+=1
        else:
            if c=='"':
                in_str=True; out.append(c); i+=1
            elif c=='/' and i+1 < len(s) and s[i+1]=='/':
                i+=2
                while i < len(s) and s[i] != '\n':
                    i+=1
            elif c=='/' and i+1 < len(s) and s[i+1]=='*':
                i+=2
                while i+1 < len(s) and not (s[i]=='*' and s[i+1]=='/'):
                    i+=1
                i+=2
            else:
                out.append(c); i+=1
    return ''.join(out)

path=Path(sys.argv[1])
text=path.read_text(encoding='utf-8').lstrip('\ufeff')
text=strip_comments(text)
obj, _ = json.JSONDecoder().raw_decode(text)
path.write_text(json.dumps(obj, ensure_ascii=False, indent=2) + "\n", encoding='utf-8')
PY
echo "cleaned $file"
done
