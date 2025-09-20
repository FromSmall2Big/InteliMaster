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

# Configure PostgreSQL authentication for local connections
echo ""
echo "Step 4.1: Configuring PostgreSQL authentication..."
PG_VERSION=$(sudo -u postgres psql -t -c "SELECT version();" | grep -oP '\d+\.\d+' | head -1)
PG_CONFIG_DIR="/etc/postgresql/${PG_VERSION}/main"

if [ -d "$PG_CONFIG_DIR" ]; then
    echo "PostgreSQL version: $PG_VERSION"
    echo "Config directory: $PG_CONFIG_DIR"
    
    # Backup original pg_hba.conf
    sudo cp "$PG_CONFIG_DIR/pg_hba.conf" "$PG_CONFIG_DIR/pg_hba.conf.backup"
    
    # Add local connection rules if not already present
    if ! sudo grep -q "local   intelimaster" "$PG_CONFIG_DIR/pg_hba.conf"; then
        echo "Adding local authentication rules..."
        sudo tee -a "$PG_CONFIG_DIR/pg_hba.conf" > /dev/null << EOF

# InteliMaster local connections
local   intelimaster         intelimaster_user                    md5
host    intelimaster         intelimaster_user    127.0.0.1/32   md5
host    intelimaster         intelimaster_user    ::1/128        md5
EOF
    fi
    
    # Restart PostgreSQL to apply changes
    echo "Restarting PostgreSQL to apply authentication changes..."
    sudo systemctl restart postgresql
    
    # Wait for PostgreSQL to start
    sleep 3
    
    # Check if PostgreSQL is running after restart
    if ! sudo systemctl is-active --quiet postgresql; then
        echo "Error: PostgreSQL failed to restart"
        echo "Restoring backup configuration..."
        sudo cp "$PG_CONFIG_DIR/pg_hba.conf.backup" "$PG_CONFIG_DIR/pg_hba.conf"
        sudo systemctl restart postgresql
        echo "Please check PostgreSQL configuration manually"
    fi
else
    echo "Warning: Could not find PostgreSQL config directory. You may need to configure authentication manually."
fi

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
# Security Configuration
SECRET_KEY=your-secret-key-change-this-in-production-12345

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=intelimaster
DB_USER=intelimaster_user
DB_PASSWORD=intelimaster123

# Application Configuration
DEBUG=True
HOST=0.0.0.0
PORT=8000

# Frontend Configuration
FRONTEND_URL=http://localhost:3000
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

