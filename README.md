# OMNIKAI – Aufbau (Blueprint)

![CI](https://github.com/xXNewbiXx/OMNIKAI-Aufbau/actions/workflows/ci.yml/badge.svg)

Robustes, modular skalierbares Multi‑Agenten‑System. Steuer‑KI: Claude. Unterstützend: Gemini (Deep Research), Grok (Trend/Red‑Team). Orchestrierung über zwei gekoppelte n8n‑Flows (*Think* → Struktur, *Execute* → Umsetzung).

## Ordner

- `/docs` – Doku & Landing (GitHub Pages)
  - `/docs/archive` – Historische Ablage
- `/flows/n8n` – Exporte der zwei Flows
- `/prompts` – Start‑Prompts
- `/agents` – Rollen
- `/infra` – Architektur & Schemas

## Pakete/Module

- **OMNICODEX (Manus‑Paket)** → siehe `docs/packages/omnicodex.md`

## Schnellstart

1. Doku lesen: `/docs/index.md`
2. Flows importieren (sobald verfügbar)
3. Prompts anpassen, erste Testläufe

## Beitrag & Verhaltensregeln

Beiträge sind willkommen! Bitte lies [CONTRIBUTING.md](CONTRIBUTING.md) und beachte den [Code of Conduct](CODE_OF_CONDUCT.md).

## Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE.md).

## Next Steps

- Automatisierte Tests ergänzen
- CI weiter härten
- n8n-Flows produktiv ausbauen
