import os
import pandas as pd
from sqlalchemy import create_engine, text
from typing import Any, Dict
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