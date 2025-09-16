#!/bin/sh

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
until mysqladmin ping -h "$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent --ssl-mode=DISABLED; do
    echo "Waiting for MySQL..."
    sleep 5
done

# Run migrations
python manage.py migrate

# Start Django server
python manage.py runserver 0.0.0.0:8000
