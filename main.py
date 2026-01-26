from docker_runner import DockerRunner
from sql_connector import SQLConnector


# def main():
#     sql = SQLConnector()
#     sql.connect()

# if __name__ == "__main__":
#     main()


def main():
    DockerRunner().run()

    # sql = SQLConnector()
    # sql.connect()

    # rows = sql.query("SELECT * FROM public.exchanges;")
    # print(rows)


if __name__ == "__main__":
    main()