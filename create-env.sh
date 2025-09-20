#!/bin/bash

# Create environment file for InteliMaster backend

echo "Creating backend/.env file..."

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


