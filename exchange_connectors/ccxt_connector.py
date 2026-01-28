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
        since: int | None = None,   # milliseconds since epoch (optional)
        limit: int = 365
    ) -> pd.DataFrame:
        """
        Fetch OHLCV data from the connected exchange and return as a pandas DataFrame.

        CCXT returns rows: [timestamp_ms, open, high, low, close, volume]
        """
        if self.exchange is None:
            raise RuntimeError("No exchange connected. Call connect_exchange() first.")

        rows = self.exchange.fetch_ohlcv(
            symbol=symbol,
            timeframe=timeframe,
            since=since,
            limit=limit
        )

        if not rows:
            raise RuntimeError(
                f"No OHLCV returned for exchange={self.exchange_id}, symbol={symbol}, timeframe={timeframe}"
            )

        df = pd.DataFrame(rows, columns=["timestamp", "open", "high", "low", "close", "volume"])

        # timestamp to datetime (UTC)
        df["timestamp"] = pd.to_datetime(df["timestamp"], unit="ms", utc=True)

        # ensure numeric columns are numeric
        for c in ["open", "high", "low", "close", "volume"]:
            df[c] = pd.to_numeric(df[c], errors="coerce")

        # (optional) set index
        df.set_index("timestamp", inplace=True)

        return df
