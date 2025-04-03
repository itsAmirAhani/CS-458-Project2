# CS-458-Project2

This project consists of a **FastAPI backend** and a **Flutter mobile app**.

## 📂 Project Structure
```
CS-458-Project2/
│-- backend/          # FastAPI backend
│   ├── main.py       # Main FastAPI app file
│-- mobile_app/       # Flutter mobile application
│-- venv/             # Python virtual environment
│-- README.md         # Project documentation
```

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
uvicorn app.main:app --reload
```
- The FastAPI server will run at **http://127.0.0.1:8000**.
- Open **http://127.0.0.1:8000/docs** to view the API documentation.

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

