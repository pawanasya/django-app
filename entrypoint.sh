#!/bin/sh

# Wait for MySQL to be ready
until mysqladmin ping -h "$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
    echo "Waiting for MySQL..."
    sleep 5
done

# Apply migrations and start Django server
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
