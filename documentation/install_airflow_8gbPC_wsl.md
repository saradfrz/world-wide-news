# Install Airflow

## Setup the OS

1. Install WSL <br>
```
wsl --unregister Ubuntu-22.04
```


```
wsl --install Ubuntu-22.04
```

3. Configure the terminal


```
nano .bash_profile
```

```
# Define colors
MACHINE_COLOR="\[\033[93m\]"
USER_COLOR="\[\033[95m\]"
DIRECTORY_COLOR="\[\033[96m\]"
RESET_COLOR="\[\033[0m\]"

# Set the prompt format
export PS1="$MACHINE_COLOR\h\[$(echo -e "\xF0\x9F\x90\xA7")\]$USER_COLOR\[$USER@\]$RESET_COLOR$DIRECTORY_COLOR\w$RESET_COLOR\\$ "
```
```
source .bash_profile
```

3. Update packages <br>

```
sudo apt update && sudo apt upgrade
```

4. Install dependencies <br>
```
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev wget libbz2-dev && sudo apt install build-essential zlib1g-dev libffi-dev && sudo apt-get update -y && sudo apt-get install -y wget libczmq-dev curl libssl-dev git inetutils-telnet bind9utils freetds-dev libkrb5-dev libsasl2-dev libffi-dev libpq-dev freetds-bin build-essential default-libmysqlclient-dev apt-utils rsync zip unzip gcc && sudo apt-get clean
```

## Install Python from Source
5. Download Python 3.10 source code <br>

```
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
```
  
6. Extract the downloaded archive <br>

```
tar -xf Python-3.10.0.tgz
```

7. Navigate to the Python source directory <br>

```
cd Python-3.10.0
```
   
8. Configure the build <br>

```
 ./configure --enable-optimizations
```
 
9. Build and install Python <br>

```
make -j$(nproc)
```

```
sudo make altinstall
```
   
10. Verify the installation <br>

```
python3.10 --version
```
   
11. Cleanup (optional) <br>

```
cd .. && sudo rm -rf Python-3.10.0 && sudo rm Python-3.10.0.tgz
```

## Configure the Linux ambient

12. Create the ssh keys <br>

```
ssh-keygen -t ed25519 -C "your_email@example.com"
```
```
git config --global user.email "you@example.com"
```
```
git config --global user.name "Your Name"
```
13. Go to airflow directory <br>

```
sudo mkdir /home/<user>/airflow
```
```
sudo chmod -R 777 /home/<user>/airflow
```
```
sudo mkdir /home/<user>/airflow
```

14. Clone the Airflow project <br>

```
git clone git@github.com:saradfrz/world-wide-news.git .
```
```
git config --global --add safe.directory /airflow
```

15. Install all tools and dependencies that can be required by Airflow <br>
```
sudo apt-get update -y && 
sudo apt-get install -y wget libczmq-dev curl libssl-dev git inetutils-telnet bind9utils freetds-dev libkrb5-dev libsasl2-dev libffi-dev libpq-dev freetds-bin build-essential default-libmysqlclient-dev apt-utils rsync zip unzip gcc && sudo apt-get clean
```
## Install Postgres
16. Install Postgres from Apt repository<br>
```bash 
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
```
17. Login with the postgres terminal user <br>

```
sudo -i -u postgres
```
18. Login to postgres <br>
```
psql
```
19. Create the airflow database
```
ALTER USER postgres WITH PASSWORD 'new_password';
```
```
CREATE DATABASE airflow_db;
```
```
CREATE USER airflow WITH PASSWORD 'radioactive';
```
```
GRANT ALL PRIVILEGES ON DATABASE airflow_db TO airflow;
```
```
GRANT ALL PRIVILEGES ON SCHEMA public TO airflow;
```
```
ALTER DATABASE airflow_db OWNER TO airflow
```
20. Grant permissions to airflow user connections <br>
```
sudo nano  /etc/postgresql/16/main/pg_hba.conf
```
Add the following line <br>
```
host    all             airflow         127.0.0.1/32            scram-sha-256
```
**Useful commands** <br>
```
# Open pg_hba.config
sudo nano  /etc/postgresql/16/main/pg_hba.config
```
```
# Restart service
sudo service postgresql restart
```
```
# Login
psql -U username -d database_name -h hostname -p port
```

## Install Airflow

**Documentation** <br>
Quick Start: https://airflow.apache.org/docs/apache-airflow/stable/start.html <br>
Install from pypi: https://airflow.apache.org/docs/apache-airflow/stable/installation/installing-from-pypi.html <br>

21. Create the virtual env named sandbox  <br>

```
sudo apt update && sudo apt upgrade
```
```
python3.10 -m venv .venv
```

22. Activate the virtual environment sandbox <br>
```
source .venv/bin/activate
```

22. Export the environment variable AIRFLOW_HOME used by Airflow to store the dags folder, logs folder and configuration file <br>
```
export AIRFLOW_HOME=/home/airflow && \
export AIRFLOW_VERSION=2.8.1 && \
export PYTHON_VERSION=3.10
export AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="postgresql+psycopg2://airflow:radioactive@localhost:5432/airflow_db" && \
export AIRFLOW__CORE__LOAD_EXAMPLES=False && \
export AIRFLOW__CORE__EXECUTOR=LocalExecutor
```

23. Install the version 2.0.2 of apache-airflow with all subpackages defined between square brackets. (Notice that you can still add subpackages after all, you will use the same command with different subpackages even if Airflow is already installed) <br>

```
pip install "apache-airflow[crypto,celery,postgres,cncf.kubernetes,docker]==${AIRFLOW_VERSION}" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
```

26. Install the postgres plugin <br>
```
pip install wheel
```
```
pip install psycopg2
```

28. Initialise the metadatabase <br>
```
airflow db migrate
```

In case of error:
```
psql -U postgres -d airflow_db -h localhost -p 5432
```

29. Configure `airflow.cfg` to point to the postgres database <br>
```
sql_alchemy_conn = postgresql+psycopg2://airflow:radioactive@localhost:5432/airflow_db
```

31. Create admin user <br>
```
airflow users create -u admin -f admin -l admin -r Admin -e admin@airflow.com -p mypassword
```

33. Start Airflow’s scheduler in background <br>
```
airflow scheduler &
```
```
airflow webserver &
```

## Next uses

34. Execute the start.sh file
```
source ./start.sh
```

# Troubleshoot <br>

## Restart
```
kill $(ps aux | grep '/home/airflow/.venv/bin/python3.10' | grep -v grep | awk '{print $2}')
export AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="postgresql+psycopg2://airflow:radioactive@localhost:5432/airflow_db" && export AIRFLOW__CORE__LOAD_EXAMPLES=False && export AIRFLOW__CORE__EXECUTOR=LocalExecutor
airflow scheduler &
airflow webserver &
```
