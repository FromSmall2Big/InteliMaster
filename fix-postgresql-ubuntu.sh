#!/bin/bash

# PostgreSQL Troubleshooting and Fix Script for InteliMaster on Ubuntu

set -e  # Exit on any error

echo "🔧 PostgreSQL Troubleshooting and Fix Script for Ubuntu"
echo "=================================================="
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check PostgreSQL service status
check_postgres_status() {
    echo "Checking PostgreSQL service status..."
    if sudo systemctl is-active --quiet postgresql; then
        echo "✅ PostgreSQL service is running"
        return 0
    else
        echo "❌ PostgreSQL service is not running"
        return 1
    fi
}

# Function to start PostgreSQL service
start_postgres() {
    echo "Starting PostgreSQL service..."
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    sleep 3
    
    if check_postgres_status; then
        echo "✅ PostgreSQL started successfully"
        return 0
    else
        echo "❌ Failed to start PostgreSQL"
        return 1
    fi
}

# Function to test database connection
test_db_connection() {
    echo "Testing database connection..."
    if PGPASSWORD='intelimaster123' psql -h localhost -U intelimaster_user -d intelimaster -c "SELECT version();" >/dev/null 2>&1; then
        echo "✅ Database connection successful!"
        return 0
    else
        echo "❌ Database connection failed"
        return 1
    fi
}

# Function to fix PostgreSQL authentication
fix_postgres_auth() {
    echo "🔧 Fixing PostgreSQL authentication..."
    
    # Get PostgreSQL version and config directory
    PG_VERSION=$(sudo -u postgres psql -t -c "SELECT version();" | grep -oP '\d+\.\d+' | head -1)
    PG_CONFIG_DIR="/etc/postgresql/${PG_VERSION}/main"
    
    if [ -d "$PG_CONFIG_DIR" ]; then
        echo "PostgreSQL version: $PG_VERSION"
        echo "Config directory: $PG_CONFIG_DIR"
        
        # Backup original pg_hba.conf
        echo "Creating backup of pg_hba.conf..."
        sudo cp "$PG_CONFIG_DIR/pg_hba.conf" "$PG_CONFIG_DIR/pg_hba.conf.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Check if our rules already exist
        if sudo grep -q "local   intelimaster" "$PG_CONFIG_DIR/pg_hba.conf"; then
            echo "Authentication rules already exist"
        else
            echo "Adding authentication rules..."
            sudo tee -a "$PG_CONFIG_DIR/pg_hba.conf" > /dev/null << EOF

# InteliMaster local connections
local   intelimaster         intelimaster_user                    md5
host    intelimaster         intelimaster_user    127.0.0.1/32   md5
host    intelimaster         intelimaster_user    ::1/128        md5
EOF
        fi
        
        echo "Restarting PostgreSQL to apply changes..."
        sudo systemctl restart postgresql
        sleep 3
        
        if check_postgres_status; then
            echo "✅ PostgreSQL authentication configured successfully"
            return 0
        else
            echo "❌ PostgreSQL failed to restart after auth changes"
            return 1
        fi
    else
        echo "❌ Could not find PostgreSQL config directory: $PG_CONFIG_DIR"
        return 1
    fi
}

# Function to recreate database and user
recreate_db_user() {
    echo "🔧 Recreating database and user..."
    
    # Drop existing database and user if they exist
    sudo -u postgres psql -c "DROP DATABASE IF EXISTS intelimaster;" 2>/dev/null || true
    sudo -u postgres psql -c "DROP USER IF EXISTS intelimaster_user;" 2>/dev/null || true
    
    # Create database and user
    sudo -u postgres psql -c "CREATE DATABASE intelimaster;"
    sudo -u postgres psql -c "CREATE USER intelimaster_user WITH PASSWORD 'intelimaster123';"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE intelimaster TO intelimaster_user;"
    sudo -u postgres psql -c "ALTER USER intelimaster_user CREATEDB;"
    
    echo "✅ Database and user recreated successfully"
}

# Function to create environment file
create_env_file() {
    echo "🔧 Creating environment file..."
    
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
    
    echo "✅ Environment file created at backend/.env"
}

# Main troubleshooting flow
echo "Starting PostgreSQL troubleshooting..."

# Step 1: Check if PostgreSQL is installed
if ! command_exists psql; then
    echo "❌ PostgreSQL is not installed. Installing..."
    sudo apt update
    sudo apt install -y postgresql postgresql-contrib
fi

# Step 2: Check PostgreSQL service status
if ! check_postgres_status; then
    echo "PostgreSQL service is not running. Starting it..."
    if ! start_postgres; then
        echo "❌ Failed to start PostgreSQL service. Please check system logs:"
        echo "   sudo journalctl -u postgresql"
        exit 1
    fi
fi

# Step 3: Test database connection
if ! test_db_connection; then
    echo "Database connection failed. Attempting to fix..."
    
    # Try to fix authentication
    if fix_postgres_auth; then
        echo "Authentication fixed. Testing connection again..."
        if test_db_connection; then
            echo "✅ Connection successful after auth fix!"
        else
            echo "Still failing. Recreating database and user..."
            recreate_db_user
            if test_db_connection; then
                echo "✅ Connection successful after recreating database!"
            else
                echo "❌ Still failing. Manual intervention required."
                exit 1
            fi
        fi
    else
        echo "❌ Failed to fix authentication. Manual intervention required."
        exit 1
    fi
fi

# Step 4: Ensure environment file exists
if [ ! -f "backend/.env" ]; then
    create_env_file
else
    echo "✅ Environment file already exists"
fi

# Step 5: Install Python dependencies
echo "🔧 Installing Python dependencies..."
cd backend
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate
pip install --upgrade pip
pip install psycopg2-binary
cd ..

echo ""
echo "🎉 PostgreSQL troubleshooting complete!"
echo ""
echo "✅ PostgreSQL is running"
echo "✅ Database connection is working"
echo "✅ Environment file is configured"
echo "✅ Python dependencies are installed"
echo ""
echo "You can now run the application with:"
echo "  ./start-dev.sh"
echo ""
echo "To test the database connection manually:"
echo "  psql -h localhost -U intelimaster_user -d intelimaster"
echo ""
echo "If you still have issues, check:"
echo "  1. PostgreSQL logs: sudo journalctl -u postgresql"
echo "  2. Authentication config: sudo cat /etc/postgresql/*/main/pg_hba.conf"
echo "  3. Network connectivity: telnet localhost 5432"



