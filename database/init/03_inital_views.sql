-- File: c:\Data_Tools\Open_SQL_DB\database\init\03_inital_views.sql

-- Create a view for ticker lookup
CREATE OR REPLACE VIEW public.vw_ticker_lookup AS
SELECT
    ticker_id,
    ticker_name
FROM
    public.tickers;

-- Create a view for exchange lookup
CREATE OR REPLACE VIEW public.vw_exchange_lookup AS
SELECT
    exchange_id,
    exchange_name
FROM
    public.exchanges;

-- Create a view for OHLCV data with ticker_name and exchange_name
CREATE OR REPLACE VIEW public.vw_ohlcv_daily AS
SELECT
    ohlcv_id,
    t.ticker_name,
    e.exchange_name,
    ohlcv.date,
    ohlcv.open,
    ohlcv.high,
    ohlcv.low,
    ohlcv.close,
    ohlcv.volume
FROM
    crypto.ohlcv_daily ohlcv
JOIN
    public.tickers t ON ohlcv.ticker_id = t.ticker_id
JOIN
    public.exchanges e ON ohlcv.exchange_id = e.exchange_id;

-- Add comments to the views
COMMENT ON VIEW public.vw_ticker_lookup IS 'View of ticker IDs and names from the tickers table.';
COMMENT ON VIEW public.vw_exchange_lookup IS 'View of exchange IDs and names from the exchanges table.';
COMMENT ON VIEW public.vw_ohlcv_daily IS 'View of OHLCV data from the crypto.ohlcv_daily table with ticker_name and exchange_name.';