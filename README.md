# Open SQL DB
The TiemscaleDB and PostgreSQL databas. 




# Running the App
First, make sure that you edit the .env file. Remove the .example at the end and add your password in the .env file before you start. 

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


# How To Use


For now, you will have to manually set up your own solution if you want to use this yourself now. There will be a seperate repo with a sepreate container for mantaining data pipelines that will hanlde the data into this database. Note that there may be isntances where other repos will connect direclty to this one as well. 


# Purpose
This Timescale DB and PostgreSQL database will store orders, tickers, exchanges, asset types, OHLCV data, and more as we build more systems.


# Current Features
* Store data for exchanges, tickers, and asset type.
* Store OHLCV daily table using Timescale DB for better performance and scalability. 
* Docker container and .bat script for quick and easy setup.




# Conventional Commit Types

## 🔧 Core Conventional Commit Types

| Type         | Description                                                                       |
|--------------|-----------------------------------------------------------------------------------|
| **feat**     | A new feature                                                                     |
| **fix**      | A bug fix                                                                         |
| **docs**     | Documentation only changes                                                        |
| **style**    | Changes that do not affect the meaning of the code (white-space, formatting, etc) |
| **refactor** | A code change that neither fixes a bug nor adds a feature                         |
| **perf**     | A code change that improves performance                                           |
| **test**     | Adding or correcting tests                                                        |
| **build**    | Changes that affect the build system or external dependencies (e.g., npm)         |
| **ci**       | Changes to CI configuration files and scripts (e.g., GitHub Actions, Travis)      |
| **chore**    | Other changes that don't modify src or test files (e.g., release notes, configs)  |
| **revert**   | Reverts a previous commit                                                         |

## 🧪 Extended/Optional Types

| Type         | Description                                                         |
|--------------|---------------------------------------------------------------------|
| **wip**      | Work in progress; not ready for production                          |
| **merge**    | A merge commit                                                      |
| **hotfix**   | A quick fix for a critical issue                                    |
| **security** | Security-related changes                                            |
| **deps**     | Updating or pinning dependencies                                    |
| **infra**    | Infrastructure-related changes (e.g., Terraform, Dockerfiles)       |
| **ux**       | Changes affecting user experience (not necessarily features)        |
| **i18n**     | Internationalization and localization changes                       |
| **release**  | Version bumps, changelog updates, tagging, etc.                     |
| **env**      | Environment-related changes (e.g., `.env` files, deployment configs)|

## 📚 Optional Scopes

You can add an optional scope in parentheses to clarify what part of the app is affected.

# Contact Me

If you'd like to get in touch, feel free to reach out via email or connect with me on LinkedIn:

- **Email:** [carljames1321@gmail.com](mailto:carljames1321@gmail.com)
- **LinkedIn:** [https://www.linkedin.com/in/jchanley/](https://www.linkedin.com/in/jchanley/)