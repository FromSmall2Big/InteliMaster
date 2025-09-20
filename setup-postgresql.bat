@echo off
echo Setting up PostgreSQL for InteliMaster...
echo.

echo Step 1: Installing PostgreSQL via Chocolatey (if available)
where choco >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Chocolatey found. Installing PostgreSQL...
    choco install postgresql -y
) else (
    echo Chocolatey not found. Please install PostgreSQL manually.
    echo Download from: https://www.postgresql.org/download/windows/
    echo.
    echo After installation, run this script again.
    pause
    exit /b 1
)

echo.
echo Step 2: Starting PostgreSQL service
net start postgresql-x64-15

echo.
echo Step 3: Creating database and user
echo Please enter the PostgreSQL password when prompted...
psql -U postgres -c "CREATE DATABASE intelimaster;"
psql -U postgres -c "CREATE USER intelimaster_user WITH PASSWORD 'intelimaster123';"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE intelimaster TO intelimaster_user;"

echo.
echo Step 4: Creating environment file
echo SECRET_KEY=your-secret-key-change-this-in-production-12345 > backend\.env
echo DATABASE_URL=postgresql://intelimaster_user:intelimaster123@localhost:5432/intelimaster >> backend\.env

echo.
echo PostgreSQL setup complete!
echo Database: intelimaster
echo User: intelimaster_user
echo Password: intelimaster123
echo.
echo You can now run the application with: start-dev.bat
pause











