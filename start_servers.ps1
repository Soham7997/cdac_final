# Drone Tech AI Portal - PowerShell Startup Script

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     Drone Tech AI Portal - Startup                  ║" -ForegroundColor Cyan
Write-Host "║                                                      ║" -ForegroundColor Cyan
Write-Host "║  Main App (Flask):        http://localhost:5000    ║" -ForegroundColor Cyan
Write-Host "║  Body Tracking (FastAPI): http://localhost:8000    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check if venv exists
if (-not (Test-Path "venv\Scripts\Activate.ps1")) {
    Write-Host "Error: Virtual environment not found!" -ForegroundColor Red
    Write-Host "Please run: python -m venv venv" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Activate virtual environment
& "venv\Scripts\Activate.ps1"

Write-Host "Starting servers..." -ForegroundColor Green
Write-Host ""

# Start Flask server in new window
Write-Host "[1/2] Starting Flask server on port 5000..." -ForegroundColor Green
$flaskJob = Start-Process pwsh -ArgumentList "-NoExit", "-Command", "cd '$PWD'; python server.py" `
    -WindowStyle Normal -PassThru

# Wait a bit
Start-Sleep -Seconds 3

# Start FastAPI server in new window
Write-Host "[2/2] Starting Body Tracking FastAPI server on port 8000..." -ForegroundColor Green
$apiJob = Start-Process pwsh -ArgumentList "-NoExit", "-Command", `
    "cd '$PWD\CDAC-INTERNSHIP'; python -m uvicorn fixed_colab:app --host 0.0.0.0 --port 8000" `
    -WindowStyle Normal -PassThru

Write-Host ""
Write-Host "✓ Servers starting in separate windows..." -ForegroundColor Green
Write-Host ""
Write-Host "Main App:        http://localhost:5000" -ForegroundColor Cyan
Write-Host "Body Tracking:   http://localhost:8000" -ForegroundColor Cyan
Write-Host ""
Write-Host "To stop both servers, close the console windows." -ForegroundColor Yellow
