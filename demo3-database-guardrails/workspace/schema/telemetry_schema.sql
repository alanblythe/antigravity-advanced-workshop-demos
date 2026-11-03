-- Enterprise BigQuery Telemetry Dataset Schema & Idempotent Seeding
CREATE SCHEMA IF NOT EXISTS `telemetry`
OPTIONS(location="us-central1");

CREATE TABLE IF NOT EXISTS `telemetry.events` (
    event_id STRING NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    service_name STRING NOT NULL,
    operation STRING NOT NULL,
    status_code INT64 NOT NULL,
    latency_ms FLOAT64 NOT NULL,
    error_message STRING
)
PARTITION BY DATE(timestamp)
CLUSTER BY service_name, status_code;

-- Idempotent Seed Data (MERGE prevents duplicate rows on re-runs)
MERGE `telemetry.events` T
USING (
  SELECT 'ev_001' AS event_id, CURRENT_TIMESTAMP() AS timestamp, 'order-service' AS service_name, 'checkout' AS operation, 200 AS status_code, 45.2 AS latency_ms, CAST(NULL AS STRING) AS error_message UNION ALL
  SELECT 'ev_002', CURRENT_TIMESTAMP(), 'order-service', 'checkout', 500, 1205.4, 'Internal database timeout' UNION ALL
  SELECT 'ev_003', CURRENT_TIMESTAMP(), 'auth-service', 'validate_token', 200, 12.1, NULL UNION ALL
  SELECT 'ev_004', CURRENT_TIMESTAMP(), 'billing-service', 'charge_card', 400, 310.8, 'Invalid card token' UNION ALL
  SELECT 'ev_005', CURRENT_TIMESTAMP(), 'order-service', 'checkout', 503, 850.0, 'Downstream service unavailable'
) S
ON T.event_id = S.event_id
WHEN NOT MATCHED THEN
  INSERT (event_id, timestamp, service_name, operation, status_code, latency_ms, error_message)
  VALUES (S.event_id, S.timestamp, S.service_name, S.operation, S.status_code, S.latency_ms, S.error_message);
