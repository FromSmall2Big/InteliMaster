#!/bin/bash

# Setup PostgreSQL for InteliMaster on Ubuntu

set -e  # Exit on any error

echo "Setting up PostgreSQL for InteliMaster on Ubuntu..."
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Error: Please don't run this script as root. Run as a regular user."
    echo "The script will ask for sudo password when needed."
    exit 1
fi

# Update package list
echo "Step 1: Updating package list..."
sudo apt update

# Install PostgreSQL if not already installed
echo ""
echo "Step 2: Installing PostgreSQL..."
if ! command_exists psql; then
    sudo apt install -y postgresql postgresql-contrib
    echo "PostgreSQL installed successfully!"
else
    echo "PostgreSQL is already installed."
fi

# Start and enable PostgreSQL service
echo ""
echo "Step 3: Starting PostgreSQL service..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Check if PostgreSQL is running
if ! sudo systemctl is-active --quiet postgresql; then
    echo "Error: Failed to start PostgreSQL service"
    exit 1
fi

echo "PostgreSQL service is running."

# Create database and user
echo ""
echo "Step 4: Creating database and user..."

# Switch to postgres user to create database and user
sudo -u postgres psql -c "CREATE DATABASE intelimaster;" 2>/dev/null || echo "Database 'intelimaster' already exists."
sudo -u postgres psql -c "CREATE USER intelimaster_user WITH PASSWORD 'intelimaster123';" 2>/dev/null || echo "User 'intelimaster_user' already exists."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE intelimaster TO intelimaster_user;"
sudo -u postgres psql -c "ALTER USER intelimaster_user CREATEDB;"

# Test connection
echo ""
echo "Step 5: Testing database connection..."
if PGPASSWORD='intelimaster123' psql -h localhost -U intelimaster_user -d intelimaster -c "SELECT version();" >/dev/null 2>&1; then
    echo "✅ Database connection successful!"
else
    echo "❌ Database connection failed. Please check the setup."
    exit 1
fi

# Create environment file
echo ""
echo "Step 6: Creating environment file..."
cat > backend/.env << EOF
SECRET_KEY=your-secret-key-change-this-in-production-12345
DATABASE_URL=postgresql://intelimaster_user:intelimaster123@localhost:5432/intelimaster
EOF

echo "Environment file created at backend/.env"

# Install Python dependencies for database connection
echo ""
echo "Step 7: Installing Python database dependencies..."
cd backend
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate
pip install psycopg2-binary

echo ""
echo "✅ PostgreSQL setup complete!"
echo "Database: intelimaster"
echo "User: intelimaster_user"
echo "Password: intelimaster123"
echo "Host: localhost:5432"
echo ""
echo "You can now run the application with: ./start-dev.sh"
echo ""
echo "To manage PostgreSQL:"
echo "  Start: sudo systemctl start postgresql"
echo "  Stop: sudo systemctl stop postgresql"
echo "  Status: sudo systemctl status postgresql"
echo "  Connect: psql -h localhost -U intelimaster_user -d intelimaster"
