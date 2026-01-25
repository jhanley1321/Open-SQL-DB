

-- Make sure the TimescaleDB extension is installed and enabled (outside transaction)
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Create the crypto schema if it doesn't exist (outside transaction)
CREATE SCHEMA IF NOT EXISTS crypto;

-- NOTE:
-- Step 1 upgrade = idempotent init. So we DO NOT DROP tables here.
-- If you want a full reset, we will add a separate reset script later.

-- Create Asset Types Table
CREATE TABLE IF NOT EXISTS asset_types (
    asset_type_id SERIAL PRIMARY KEY,
    asset_type_name VARCHAR(50) NOT NULL UNIQUE
);

-- Create Exchanges Table
CREATE TABLE IF NOT EXISTS exchanges (
    exchange_id SERIAL PRIMARY KEY,
    exchange_name VARCHAR(100) NOT NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

-- Create Exchange Asset Types Junction Table
CREATE TABLE IF NOT EXISTS exchange_asset_types (
    exchange_id INTEGER NOT NULL REFERENCES exchanges(exchange_id),
    asset_type_id INTEGER NOT NULL REFERENCES asset_types(asset_type_id),
    PRIMARY KEY (exchange_id, asset_type_id)
);

-- Create Tickers Table
CREATE TABLE IF NOT EXISTS tickers (
    ticker_id SERIAL PRIMARY KEY,
    ticker_symbol VARCHAR(50) NOT NULL,
    ticker_name VARCHAR(50) NOT NULL,
    asset_type_id INTEGER NOT NULL REFERENCES asset_types(asset_type_id),
    exchange_id INTEGER NOT NULL REFERENCES exchanges(exchange_id),
    trading BOOLEAN NOT NULL,
    CONSTRAINT unique_ticker_exchange
      UNIQUE (ticker_symbol, ticker_name, asset_type_id, exchange_id),
    CONSTRAINT valid_exchange_asset_type
      FOREIGN KEY (exchange_id, asset_type_id)
      REFERENCES exchange_asset_types (exchange_id, asset_type_id)
);

-- Create crypto.ohlcv_daily Table
CREATE TABLE IF NOT EXISTS crypto.ohlcv_daily (
    ohlcv_id SERIAL,
    ticker_id INTEGER NOT NULL REFERENCES tickers(ticker_id),
    exchange_id INTEGER NOT NULL REFERENCES exchanges(exchange_id),
    date DATE NOT NULL,
    open NUMERIC(18,6) NOT NULL,
    high NUMERIC(18,6) NOT NULL,
    low NUMERIC(18,6) NOT NULL,
    close NUMERIC(18,6) NOT NULL,
    volume NUMERIC(18,6) NOT NULL,
    PRIMARY KEY (ticker_id, exchange_id, date)
);

-- After the tables exist, create the hypertable and indexes
-- (Timescale will no-op if it already exists as a hypertable due to if_not_exists => TRUE)

SELECT create_hypertable(
    'crypto.ohlcv_daily',
    'date',
    partitioning_column => 'ticker_id',
    number_partitions => 8,
    if_not_exists => TRUE
);

-- Create indexes after hypertable creation
CREATE INDEX IF NOT EXISTS idx_tickers_exchange_id ON tickers(exchange_id);
CREATE INDEX IF NOT EXISTS idx_tickers_symbol ON tickers(ticker_symbol);
CREATE INDEX IF NOT EXISTS idx_tickers_asset_type ON tickers(asset_type_id);

CREATE INDEX IF NOT EXISTS idx_ohlcv_date ON crypto.ohlcv_daily(date);
CREATE INDEX IF NOT EXISTS idx_ohlcv_ticker_date ON crypto.ohlcv_daily(ticker_id, date, exchange_id);
CREATE INDEX IF NOT EXISTS idx_ohlcv_exchange_date ON crypto.ohlcv_daily(exchange_id, date);

CREATE INDEX IF NOT EXISTS idx_exchange_asset_types_asset_type_id ON exchange_asset_types(asset_type_id);
