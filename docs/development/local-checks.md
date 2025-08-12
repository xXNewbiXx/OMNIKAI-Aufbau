# Lokale Checks

Führe vor einem Commit Basistests aus, um Syntaxfehler früh zu finden.

```bash
# beide Checks ausführen
make sanity

# nur JSON oder Markdown prüfen
make check-json
make check-markdown
```

Alternativ können die Skripte direkt aufgerufen werden:

```bash
bash scripts/sanity/check-json.sh
bash scripts/sanity/check-markdown.sh
```
