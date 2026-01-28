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
