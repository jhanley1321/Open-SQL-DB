
class OHLCVManager():
    def __init__(self):
        pass


    def insert_ohlcv(self, df,  overwrite, date_col='date', window=2):
        pass
        # get the the date from the data frame
        df_ohlcv_insert = df.nlargest(window, date_col)
        print(df_ohlcv_insert)
        return df_ohlcv_insert

        
    

        