#!/bin/sh
echo "Waiting for MySQL to be ready..."
until mysql -h "$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --ssl-mode=DISABLED -e "SELECT 1;" &> /dev/null
do
  echo "MySQL is unavailable - sleeping"
  sleep 5
done

echo "MySQL is up - running migrations"
python manage.py migrate

echo "Starting Django server"
python manage.py runserver 0.0.0.0:8000
