# Architektur

Dieses Dokument skizziert die Komponenten des OMNIKAI-Aufbau und deren Zusammenspiel.

## Kernkomponenten

- **Flows** (`flows/`): Enthält n8n-Workflows für die Phasen *Think* und *Execute*.
- **Prompts** (`prompts/`): Sammlung zentraler Prompt-Templates für Claude und unterstützende Modelle.
- **Agents** (`agents/`): Agentenlogik und Koordination der Modelle.
- **Docs** (`docs/`): Projekt- und Architektur-Dokumentation.
- **Scripts** (`scripts/`): Hilfsskripte für Wartung, CI und Submodule.
- **Tests** (`tests/`): Automatisierte Tests und Validierungen.

## External Module: claude-flow

Das externe Modul **claude-flow** liefert vorgefertigte n8n-Bausteine für Claude-Workflows.

- **Zweck:** Wiederverwendbare, geprüfte Standardabläufe, die die Integration von Claude in komplexe Workflows vereinfachen.
- **Update-Policy:** Aktualisierungen erfolgen ausschließlich über Pull Requests mit Review. Synchronisation über `scripts/update_submodules.sh` oder manuell bei vendored Kopien.
- **Risiken:** Upstream-Änderungen können zu Breaking Changes oder Sicherheitsproblemen führen. Fehlende Verfügbarkeit erfordert lokale Fallback-Workflows.

