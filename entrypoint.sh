#!/bin/sh
echo "Waiting for MySQL..."

# Use pymysql in a separate Python script for clarity
while ! python check_mysql.py; do
    echo "Waiting for MySQL..."
    sleep 5
done

echo "MySQL is ready. Running migrations..."
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
