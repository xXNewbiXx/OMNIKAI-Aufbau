#!/usr/bin/env python3
import argparse
import json
import os
import re
from datetime import datetime, timedelta

import pandas as pd
import yaml
from jinja2 import Template


def ensure_metrics(path):
    if not os.path.exists(path):
        today = datetime.today().date().isoformat()
        with open(path, 'w', encoding='utf-8') as f:
            f.write('date,visitors,signups,trials,paid_users,mrr,marketing_spend,refunds,support_tickets\n')
            f.write(f"{today},0,0,0,0,0,0,0,0\n")
    return pd.read_csv(path, parse_dates=['date'])


def count_experiments(path):
    if not os.path.exists(path):
        return 0
    text = open(path, 'r', encoding='utf-8').read()
    blocks = re.findall(r'-\s*title:.*?(?=\n-\s*title:|\Z)', text, re.S)
    count = 0
    cutoff = datetime.today().date() - timedelta(days=7)
    for b in blocks:
        status = re.search(r'status:\s*(\w+)', b)
        date_m = re.search(r'date:\s*(\d{4}-\d{2}-\d{2})', b)
        if status and status.group(1) == 'done' and date_m:
            d = datetime.fromisoformat(date_m.group(1)).date()
            if d >= cutoff:
                count += 1
    return count


def sparkline(values):
    ticks = '▁▂▃▄▅▆▇█'
    if not values:
        return ''
    mn, mx = min(values), max(values)
    if mx == mn:
        return ticks[0] * len(values)
    scale = len(ticks) - 1
    return ''.join(ticks[int((v - mn) / (mx - mn) * scale)] for v in values)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--config', required=True)
    p.add_argument('--params', required=True)
    p.add_argument('--metrics', required=True)
    p.add_argument('--threshold', required=True)
    p.add_argument('--template', required=True)
    p.add_argument('--out', required=True)
    p.add_argument('--json', required=True)
    args = p.parse_args()

    cfg = yaml.safe_load(open(args.config, encoding='utf-8'))
    params = yaml.safe_load(open(args.params, encoding='utf-8'))
    thr = json.load(open(args.threshold, encoding='utf-8'))

    df = ensure_metrics(args.metrics).sort_values('date')
    latest = df.iloc[-1]
    prev = df.iloc[-2] if len(df) > 1 else None

    visitors = latest['visitors']
    signups = latest['signups']
    trials = latest['trials']
    paid = latest['paid_users']
    mrr = latest['mrr']

    conv_vs = (signups / visitors * 100) if visitors else 0
    conv_st = (trials / signups * 100) if signups else 0
    conv_tp = (paid / trials * 100) if trials else 0

    variable_costs = latest['marketing_spend'] + latest['refunds']
    gross_margin = params['gross_margin']
    netrev = mrr * gross_margin - variable_costs

    if prev is not None and prev['paid_users'] > 0:
        churn = max((prev['paid_users'] - paid) / prev['paid_users'], 0)
    else:
        churn = params['churn_month']

    LTV = params['arpu_month'] * params['gross_margin'] * (1 / params['churn_month'])
    Payback = params['cac'] / (params['arpu_month'] * params['gross_margin'])

    experiments = count_experiments('profit/experiments_backlog.md')
    Velocity = experiments / 3.0
    Velocity = max(0.5, min(2.0, Velocity))

    OPI = (LTV / params['cac']) * params['gross_margin'] * Velocity

    recos = []
    if Payback > params.get('payback_target_months', 0):
        recos.append('Price/Packaging')
    if (conv_tp / 100) < params.get('trial_to_paid', 1):
        recos.append('Activation/Onboarding')
    if churn > 0.08:
        recos.append('Retention/Winback')
    recos = recos[:3]

    spark = sparkline(df['mrr'].tail(8).tolist())

    summary = {
        'date': latest['date'].date().isoformat(),
        'OPI': float(OPI),
        'LTV': float(LTV),
        'CAC': float(params['cac']),
        'Payback': float(Payback),
        'gross_margin': float(gross_margin),
        'Velocity': float(Velocity),
        'visitors': int(visitors),
        'signups': int(signups),
        'trials': int(trials),
        'paid_users': int(paid),
        'conv_vs': float(conv_vs),
        'conv_st': float(conv_st),
        'conv_tp': float(conv_tp),
        'NetRev': float(netrev),
        'Recos': recos,
        'sparkline': spark,
        'Experiments_shipped_last_7d': int(experiments),
        'thresholds': thr,
    }

    tpl = Template(open(args.template, encoding='utf-8').read())
    with open(args.out, 'w', encoding='utf-8') as f:
        f.write(tpl.render(**summary))
    with open(args.json, 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)


if __name__ == '__main__':
    main()
