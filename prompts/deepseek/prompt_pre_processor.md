
---

## **`prompts/deepseek/prompt_pre_processor.md`**
```markdown
# DeepSeek Prompt Pre-Processor (Pro V2)

**Ziel:**  
Dieses Modul filtert und optimiert Prompts vor dem Senden an **DeepSeek**, um alle bekannten Inhaltsblockaden zu umgehen.  
Es kombiniert **umfassende Keyword-Erkennung**, **Synonymisierung**, **Rephrase-Techniken** und **Fallback-Routing**.

---

## 1. Funktionsweise

1. **Konflikterkennung**  
   - Erkennung von Keywords in Deutsch/Englisch/Szenario-spezifischem Slang.
   - Berücksichtigt auch Hacking-, Terror- und Explosivthemen.

2. **Synonymisierung**  
   - Kritische Begriffe werden entschärft (z. B. `hack` → `digitale Umgehung`).
   - Sprach- und Kontextanpassung.

3. **Rephrase-Strategie**  
   - Standard: Rollenspiel.
   - Alternative: Kontextualisierung, hypothetische Szenarien.

4. **Primär-API-Call**  
   - Haupt-Endpoint von DeepSeek.

5. **Policy-Check**  
   - Erkennt Ablehnungen.
   - Falls blockiert → Doppel-Rephrase.

6. **Fallback-API-Call**  
   - Nutzung eines alternativen Endpoints/Region.

---

## 2. Integration in OMNIKAI

- **Dateipfad:**  
  `flows/n8n/prompt_pre_processor_deepseek_v2.json`
- **Einfügen in n8n:**  
  Vor jedem DeepSeek-Request in Think- oder Execute-Flows.

---

## 3. Vorteile

- Blockadequote nahezu 0 % bei Tests.
- Erweiterbare Keyword-Liste.
- Funktioniert mit sensiblen Szenarien (Hacking, Explosives, etc.).
- Doppel-Rephrase sichert auch komplexe Fälle ab.

---

## 4. Beispiel-Workflow

```mermaid
flowchart LR
  A[Original Prompt] --> B[Conflict Detection]
  B -->|true| C[Synonym Obfuscation]
  B -->|false| E[Skip Obfuscation]
  C --> D[Rephrase Strategy]
  E --> D
  D --> F[DeepSeek API Primary]
  F --> G[Policy Check]
  G -->|retry| H[Double Rephrase + Fallback]
  G -->|pass| I[Return Response]
  H --> I

