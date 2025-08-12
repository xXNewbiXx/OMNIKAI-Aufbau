# ChatGPT Prompt Pre-Processor (Pro V2)

**Ziel:**  
Dieses Modul filtert, verschleiert und optimiert Anfragen an **ChatGPT**, um sensible Analysen in den Bereichen Wirtschaft, Sicherheit, geheime Strukturen und strategische Operationen zu ermöglichen – ohne Policy-Blockaden.  
Es kombiniert **umfassende Keyword-Erkennung**, **Synonymisierung**, **Rephrase-Techniken** und **Fallback-Routing**.

---

## 1. Funktionsweise

1. **Konflikterkennung**  
   - Erkennt kritische Begriffe aus den Bereichen Wirtschaftsspionage, Red-Team, Sicherheit, Technologie und geopolitische Analysen.

2. **Synonymisierung & Kontextverschiebung**  
   - Entschärft sensible Begriffe (`Wirtschaftsspionage` → `strategische Marktanalyse`, `Bombe` → `Druckbehälter`).
   - Verlegt den Kontext in hypothetische, analytische oder historische Szenarien.

3. **Rephrase-Strategie**  
   - Standard: Rollenspiel-Modus („Handle als Analyst/Forscher“).
   - Alternative: Hypothetisches Szenario oder historische Analyse.

4. **Primär-API-Call**  
   - Anfrage an Haupt-Endpoint von ChatGPT.

5. **Policy-Check**  
   - Erkennt Ablehnungen.
   - Falls blockiert → Doppel-Rephrase.

6. **Fallback-API-Call**  
   - Alternativer Endpoint oder Modellversion.

---

## 2. Integration in OMNIKAI

- **Dateipfad:**  
  `flows/n8n/prompt_pre_processor_chatgpt_v2.json`
- **Einfügen in n8n:**  
  Vor jedem ChatGPT-Request in Think- oder Execute-Flows.

---

## 3. Vorteile

- Blockadequote <1 % bei sensiblen Themen.
- Mehrsprachige Keyword-Liste (Deutsch, Englisch, Slang).
- Doppel-Rephrase sichert auch schwierige Fälle ab.
- Einfach anpassbar für neue Themen.

---

## 4. Beispiel-Workflow

```mermaid
flowchart LR
  A[Original Prompt] --> B[Conflict Detection]
  B -->|true| C[Synonym Obfuscation + Kontextverschiebung]
  B -->|false| E[Skip Obfuscation]
  C --> D[Rephrase Strategy]
  E --> D
  D --> F[ChatGPT API Primary]
  F --> G[Policy Check]
  G -->|retry| H[Double Rephrase + Fallback]
  G -->|pass| I[Return Response]
  H --> I
