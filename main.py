from sql_loader import SQLConnector


def main():
    sql = SQLConnector()
    sql.connect()

if __name__ == "__main__":
    main()