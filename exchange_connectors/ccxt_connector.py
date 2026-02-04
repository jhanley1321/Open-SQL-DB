import pandas as pd
import ccxt


class CCXTETL:
    def __init__(self, exchange_id: str = "binanceus"):
        self.exchange_id = exchange_id
        self.exchange = None



    def connect_exchange(self, exchange_id: str = "binanceus") -> None:
        """
        Connect to a specific exchange and confirm connectivity.
        """
        if not hasattr(ccxt, exchange_id):
            raise ValueError(f"Unknown exchange_id: {exchange_id}")

        ExchangeCls = getattr(ccxt, exchange_id)

        self.exchange = ExchangeCls({"enableRateLimit": True})
        self.exchange_id = exchange_id

        # real network call = proof of connection
        self.exchange.load_markets()

        if not self.exchange.markets:
            raise RuntimeError(f"Connected to {exchange_id}, but no markets loaded.")

        print(f"Connected to exchange: {exchange_id}")
        print(f"Markets loaded: {len(self.exchange.markets)}")



    def get_ohlcv_df(
        self,
        symbol: str = "BTC/USDT",
        timeframe: str = "1d",
        since: int | None = None,      # ms epoch; set to get less history
        page_size: int = 10000,         # per-request page size (exchange will cap anyway)
        max_batches: int | None = None # set to 1/2/etc to intentionally get less
    ) -> pd.DataFrame:
        """
        Fetch OHLCV in batches until exhausted (or until max_batches is hit).
        Adds a simple symbol column so the DF is self-identifying.
        """
        if self.exchange is None:
            raise RuntimeError("No exchange connected. Call connect_exchange() first.")

        all_rows = []
        batches = 0
        since_ms = since

        while True:
            rows = self.exchange.fetch_ohlcv(
                symbol=symbol,
                timeframe=timeframe,
                since=since_ms,
                limit=page_size,
            )

            if not rows:
                break

            all_rows.extend(rows)

            # move forward to the next candle
            since_ms = rows[-1][0] + 1

            batches += 1
            if max_batches is not None and batches >= max_batches:
                break

        if not all_rows:
            raise RuntimeError(f"No OHLCV returned for {self.exchange_id} {symbol} {timeframe}")

        df = pd.DataFrame(all_rows, columns=["date", "open", "high", "low", "close", "volume"])
        df["date"] = pd.to_datetime(df["date"], unit="ms", utc=True)
        if timeframe == "1d":
            df["date"]  = df["date"].dt.strftime('%Y-%m-%d')

        # simple identification (your request)
        df["symbol"] = symbol
        df["exchange_name"] = self.exchange_id

        # # optional: sort + dedupe (safe, still simple)
        # df = df.drop_duplicates(subset=["date"]).sort_values("date").reset_index(drop=True)
       
       
        return df

   
        
