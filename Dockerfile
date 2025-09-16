# Base image
FROM python:3.9-slim

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory inside container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libmariadb-dev \
    build-essential \
    default-mysql-client \
    mariadb-client \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app/

# Expose Django port
EXPOSE 8000

# Run server with wait-for-MySQL
# Using env variables from .env file: DB_HOST, DB_USER, DB_PASSWORD
CMD ["sh", "-c", "\
    echo 'Waiting for MySQL to be ready...' && \
    until mysqladmin ping -h \"$DB_HOST\" -u\"$DB_USER\" -p\"$DB_PASSWORD\" --silent; do \
        sleep 5; \
    done && \
    echo 'MySQL is ready. Running migrations...' && \
    python manage.py migrate && \
    echo 'Starting Django server...' && \
    python manage.py runserver 0.0.0.0:8000"]
