@echo off
REM Set the environment variable for the PostgreSQL password from the .env file
setlocal
for /f "tokens=1,2 delims==" %%a in (c:\Data_Tools\Open_SQL_DB\.env) do (
    if "%%a"=="DB_PASSWORD" set DB_PASSWORD=%%b
)

REM Navigate to the project directory
cd /d c:\Data_Tools\Open_SQL_DB

REM Start the Docker container using Docker Compose
docker-compose up -d

REM Verify the container is running
docker ps

REM Wait for the container to be fully up and running
timeout /t 10 /nobreak

REM Connect to the PostgreSQL database and confirm the connection
docker exec -it timescaledb psql -U postgres -d postgres -c "SELECT 1 AS connected" > connection_check.txt
type connection_check.txt
if %errorlevel% neq 0 (
    echo Failed to connect to the PostgreSQL database.
    goto end
)

REM List all schemas in the database after running the scripts
docker exec -it timescaledb psql -U postgres -d postgres -c "\dn" > schemas_list.txt
type schemas_list.txt

REM Pause the script to keep the window open
pause
endlocal

:end
REM Clean up temporary files
del connection_check.txt
del schemas_list.txt