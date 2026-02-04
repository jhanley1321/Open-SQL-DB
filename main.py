
from hanley import Hanley 





def main():
    han = Hanley()
    # han.docker.run()


  
    # han.insert_ohlcv()
    # han.read_ohlcv(table_name="ohlcv_daily", schema="crypto")
    han.ccxt.connect_exchange()
    han.update_ohlcv()
 


if __name__ == "__main__":
    main()