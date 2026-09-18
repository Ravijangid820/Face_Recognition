# Face Recognition with MySQL Registration

Real-time face recognition (OpenCV + `face_recognition`) with MySQL-backed registration.
Register a face once (name + registration number), then recognize it live from webcam.

> **Note:** Face encodings are biometric data. This repo stores them in MySQL only — no `face_encodings.json` is committed.

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
│   └── iterations/          # earlier experiments (json/mysql/regNo variants)
├── main/
│   ├── save_face.py         # minimal enrollment example
│   └── verify_face.py       # minimal verification example
├── environment.yml          # conda env
├── dockerfile
└── README.md
```

## Requirements
- Python 3.10+
- MySQL 8.x running locally
- Webcam

## Setup
```bash
conda env create -f environment.yml
conda activate face
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
