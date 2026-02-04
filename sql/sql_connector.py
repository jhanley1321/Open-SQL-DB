import os
import pandas as pd
from sqlalchemy import create_engine, text, insert, MetaData, Table
from typing import Optional, Dict, Any
from dotenv import load_dotenv

# Load .env once, globally
load_dotenv()


class SQLConnector:
    def __init__(
        self,
        host: str | None = None,
        port: int | None = None,
        database: str | None = None,
        username: str | None = None,
        password: str | None = None,
        manager=None
    ):
        self.manager = manager

        # Pull from .env first, allow overrides
        self.host = host or os.getenv("DB_HOST", "localhost")
        self.port = port or int(os.getenv("DB_PORT", 5432))
        self.database = database or os.getenv("DB_NAME", "postgres")
        self.username = username or os.getenv("DB_USER", "postgres")
        self.password = password or os.getenv("DB_PASSWORD")

        if not self.password:
            raise ValueError("DB_PASSWORD is not set (check .env)")

        self.connection_url = (
            f"postgresql+psycopg2://"
            f"{self.username}:{self.password}"
            f"@{self.host}:{self.port}/{self.database}"
        )

        self.engine = create_engine(self.connection_url)

        print("SQLLoader initialized")
        self.connect()

    def connect(self) -> None:
        with self.engine.connect() as connection:
            connection.execute(text("SELECT 1"))
        print("Database connection successful")


    def query(self, query: str = 'SELECT * FROM exchanges', **kwargs: Any) -> list:
        with self.engine.connect() as connection:
            result = connection.execute(text(query))
            rows = result.fetchall()
            return rows

    def query_full(self, query: str = 'SELECT * FROM exchanges', **kwargs: Any) -> list[Dict[str, Any]]:
        with self.engine.connect() as connection:
            result = connection.execute(text(query))
            rows = result.fetchall()
            columns = result.keys()
            return [dict(zip(columns, row)) for row in rows]
  

    def read_sql_to_df(self, table_name, schema='public', **kwargs):
        print('Fetching SQL query to DataFrame...')
        with self.engine.connect() as connection:
            df = pd.read_sql_table(table_name, con=connection, schema=schema)
        # print(df.head(10))
        if self.manager is not None:
            self.manager.df_sql = df
        print(df.head(10))
        return df


    def insert_df_to_sql(self, df=None, index = False, schema='crypto', table_name='ohlcv_daily', if_exists="append", **kwargs):
        # if df is None:
        #     df = self.manager.df_ohlcv_wrangled
        #     print(df.head())
            
            
        # add check to ensure that the shemcma does exist , BEFORE it can write to the table 

        # add check to ensure that the the column names are found

        
       
        df.to_sql(name=table_name, schema=schema, con=self.engine, if_exists=if_exists, index=index)
        print("Data inserted successfully.")




    
    # Create Method to view all shcemas

    # create method to add shcemeas

    # create method to remove schemas

    # Create method to view all Tables

    # Create method to add TAbles

    # create method to remove all data from tables

    # create method to remove talbes entirely 

    # create mehtod to list all servesr

    # create method to create new server 

    # def select_sql_values(self)