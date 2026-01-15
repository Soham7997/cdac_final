#!/usr/bin/env python3
"""
Unified startup script for Drone Tech AI Portal
Starts both Flask (main app) and FastAPI (body tracking) servers
"""

import os
import sys
import subprocess
import time
import signal
import threading

# Colors for terminal output
GREEN = '\033[92m'
BLUE = '\033[94m'
YELLOW = '\033[93m'
RED = '\033[91m'
RESET = '\033[0m'

def print_banner():
    print(f"""
{BLUE}╔══════════════════════════════════════════════════════╗
║     Drone Tech AI Portal - Unified Startup Script    ║
║                                                      ║
║  Main App (Flask):        http://localhost:5000    ║
║  Body Tracking (FastAPI): http://localhost:8000    ║
╚══════════════════════════════════════════════════════╝{RESET}
    """)

def start_flask_server():
    """Start the main Flask server on port 5000"""
    print(f"{GREEN}[1/2] Starting Flask server on port 5000...{RESET}")
    try:
        subprocess.run([sys.executable, 'server.py'])
    except KeyboardInterrupt:
        print(f"{YELLOW}Flask server stopped{RESET}")
    except Exception as e:
        print(f"{RED}Error starting Flask server: {e}{RESET}")

def start_body_tracking_server():
    """Start the body tracking FastAPI server on port 8000"""
    print(f"{GREEN}[2/2] Waiting 3 seconds before starting Body Tracking server...{RESET}")
    time.sleep(3)
    print(f"{GREEN}Starting FastAPI Body Tracking server on port 8000...{RESET}")
    try:
        # Change to CDAC-INTERNSHIP directory
        cdac_path = os.path.join(os.getcwd(), 'CDAC-INTERNSHIP')
        if not os.path.exists(cdac_path):
            print(f"{RED}Error: CDAC-INTERNSHIP folder not found{RESET}")
            return
        
        os.chdir(cdac_path)
        # Set environment variables for the server
        env = os.environ.copy()
        env['HOST'] = '0.0.0.0'
        env['PORT'] = '8000'
        
        # Use uvicorn directly to run fixed_colab.py
        subprocess.run([sys.executable, '-m', 'uvicorn', 'fixed_colab:app', 
                       '--host', '0.0.0.0', '--port', '8000', '--reload'], env=env)
    except KeyboardInterrupt:
        print(f"{YELLOW}Body Tracking server stopped{RESET}")
    except Exception as e:
        print(f"{RED}Error starting Body Tracking server: {e}{RESET}")
        print(f"{YELLOW}Make sure fastapi and uvicorn are installed: pip install fastapi uvicorn{RESET}")

def main():
    print_banner()
    
    # Create threads for both servers
    flask_thread = threading.Thread(target=start_flask_server, daemon=False)
    tracking_thread = threading.Thread(target=start_body_tracking_server, daemon=True)
    
    # Start both servers
    flask_thread.start()
    tracking_thread.start()
    
    print(f"\n{BLUE}Both servers starting...{RESET}")
    print(f"{GREEN}✓ Main App will be at:        http://localhost:5000{RESET}")
    print(f"{GREEN}✓ Body Tracking will be at:   http://localhost:8000{RESET}")
    print(f"{YELLOW}Press Ctrl+C to stop all servers{RESET}\n")
    
    try:
        # Keep the main thread alive
        flask_thread.join()
    except KeyboardInterrupt:
        print(f"\n{YELLOW}Shutting down all servers...{RESET}")

if __name__ == '__main__':
    main()
