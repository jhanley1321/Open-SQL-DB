
-- Create a view for ticker lookup
CREATE OR REPLACE VIEW public.vw_ticker_lookup AS
SELECT
    ticker_id,
    ticker_symbol
FROM public.tickers;

-- Create a view for exchange lookup
CREATE OR REPLACE VIEW public.vw_exchange_lookup AS
SELECT
    exchange_id,
    exchange_name
FROM public.exchanges;

-- Create a view for exchange + ticker + asset type lookup
CREATE OR REPLACE VIEW public.vw_exchange_ticker_asset_lookup AS
SELECT 
    e.exchange_id,
    e.exchange_name, 
    e.active AS exchange_active,
    t.ticker_id,
    t.ticker_symbol,
    t.asset_type_id,
    at.asset_type_name
FROM public.exchanges e
INNER JOIN public.tickers t
    ON e.exchange_id = t.exchange_id
INNER JOIN public.asset_types at
    ON t.asset_type_id = at.asset_type_id;

-- Create a view for OHLCV data with ticker_name and exchange_name
CREATE OR REPLACE VIEW crypto.vw_ohlcv_daily AS
SELECT
    ohlcv.ohlcv_id,
    t.ticker_name,
    e.exchange_name,
    ohlcv.date,
    ohlcv.open,
    ohlcv.high,
    ohlcv.low,
    ohlcv.close,
    ohlcv.volume
FROM crypto.ohlcv_daily ohlcv
JOIN public.tickers t ON ohlcv.ticker_id = t.ticker_id
JOIN public.exchanges e ON ohlcv.exchange_id = e.exchange_id;

-- Create View for Decomposition (residual bug fixed; cyclical set to 0 for now)
CREATE OR REPLACE VIEW crypto.vw_ohlcv_daily_decomposed AS
WITH moving_averages AS (
    SELECT 
        date,
        ticker_id,
        close,

        -- Trend: centered moving average (use PARTITION BY ticker_id so tickers don't mix)
        AVG(close) OVER (
            PARTITION BY ticker_id
            ORDER BY date
            ROWS BETWEEN 7 PRECEDING AND 7 FOLLOWING
        ) AS trend_component,

        -- Seasonal: simple day-of-week effect (still approximate)
        close - AVG(close) OVER (
            PARTITION BY ticker_id, EXTRACT(DOW FROM date)
            ORDER BY date
            ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
        ) AS seasonal_component
    FROM crypto.ohlcv_daily
),
components AS (
    SELECT 
        date,
        ticker_id,
        close,
        trend_component,
        seasonal_component,

        -- Cyclical: not reliably estimated in this SQL approach; set to 0
        0::NUMERIC AS cyclical_component,

        -- Residual: what's left after trend + seasonal (and cyclical=0)
        (close - COALESCE(trend_component, close) - COALESCE(seasonal_component, 0)) AS residual_component
    FROM moving_averages
)
SELECT 
    date,
    ticker_id,
    close AS original_close,
    COALESCE(trend_component, close) AS trend_component,
    COALESCE(seasonal_component, 0) AS seasonal_component,
    cyclical_component,
    COALESCE(residual_component, 0) AS residual_component
FROM components
ORDER BY ticker_id, date;

-- Add comments to the views
COMMENT ON VIEW public.vw_ticker_lookup IS 'View of ticker IDs and symbols from the tickers table.';
COMMENT ON VIEW public.vw_exchange_lookup IS 'View of exchange IDs and names from the exchanges table.';
COMMENT ON VIEW public.vw_exchange_ticker_asset_lookup IS 'Lookup view combining exchange, ticker, and asset type information.';
COMMENT ON VIEW crypto.vw_ohlcv_daily IS 'OHLCV daily view enriched with ticker_name and exchange_name.';
COMMENT ON VIEW crypto.vw_ohlcv_daily_decomposed IS
    'Approximate decomposition of close into trend + seasonal + residual. Cyclical is set to 0 (placeholder).';
