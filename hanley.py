from docker_utilty.docker_runner import DockerRunner
from sql.sql_connector import SQLConnector
from exchange_connectors.ccxt_connector import CCXTETL
from ohlcv_manager import OHLCVManager
import pandas as pd




class Hanley():
    def __init__(self):
        self.docker = DockerRunner()
        self.sql = SQLConnector()
        self.ccxt = CCXTETL()
        self.ohlcv_manager = OHLCVManager()

    
    
    # get exchange table
    def get_exchange(self):
        self.sql.read_sql_to_df(table_name="exchanges", schema="public")

    
    
    
    def insert_ohlcv(self, symbol="ETH/USDT", timeframe="1d", schema='crypto', table_name='ohlcv_daily', if_exists='append' ):
        # Get exchange 
        self.get_exchange()
        
        self.ccxt.connect_exchange()
        df = self.ccxt.get_ohlcv_df(symbol=symbol, timeframe=timeframe)
        # self.sql.insert_df_to_sql(df=df, index = False, schema=schema, table_name=table_name, if_exists=if_exists) 
        # self.sql.read_sql_to_df(table_name=table_name, schema=schema)


    # Move this logic later out 
    def update_ohlcv(self,  schema="crypto", table_name="ohlcv_daily",
     timeframe="1d", symbol="BTC/USDT", exchange='Binance'):

        # get the old ohlcv data
        df_old = self.sql.read_sql_to_df(table_name=table_name, schema=schema)  
        # print(df_old.head())

   
   
       
        
        # Get exhcange ID for df
        df_ex = self.sql.read_sql_to_df(table_name='exchanges', schema='public')
        ex_dict = dict(zip(df_ex['exchange_name'], df_ex['exchange_id']))
        ex_id = ex_dict[exchange]
    

        # get exchange ID for df
        df_tic = self.sql.read_sql_to_df(table_name='tickers', schema='public')
        tic_dict = dict(zip(df_tic['ticker_symbol'], df_tic['ticker_id']))
        tic_id = tic_dict[symbol]
      
        # get  new ohlcv data
        df_new = self.ccxt.get_ohlcv_df( timeframe="1d", symbol="BTC/USDT")
        

        # Clean new ohlcv data
        df_new.drop(columns=['symbol', 'exchange_name'], inplace=True)
        df_new['exchange_id'] = ex_id
        df_new['ticker_id'] = tic_id
        print(df_old.head())
        print(df_new.head())

        # Keep only new values in df_new that are new 
        df_old["date"] = pd.to_datetime(df_old["date"], utc=True)
        df_new["date"] = pd.to_datetime(df_new["date"], utc=True)

        if df_old.empty:
            df_new_only = df_new.copy()
        else:
            cutoff = df_old["date"].max()
            df_new_only = df_new[df_new["date"] > cutoff]

        print(df_new_only)

        self.sql.insert_df_to_sql(df=df_new_only)
    
       
        
        # # return out
