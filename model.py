import cv2
import face_recognition
import numpy as np
import os
import pickle

# Directory to store face encodings
ENCODINGS_FILE = "face_encodings.pkl"

# Capture and save a new face encoding
def capture_face_encoding(name):
    video_capture = cv2.VideoCapture(0)
    print("Look at the camera to capture your face...")
    encodings = []
    
    for _ in range(50):  # Capture multiple frames
        ret, frame = video_capture.read()
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        face_locations = face_recognition.face_locations(rgb_frame)
        face_encodings = face_recognition.face_encodings(rgb_frame, face_locations)
        
        if face_encodings:
            encodings.append(face_encodings[0])
        
        cv2.imshow("Face Capture", frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    
    video_capture.release()
    cv2.destroyAllWindows()
    
    if encodings:
        avg_encoding = np.mean(encodings, axis=0)  # Average multiple encodings
        with open(ENCODINGS_FILE, "ab") as f:
            pickle.dump((name, avg_encoding), f)
        print(f"Face encoding saved for {name}")
    else:
        print("No face detected. Try again.")

# Verify a face against saved encodings
def verify_face():
    if not os.path.exists(ENCODINGS_FILE):
        print("No known faces found!")
        return
    
    known_encodings = []
    known_names = []
    with open(ENCODINGS_FILE, "rb") as f:
        while True:
            try:
                name, encoding = pickle.load(f)
                known_encodings.append(encoding)
                known_names.append(name)
            except EOFError:
                break
    
    video_capture = cv2.VideoCapture(0)
    print("Look at the camera to verify your face...")
    
    while True:
        ret, frame = video_capture.read()
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        face_locations = face_recognition.face_locations(rgb_frame)
        face_encodings = face_recognition.face_encodings(rgb_frame, face_locations)
        
        for (top, right, bottom, left), face_encoding in zip(face_locations, face_encodings):
            matches = face_recognition.compare_faces(known_encodings, face_encoding)
            name = "Unknown"
            
            face_distances = face_recognition.face_distance(known_encodings, face_encoding)
            best_match_index = np.argmin(face_distances) if face_distances.size > 0 else None
            
            if best_match_index is not None and matches[best_match_index]:
                name = known_names[best_match_index]
            
            cv2.rectangle(frame, (left, top), (right, bottom), (0, 255, 0), 2)
            cv2.putText(frame, name, (left, top - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
            print(f"Detected: {name}")
        
        cv2.imshow("Face Verification", frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    
    video_capture.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    choice = input("Enter 1 to register a face, 2 to verify: ")
    if choice == "1":
        user_name = input("Enter your name: ")
        capture_face_encoding(user_name)
    elif choice == "2":
        verify_face()
    else:
        print("Invalid choice")
