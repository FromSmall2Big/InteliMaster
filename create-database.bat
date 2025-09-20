@echo off
echo Creating InteliMaster PostgreSQL Database...
echo.

echo Step 1: Testing PostgreSQL connection
psql --version
if %ERRORLEVEL% NEQ 0 (
    echo PostgreSQL is not installed or not in PATH.
    echo Please install PostgreSQL from: https://www.postgresql.org/download/windows/
    echo Make sure to add PostgreSQL to PATH during installation.
    pause
    exit /b 1
)

echo PostgreSQL found. Creating database and user...
echo.

echo Step 2: Creating database and user
echo Please enter the PostgreSQL password when prompted...
echo.

psql -U postgres -c "CREATE DATABASE intelimaster;" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Database 'intelimaster' created successfully.
) else (
    echo Database 'intelimaster' may already exist or there was an error.
)

psql -U postgres -c "CREATE USER intelimaster_user WITH PASSWORD 'intelimaster123';" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo User 'intelimaster_user' created successfully.
) else (
    echo User 'intelimaster_user' may already exist or there was an error.
)

psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE intelimaster TO intelimaster_user;" 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Privileges granted successfully.
) else (
    echo Error granting privileges.
)

echo.
echo Step 3: Creating environment file
echo Creating backend\.env file...
echo SECRET_KEY=your-secret-key-change-this-in-production-12345 > backend\.env
echo DATABASE_URL=postgresql://intelimaster_user:intelimaster123@localhost:5432/intelimaster >> backend\.env

echo.
echo PostgreSQL setup complete!
echo.
echo Database Details:
echo - Database: intelimaster
echo - User: intelimaster_user  
echo - Password: intelimaster123
echo - Host: localhost
echo - Port: 5432
echo.
echo You can now run the application with: start-dev.bat
echo.
pause










