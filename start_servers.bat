@echo off
REM Start Drone Tech AI Portal with both Flask and FastAPI servers

echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║     Drone Tech AI Portal - Startup                  ║
echo ║                                                      ║
echo ║  Main App (Flask):        http://localhost:5000    ║
echo ║  Body Tracking (FastAPI): http://localhost:8000    ║
echo ╚══════════════════════════════════════════════════════╝
echo.

REM Check if venv exists
if not exist "venv\Scripts\activate.bat" (
    echo Error: Virtual environment not found!
    echo Please run: python -m venv venv
    pause
    exit /b 1
)

REM Activate virtual environment
call venv\Scripts\activate.bat

echo Starting servers...
echo.

REM Start Flask server in new window
echo [1/2] Starting Flask server on port 5000...
start "Drone Tech - Flask Server (5000)" cmd /k python server.py

REM Wait a bit, then start FastAPI server
timeout /t 3 /nobreak

echo [2/2] Starting Body Tracking FastAPI server on port 8000...
start "Drone Tech - Body Tracking (8000)" cmd /k cd CDAC-INTERNSHIP && python -m uvicorn fixed_colab:app --host 0.0.0.0 --port 8000

echo.
echo ✓ Servers starting in separate windows...
echo.
echo Main App:        http://localhost:5000
echo Body Tracking:   http://localhost:8000
echo.
pause
