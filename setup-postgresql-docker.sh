#!/bin/bash

# Setup PostgreSQL with Docker for InteliMaster on Ubuntu

set -e  # Exit on any error

echo "Setting up PostgreSQL with Docker for InteliMaster on Ubuntu..."
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Docker is installed
echo "Step 1: Checking if Docker is installed..."
if ! command_exists docker; then
    echo "Docker is not installed. Installing Docker..."
    echo ""
    
    # Update package index
    sudo apt update
    
    # Install required packages
    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    sudo apt update
    
    # Install Docker
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    echo ""
    echo "Docker installed successfully!"
    echo "⚠️  IMPORTANT: Please log out and log back in for Docker group changes to take effect."
    echo "   Or run: newgrp docker"
    echo ""
    echo "After logging back in, run this script again."
    exit 0
else
    echo "Docker is already installed."
fi

# Check if Docker daemon is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker daemon is not running. Starting Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Check if user is in docker group
if ! groups $USER | grep -q '\bdocker\b'; then
    echo "Adding user to docker group..."
    sudo usermod -aG docker $USER
    echo "⚠️  Please log out and log back in for Docker group changes to take effect."
    echo "   Or run: newgrp docker"
    echo "   Then run this script again."
    exit 0
fi

echo ""
echo "Step 2: Stopping any existing PostgreSQL container..."
docker stop postgres-intelimaster 2>/dev/null || true
docker rm postgres-intelimaster 2>/dev/null || true

echo ""
echo "Step 3: Starting PostgreSQL container..."
docker run --name postgres-intelimaster \
    -e POSTGRES_DB=intelimaster \
    -e POSTGRES_USER=intelimaster_user \
    -e POSTGRES_PASSWORD=intelimaster123 \
    -p 5432:5432 \
    -d postgres:15

echo ""
echo "Step 4: Waiting for PostgreSQL to start..."
sleep 10

# Check if container is running
if ! docker ps | grep -q postgres-intelimaster; then
    echo "Error: PostgreSQL container failed to start"
    echo "Container logs:"
    docker logs postgres-intelimaster
    exit 1
fi

echo "PostgreSQL container is running."

# Test connection
echo ""
echo "Step 5: Testing database connection..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if docker exec postgres-intelimaster psql -U intelimaster_user -d intelimaster -c "SELECT version();" >/dev/null 2>&1; then
        echo "✅ Database connection successful!"
        break
    else
        echo "Attempt $attempt/$max_attempts: Waiting for database to be ready..."
        sleep 2
        ((attempt++))
    fi
done

if [ $attempt -gt $max_attempts ]; then
    echo "❌ Database connection failed after $max_attempts attempts"
    echo "Container logs:"
    docker logs postgres-intelimaster
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
echo "✅ PostgreSQL Docker setup complete!"
echo "Database: intelimaster"
echo "User: intelimaster_user"
echo "Password: intelimaster123"
echo "Host: localhost:5432"
echo ""
echo "You can now run the application with: ./start-dev.sh"
echo ""
echo "Docker commands:"
echo "  Stop PostgreSQL: docker stop postgres-intelimaster"
echo "  Start PostgreSQL: docker start postgres-intelimaster"
echo "  View logs: docker logs postgres-intelimaster"
echo "  Connect to DB: docker exec -it postgres-intelimaster psql -U intelimaster_user -d intelimaster"
echo "  Remove container: docker rm -f postgres-intelimaster"
