# Face Recognition with MySQL Registration

Real-time face recognition (OpenCV + `face_recognition`) with MySQL-backed registration.
Register a face once (name + registration number), then recognize it live from webcam.

> **Note:** `face_encodings.json` is gitignored — encodings are biometric data. Use MySQL as the source of truth.

## Features
- 🔍 Face detection & recognition (`hog` for live, `cnn` option for enrollment)
- 🗄️ MySQL storage of face encodings (pickle BLOB), dedup check before insert
- 🪟 Live overlay: name + registration number on video feed
- 🐳 Dockerfile for reproducible setup

## Project structure
```
.
├── face_recognition.py      # main app (renamed from final.py): register + recognize loop
├── face_recognition_model.py# encoding helpers
├── model.py                 # model utilities
├── examples/
│   ├── save_face.py         # minimal enrollment example
│   ├── verify_face.py       # minimal verification example
│   └── iterations/          # earlier experiments (json/mysql/regNo variants)
├── environment.yml          # conda env
├── requirements.txt         # pip install
├── Dockerfile
└── README.md
```

## Requirements
- Python 3.10+
- MySQL 8.x running locally
- Webcam

## Setup
```bash
# conda
conda env create -f environment.yml
conda activate face-recognition

# or pip
pip install -r requirements.txt
```

```sql
CREATE DATABASE face_recognition_db;
```

Edit `DB_CONFIG` in `face_recognition.py` with your MySQL user/password
(or export `MYSQL_HOST/MYSQL_USER/MYSQL_PASSWORD/MYSQL_DB` if you wire env support).

## Run
```bash
python face_recognition.py
# press 'q' to quit the video window
```

## How it works
1. `connect_db()` ensures `users(reg_number UNIQUE, name, face_encoding BLOB)`.
2. Enrollment captures 5 frames → encodings → `is_duplicate_face()` (tolerance 0.35) → insert if new.
3. Recognition loop matches live encodings against DB and draws name + reg. number.

## License
Open source — contributions welcome via pull requests.
