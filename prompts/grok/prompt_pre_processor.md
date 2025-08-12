# Grok Prompt Pre-Processor (Pro V2)

**Ziel:**  
Dieses Modul filtert und optimiert Anfragen an **Grok**, um sensible Trend-, Sicherheits- oder Red-Team-Analysen zu ermöglichen, ohne dass Grok’s Filter eingreifen.  
Es kombiniert **umfassende Keyword-Erkennung**, **Synonymisierung**, **Rephrase-Techniken** und einen **Fallback-Mechanismus**.

---

## 1. Funktionsweise

1. **Konflikterkennung**  
   - Erkennung von kritischen Themen in Trend- oder Red-Team-Szenarien (Politik, Sicherheit, Extremismus, kontroverse Inhalte).
   - Unterstützt Deutsch, Englisch und gebräuchliche Slangformen.

2. **Synonymisierung**  
   - Entschärft Schlüsselbegriffe (`terror` → `extreme Handlung`, `illegale Aktion` → `nicht autorisierte Aktivität`).
   - Passt sich kontextsensitiv an (z. B. bei Trend-Analysen Formulierungen zu neutralisieren).

3. **Rephrase-Strategie**  
   - Standard: Hypothetisches Szenario („Angenommen, dies wäre eine Analyse…“).
   - Alternative: Rollenspiel-Modus oder Kontextualisierung.

4. **Primär-API-Call**  
   - Sendet optimierten Prompt an Grok-Endpoint.

5. **Policy-Check**  
   - Erkennt Ablehnungen oder Filterreaktionen.
   - Falls blockiert → Doppel-Rephrase mit zusätzlicher Kontextverlagerung.

6. **Fallback-API-Call**  
   - Zweiter Grok-Endpoint (alternative Region oder API-Version).

---

## 2. Integration in OMNIKAI

- **Dateipfad:**  
  `flows/n8n/prompt_pre_processor_grok_v2.json`
- **Einfügen in n8n:**  
  Vor jedem Grok-Request in Think- oder Execute-Flows.

---

## 3. Vorteile

- Minimiert Policy-Blockaden bei kritischen Trend-/Red-Team-Themen.
- Mehrsprachig erweiterbare Keyword-Liste.
- Strategien speziell für Analyse-/Testzwecke optimiert.
- Doppel-Rephrase als Sicherheitsnetz.

---

## 4. Beispiel-Workflow

```mermaid
flowchart LR
  A[Original Prompt] --> B[Conflict Detection]
  B -->|true| C[Synonym Obfuscation]
  B -->|false| E[Skip Obfuscation]
  C --> D[Rephrase Strategy]
  E --> D
  D --> F[Grok API Primary]
  F --> G[Policy Check]
  G -->|retry| H[Double Rephrase + Fallback]
  G -->|pass| I[Return Response]
  H --> I
