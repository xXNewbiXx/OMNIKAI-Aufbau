# OMNIKAI – Projektüberblick

OMNIKAI ist ein modularer Multi‑Agenten‑Stack. Steuer‑KI: **Claude**. Unterstützend: **Gemini** (Deep Research) und **Grok** (Red‑Team/Trendcheck).  
Orchestrierung über zwei gekoppelte n8n‑Flows: **Think** (Struktur) → **Execute** (Umsetzung).

## Architektur
```mermaid
flowchart LR
  A[Inputs: Ideen/Daten] --> B[Flow 1: THINK]
  B --> C[Backlog & Prompts]
  C --> D[Flow 2: EXECUTE]
  D --> E[Outputs: Artefakte/Reports/Commits]
  E -->|Feedback| B
