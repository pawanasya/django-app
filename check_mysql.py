import pymysql
import os
import sys

host = os.environ.get('DB_HOST', 'localhost')
user = os.environ.get('DB_USER', 'root')
password = os.environ.get('DB_PASSWORD', '')
database = os.environ.get('DB_NAME', '')
port = int(os.environ.get('DB_PORT', 3306))

print(f"[CHECK_MYSQL] Trying to connect to MySQL at {host}:{port} as user '{user}'")

try:
    conn = pymysql.connect(
        host=host,
        user=user,
        password=password,
        database=database,
        port=port,
        ssl={"ssl": {}},  # disables SSL errors
    )
    conn.close()
    print("[CHECK_MYSQL] MySQL connection successful!")
except Exception as e:
    print(f"[CHECK_MYSQL] MySQL connection failed: {e}")
    sys.exit(1)
