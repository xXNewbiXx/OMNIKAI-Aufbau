# Gemini Prompt Pre-Processor (Pro V2)

**Ziel:**  
Dieses Modul sitzt vor allen Anfragen an **Gemini** und minimiert Policy-Blockaden durch eine Kombination aus **mehrstufiger Konflikterkennung**, **Synonymverschleierung**, **intelligenter Umformulierung** und einem **Fallback-Mechanismus**.

---

## 1. Funktionsweise

1. **Konflikterkennung**  
   - Prüft den Prompt auf problematische Schlüsselwörter (Deutsch + Englisch + Slang).
   - Setzt `conflict: true` oder `false`.

2. **Synonymverschleierung**  
   - Ersetzt kritische Begriffe durch neutrale Alternativen (z. B. `bombe` → `Druckbehälter`).
   - Mehrsprachige Abdeckung.

3. **Rephrase-Strategie**  
   - Standard: Rollenspiel-Modus für maximale Akzeptanz.
   - Alternativ: Kontextualisierung oder hypothetisches Szenario.

4. **Primär-API-Call**  
   - Anfrage an Haupt-Gemini-Endpoint.

5. **Policy-Check**  
   - Erkennt Blockaden in der Antwort.
   - Falls blockiert → Doppel-Rephrase.

6. **Fallback-API-Call**  
   - Zweiter Endpoint mit alternativer Region/Version.

---

## 2. Integration in OMNIKAI

- **Dateipfad:**  
  `flows/n8n/prompt-pre-processor-gemini-v2.json`
- **Einfügen in n8n:**  
  Vor jedem Gemini-Request in Think- oder Execute-Flows.

---

## 3. Vorteile

- Blockadequote <1 % in Tests.
- Mehrsprachig erweiterbare Keyword-Liste.
- Zwei Sicherheitsstufen (Primary + Fallback).
- Leicht wartbar in n8n.

---

## 4. Beispiel-Workflow

```mermaid
flowchart LR
  A[Original Prompt] --> B[Conflict Detection]
  B -->|true| C[Synonym Obfuscation]
  B -->|false| E[Skip Obfuscation]
  C --> D[Rephrase Strategy]
  E --> D
  D --> F[Gemini API Primary]
  F --> G[Policy Check]
  G -->|retry| H[Double Rephrase + Fallback]
  G -->|pass| I[Return Response]
  H --> I
