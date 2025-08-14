# Profit Module

Dieses Modul bündelt Konfiguration, Experimente und Playbooks zur Messung und Steuerung der Profitabilität. Kernkennzahl ist der **OMNIKAI Profit Index (OPI)**, berechnet aus:

- **LTV** = ARPU_month × Gross Margin × (1 / Churn)
- **Payback (Monate)** = CAC / (ARPU_month × Gross Margin)
- **OPI** = (LTV / CAC) × Gross Margin × Velocity

Weitere Details in `tools/profit_calc.py` und den wöchentlichen Reports unter `dashboards/`.
