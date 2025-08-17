# Architektur

```mermaid
flowchart LR
  subgraph Internal
    T[Think Flow]
    E[Execute Flow]
    T --> E
  end
  E --> CF[Claude-Flow (external)]
  CF --> E
  E --> OUT[Artefakte]
```

- **Think Flow** – strukturiert Anforderungen und füllt das Backlog.
- **Execute Flow** – realisiert Aufgaben und nutzt Komponenten aus `Claude-Flow`.
- **Claude-Flow (external)** – gepflegtes Modul mit wiederverwendbaren Prompt- und Code-Bausteinen.
  Aktualisierung via `git submodule update --init --recursive` und `bash scripts/update_submodules.sh`.

