@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM 0) Resolve PROJECT_ROOT even if this script is moved later
REM    - Works if .bat is in repo root OR in repo-root\scripts\
REM ============================================================
set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%"

REM If docker-compose.yml is not in the script folder, try parent
if not exist "%PROJECT_ROOT%docker-compose.yml" (
  for %%I in ("%SCRIPT_DIR%..\") do set "PROJECT_ROOT=%%~fI\"
)

REM If still not found, fail fast (helps when script is moved around)
if not exist "%PROJECT_ROOT%docker-compose.yml" (
  echo ERROR: Could not find docker-compose.yml.
  echo Expected it in: "%SCRIPT_DIR%" or its parent folder.
  goto end
)

cd /d "%PROJECT_ROOT%"

REM ============================================================
REM 1) Ensure logs folder exists (all generated outputs go here)
REM ============================================================
if not exist "logs" mkdir "logs"

REM ============================================================
REM 2) Load DB_PASSWORD from .env in PROJECT_ROOT
REM ============================================================
if not exist ".env" (
  echo ERROR: .env not found in "%PROJECT_ROOT%"
  echo Copy .env.example to .env and set DB_PASSWORD.
  > "logs\error.txt" echo .env missing in %PROJECT_ROOT%
  goto end
)

set "DB_PASSWORD="
for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
  if /i "%%a"=="DB_PASSWORD" set "DB_PASSWORD=%%b"
)

if "%DB_PASSWORD%"=="" (
  echo ERROR: DB_PASSWORD not set in .env
  > "logs\error.txt" echo DB_PASSWORD missing or empty in .env
  goto end
)

REM ============================================================
REM 3) Start containers
REM ============================================================
echo Starting database with docker-compose...
docker-compose up -d

REM ============================================================
REM 4) Wait for Postgres to accept connections (up to ~60s)
REM ============================================================
echo Waiting for database to accept connections...
set "READY=0"
for /L %%i in (1,1,30) do (
  docker exec timescaledb pg_isready -U postgres >nul 2>nul
  if !errorlevel! EQU 0 (
    set "READY=1"
    goto db_ready
  )
  timeout /t 2 /nobreak >nul
)

:db_ready
if "%READY%"=="0" (
  echo ERROR: Database did not become ready in time.
  > "logs\error.txt" echo pg_isready did not succeed after retries
  goto end
)

REM ============================================================
REM 5) Connection check (write output to logs)
REM ============================================================
docker exec -it timescaledb psql -U postgres -d postgres -c "SELECT 1 AS connected;" > "logs\connection_check.txt"
type "logs\connection_check.txt"

if %errorlevel% neq 0 (
  echo ERROR: Failed to connect to PostgreSQL.
  > "logs\error.txt" echo psql connection check failed
  goto end
)

REM ============================================================
REM 6) Schema list (write output to logs)
REM ============================================================
docker exec -it timescaledb psql -U postgres -d postgres -c "\dn" > "logs\schemas_list.txt"
type "logs\schemas_list.txt"

echo.
echo Done.
echo Project root: "%PROJECT_ROOT%"
echo Logs written to: "%PROJECT_ROOT%logs\"
echo.
pause

:end
endlocal