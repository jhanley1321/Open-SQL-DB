from docker_runner import DockerRunner
from sql_connector import SQLConnector
from exchange_connectors.ccxt_connector import CCXTETL


class Hanley():
    def __init__(self):
        self.docker = DockerRunner()
        self.sql = SQLConnector()
        self.ccxt = CCXTETL()

    
   

    
    


