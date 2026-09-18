


import cv2
import face_recognition
import numpy as np
import mysql.connector
import time
import pickle

# MySQL Database Configuration
DB_CONFIG = {
    "host": "localhost",
    "user": "root",  # Change to your MySQL username
    "password": "password",  # Change to your MySQL password
    "database": "face_recognition_db"
}

# Connect to MySQL Database
def connect_db():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            reg_number VARCHAR(50) UNIQUE,
            name VARCHAR(255),
            face_encoding BLOB
        )
    """)
    conn.commit()
    return conn, cursor

# Load registered faces from MySQL
def load_registered_faces():
    conn, cursor = connect_db()
    cursor.execute("SELECT reg_number, name, face_encoding FROM users")
    known_encodings = {}
    reg_numbers = {}
    
    for reg_number, name, enc_blob in cursor.fetchall():
        known_encodings[name] = pickle.loads(enc_blob)
        reg_numbers[name] = reg_number
    
    conn.close()
    return known_encodings, reg_numbers

# Check if face is already registered
def is_duplicate_face(new_encoding, known_encodings):
    for name, encodings in known_encodings.items():
        matches = face_recognition.compare_faces(encodings, new_encoding, tolerance=0.35)
        if any(matches):
            return name  # Return the existing name
    return None

# Recognize face from the camera and display info
def recognize_and_display(known_encodings, reg_numbers):
    cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        face_locations = face_recognition.face_locations(rgb_frame, model="hog")
        face_encodings = face_recognition.face_encodings(rgb_frame, face_locations, num_jitters=5)
        
        for face_encoding, face_location in zip(face_encodings, face_locations):
            name = is_duplicate_face(face_encoding, known_encodings) or "Unknown"
            reg_number = reg_numbers.get(name, "N/A")
            
            top, right, bottom, left = face_location
            color = (0, 255, 0) if name != "Unknown" else (0, 0, 255)
            cv2.rectangle(frame, (left, top), (right, bottom), color, 2)
            text = f"{name} - {reg_number}"
            cv2.putText(frame, text, (left, top - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)
            
            print(f"Face recognized: {name}, Registration Number: {reg_number}")
        
        cv2.imshow("Face Recognition", frame)
        
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    
    cap.release()
    cv2.destroyAllWindows()

# Main function
def main():
    known_encodings, reg_numbers = load_registered_faces()
    recognize_and_display(known_encodings, reg_numbers)

if __name__ == "__main__":
    main()
