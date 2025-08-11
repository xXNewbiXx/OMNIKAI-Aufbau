# OMNICODEX – Manus-Paket (Import-Ready)

**Zweck:** Dieses Paket bündelt alle Anweisungen, Prompts und Konfigurationen,
damit *Manus* den **gbtAgent `omnicodex`** initialisiert und damit **Claude Flow**
als Steuer-KI bedient. Ziel: vollautomatisierte Marktanalyse → Produktentwicklung → Distribution.

## Import-Hinweis
1) Lade das ZIP in Manus hoch.
2) Manus liest `manus_manifest.json` und startet den Entry-Point `prompts/initialisierung.omnicodex.md`.
3) Der Agent `omnicodex` registriert Quellen aus `datasources/`, baut RAG gemäß `rag/config.json`
   und lädt **Workflows** aus `workflows/claude_flow.yaml`.
4) KPIs & Events werden aus `kpis/kpis.yaml` und `analytics/events.schema.json` bekannt gemacht.

## Ordnerstruktur
- `agents/` – Agent-Definitionen (Rollen, Policies, Toolzugriffe)
- `workflows/` – ausführbare Pipelines für Claude Flow & Co.
- `prompts/` – Initialisierung, Trigger, Briefings
- `kpis/` – Metriken & Schwellenwerte (Trigger für Auto-Entscheidungen)
- `analytics/` – Event-Schema (für GA4/Meta/UTM vereinheitlicht)
- `security/` – rechtliche Leitplanken & IP-Schutz (knapp, praxisnah 😉)
- `branding/` – konsistente Logo-/Handle-Vorgaben
- `datasources/` – Quellen (Dateien, Ordner, Feeds) mit Klassifizierung
- `rag/` – Retrieval-Konfiguration (Chunking, Embeddings)

## Kurz-Workflow
- *omnicodex* übernimmt: Ingest → Strukturieren → Prompting von Claude → Auswertung → Decision Loops.
- *Gemini* wird für Massendaten/Videoanalyse via Briefing `prompts/gemini_briefing.md` beauftragt.
- *Grok* optional als Stresstester.
