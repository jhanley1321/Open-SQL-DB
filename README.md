# Open SQL DB
The TiemscaleDB and PostgreSQL database. 



# Running The App (Recommended) 
You now only need to run:
```
python main.py 
```
The file will spin up the docker container for you by running the .bat file.

# Running The Database from the .bat file 
First, make sure that you edit the .env file. Remove the .example at the end and add your password in the .env file before you start. 


To run the .bat file use:
```
.\run-open-sql-db.bat
```


To Stop the container run 
```
docker stop timescaledb
docker rm timescaledb
```

For a complete fresh start run
```
docker stop timescaledb
docker rm timescaledb
docker volume rm timescale_data
```


# How To Use


For now, you will have to manually set up your own solution if you want to use this yourself now. There will be a separate repo with a separate container for maintaining data pipelines that will handle the data into this database. Note that there may be instances where other repos will connect directly to this one as well. 


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