#!/bin/sh

echo "Waiting for MySQL to be ready..."

# Use Python + PyMySQL to check connection instead of mysqladmin
until python -c "
import pymysql, os, sys
try:
    conn = pymysql.connect(
        host=os.environ.get('DB_HOST'),
        user=os.environ.get('DB_USER'),
        password=os.environ.get('DB_PASSWORD'),
        database=os.environ.get('DB_NAME'),
        port=int(os.environ.get('DB_PORT', 3306)),
        ssl={'ssl':{}}
    )
    conn.close()
except Exception as e:
    sys.exit(1)
" 2>/dev/null; do
    echo "Waiting for MySQL..."
    sleep 5
done

echo "MySQL is ready. Running migrations..."
python manage.py migrate

echo "Starting Django server..."
python manage.py runserver 0.0.0.0:8000
