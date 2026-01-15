# Drone Tech AI Portal - Integration Guide

## Overview
This is a **unified web application** combining:
- **Main App** (Flask): Login + Dashboard with 3 modules
  - Object Detection
  - Gender Detection  
  - **Body Tracking** ← Now integrated with separate FastAPI backend
- **Body Tracking** (FastAPI): Advanced body pose estimation and behavior analysis

## Quick Start

### Prerequisites
- Python 3.8+
- Pip or Conda
- Webcam (for live tracking)

### Setup

#### 1. Create & Activate Virtual Environment

**Command Prompt:**
```bash
python -m venv venv
venv\Scripts\activate
```

**PowerShell:**
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

#### 2. Install All Dependencies

```bash
# Install main app dependencies
pip install -r requirements.txt

# Install body tracking dependencies
pip install -r CDAC-INTERNSHIP/requirements.txt
```

> **Note:** If `torch` installation fails, get the correct wheel from https://pytorch.org/

#### 3. Run the Application

**Option A: Separate Windows (Recommended for Windows)**
```bash
start_servers.bat
```
This opens 2 separate console windows:
- Flask on `http://localhost:5000`
- FastAPI on `http://localhost:8000`

**Option B: PowerShell**
```powershell
.\start_servers.ps1
```

**Option C: Single Process**
```bash
python start_all.py
```

---

## How It Works

### User Flow
1. **Login** → `index.html` (Sign in with any username/password)
2. **Dashboard** → `dashboard.html` (3 module cards)
3. **Click Body Tracking** → Opens full body tracking interface

### Architecture

```
┌─────────────────────────────────────────────────┐
│         Browser (Port 5000)                     │
│  ┌───────────────────────────────────────────┐  │
│  │  Login → Dashboard → Body Tracking Page   │  │
│  │                                           │  │
│  │  body.html connects to FastAPI at 8000   │  │
│  └───────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
          ↓ (iframe/fetch)              ↓
┌──────────────────────┐    ┌──────────────────────┐
│  Flask Server        │    │  FastAPI Server      │
│  Port: 5000          │    │  Port: 8000          │
│  ├─ index.html       │    │  ├─ Body Tracking UI │
│  ├─ dashboard.html   │    │  ├─ WebSocket /ws   │
│  ├─ body.html        │    │  └─ MediaPipe Pose  │
│  ├─ object.html      │    │                      │
│  └─ gender.html      │    │                      │
└──────────────────────┘    └──────────────────────┘
```

### Body Tracking Flow
1. User clicks **Body Tracking** button in dashboard
2. Navigates to `/body.html` (Flask)
3. `body.html` loads the FastAPI interface from `http://localhost:8000/`
4. WebSocket connection established for real-time pose tracking
5. MediaPipe processes video frames
6. Results displayed with behavior classification

---

## File Structure

```
frontend_proto/
├── server.py                    # Flask main server
├── index.html                   # Login page
├── dashboard.html               # Main dashboard (3 modules)
├── body.html                    # ✓ Body tracking page (NEW)
├── object.html                  # Object detection
├── gender.html                  # Gender detection
├── style.css                    # Shared styling
├── script.js                    # Dashboard logic
├── module.js                    # Module page logic
├── app.js                       # Alternative app logic
│
├── requirements.txt             # Main app dependencies
├── start_all.py                 # ✓ Python startup script (NEW)
├── start_servers.bat            # ✓ Windows batch script (NEW)
├── start_servers.ps1            # ✓ PowerShell script (NEW)
│
└── CDAC-INTERNSHIP/             # Body Tracking SubApp
    ├── fixed_colab.py           # FastAPI server + model
    ├── ws_ping.py               # WebSocket handler
    ├── requirements.txt         # FastAPI dependencies
    ├── Body_Tracking.pkl        # ML model file
    ├── static/
    │   ├── index.html           # Body tracking UI
    │   ├── script.js            # WebSocket client logic
    │   └── styles.css           # Body tracking styles
    └── README.md
```

---

## Running Individual Components

### Main App Only (Flask)
```bash
# Just the login + dashboard, without body tracking
python server.py
# Visit: http://localhost:5000
```

### Body Tracking Only (FastAPI)
```bash
cd CDAC-INTERNSHIP
python -m uvicorn fixed_colab:app --host 0.0.0.0 --port 8000
# Visit: http://localhost:8000
```

---

## Troubleshooting

### "Body Tracking interface not loading"
**Solution:** Ensure FastAPI server is running on port 8000
```bash
cd CDAC-INTERNSHIP
python -m uvicorn fixed_colab:app --host 0.0.0.0 --port 8000
```

### "Port 5000/8000 already in use"
**Solution:** Kill the process or use a different port
```powershell
# PowerShell: Kill process on port 5000
Stop-Process -Id (Get-NetTCPConnection -LocalPort 5000).OwningProcess -Force
```

### "ModuleNotFoundError: No module named 'mediapipe'"
**Solution:** Install missing packages
```bash
pip install mediapipe fastapi uvicorn websockets
```

### "WebSocket connection failed"
**Solution:** Check CORS settings in `fixed_colab.py`
- Ensure `allow_origins=["*"]` is set (or specify localhost:5000)
- Firewall may be blocking port 8000

---

## Features

### Main Dashboard
- ✓ Login/Logout
- ✓ User greeting
- ✓ 3 module cards (Object, Gender, Body)
- ✓ Subscribe/Unsubscribe buttons
- ✓ Module navigation

### Body Tracking
- ✓ Real-time webcam pose estimation
- ✓ 9 behavior classifications
- ✓ MediaPipe full-body tracking
- ✓ Movement intensity scoring
- ✓ Behavior timeline graphs
- ✓ WebSocket for low-latency streaming
- ✓ Analysis summary & voice report

---

## Development Notes

### Adding New Modules
To add another module (e.g., "Face Recognition"):

1. Create `facerecog.html` (similar to `body.html`)
2. Add card to `dashboard.html`:
   ```html
   <article class="card func-card" data-module="facerecog">
     <h3>Face Recognition</h3>
     ...
   </article>
   ```
3. Update mapping in `script.js`:
   ```js
   const mapping = {
     object: 'object.html',
     gender: 'gender.html',
     body: 'body.html',
     facerecog: 'facerecog.html'  // Add this
   };
   ```

### Customizing Ports
Edit `start_servers.bat` or use environment variables:
```bash
set PORT=8080
set FLASK_PORT=5000
python server.py
```

---

## Support

For issues or questions:
1. Check browser console (F12 → Console tab)
2. Check server logs in the console windows
3. Verify both servers are running
4. Ensure ports 5000 and 8000 are available
5. Try restarting both servers

---

**Last Updated:** January 2026
**Version:** 2.0 (Integrated Body Tracking)
