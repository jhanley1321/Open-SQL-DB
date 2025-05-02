# Open SQL DB



# How to use
To start the docker container using Docker Compose run:
```
docker-compose up -d
```

To verify the container is running:
```
docker ps
```
you should see an entry called timescaledb container.

To connect to the Timescaledb container, run 
```
docker exec -it timescaledb psql -U postgres -d postgres
```

To run the .bat file use:
```
.\run-open-sql-db.bat
```



To Stop the container run 
```
docker stop timescaledb
docker rm timescaledb
```

For a compelte fresh start run
```
docker stop timescaledb
docker rm timescaledb
docker volume rm timescale_data
```