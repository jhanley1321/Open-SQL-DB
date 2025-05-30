-- Enable TimescaleDB extension
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Create the base table with correct primary key
CREATE TABLE IF NOT EXISTS pytrends (
    id SERIAL,
    topic TEXT NOT NULL,
    date DATE NOT NULL,
    score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
    PRIMARY KEY (topic, date)
);

-- Convert to a TimescaleDB hypertable
SELECT create_hypertable('pytrends', 'date', 
                         chunk_time_interval => INTERVAL '1 month',
                         if_not_exists => TRUE);

-- Create indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_pytrends_topic ON pytrends (topic);
CREATE INDEX IF NOT EXISTS idx_pytrends_date ON pytrends (date);

-- Enable compression on the hypertable
ALTER TABLE pytrends SET (
    timescaledb.compress,
    timescaledb.compress_segmentby = 'topic'
);

-- Add compression policy (compress data older than 30 days)
SELECT add_compression_policy('pytrends', INTERVAL '30 days');