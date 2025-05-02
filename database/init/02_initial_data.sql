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
    ('BTC', 'Bitcoin', 1, 1, true),
    ('AAPL', 'Apple Inc', 2, 2, true);

COMMIT;