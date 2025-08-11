# OMNIKAI Compliance Check v1.0 — FIX PACK Addendum

**Adds mandatory section:** Flags + Maßnahmen + Owner + Deadline (per DONE criteria).  
**References (explicit):** `PATCHED/POLICY.json`, `PATCHED/ARCH_edge_core.md`

## Flags, Maßnahmen, Owner, Deadline
- **FLAG-C1: GDPR Score < 99% in last 7d**  
  - **Maßnahmen:** Review Consent-Guard mappings; raise threshold in `n8n_guards.json`; re-run DSAR tests.  
  - **Owner:** DPO / Claude-Flow  
  - **Deadline:** 2025-08-09 + 7 Tage

- **FLAG-C2: Transfer-Gate Coverage < 100%**  
  - **Maßnahmen:** Cross-check `data_transfers.evaluation_criteria` in `PATCHED/POLICY.json`; block missing destinations; add SCC templates.  
  - **Owner:** Legal / Claude-Flow  
  - **Deadline:** 2025-08-09 + 10 Tage

- **FLAG-C3: Board-Outside-Jurisdiction Detected**  
  - **Maßnahmen:** Enforce Signatur-Geofence; minutes redo in Micro-HQ; attach travel ledger.  
  - **Owner:** Basti (Field)  
  - **Deadline:** 2025-08-09 + 14 Tage

- **FLAG-C4: Vendor Without DPA**  
  - **Maßnahmen:** DPA nachziehen oder Vendor sperren; update Vendor-Register.  
  - **Owner:** Procurement / Compliance  
  - **Deadline:** 2025-08-09 + 10 Tage

## Owner Matrix
- **Legal/DPO:** GDPR, Transfer, DSAR, DPA
- **Claude-Flow:** Guards, Logging, Evidence
- **Basti:** Micro-HQ Substanz-Belege, Minutes, Travel

_Diese Addenda ergänzt die bereits vorhandenen KPIs/Abort/Monitoring-Teile._
