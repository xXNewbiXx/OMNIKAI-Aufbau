# Mindmap→Ontology Extractor

Input: Ein Mindmap-Bild zu Marketing (SEO, PPC, SMM, Content, Email, Analytics).

Ziele
1) **Outline** (Markdown, H1–H3, konsolidierte Begriffe).
2) **Graph-JSON** nach Schema unten (Knoten/Relationen, normalisiert).
3) **Actionables**: 5–10 konkrete Aufgaben pro Branch inkl. Definition of Done und KPI.

Graph-JSON Schema
{
  "source_image": "<filename>",
  "root": "<string>",
  "nodes": [{"id":"seo.onpage","label":"On-Page SEO","level":2,"tags":["seo","onpage"]}],
  "edges": [{"from":"digital.marketing","to":"seo","relation":"includes"}],
  "version":"0.1",
  "confidence": 0.0
}

Qualität
- Normalisieren statt 1:1 abtippen; Synonyme zusammenführen; Doppler entfernen.
- Fehlendes aus Ontologie als **TODO** markieren (keine Halluzinationen).
- Confidence 0.0–1.0 setzen.

Outputs
- `rag/mindmaps/{slug}.outline.md`
- `rag/mindmaps/{slug}.graph.json`
- `rag/mindmaps/{slug}.actions.md`
