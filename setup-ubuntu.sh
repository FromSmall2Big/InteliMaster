#!/bin/bash

# Complete setup script for InteliMaster on Ubuntu

set -e  # Exit on any error

echo "🚀 Setting up InteliMaster development environment on Ubuntu..."
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

# Install system dependencies
echo ""
echo "Step 2: Installing system dependencies..."
sudo apt install -y curl wget git build-essential software-properties-common

# Install Python 3 and pip
echo ""
echo "Step 3: Installing Python 3 and pip..."
if ! command_exists python3; then
    sudo apt install -y python3 python3-pip python3-venv
    echo "Python 3 installed successfully!"
else
    echo "Python 3 is already installed."
fi

# Install Node.js (using NodeSource repository for latest LTS)
echo ""
echo "Step 4: Installing Node.js..."
if ! command_exists node; then
    echo "Installing Node.js 18.x LTS..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "Node.js installed successfully!"
else
    echo "Node.js is already installed."
    node --version
fi

# Install PostgreSQL
echo ""
echo "Step 5: Installing PostgreSQL..."
if ! command_exists psql; then
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    echo "PostgreSQL installed successfully!"
else
    echo "PostgreSQL is already installed."
fi

# Install Docker (optional)
echo ""
echo "Step 6: Installing Docker (optional)..."
if ! command_exists docker; then
    read -p "Do you want to install Docker? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Install Docker
        sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        sudo usermod -aG docker $USER
        echo "Docker installed successfully!"
        echo "⚠️  Please log out and log back in for Docker group changes to take effect."
    else
        echo "Skipping Docker installation."
    fi
else
    echo "Docker is already installed."
fi

# Setup database
echo ""
echo "Step 7: Setting up database..."
read -p "Do you want to use Docker for PostgreSQL? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Setting up PostgreSQL with Docker..."
    if [ -f "setup-postgresql-docker.sh" ]; then
        chmod +x setup-postgresql-docker.sh
        ./setup-postgresql-docker.sh
    else
        echo "❌ setup-postgresql-docker.sh not found!"
        echo "Falling back to native PostgreSQL setup..."
        chmod +x setup-postgresql.sh
        ./setup-postgresql.sh
    fi
else
    echo "Setting up PostgreSQL natively..."
    if [ -f "setup-postgresql.sh" ]; then
        chmod +x setup-postgresql.sh
        ./setup-postgresql.sh
    else
        echo "❌ setup-postgresql.sh not found!"
        echo "Please run the PostgreSQL setup manually or use Docker."
        exit 1
    fi
fi

# Check if database setup was successful
echo ""
echo "Step 7.1: Verifying database setup..."
if [ -f "backend/.env" ]; then
    echo "✅ Environment file created"
else
    echo "❌ Environment file not found. Creating it..."
    chmod +x create-env.sh
    ./create-env.sh
fi

# Test database connection
if PGPASSWORD='intelimaster123' psql -h localhost -U intelimaster_user -d intelimaster -c "SELECT 1;" >/dev/null 2>&1; then
    echo "✅ Database connection verified"
else
    echo "❌ Database connection failed!"
    echo "Running PostgreSQL troubleshooting script..."
    if [ -f "fix-postgresql-ubuntu.sh" ]; then
        chmod +x fix-postgresql-ubuntu.sh
        ./fix-postgresql-ubuntu.sh
    else
        echo "Please run the PostgreSQL setup again or check the configuration manually."
    fi
fi

# Install project dependencies
echo ""
echo "Step 8: Installing project dependencies..."

# Backend dependencies
echo "Installing Python dependencies..."
cd backend
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
cd ..

# Frontend dependencies
echo "Installing Node.js dependencies..."
cd frontend
npm install
cd ..

# Make scripts executable
echo ""
echo "Step 9: Making scripts executable..."
chmod +x *.sh

echo ""
echo "✅ Setup complete!"
echo ""
echo "🎉 InteliMaster is ready to run on Ubuntu!"
echo ""
echo "To start the development servers:"
echo "  ./start-dev.sh"
echo ""
echo "Available scripts:"
echo "  ./start-dev.sh              - Start both frontend and backend"
echo "  ./setup-postgresql.sh       - Setup PostgreSQL natively"
echo "  ./setup-postgresql-docker.sh - Setup PostgreSQL with Docker"
echo ""
echo "Database management:"
echo "  Native PostgreSQL:"
echo "    sudo systemctl start postgresql"
echo "    sudo systemctl stop postgresql"
echo "    psql -h localhost -U intelimaster_user -d intelimaster"
echo ""
echo "  Docker PostgreSQL:"
echo "    docker start postgres-intelimaster"
echo "    docker stop postgres-intelimaster"
echo "    docker exec -it postgres-intelimaster psql -U intelimaster_user -d intelimaster"
echo ""
echo "Happy coding! 🚀"

