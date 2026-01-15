# 🚀 Drone Tech AI Portal - Integrated Body Tracking System

A comprehensive AI-powered web application that integrates multiple computer vision modules including **Object Detection**, **Gender Classification**, and **Real-time Body Tracking with Behavior Analysis**.

## 📋 Table of Contents

- [Features](#features)
- [System Architecture](#system-architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Usage Guide](#usage-guide)
- [Project Structure](#project-structure)
- [API Endpoints](#api-endpoints)
- [Troubleshooting](#troubleshooting)
- [Dependencies](#dependencies)
- [Contributing](#contributing)

---

## ✨ Features

### 🔐 Authentication & Dashboard
- User login/logout system
- Session management
- Personalized dashboard with module selection
- Subscription-based module access

### 🎯 Object Detection Module
- Real-time object detection using YOLOv8
- Camera and file-based input support
- Confidence scoring and bounding boxes
- Video stream processing

### 👥 Gender Classification Module
- Real-time gender detection
- Live camera feed processing
- File upload support
- Classification confidence display

### 🧬 Body Tracking Module (NEW - INTEGRATED)
- **Real-time pose estimation** using MediaPipe Holistic
- **9 behavior classifications** (standing, covering face, hands up, fear, happy, etc.)
- **Movement intensity scoring** with temporal smoothing
- **Live metrics display** (behavior, confidence, movement score, frame count)
- **Analysis graphs** (action frequency, behavior timeline, movement intensity)
- **WebSocket-based streaming** for low-latency real-time processing
- **Voice report generation**

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────┐
│         Browser (User Interface)                │
│  ├─ Login Page (index.html)                     │
│  ├─ Dashboard (dashboard.html)                  │
│  ├─ Object Detection (object.html)              │
│  ├─ Gender Classification (gender.html)         │
│  └─ Body Tracking (body.html)                   │
└─────────────────────────────────────────────────┘
         ↓ HTTP Requests                ↓ WebSocket
┌──────────────────────┐    ┌──────────────────────┐
│  Flask Server        │    │  FastAPI Server      │
│  Port: 5000          │    │  Port: 8000          │
│                      │    │                      │
│ • index.html         │    │ • Body Tracking UI   │
│ • dashboard.html     │    │ • WebSocket /ws      │
│ • object.html        │    │ • MediaPipe Pose     │
│ • gender.html        │    │ • ML Model (PKL)     │
│ • body.html          │    │ • Graph Generation   │
│ • YOLO best.pt       │    │                      │
│ • CORS enabled       │    │ • CORS enabled       │
└──────────────────────┘    └──────────────────────┘
```

---

## 📦 Installation

### Prerequisites

- **Python 3.8+** (recommended: 3.9 or 3.10)
- **pip** (Python package manager)
- **Git** (for version control)
- **Webcam** (for live tracking features)
- **~5GB** free disk space (for dependencies and models)

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd cdac_final
```

### Step 2: Create Virtual Environment

**Windows (CMD):**
```bash
python -m venv venv
venv\Scripts\activate
```

**Windows (PowerShell):**
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

**macOS/Linux:**
```bash
python3 -m venv venv
source venv/bin/activate
```

### Step 3: Install Dependencies

**Install all requirements (main app + body tracking):**
```bash
pip install -r requirements.txt
```

If PyTorch installation fails, get the correct wheel for your system:
- Visit https://pytorch.org/get-started/locally/
- Select your OS, package manager (pip), Python version, and compute platform
- Copy the install command and run it

Example for CPU-only:
```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
```

### Step 4: Verify Installation

```bash
python -c "import flask; import fastapi; import torch; import cv2; import mediapipe; print('✓ All dependencies installed successfully!')"
```

---

## ⚙️ Configuration

### File Structure
```
frontend_proto/
├── index.html                    # Login page
├── dashboard.html                # Main dashboard (3 modules)
├── body.html                     # Body tracking UI
├── object.html                   # Object detection page
├── gender.html                   # Gender classification page
├── server.py                     # Flask main server
├── final.py                      # Standalone detection script
├── style.css                     # Shared styling
├── script.js                     # Dashboard logic
├── module.js                     # Module page logic
├── app.js                        # Alternative app logic
├── best.pt                       # YOLO object detection model
├── requirements.txt              # Python dependencies
├── README.md                     # This file
│
└── CDAC-INTERNSHIP/              # Body Tracking Sub-Application
    ├── fixed_colab.py            # FastAPI server for body tracking
    ├── ws_ping.py                # WebSocket connection manager
    ├── Body_Tracking.pkl         # ML model for behavior classification
    ├── requirements.txt          # Body tracking specific dependencies
    ├── run_dev.py                # Development runner
    │
    └── static/
        ├── index.html            # Body tracking UI
        ├── script.js             # WebSocket client & tracking logic
        └── styles.css            # Body tracking styling
```

### Port Configuration

Default ports:
- **Flask**: 5000 (main app)
- **FastAPI**: 8000 (body tracking)

To change ports, modify in `server.py`:
```python
app.run(debug=True, port=5000)  # Change 5000 to desired port
```

And in `CDAC-INTERNSHIP/fixed_colab.py`:
```python
uvicorn.run("fixed_colab:app", host="127.0.0.1", port=8000)  # Change 8000
```

---

## 🚀 Running the Application

### Quick Start (Recommended)

**Windows (CMD):**
```bash
cd c:\Users\[username]\Desktop\frontend_proto
python server.py
```

This automatically starts:
- Flask server on port 5000 (main app)
- FastAPI server on port 8000 (body tracking)

**Then open browser:**
```
http://localhost:5000
```

### Alternative: Start Servers Separately

**Terminal 1 - Flask Server:**
```bash
python server.py
# Or without auto-start of FastAPI:
python -m flask run --port 5000
```

**Terminal 2 - FastAPI Server:**
```bash
cd CDAC-INTERNSHIP
python -m uvicorn fixed_colab:app --host 127.0.0.1 --port 8000
```

### Stop the Application

- **Combined Terminal**: Press `Ctrl+C` once to stop Flask, then `Ctrl+C` again for FastAPI
- **Separate Terminals**: Press `Ctrl+C` in each terminal window

---

## 👤 Usage Guide

### 1. Login
1. Open `http://localhost:5000` in your browser
2. Enter any username, email, and password
3. Click **"Log In"**

### 2. Dashboard
After login, you'll see three modules:
- **Object Detection** - Real-time object identification
- **Gender Classification** - Gender detection from video
- **Body Tracking** - Pose estimation & behavior analysis

### 3. Body Tracking (Main Feature)

#### Enable Module
1. Click **"Subscribe"** on Body Tracking card
2. Click **"Open"** button (now enabled)

#### Start Tracking
1. Allow **camera access** when prompted
2. Click **"Start Tracking"**
3. Video feed with pose skeleton will appear

#### Monitor Metrics
- **Behavior**: Current detected behavior (9 types)
- **Confidence**: Classification confidence (0-100%)
- **Movement Score**: Movement intensity (0-100)
- **Frame Count**: Frames processed

#### Generate Analysis
1. Click **"Generate Graphs"** after tracking
2. View:
   - Action Frequency histogram
   - Behavior Timeline chart
   - Movement Intensity graph
   - Analysis Summary with recommendations

#### Voice Report
1. Click **"Play Voice Report"** for audio analysis

---

## 🔌 API Endpoints

### Flask Server (Port 5000)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Serve index.html (login) |
| GET | `/dashboard.html` | Main dashboard |
| GET | `/body.html` | Body tracking page |
| GET | `/object.html` | Object detection |
| GET | `/gender.html` | Gender classification |
| GET | `/video_feed?mode=processed` | Live object detection stream |
| POST | `/upload` | Upload video file |
| POST | `/run_detection` | Run detection on video |
| GET | `/<path:path>` | Serve static files |

### FastAPI Server (Port 8000)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Serve body tracking UI |
| GET | `/static/*` | Serve static files (CSS, JS) |
| WebSocket | `/ws` | Real-time pose tracking stream |
| GET | `/health` | Server health check |
| GET | `/ws-status` | WebSocket endpoint status |

---

## 🔧 Troubleshooting

### Issue: "Port 5000 already in use"
```bash
# Kill process using port 5000
# Windows CMD:
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Windows PowerShell:
Stop-Process -Id (Get-NetTCPConnection -LocalPort 5000).OwningProcess -Force
```

### Issue: "Cannot connect to localhost:8000"
1. Verify FastAPI server started (check console output)
2. Wait 5 seconds for server to initialize
3. Reload browser (Ctrl+R or Cmd+R)
4. Check firewall settings

### Issue: "Camera not working"
1. Allow camera in **browser settings**
2. Check **Windows Privacy** → Camera → Enable for apps
3. Verify no other app is using camera
4. Try different camera index (modify in fixed_colab.py)

### Issue: "MediaPipe warning"
```
⚠ WARNING: MediaPipe loaded but solutions not available
```
This is expected - the system uses a fallback. Functionality still works.

### Issue: "ModuleNotFoundError"
```bash
# Verify venv is activated
# Windows:
venv\Scripts\activate

# Then reinstall:
pip install -r requirements.txt

# For specific package issues:
pip install --upgrade mediapipe fastapi uvicorn
```

### Issue: "Slow performance"
1. Close other applications
2. Reduce browser tabs open
3. Check system resources (Task Manager → Performance)
4. Ensure adequate disk space (>1GB free)

### Issue: "WebSocket connection fails"
1. Ensure both servers are running (check both terminals)
2. Firewall might be blocking port 8000
3. Try: `python -m uvicorn fixed_colab:app --host 127.0.0.1 --port 8000`
4. Check browser console (F12 → Console tab)

---

## 📚 Dependencies

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| **Flask** | 3.1.0+ | Web framework (main app) |
| **FastAPI** | 0.95.0+ | Modern web framework (body tracking) |
| **Uvicorn** | 0.15.0+ | ASGI server for FastAPI |
| **OpenCV** | 4.5.0+ | Computer vision processing |
| **NumPy** | 1.20.0+ | Numerical computing |
| **Pandas** | 1.3.0+ | Data manipulation |
| **PyTorch** | 1.9.0+ | Deep learning (YOLO) |
| **TorchVision** | 0.10.0+ | Vision utilities |
| **Ultralytics** | 8.0.0+ | YOLOv8 object detection |
| **MediaPipe** | 0.10.30+ | Pose estimation |
| **scikit-learn** | 1.0.0+ | ML model (behavior classification) |
| **Matplotlib** | 3.5.0+ | Graph generation |
| **Joblib** | 1.0.0+ | Model serialization |
| **WebSockets** | 11.0.0+ | WebSocket support |

See `requirements.txt` for complete list with versions.

---

## 🤝 Contributing

### Guidelines
1. Create feature branches from `main`
2. Follow PEP 8 Python style guide
3. Add comments for complex logic
4. Test all features before pushing
5. Create detailed pull requests

### Reporting Issues
1. Check existing issues first
2. Provide clear description and steps to reproduce
3. Include console output and error messages
4. Specify Python version and OS

---

## 📄 License

This project is part of CDAC DRONE TECH initiative.

---

## 👥 Team

- **Integration & Development**: [Your Name]
- **Body Tracking Model**: CDAC DRONE TECH
- **Original Framework**: Drone Tech AI Portal

---

## 📞 Support

For issues, questions, or improvements:
1. Check **Troubleshooting** section above
2. Review console logs for error messages
3. Contact team members
4. Create an issue on GitHub

---

## 🎯 Quick Reference

### Start Application
```bash
python server.py
```

### Access Application
```
http://localhost:5000
```

### Stop Application
```
Ctrl+C in terminal
```

### Install Dependencies
```bash
pip install -r requirements.txt
```

### Check Server Status
```
Flask: http://localhost:5000/
FastAPI: http://localhost:8000/
```

### View Logs
Check terminal output for real-time logs

---

**Last Updated**: January 15, 2025  
**Version**: 2.0 (Integrated Body Tracking)  
**Status**: ✅ Production Ready
