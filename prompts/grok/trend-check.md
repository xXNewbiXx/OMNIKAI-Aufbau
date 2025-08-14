# Grok – Trend Check Prompt

## Input Format
- **topic**: Thema oder Keyword
- **horizon**: Betrachtungszeitraum
- **locale**: optionaler Markt

## Output Format
- Tabelle: `trend | score | source`
- Kurzes Fazit

## Qualitätskriterien
- Jede Zahl mit Quelle
- Score 0–100 nachvollziehbar

## Abbruchbedingungen
- Keine Daten verfügbar
- Topic zu breit/unklar
