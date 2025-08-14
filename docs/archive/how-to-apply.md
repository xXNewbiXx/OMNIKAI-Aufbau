# HOW TO APPLY — MANUS FIX PACK v1.0

**Target DB:** PostgreSQL 14+

1) **Rename** die gelieferten MANUS-Dateien gemäß `RENAME.txt` (oder ersetze sie direkt durch die Dateien in diesem Pack).
2) **DB:** führe `kpi_schema.pg.sql` auf der KPI-Datenbank aus (Role mit CREATE/USAGE/CREATE VIEW).
3) **Dashboard:** importiere `monitor_dashboard.pg.json` (dein BI-Tool oder n8n-UI Panel).
4) **Docs:** ersetze/merge:
   - `compliance_check.md` mit der Version aus diesem Pack (Flags/Owner/Deadline ergänzt).
   - `risk_memo_legal_flags.md` (enthält zusätzliche Flags zu PE, OSS/VAT, Exit-Tax).
   - `basti_checkliste.md` (kompakte 1-Seiten-Version).
5) **n8n:** stelle sicher, dass die Workflows (`n8n_sales_core.json`, `n8n_guards.json`) auf **PostgreSQL** loggen.
   - Credential Name: `POSTGRES_OMNIKAI`
   - ENV: `OMNIKAI_DB_URL=postgres://user:pass@host:5432/omnikai`
6) **Smoke-Test:** 3 vollständige Runs → Dashboard zeigt Daten; keine SQL-Fehler.
7) **Go/No-Go:** Wenn Checkliste grün & DONE-Kriterien erfüllt → RESULT=APPROVED.

_Dieses Pack harmonisiert SQL-Dialekte, ergänzt fehlende Views und macht alles nativ Postgres._
