-- File: c:\Data_Tools\Open_SQL_DB\database\init\03_inital_views.sql

-- Create a view for ticker lookup
CREATE OR REPLACE VIEW public.vw_ticker_lookup AS
SELECT
    ticker_id,
    ticker_symbol
FROM
    public.tickers;

-- Create a view for exchange lookup
CREATE OR REPLACE VIEW public.vw_exchange_lookup AS
SELECT
    exchange_id,
    exchange_name
FROM
    public.exchanges;

-- Create a view to exchange ticker asset lookup
CREATE VIEW public.vw_exchange_ticker_asset_lookup AS
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


-- Create View for Decomposition  (Move to datewarehouse later)
CREATE OR REPLACE VIEW crypto.vw_ohlcv_daily_decomposed AS
WITH moving_averages AS (
    -- Calculate centered moving average (Trend)
    SELECT 
        date,
        ticker_id,
        close,
        AVG(close) OVER (
            ORDER BY date
            ROWS BETWEEN 7 PRECEDING AND 7 FOLLOWING
        ) as trend_component,
        
        -- Calculate seasonal component (using 7-day seasonality for daily data)
        close - AVG(close) OVER (
            PARTITION BY EXTRACT(DOW FROM date)
            ORDER BY date 
            ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
        ) as seasonal_component
    FROM crypto.ohlcv_daily
),
components AS (
    SELECT 
        date,
        ticker_id,
        close,
        trend_component,
        seasonal_component,
        -- Calculate cyclical component (using longer-term deviations)
        (close - trend_component - seasonal_component) as cyclical_component,
        -- Calculate random/residual component
        close - trend_component - seasonal_component - 
        (close - trend_component - seasonal_component) as residual_component
    FROM moving_averages
)
SELECT 
    date,
    ticker_id,
    close as original_close,
    COALESCE(trend_component, close) as trend_component,
    COALESCE(seasonal_component, 0) as seasonal_component,
    COALESCE(cyclical_component, 0) as cyclical_component,
    COALESCE(residual_component, 0) as residual_component
FROM components
ORDER BY date;





-- Add comments to the views
COMMENT ON VIEW public.vw_ticker_lookup IS 'View of ticker IDs and names from the tickers table.';
COMMENT ON VIEW public.vw_exchange_lookup IS 'View of exchange IDs and names from the exchanges table.';
COMMENT ON VIEW public.exchange_ticker_asset_lookup IS 'Lookup view that combines exchange, ticker, and asset type information for easy querying of relationships between these entities';
COMMENT ON VIEW crypto.vw_ohlcv_daily IS 'View of OHLCV data from the crypto.ohlcv_daily table with ticker_name and exchange_name.';

-- Temporary comment
COMMENT ON VIEW crypto.vw_ohlcv_daily_decomposed IS
    'Decomposes the daily OHLCV close price into Trend, Seasonal, Cyclical, and Residual components using moving averages.';