import mysql.connector

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "password",
    "database": "face_recognition_db"
}

try:
    conn = mysql.connector.connect(**DB_CONFIG)
    if conn.is_connected():
        print("Connected to MySQL successfully!")
    conn.close()
except mysql.connector.Error as e:
    print(f"Error: {e}")
