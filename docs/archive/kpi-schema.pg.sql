-- OMNIKAI KPI Schema (PostgreSQL) — FIX PACK v1.0 — 2025-08-09
-- This script replaces mixed SQL with canonical PostgreSQL DDL + required views.

-- =======================
-- EXTENSIONS (optional)
-- =======================
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =======================
-- TABLES
-- =======================
CREATE TABLE IF NOT EXISTS workflow_runs (
    run_id TEXT PRIMARY KEY,
    workflow_name TEXT NOT NULL,
    workflow_type TEXT NOT NULL,     -- 'sales_core' | 'guards' | 'micro_hq' | 'api' ...
    start_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    end_timestamp   TIMESTAMPTZ,
    status          TEXT NOT NULL DEFAULT 'RUNNING', -- RUNNING|SUCCESS|FAILED|ABORTED
    execution_time_ms INTEGER,
    error_message   TEXT,
    input_data  JSONB,
    output_data JSONB,
    correlation_id TEXT,
    created_by  TEXT
);
CREATE INDEX IF NOT EXISTS idx_workflow_runs_ts ON workflow_runs (start_timestamp);
CREATE INDEX IF NOT EXISTS idx_workflow_runs_status ON workflow_runs (status);
CREATE INDEX IF NOT EXISTS idx_workflow_runs_type ON workflow_runs (workflow_type);

CREATE TABLE IF NOT EXISTS operation_costs (
    cost_id TEXT PRIMARY KEY,
    operation_type TEXT NOT NULL,   -- 'api_call'|'llm_usage'|'storage'|'compute'|'customer_acquisition'
    operation_name TEXT NOT NULL,
    cost_amount NUMERIC(12,4) NOT NULL,
    cost_currency TEXT NOT NULL DEFAULT 'EUR',
    cost_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    run_id TEXT REFERENCES workflow_runs(run_id),
    resource_usage JSONB,
    provider TEXT,
    region   TEXT DEFAULT 'EU'
);
CREATE INDEX IF NOT EXISTS idx_operation_costs_ts ON operation_costs (cost_timestamp);
CREATE INDEX IF NOT EXISTS idx_operation_costs_type ON operation_costs (operation_type);

CREATE TABLE IF NOT EXISTS error_incidents (
    incident_id TEXT PRIMARY KEY,
    run_id  TEXT REFERENCES workflow_runs(run_id),
    error_type TEXT,
    severity   TEXT,       -- INFO|WARNING|ERROR|CRITICAL
    message    TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_error_incidents_ts ON error_incidents (created_at);

CREATE TABLE IF NOT EXISTS sales_pipeline (
  lead_id TEXT PRIMARY KEY,
  source TEXT,
  region TEXT,
  assigned_agent TEXT DEFAULT 'Sebastian Horn',
  stage TEXT, -- lead|qualified|opportunity|proposal|meeting|closed_won|closed_lost
  contact_email TEXT,
  contact_phone TEXT,
  lead_value_eur NUMERIC(12,2),
  probability_percent INT DEFAULT 0,
  created_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_activity_timestamp TIMESTAMPTZ,
  qualified_timestamp TIMESTAMPTZ,
  opportunity_timestamp TIMESTAMPTZ,
  proposal_timestamp TIMESTAMPTZ,
  meeting_timestamp TIMESTAMPTZ,
  closed_timestamp TIMESTAMPTZ,
  response_time_hours NUMERIC(8,2),
  qualification_time_hours NUMERIC(8,2),
  proposal_generation_time_hours NUMERIC(8,2),
  meeting_conversion_time_hours NUMERIC(8,2),
  close_time_days NUMERIC(8,2)
);
CREATE INDEX IF NOT EXISTS idx_sales_created ON sales_pipeline (created_timestamp);
CREATE INDEX IF NOT EXISTS idx_sales_stage   ON sales_pipeline (stage);
CREATE INDEX IF NOT EXISTS idx_sales_agent   ON sales_pipeline (assigned_agent);

CREATE TABLE IF NOT EXISTS conversion_metrics (
  metric_date DATE NOT NULL,
  metric_hour INT,
  stage_from TEXT,
  stage_to   TEXT,
  region     TEXT,
  agent_name TEXT,
  value      NUMERIC(12,4) NOT NULL,
  PRIMARY KEY (metric_date, metric_hour, stage_from, stage_to, region, agent_name)
);

CREATE TABLE IF NOT EXISTS compliance_events (
  event_id TEXT PRIMARY KEY,
  event_type TEXT,  -- 'data_transfer'|'consent_verification'|'dsar_request'|...
  compliance_status TEXT, -- 'COMPLIANT'|'VIOLATION'|'BLOCKED'
  event_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  data_subject_id TEXT,
  consent_id TEXT,
  details JSONB
);
CREATE INDEX IF NOT EXISTS idx_compliance_ts ON compliance_events (event_timestamp);
CREATE INDEX IF NOT EXISTS idx_compliance_type ON compliance_events (event_type);

CREATE TABLE IF NOT EXISTS financial_metrics (
  metric_date DATE NOT NULL,
  metric_type TEXT,  -- 'revenue'|'cost'|'mrr'
  amount_eur  NUMERIC(14,2) NOT NULL,
  customer_id TEXT,
  PRIMARY KEY (metric_date, metric_type, customer_id)
);

CREATE TABLE IF NOT EXISTS micro_hq_substance (
  record_date DATE NOT NULL,
  physical_presence_hours NUMERIC(6,1) NOT NULL DEFAULT 0,
  required_presence_hours NUMERIC(6,1) NOT NULL DEFAULT 8,
  presence_compliance_percent NUMERIC(5,2),
  ciga_value_generated_eur NUMERIC(14,2) DEFAULT 0,
  board_meetings_held INT DEFAULT 0,
  board_meetings_in_jurisdiction INT DEFAULT 0,
  documentation_compliance_percent NUMERIC(5,2),
  responsible_agent TEXT,
  PRIMARY KEY (record_date, responsible_agent)
);

-- Backfill presence_compliance_percent if null
-- (Use a trigger in production; here a one-off UPDATE)
UPDATE micro_hq_substance
   SET presence_compliance_percent = CASE WHEN required_presence_hours>0
                                         THEN (physical_presence_hours*100.0/required_presence_hours)
                                         ELSE 0 END
 WHERE presence_compliance_percent IS NULL;

-- =======================
-- VIEWS (matching dashboard)
-- =======================

-- Sales KPIs (daily)
CREATE OR REPLACE VIEW v_sales_kpis AS
SELECT
  date_trunc('day', created_timestamp) AS kpi_date,
  COUNT(*) FILTER (WHERE stage IN ('qualified','opportunity','proposal','meeting','closed_won'))::INT AS pipeline_items,
  AVG(response_time_hours)                         AS avg_response_time_hours,
  AVG(proposal_generation_time_hours)              AS avg_proposal_latency_hours,
  AVG(close_time_days)                             AS avg_close_time_days,
  (COUNT(*) FILTER (WHERE closed_timestamp IS NOT NULL AND stage='closed_won') * 100.0 / NULLIF(COUNT(*),0))::NUMERIC(5,2) AS close_rate_percent
FROM sales_pipeline
GROUP BY 1;

-- Operational KPIs from workflow runs (hourly)
CREATE OR REPLACE VIEW v_operational_kpis AS
SELECT
  date_trunc('hour', start_timestamp) AS kpi_hour,
  workflow_type,
  COUNT(*)::INT                       AS total_runs,
  COUNT(*) FILTER (WHERE status='SUCCESS')::INT AS successful_runs,
  COUNT(*) FILTER (WHERE status='FAILED')::INT  AS failed_runs,
  (COUNT(*) FILTER (WHERE status='SUCCESS') * 100.0 / NULLIF(COUNT(*),0))::NUMERIC(5,2) AS success_rate_percent,
  ROUND(AVG(execution_time_ms))::INT  AS avg_execution_time_ms
FROM workflow_runs
GROUP BY 1,2;

-- Compliance KPIs (30d)
CREATE OR REPLACE VIEW v_compliance_kpis AS
SELECT
  date_trunc('day', event_timestamp) AS kpi_date,
  event_type,
  COUNT(*)::INT AS total_events,
  COUNT(*) FILTER (WHERE compliance_status='COMPLIANT')::INT AS compliant_events,
  COUNT(*) FILTER (WHERE compliance_status IN ('VIOLATION','BLOCKED'))::INT AS violation_events,
  (COUNT(*) FILTER (WHERE compliance_status='COMPLIANT') * 100.0 / NULLIF(COUNT(*),0))::NUMERIC(5,2) AS compliance_rate_percent
FROM compliance_events
WHERE event_timestamp >= NOW() - INTERVAL '30 days'
GROUP BY 1,2;

-- Financial KPIs (30d window)
CREATE OR REPLACE VIEW v_financial_kpis AS
SELECT
  SUM(CASE WHEN metric_type='revenue' THEN amount_eur ELSE 0 END) AS revenue_eur,
  SUM(CASE WHEN metric_type='cost'    THEN amount_eur ELSE 0 END) AS cost_eur,
  SUM(CASE WHEN metric_type='mrr'     THEN amount_eur ELSE 0 END) AS mrr_eur,
  CASE WHEN SUM(CASE WHEN metric_type='revenue' THEN amount_eur ELSE 0 END) > 0
       THEN ((SUM(CASE WHEN metric_type='revenue' THEN amount_eur ELSE 0 END) - SUM(CASE WHEN metric_type='cost' THEN amount_eur ELSE 0 END))
             / SUM(CASE WHEN metric_type='revenue' THEN amount_eur ELSE 0 END) * 100.0)
       ELSE NULL END AS gross_margin_percent
FROM financial_metrics
WHERE metric_date >= CURRENT_DATE - INTERVAL '30 days';

-- Micro-HQ KPIs (90d window)
CREATE OR REPLACE VIEW v_micro_hq_kpis AS
SELECT
  AVG(presence_compliance_percent) AS presence_avg_percent,
  SUM(ciga_value_generated_eur)    AS ciga_value_eur,
  CASE WHEN SUM(board_meetings_held)>0
       THEN (SUM(board_meetings_in_jurisdiction) * 100.0 / SUM(board_meetings_held))
       ELSE NULL END               AS board_in_jurisdiction_percent,
  AVG(documentation_compliance_percent) AS documentation_score
FROM micro_hq_substance
WHERE record_date >= CURRENT_DATE - INTERVAL '90 days';

-- API performance (last 5 minutes)
CREATE OR REPLACE VIEW v_api_performance AS
SELECT
  ROUND(AVG(execution_time_ms))::INT AS avg_response_time_ms
FROM workflow_runs
WHERE start_timestamp >= NOW() - INTERVAL '5 minutes'
  AND (workflow_type='api' OR workflow_name ILIKE 'api%%');

-- System health (uptime based on success rate in last 24h)
CREATE OR REPLACE VIEW v_system_health AS
SELECT
  'core'::TEXT AS component,
  (COUNT(*) FILTER (WHERE status='SUCCESS') * 100.0 / NULLIF(COUNT(*),0))::NUMERIC(5,2) AS uptime_percent
FROM workflow_runs
WHERE start_timestamp >= NOW() - INTERVAL '24 hours';

-- System health status (traffic-light mapping)
CREATE OR REPLACE VIEW v_system_health_status AS
SELECT
  CASE
    WHEN uptime_percent >= 98 THEN 'healthy'
    WHEN uptime_percent >= 95 THEN 'warning'
    ELSE 'critical'
  END AS status,
  uptime_percent
FROM v_system_health;

-- Agent performance (close-rate by agent, last 30d)
CREATE OR REPLACE VIEW v_agent_performance AS
SELECT
  assigned_agent AS agent,
  (COUNT(*) FILTER (WHERE closed_timestamp IS NOT NULL AND stage='closed_won') * 100.0 / NULLIF(COUNT(*),0))::NUMERIC(5,2)
    AS success_rate_percent
FROM sales_pipeline
WHERE created_timestamp >= NOW() - INTERVAL '30 days'
GROUP BY assigned_agent;

-- Abort criteria status (7–14d examples)
CREATE OR REPLACE VIEW v_abort_criteria_status AS
SELECT 'sales_performance'::TEXT AS category, 'lead_response_time_hours'::TEXT AS metric_name,
       AVG(response_time_hours) AS current_value, 4.0::NUMERIC AS abort_threshold,
       CASE WHEN AVG(response_time_hours) > 4.0 THEN 'ABORT' ELSE 'OK' END AS status,
       'Average lead response time exceeds 4 hours'::TEXT AS description
FROM sales_pipeline
WHERE created_timestamp >= NOW() - INTERVAL '7 days'
UNION ALL
SELECT 'operational_performance','workflow_success_rate_percent',
       (COUNT(*) FILTER (WHERE status='SUCCESS') * 100.0 / NULLIF(COUNT(*),0))::NUMERIC,
       85.0::NUMERIC,
       CASE WHEN (COUNT(*) FILTER (WHERE status='SUCCESS') * 100.0 / NULLIF(COUNT(*),0)) < 85.0 THEN 'ABORT' ELSE 'OK' END,
       'Workflow success rate below 85%'
FROM workflow_runs
WHERE start_timestamp >= NOW() - INTERVAL '7 days';
