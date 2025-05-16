-- File: c:\Data_Tools\Open_SQL_DB\database\init\02_initial_data.sql

BEGIN;

-- Insert initial asset types
INSERT INTO asset_types (asset_type_name) VALUES
    ('crypto'),
    ('stocks'),
    ('forex');

-- Insert initial exchanges
INSERT INTO exchanges (exchange_name) VALUES
    ('Binance'),
    ('Alpaca Markets');

-- Insert into exchange_asset_types (assuming asset_type_id and exchange_id are 1-based and sequential)
INSERT INTO exchange_asset_types (exchange_id, asset_type_id) VALUES
    (1, 1), -- Binance supports crypto
    (2, 2); -- Alpaca Markets supports stocks

-- Insert initial tickers
INSERT INTO tickers (ticker_symbol, ticker_name, asset_type_id, exchange_id, trading) VALUES
    ('BTC/USDT', 'Bitcoin', 1, 1, true),
    ('AAPL', 'Apple Inc', 2, 2, true);

-- Insert initial OHLCV data (example, ONLY uncomment for testing)
/*
INSERT INTO crypto.ohlcv_daily (ticker_id, exchange_id, date, open, high, low, close, volume) VALUES
    (1, 1, '2023-01-01', 40000.00, 41000.00, 39000.00, 40500.00, 1000.00),
    (2, 2, '2023-01-01', 150.00, 155.00, 145.00, 152.00, 1000000.00);
*/
COMMIT;