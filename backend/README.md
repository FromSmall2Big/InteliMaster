# InteliMaster Backend API

A FastAPI-based backend service with JWT authentication for the InteliMaster application.

## Features

- User registration and authentication
- JWT token-based authentication
- PostgreSQL database with SQLAlchemy ORM
- Password hashing with bcrypt
- CORS support for frontend integration
- RESTful API endpoints

## Setup

1. **Install dependencies:**
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

2. **Set up PostgreSQL database:**
   - Install PostgreSQL on your system
   - Create a database named `intelimaster`
   - Create a user with appropriate permissions

3. **Set up environment variables:**
   Create a `.env` file in the backend directory (copy from `env.example`):
   ```
   SECRET_KEY=your-super-secret-key-change-this-in-production-12345
   DATABASE_URL=postgresql://username:password@localhost:5432/intelimaster
   ```

4. **Run the development server:**
   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

The API will be available at `http://localhost:8000`

## API Endpoints

### Authentication
- `POST /signup` - Register a new user
- `POST /token` - Sign in and get access token
- `GET /users/me` - Get current user information (requires authentication)

### General
- `GET /` - API status
- `GET /health` - Health check

## API Documentation

Once the server is running, you can access:
- Interactive API docs: `http://localhost:8000/docs`
- Alternative docs: `http://localhost:8000/redoc`

## Database

The application uses PostgreSQL. Make sure you have PostgreSQL installed and running, then:

1. Create a database:
   ```sql
   CREATE DATABASE intelimaster;
   ```

2. Create a user (optional, you can use the default postgres user):
   ```sql
   CREATE USER your_username WITH PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE intelimaster TO your_username;
   ```

3. Update your `.env` file with the correct database URL

The database tables will be created automatically when you first run the application.

## Security

- Passwords are hashed using bcrypt
- JWT tokens expire after 30 minutes
- CORS is configured for the frontend URL
- Remember to change the SECRET_KEY in production!

