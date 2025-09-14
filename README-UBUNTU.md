# InteliMaster - Ubuntu Setup Guide

This guide will help you set up and run InteliMaster on Ubuntu.

## Quick Start

### Option 1: Automated Setup (Recommended)
```bash
# Clone the repository
git clone <your-repo-url>
cd Intelimaster

# Run the automated setup script
./setup-ubuntu.sh
```

### Option 2: Manual Setup

#### 1. Install System Dependencies
```bash
sudo apt update
sudo apt install -y curl wget git build-essential software-properties-common
```

#### 2. Install Python 3
```bash
sudo apt install -y python3 python3-pip python3-venv
```

#### 3. Install Node.js
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### 4. Setup Database
Choose one of the following options:

**Option A: Native PostgreSQL**
```bash
sudo apt install -y postgresql postgresql-contrib
./setup-postgresql.sh
```

**Option B: Docker PostgreSQL**
```bash
# Install Docker first
sudo apt install -y docker.io
sudo usermod -aG docker $USER
# Log out and log back in
./setup-postgresql-docker.sh
```

#### 5. Install Project Dependencies
```bash
# Backend
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cd ..

# Frontend
cd frontend
npm install
cd ..
```

## Running the Application

### Start Development Servers
```bash
./start-dev.sh
```

This will start both the FastAPI backend (port 8000) and Next.js frontend (port 3000).

### Access the Application
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs

## Available Scripts

| Script | Description |
|--------|-------------|
| `./setup-ubuntu.sh` | Complete automated setup for Ubuntu |
| `./start-dev.sh` | Start both frontend and backend servers |
| `./setup-postgresql.sh` | Setup PostgreSQL natively |
| `./setup-postgresql-docker.sh` | Setup PostgreSQL with Docker |

## Database Management

### Native PostgreSQL
```bash
# Start/Stop service
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl status postgresql

# Connect to database
psql -h localhost -U intelimaster_user -d intelimaster
```

### Docker PostgreSQL
```bash
# Start/Stop container
docker start postgres-intelimaster
docker stop postgres-intelimaster

# View logs
docker logs postgres-intelimaster

# Connect to database
docker exec -it postgres-intelimaster psql -U intelimaster_user -d intelimaster

# Remove container
docker rm -f postgres-intelimaster
```

## Troubleshooting

### Common Issues

1. **Permission denied when running scripts**
   ```bash
   chmod +x *.sh
   ```

2. **Docker permission denied**
   ```bash
   sudo usermod -aG docker $USER
   # Log out and log back in
   ```

3. **Python virtual environment issues**
   ```bash
   cd backend
   rm -rf venv
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

4. **Node.js dependencies issues**
   ```bash
   cd frontend
   rm -rf node_modules package-lock.json
   npm install
   ```

5. **Database connection issues**
   - Check if PostgreSQL is running: `sudo systemctl status postgresql`
   - Check if Docker container is running: `docker ps`
   - Verify environment file: `cat backend/.env`

### Getting Help

If you encounter any issues:
1. Check the error messages carefully
2. Ensure all dependencies are installed
3. Verify database connectivity
4. Check the logs for more details

## Development

### Project Structure
```
Intelimaster/
├── backend/          # FastAPI backend
├── frontend/         # Next.js frontend
├── *.sh             # Ubuntu shell scripts
└── README-UBUNTU.md # This file
```

### Environment Variables
The setup scripts create a `backend/.env` file with:
```
SECRET_KEY=your-secret-key-change-this-in-production-12345
DATABASE_URL=postgresql://intelimaster_user:intelimaster123@localhost:5432/intelimaster
```

**Important**: Change the SECRET_KEY in production!

## Production Deployment

For production deployment on Ubuntu:
1. Use a production WSGI server like Gunicorn
2. Use a reverse proxy like Nginx
3. Use a production database
4. Set up proper environment variables
5. Use HTTPS
6. Set up monitoring and logging

Happy coding! 🚀
