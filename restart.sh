kill $(ps aux | grep '/home/airflow/.venv/bin/python3.10' | grep -v grep | awk '{print $2}')
export AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="postgresql+psycopg2://airflow:radioactive@localhost:5432/airflow_db" && export AIRFLOW__CORE__LOAD_EXAMPLES=False && export AIRFLOW__CORE__EXECUTOR=LocalExecutor
airflow scheduler &
airflow webserver &
