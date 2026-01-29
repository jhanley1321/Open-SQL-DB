# from docker_runner import DockerRunner
# from sql_connector import SQLConnector
# from exchange_connectors.ccxt_connector import CCXTETL
from hanley import Hanley 






# def main():
#     # DockerRunner().run()

#     sql = SQLConnector()
#     sql.connect()

#     rows = sql.query()
#     print(rows)

#     exc = CCXTETL()
    
#     exc.connect_exchange()
#     df = exc.get_ohlcv_df(symbol="BTC/USDT", timeframe="1d")
#     print(df.head())
#     print("rows:", len(df))


def main():
    han = Hanley()
    # han.docker.run()


  
    han.sql.connect()

    rows = han.sql.query()
    print(rows)

   
    
    han.ccxt.connect_exchange()
    df = han.ccxt.get_ohlcv_df(symbol="BTC/USDT", timeframe="1d")
    print(df.head())
    # print("rows:", len(df))


if __name__ == "__main__":
    main()