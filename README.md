# Open-SQL-DB

Open-SQL-DB is a container-friendly PostgreSQL + TimescaleDB database designed for storing time-series market data. It provides a reusable database backend for exchanges, tickers, asset types, and OHLCV data, intended to be consumed by external ETL pipelines, analytics systems, and ML workflows.

This repository focuses strictly on database structure, schema, and lifecycle management. It is not an all-in-one ETL solution.

---

## Overview

Open-SQL-DB is a standalone database layer built on PostgreSQL with the TimescaleDB extension. It is optimized for time-series workloads such as OHLCV candle data and is meant to act as a shared persistence layer for other projects.

The goal is to provide a reproducible, containerized database that can be spun up locally or in development environments and then connected to by external services.

---

## Features

- PostgreSQL with TimescaleDB
- Optimized for time-series storage and querying
- Schema for exchanges, tickers, asset types, and daily OHLCV data
- Docker-based setup
- Python entry points for orchestration and initialization
- Sample data included for testing

---

## Prerequisites

- Docker (installed and running)
- Python 3.8+
- Git
- Terminal or command prompt
- Optional: Python virtual environment

---

## Quick Start

Clone the repository and enter the project directory:

git clone https://github.com/jhanley1321/Open-SQL-DB.git  
cd Open-SQL-DB  

Run the main entry point:
```
python main.py  
```

This will start the TimescaleDB Docker container, initialize the database, apply the schema, and leave the database running and ready for connections.

---

## Manual Docker Usage

Create a .env file in the project root with your PostgreSQL credentials:
```
POSTGRES_USER=postgres  
POSTGRES_PASSWORD=postgres  
POSTGRES_DB=timescaledb
```

Start the database on Windows:
```
run-open-sql-db.bat  
```
Stop the database:

```
docker stop timescaledb  
docker rm timescaledb
```

Reset the database (destructive, removes all data and volumes):

```
docker stop timescaledb  
docker rm timescaledb  
docker volume rm timescale_data
```

---

## Intended Usage

This repository is intended to act as a shared database backend.

Typical use cases include feeding OHLCV data from ETL pipelines, powering analytics and BI dashboards, serving as a data source for ML workflows, and storing market metadata and reference data.

All ingestion and business logic live outside this repository.

---

## Repository Structure

Open-SQL-DB/  
database/            Database initialization logic  
docker_utility/      Docker helpers  
sql/                 SQL schema and table definitions  
etl_pipeline.py      Example ETL interface (non-production)  
ohlcv_manager.py     OHLCV helpers  
hanley.py            Utility or CLI helpers  
main.py              Primary orchestration entry point  
run-open-sql-db.bat  Docker startup script (Windows)  
README.md  

---

## Commit Message Conventions

feat: new feature  
fix: bug fix  
docs: documentation only  
style: formatting or whitespace changes  
refactor: refactoring without behavior change  
perf: performance improvements  
test: tests  
ci: CI/CD related changes  
chore: maintenance  
wip: work in progress  

---




## Contact

Email: carljames1321@gmail.com  
LinkedIn: https://www.linkedin.com/in/jchanley/
