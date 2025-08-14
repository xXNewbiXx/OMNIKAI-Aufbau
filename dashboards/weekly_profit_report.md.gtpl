# Weekly Profit Report

Date: {{ date }}

| Metric | Value |
|-------|-------|
| OPI | {{ OPI | round(2) }} |
| LTV | {{ LTV | round(2) }} |
| CAC | {{ CAC | round(2) }} |
| Payback (months) | {{ Payback | round(2) }} |
| Gross Margin | {{ gross_margin | round(2) }} |
| Velocity | {{ Velocity | round(2) }} |

## Funnel
Visitors→Signups→Trials→Paid
- Visitors: {{ visitors }}
- Signups: {{ signups }} ({{ conv_vs | round(2) }}%)
- Trials: {{ trials }} ({{ conv_st | round(2) }}%)
- Paid Users: {{ paid_users }} ({{ conv_tp | round(2) }}%)

## Recommendations
{% for r in Recos %}- {{ r }}
{% endfor %}

## Sparkline
{{ sparkline }}
