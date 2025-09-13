#!/bin/bash

# Start development servers for both frontend and backend

echo "Starting InteliMaster development environment..."

# Start backend in background
echo "Starting FastAPI backend..."
cd backend
python -m venv venv
source venv/bin/activate 2>/dev/null || source venv/Scripts/activate 2>/dev/null
pip install -r requirements.txt
python run.py &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 3

# Start frontend
echo "Starting Next.js frontend..."
cd ../frontend
npm install
npm run dev &
FRONTEND_PID=$!

echo "Development servers started!"
echo "Backend: http://localhost:8000"
echo "Frontend: http://localhost:3000"
echo "API Docs: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop both servers"

# Wait for user to stop
wait

# Cleanup on exit
kill $BACKEND_PID 2>/dev/null
kill $FRONTEND_PID 2>/dev/null








