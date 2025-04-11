# CS-458-Project2

This project consists of a **FastAPI backend** and a **Flutter mobile app**.

## 📂 Project Structure
```
CS-458-PROJECT-2/
│
├── backend/                    # FastAPI backend
│   ├── app/                    # Main app directory
│   │   ├── database/           # Database-related files
│   │   │   ├── init.py     # Database module init
│   │   │   ├── surveys_db.py   # Survey database storage
│   │   │   └── users_db.py     # User database storage
│   │   ├── managers/           # Manager classes for business logic
│   │   │   ├── init.py     # Managers module init
│   │   │   ├── AuthManager.py  # Handles authentication logic
│   │   │   ├── LockoutManager.py  # Manages user lockout
│   │   │   ├── LoginManager.py # Handles login operations
│   │   │   ├── LogoutManager.py  # Handles logout operations
│   │   │   ├── PasswordValidator.py  # Validates passwords
│   │   │   ├── SpotifyOAuthManager.py  # Manages Spotify OAuth
│   │   │   ├── SurveyManager.py  # Handles survey submission
│   │   │   └── UserManager.py  # Manages user operations
│   │   ├── models/             # Data models
│   │   │   ├── init.py     # Models module init
│   │   │   ├── LoginRequest.py # Login request model
│   │   │   └── SurveyRequest.py  # Survey request model
│   │   ├── routes/             # API routes
│   │   │   ├── init.py     # Routes module init
│   │   │   ├── login.py        # Login routes
│   │   │   ├── survey.py       # Survey routes
│   │   │   └── main.py         # Main app routes
│   │   └── init.py         # App module init
│   ├── venv/                   # Python virtual environment
│   ├── .gitignore              # Git ignore file for backend
│   └── requirements.txt        # Backend dependencies
│
├── mobile_app/                 # Flutter mobile application
│   ├── .dart_tool/             # Dart tool files
│   ├── android/                # Android-specific files
│   ├── build/                  # Build output
│   ├── ios/                    # iOS-specific files
│   ├── lib/                    # Flutter source code
│   │   ├── components/         # Reusable UI components
│   │   │   ├── google_login.dart  # Google login component
│   │   │   └── normal_login.dart  # Normal login component
│   │   ├── pages/              # App pages/screens
│   │   │   ├── login_page.dart # Login page UI
│   │   │   └── survey_page.dart  # Survey page UI
│   │   ├── config.dart         # Configuration (e.g., API base URL)
│   │   └── main.dart           # App entry point
│   ├── linux/                  # Linux-specific files
│   ├── macos/                  # macOS-specific files
│   ├── test/                   # Test files
│   ├── tests/                  # Appium test automation files
│   ├── web/                    # Web-specific files
│   ├── windows/                # Windows-specific files
│   ├── .flutter-plugins        # Flutter plugins file
│   ├── .flutter-plugins-dependencies  # Plugin dependencies
│   ├── .gitignore              # Git ignore file for Flutter
│   ├── .metadata               # Flutter metadata
│   ├── analysis_options.yaml   # Linting rules
│   ├── pubspec.lock            # Dependency lock file
│   ├── pubspec.yaml            # Flutter dependencies
│
└── README.md                   # Project documentation

---
## 🚀 Setup & Run Instructions

### **1️⃣ Backend (FastAPI)**
#### **Setup**
1. **Navigate to the project folder**:
   ```bash
   cd CS-458-Project2/backend
   ```
2. **Create & activate a virtual environment**:
   ```bash
   python -m venv venv  # Create virtual environment
   source venv/bin/activate  # macOS/Linux
   venv\Scripts\activate  # Windows
   ```
3. **Install dependencies**:
   ```bash
   pip install fastapi uvicorn httpx
   ```
   1. **(Important)**:
      ```bash 
      pip install "pydantic<2.0" 
      ```
#### **Run the FastAPI Server**
```bash
python -m uvicorn app.main:app --host 0.0.0.0 --reload
```
- The FastAPI server will run at **http://0.0.0.0:8000**.
- Open **http://localhost:8000/docs** to view the API documentation.

---
### **2️⃣ Mobile App (Flutter)**
#### **Setup**
1. **Navigate to the Flutter project**:
   ```bash
   cd mobile_app
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

#### **Run the Flutter App**
```bash
flutter run
```
- If using an **Android emulator/iOS simulator**, update the API URL in `lib/main.dart` to match your local machine's IP.

---
## 📌 Notes
- Ensure **FastAPI is running before starting Flutter** so the app can fetch data.
- If running on a mobile device/emulator, replace `127.0.0.1` with your local IP.

Let me know if you need any modifications! 🚀

