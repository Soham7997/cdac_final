# System Architecture Diagram

## Network Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                         USER BROWSER                           │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │                                                          │ │
│  │  1. Login (index.html)                                  │ │
│  │     ↓                                                    │ │
│  │  2. Dashboard (dashboard.html)                          │ │
│  │     - Object Detection                                  │ │
│  │     - Gender Detection                                  │ │
│  │     - Body Tracking [INTEGRATED]                        │ │
│  │     ↓ (click Body Tracking)                             │ │
│  │  3. Body Tracking Page (body.html)                      │ │
│  │     ↓ (fetch from port 8000)                            │ │
│  │  4. Body Tracking UI (loaded from FastAPI)              │ │
│  │     - WebSocket connection                              │ │
│  │     - Real-time pose tracking                           │ │
│  │     - Graphs & analysis                                 │ │
│  │                                                          │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                │
└────────────────────────────────────────────────────────────────┘
         ↓ HTTP (5000)         ↓ HTTP/WS (8000)
    ┌─────────────────┐    ┌──────────────────┐
    │  FLASK SERVER   │    │ FASTAPI SERVER   │
    │  Port: 5000     │    │ Port: 8000       │
    │                 │    │                  │
    │ ✓ index.html    │    │ ✓ WebSocket /ws  │
    │ ✓ dashboard     │    │ ✓ Static files   │
    │ ✓ object.html   │    │ ✓ MediaPipe      │
    │ ✓ gender.html   │    │ ✓ Model predict  │
    │ ✓ body.html     │    │ ✓ Graph generate │
    │                 │    │                  │
    │ Models:         │    │ Models:          │
    │ - best.pt       │    │ - Body_Tracking  │
    │   (YOLO)        │    │   .pkl (scikit)  │
    └─────────────────┘    └──────────────────┘
```

## Data Flow for Body Tracking

```
User Flow:
──────────
  Login Page
      ↓
  Enter credentials (any values)
      ↓
  Dashboard (3 modules)
      ↓
  Click "Subscribe" on Body Tracking
      ↓
  Click "Open" button (now enabled)
      ↓
  Navigate to body.html
      ↓
  Browser loads: http://localhost:5000/body.html
      ↓
  body.html JavaScript fetches from http://localhost:8000/
      ↓
  Gets HTML + WebSocket URI
      ↓
  Connects WebSocket: ws://localhost:8000/ws
      ↓
  Camera access permission dialog
      ↓
  Start Tracking clicked
      ↓

Real-time Processing Pipeline:
───────────────────────────────
  Camera Frame (webcam)
      ↓
  Browser captures video
      ↓
  WebSocket sends frame to FastAPI
      ↓
  fixed_colab.py receives frame
      ↓
  MediaPipe processes:
      ├─ Body pose estimation (33 landmarks)
      ├─ Hand detection (21 points per hand)
      ├─ Face mesh (468 landmarks)
      ├─ Holistic model analysis
      └─ Feature extraction
      ↓
  Model prediction:
      ├─ Input: 2004 features (33*4*15 frames + face + hands)
      ├─ Model: Body_Tracking.pkl (scikit-learn)
      ├─ Output: 9 behavior classes
      │  (standing_still, covering_face, hands_up, fear,
      │   crossed_arms, happy, melancholy, calling_out, etc)
      └─ Confidence score
      ↓
  Generate metrics:
      ├─ Behavior label
      ├─ Confidence percentage
      ├─ Movement intensity score
      ├─ Frame count
      └─ Smoothed predictions
      ↓
  WebSocket sends results back to browser
      ↓
  Browser updates UI:
      ├─ Annotated canvas (pose drawn)
      ├─ Metric displays
      ├─ Behavior text
      ├─ Confidence bar
      ├─ Movement graph (real-time)
      └─ Timeline history
      ↓
  Repeat for each frame (~30 FPS)
      ↓

Analysis Phase:
──────────────
  User clicks "Generate Graphs"
      ↓
  WebSocket sends: generate_graphs command
      ↓
  fixed_colab.py processes history:
      ├─ Action frequency histogram
      ├─ Behavior timeline chart
      └─ Movement intensity graph
      ↓
  Renders as images (matplotlib)
      ↓
  Encodes to base64
      ↓
  Sends via WebSocket
      ↓
  Browser displays graphs
      ↓
  Generate summary:
      ├─ Total frames & time
      ├─ Most frequent behavior
      ├─ Average intensity
      ├─ Peak intensity moment
      └─ Recommendations
      ↓
  Voice report option (text-to-speech in browser)
```

## File Dependencies

```
App Startup:
─────────────
  start_servers.bat
    ├─ Activates venv
    ├─ Starts Flask → server.py
    │   ├─ Imports cv2, YOLO, flask, flask_cors
    │   ├─ Loads best.pt (object detection model)
    │   ├─ Serves HTML/CSS/JS files
    │   ├─ Waits 3 seconds
    │   └─ Spawns subprocess: cd CDAC-INTERNSHIP && python fixed_colab.py
    │
    └─ Starts FastAPI → fixed_colab.py
        ├─ Imports fastapi, uvicorn, mediapipe, pandas, joblib
        ├─ Loads Body_Tracking.pkl (behavior model)
        ├─ Mounts static files (HTML/CSS/JS)
        ├─ Sets up WebSocket endpoint: /ws
        ├─ Starts MediaPipe holistic
        └─ Listens on port 8000


User Session:
─────────────
  Browser
    ├─ GET http://localhost:5000/
    │   └─ Served: index.html
    │
    ├─ POST login form
    │   └─ Stored in sessionStorage
    │
    ├─ GET http://localhost:5000/dashboard.html
    │   ├─ Loaded: dashboard.html
    │   ├─ Loaded: script.js (module routing)
    │   └─ Uses sessionStorage (user data)
    │
    ├─ Click Body Tracking button
    │   └─ Navigates to: window.location.href = 'body.html'
    │
    ├─ GET http://localhost:5000/body.html
    │   ├─ Loaded: body.html (Flask)
    │   └─ JavaScript code (FETCH from :8000)
    │
    ├─ FETCH http://localhost:8000/
    │   └─ Received: FastAPI index.html
    │
    ├─ Loaded script: http://localhost:8000/static/script.js
    │   ├─ Establishes WebSocket connection
    │   ├─ Gets webcam stream (getUserMedia)
    │   └─ Sends frames via WebSocket
    │
    └─ WebSocket ws://localhost:8000/ws
        ├─ Frame data → Server
        ├─ ← Pose + Behavior predictions
        ├─ ← Graphs (on demand)
        ├─ ← Analysis summary
        └─ ← Voice report text
```

## Deployment Structure

```
Production (Same as Development):
──────────────────────────────────
  Docker Container (Optional)
    ├─ Flask (Main App)
    │   └─ Port 5000
    │
    └─ FastAPI (Body Tracking)
        └─ Port 8000

Environment Variables:
  ├─ FLASK_PORT=5000 (or uses default)
  ├─ FASTAPI_PORT=8000
  ├─ DEBUG=False (production)
  └─ HOST=0.0.0.0

Models:
  ├─ best.pt (YOLO Object Detection) - 250MB
  ├─ Body_Tracking.pkl (Scikit-learn) - 50MB
  └─ MediaPipe (downloaded on first run) - 100MB
```

## Error Handling Flow

```
Client Error:
─────────────
  ❌ Port 5000 not responding
    → Can't access login page
    → Solution: Start Flask server

  ❌ Port 8000 not responding
    → Body tracking page shows error
    → "Connecting to body tracking server..."
    → Solution: Start FastAPI server (fixed_colab.py)

  ❌ WebSocket connection fails
    → Pose tracking won't work
    → Browser console shows error
    → Check CORS settings in fixed_colab.py
    → Firewall might be blocking port 8000

  ❌ Camera permission denied
    → Video stream empty
    → Allow camera in browser settings
    → Check Windows privacy settings

  ❌ MediaPipe import error
    → Falls back to placeholder
    → Some features limited
    → Install: pip install mediapipe

Server Error:
─────────────
  ❌ Model loading failed
    → Fixed_colab.py sets MODEL_AVAILABLE=False
    → System continues but predictions fail
    → Check Body_Tracking.pkl file exists

  ❌ YOLO model not found
    → best.pt missing
    → Download from: https://github.com/ultralytics/yolov8
    → Place in project root

  ❌ Frame processing timeout
    → WebSocket connection drops
    → Browser auto-reconnects
    → Server logs the error
```

---

## Integration Points

### Flask ↔ FastAPI Communication

```
Reverse Proxy Method (Not used here):
────────────────────────────────────
  Client → Nginx (Port 80)
    ├─ /api/* → FastAPI (Port 8000)
    └─ /* → Flask (Port 5000)

Direct Multi-Port Method (Current):
────────────────────────────────────
  Client → Flask (Port 5000) [Main App]
    └─ Serves: index.html, dashboard.html
    
  Client → FastAPI (Port 8000) [Body Tracking]
    └─ Serves: body tracking UI + WebSocket
    
  Integration Point:
    body.html (Flask) → FETCH → FastAPI:8000
```

---

**Architecture Version:** 2.0 (Multi-Server)
**Status:** ✅ Production Ready
