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
        face_encodings = face_recognition.face_encodings(rgb_frame, face_locations, num_jitters=2)
        
        if face_encodings:
            existing_name = is_duplicate_face(face_encodings[0], known_encodings)
            if existing_name:
                print(f"Face already registered under '{existing_name}'. Registration aborted.")
                cap.release()
                return False
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
        return True
    else:
        print("No face detected. Try again.")
        return False

def recognize_face(frame, known_encodings, known_names):
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    face_locations = face_recognition.face_locations(rgb_frame, model="hog")
    face_encodings = face_recognition.face_encodings(rgb_frame, face_locations, num_jitters=3)
    
    for face_encoding, face_location in zip(face_encodings, face_locations):
        name = is_duplicate_face(face_encoding, known_encodings) or "Unknown"
        
        if name == "Unknown":
            print("New face detected. Registering...")
            success = save_new_face(known_encodings)
            return success
        else:
            print(f"Face recognized: {name}")
            return True
    return False

def main():
    known_encodings, known_names = load_registered_faces()
    
    cap = cv2.VideoCapture(0)
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        
        success = recognize_face(frame, known_encodings, known_names)
        
        if success:
            break  # Exit after recognizing or registering a face
    
    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
