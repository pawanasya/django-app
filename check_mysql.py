import pymysql
import os
import sys

try:
    conn = pymysql.connect(
        host=os.environ.get('DB_HOST', 'localhost'),
        user=os.environ.get('DB_USER'),
        password=os.environ.get('DB_PASSWORD'),
        database=os.environ.get('DB_NAME'),
        port=int(os.environ.get('DB_PORT', 3306)),
        ssl={}  # Disable SSL
    )
    conn.close()
except Exception:
    sys.exit(1)
