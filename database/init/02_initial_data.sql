-- File: database/init/02_initial_data.sql
-- Purpose: Rerunnable seed data (idempotent) with no hard-coded IDs.

BEGIN;

-- 1) Asset types (idempotent)
INSERT INTO asset_types (asset_type_name) VALUES
  ('crypto'),
  ('stocks'),
  ('forex')
ON CONFLICT (asset_type_name) DO NOTHING;

-- 2) Exchanges (idempotent)
INSERT INTO exchanges (exchange_name) VALUES
  ('Binance'),
  ('Alpaca Markets')
ON CONFLICT (exchange_name) DO NOTHING;

-- 3) Exchange ↔ Asset Types mapping (idempotent, no hard-coded IDs)
INSERT INTO exchange_asset_types (exchange_id, asset_type_id)
SELECT e.exchange_id, a.asset_type_id
FROM exchanges e
JOIN asset_types a
  ON (e.exchange_name = 'Binance' AND a.asset_type_name = 'crypto')
  OR (e.exchange_name = 'Alpaca Markets' AND a.asset_type_name = 'stocks')
ON CONFLICT (exchange_id, asset_type_id) DO NOTHING;

-- 4) Tickers (idempotent, no hard-coded IDs)
-- Note: This matches your unique constraint:
-- UNIQUE (ticker_symbol, ticker_name, asset_type_id, exchange_id)
INSERT INTO tickers (ticker_symbol, ticker_name, asset_type_id, exchange_id, trading)
SELECT
  'BTC/USDT',
  'Bitcoin',
  a.asset_type_id,
  e.exchange_id,
  TRUE
FROM exchanges e
JOIN asset_types a ON a.asset_type_name = 'crypto'
WHERE e.exchange_name = 'Binance'
ON CONFLICT (ticker_symbol, ticker_name, asset_type_id, exchange_id) DO NOTHING;

INSERT INTO tickers (ticker_symbol, ticker_name, asset_type_id, exchange_id, trading)
SELECT
  'AAPL',
  'Apple Inc',
  a.asset_type_id,
  e.exchange_id,
  TRUE
FROM exchanges e
JOIN asset_types a ON a.asset_type_name = 'stocks'
WHERE e.exchange_name = 'Alpaca Markets'
ON CONFLICT (ticker_symbol, ticker_name, asset_type_id, exchange_id) DO NOTHING;

-- 5) Optional OHLCV test data (still commented out)
-- If you ever enable this, it should also avoid hard-coded IDs.
-- Example pattern shown below:
--
INSERT INTO crypto.ohlcv_daily (ticker_id, exchange_id, date, open, high, low, close, volume)SELECT t.ticker_id, t.exchange_id, '2023-01-01', 40000.00, 41000.00, 39000.00, 40500.00, 1000.00
FROM tickers t
JOIN exchanges e ON e.exchange_id = t.exchange_id
WHERE e.exchange_name='Binance' AND t.ticker_symbol='BTC/USDT'
ON CONFLICT (ticker_id, exchange_id, date) DO NOTHING;

COMMIT;
