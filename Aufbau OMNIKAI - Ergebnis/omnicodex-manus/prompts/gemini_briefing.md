# Briefing für Gemini – Warum & Wie

**Warum Gemini?**
- Für lange Videos/Datenmassen kosteneffizient und robust.
- Ziel: strukturierte Extrakte (Themen, Metriken, Zitate, Zeitstempel) für *Claude Flow*.

**Auftrag (Template):**
- Input: <Liste an YouTube-Links/Dateien>.
- Tasks:
  1) Kapitel & Zeitstempel extrahieren.
  2) Key Claims + Evidenz notieren, Unsicherheiten markieren.
  3) Relevanz zu unseren Opportunity-Scores bewerten (0–100).
  4) Export als `jsonl` nach Schema: `{{source, ts, claim, evidence_url, score}}`.
- Output-Übergabe: n8n Webhook `<URL>`.

**Hinweis:** Ergebnis wird in RAG übernommen; Claude Flow erhält nur verlässliche, zitationsfähige Nuggets.
