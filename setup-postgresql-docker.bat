@echo off
echo Setting up PostgreSQL with Docker for InteliMaster...
echo.

echo Step 1: Checking if Docker is installed
docker --version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Docker is not installed. Please install Docker Desktop first.
    echo Download from: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)

echo Docker found. Starting PostgreSQL container...
echo.

echo Step 2: Stopping any existing PostgreSQL container
docker stop postgres-intelimaster >nul 2>nul
docker rm postgres-intelimaster >nul 2>nul

echo Step 3: Starting PostgreSQL container
docker run --name postgres-intelimaster ^
    -e POSTGRES_DB=intelimaster ^
    -e POSTGRES_USER=intelimaster_user ^
    -e POSTGRES_PASSWORD=intelimaster123 ^
    -p 5432:5432 ^
    -d postgres:15

echo.
echo Step 4: Waiting for PostgreSQL to start...
timeout /t 10 /nobreak > nul

echo Step 5: Creating environment file
echo SECRET_KEY=your-secret-key-change-this-in-production-12345 > backend\.env
echo DATABASE_URL=postgresql://intelimaster_user:intelimaster123@localhost:5432/intelimaster >> backend\.env

echo.
echo PostgreSQL setup complete!
echo Database: intelimaster
echo User: intelimaster_user
echo Password: intelimaster123
echo Host: localhost:5432
echo.
echo You can now run the application with: start-dev.bat
echo.
echo To stop PostgreSQL: docker stop postgres-intelimaster
echo To start PostgreSQL: docker start postgres-intelimaster
pause







