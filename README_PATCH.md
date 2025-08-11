# OMNICODEX – Manus Patch (Mindmap+Merge)

**Zweck:** Dieses Patch-Paket erweitert dein bestehendes Manus-Projekt um:
- Bild→Wissen-Pipeline (Mindmap-Extractor → Outline/Graph/Actionables),
- Mini-Ontologie für einheitliche Begriffe,
- aktualisierte `workflows/claude_flow.merged.yaml` mit Stage `mindmap_ingest`,
- angepasste `datasources/sources.yaml`-Beispiele.

**Schnell-Import (Drop-in):**
1) Entpacke das ZIP **in dein bestehendes Manus-Projekt** (Dateien zusammenführen).
2) Ersetze **optional** deine aktuelle `workflows/claude_flow.yaml` durch `workflows/claude_flow.merged.yaml` (Backup empfohlen).
   - Falls du lieber manuell mergen willst, nutze `workflows/claude_flow.diff.txt`.
3) Lege deine Bilder in `/uploads/manus/mindmaps/` ab (Ordner ggf. anlegen).
4) Prüfe/ergänze `datasources/sources.yaml` gemäß Beispiel.
5) Starte Manus neu oder triggert den Reload, dann in **omnicodex**: `Init` ausführen.

**Validierung (2 Minuten):**
- Prüfe, ob in `rag/mindmaps` neue Dateien entstehen (`*.outline.md`, `*.graph.json`, `*.actions.md`).
- Frage: „Zeige mir die Actionables aus *Mindmap XYZ*.“

Version: patch-20250810T194542Z
