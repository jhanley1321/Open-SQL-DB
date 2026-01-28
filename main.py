from docker_runner import DockerRunner
from sql_connector import SQLConnector
from exchange_connectors.ccxt_connector import CCXTETL






def main():
    # DockerRunner().run()

    sql = SQLConnector()
    sql.connect()

    rows = sql.query()
    print(rows)

    exc = CCXTETL()
    
    exc.connect_exchange()
    df = exc.get_ohlcv_df(symbol="BTC/USDT", timeframe="1d", limit=None)
    print(df.head())
    print("rows:", len(df))


if __name__ == "__main__":
    main()