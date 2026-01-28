from docker_runner import DockerRunner
from sql_connector import SQLConnector
from exchange_connectors.ccxt_connector import CCXTETL






def main():
    # DockerRunner().run()

    sql = SQLConnector()
    sql.connect()

    rows = sql.query()
    print(rows)

    exchanges = CCXTETL()
    
    exchanges.connect_exchange()


if __name__ == "__main__":
    main()