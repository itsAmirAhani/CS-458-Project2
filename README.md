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
│   │   ├── test1.py            # test1
│   │   ├── test2.py            # test2
│   │   ├── test3.py            # test3
│   │   ├── test4.py            # test4
│   │   └── test5.py            # test5
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

Verify the API:
Open your browser and go to http://localhost:8000/docs to view the interactive API documentation (Swagger UI).
Test endpoints like /login and /survey to ensure the backend is working.
Troubleshooting
If the server fails to start, ensure all dependencies are installed correctly and there are no port conflicts (e.g., port 8000 is already in use).
Check the terminal output for error messages, such as missing dependencies or database issues.

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
3. **Update the API Base URL**:
   Open the file mobile_app/lib/config.dart.
   Find the baseUrl variable, which might look like:
   ```bash
   const String baseUrl = "http://127.0.0.1:8000";
   ```
   Replace 127.0.0.1 with your machine’s IPv4 address (e.g., 192.168.1.100). To find your IPv4 address:
   Windows: Run ipconfig in Command Prompt and look for IPv4 Address.
   macOS/Linux: Run ifconfig or ip addr and look for your network interface’s IP.
   Example updated config.dart
   ```bash
   const String baseUrl = "http://192.168.1.100:8000";
   ```

#### **Run the Flutter App**
1. Ensure an emulator is running or a physical device is connected:
```bash
flutter devices
```
This will list available devices (e.g., emulator-5554).

2. Start the Flutter app:
```bash
flutter run
```

#### **Automated Testing with Appium**
The project includes Appium test scripts in the mobile_app/tests/ directory to automate testing of the login and survey submission features.

Prerequisites
Appium Server: Install Appium globally using npm:

```bash
npm install -g appium
```
Appium UIAutomator2 Driver: Install the Android driver:

```bash
appium driver install uiautomator2
```

Python 3.9+: Ensure Python is installed.
Appium Python Client: Install the Appium Python client library:

```bash
pip install Appium-Python-Client
```
Android Emulator: Ensure an emulator (e.g., emulator-5554) is running.
Flutter App APK: The test scripts use the debug APK located at mobile_app/build/app/outputs/flutter-apk/app-debug.apk.

Setup
1. Start the Appium Server:
Run the Appium server in a terminal:

```bash
appium
```

2. The server will start on http://localhost:4723 by default.
Ensure no other processes are using port 4723.
Start the Android Emulator:
Open Android Studio, go to AVD Manager, and start the emulator (e.g., emulator-5554).
Verify the emulator is running:

```bash
adb devices
```

3. Ensure the Backend is Running:
Follow the backend setup instructions above to start the FastAPI server.
Update mobile_app/lib/config.dart with your IPv4 address (as described in the Flutter setup).

**Run the Appium Tests**:

1. Navigate to the tests directory:
```bash
cd CS-458-Project2/mobile_app/tests
```
2. Run the test scripts:
The project includes two test scripts: test1.py and test2.py.
Run test1.py (which tests login and survey submission):

```bash
python test1.py
```

## 📌 Notes
- Ensure **FastAPI is running before starting Flutter** so the app can fetch data.
- If running on a mobile device/emulator, replace `127.0.0.1` with your local IP.

**🛠️ Development Tips** 
- Backend Debugging: Use the /docs endpoint (http://localhost:8000/docs) to test API endpoints manually.
- Flutter Debugging: Use flutter logs to view app logs during development.
- Appium Debugging: Add debug statements in the test scripts to print element attributes (e.g., content-desc, text) to verify locators.

