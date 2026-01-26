import cv2
import face_recognition
import os
import numpy as np
import json
import time

# Path to store face encodings
ENCODINGS_FILE = "face_encodings.json"

# Ensure encoding file exists
if not os.path.exists(ENCODINGS_FILE):
    with open(ENCODINGS_FILE, "w") as f:
        json.dump({}, f)

def load_registered_faces():
    if os.path.exists(ENCODINGS_FILE):
        with open(ENCODINGS_FILE, "r") as f:
            data = json.load(f)
        
        known_names = list(data.keys())
        known_encodings = {name: [np.array(enc) for enc in enc_list] for name, enc_list in data.items()}  # Store multiple encodings per person
    else:
        known_names = []
        known_encodings = {}
    
    return known_encodings, known_names

def is_duplicate_face(new_encoding, known_encodings):
    for name, encodings in known_encodings.items():
        matches = face_recognition.compare_faces(encodings, new_encoding, tolerance=0.35)
        if any(matches):
            return name  # Return the existing name
    return None

def save_new_face(known_encodings):
    cap = cv2.VideoCapture(0)
    print("Capturing multiple frames for better accuracy. Look at the camera...")
    encodings = []
    
    for _ in range(5):  # Capture 5 frames
        ret, frame = cap.read()
        if not ret:
            break
        
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        face_locations = face_recognition.face_locations(rgb_frame, model="hog")
        face_encodings = face_recognition.face_encodings(rgb_frame, face_locations, num_jitters=5)
        
        if face_encodings:
            existing_name = is_duplicate_face(face_encodings[0], known_encodings)
            if existing_name:
                print(f"Face already registered under '{existing_name}'. Registration aborted.")
                cap.release()
                return
            encodings.append(face_encodings[0])
        
        time.sleep(0.5)  # Pause between captures
    
    cap.release()
    
    if encodings:
        name = input("Enter name for the new face: ")
        with open(ENCODINGS_FILE, "r") as f:
            data = json.load(f)
        
        data[name] = [enc.tolist() for enc in encodings]  # Store new encodings
        
        with open(ENCODINGS_FILE, "w") as f:
            json.dump(data, f)
        
        print(f"New face encodings saved for {name}")
    else:
        print("No face detected. Try again.")

def recognize_face(frame, known_encodings, known_names):
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    face_locations = face_recognition.face_locations(rgb_frame, model="hog")
    face_encodings = face_recognition.face_encodings(rgb_frame, face_locations, num_jitters=3)
    
    for face_encoding, face_location in zip(face_encodings, face_locations):
        name = is_duplicate_face(face_encoding, known_encodings) or "Unknown"
        
        if name == "Unknown":
            print("New face detected. Registering...")
            save_new_face(known_encodings)
        
        top, right, bottom, left = face_location
        cv2.rectangle(frame, (left, top), (right, bottom), (0, 255, 0), 2)
        cv2.putText(frame, name, (left, top - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
    
    return frame

def main():
    known_encodings, known_names = load_registered_faces()
    
    cap = cv2.VideoCapture(0)
    
    # Track FPS
    prev_time = time.time()
    frame_count = 0
    fps = 0.0
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        
        frame = recognize_face(frame, known_encodings, known_names)
        
        # Calculate FPS
        frame_count += 1
        if frame_count >= 10:
            current_time = time.time()
            fps = frame_count / (current_time - prev_time)
            prev_time = current_time
            frame_count = 0
        
        cv2.putText(frame, f"FPS: {fps:.2f}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)
        
        cv2.imshow("Face Recognition", frame)
        
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    
    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
