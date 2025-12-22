#!/bin/sh
set -e

# Ждем доступность PostgreSQL через попытку выполнения миграции
echo "Waiting for PostgreSQL to be ready..."

until python3 -c "
import psycopg2
import os
import time
from dotenv import load_dotenv

load_dotenv()

dbname = os.getenv('POSTGRES_DB')
user = os.getenv('POSTGRES_USER')
password = os.getenv('POSTGRES_PASSWORD')
host = os.getenv('POSTGRES_HOST')
port = os.getenv('POSTGRES_PORT')

for i in range(30):
    try:
        conn = psycopg2.connect(
            dbname=dbname,
            user=user,
            password=password,
            host=host,
            port=port
        )
        conn.close()
        print('PostgreSQL соединение установлено')
        exit(0)
    except Exception as e:
        if i == 29:
            print(f'Ошибка подключения к PostgreSQL после 30 попыток: {e}')
            exit(1)
        time.sleep(1)
" 2>/dev/null; do
  echo "PostgreSQL не доступен"
  sleep 1
done

echo "PostgreSQL запущен - запускаем миграции"
python3 manage.py migrate

echo "Стартуем Django сервер"
exec "$@"