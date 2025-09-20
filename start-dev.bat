@echo off
echo Starting InteliMaster development environment...

echo Starting FastAPI backend...
cd backend
python -m venv venv
call venv\Scripts\activate
pip install -r requirements.txt
start "Backend Server" cmd /k "python run.py"

echo Waiting for backend to start...
timeout /t 3 /nobreak > nul

echo Starting Next.js frontend...
cd ..\frontend
call npm install
start "Frontend Server" cmd /k "npm run dev"

echo Development servers started!
echo Backend: http://localhost:8000
echo Frontend: http://localhost:3000
echo API Docs: http://localhost:8000/docs
echo.
echo Press any key to exit...
pause > nul












