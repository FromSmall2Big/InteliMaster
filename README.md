# InteliMaster - Full Stack Application

A modern full-stack web application built with Next.js (frontend) and FastAPI (backend), featuring user authentication and a professional software development company website.

## 🚀 Features

### Frontend (Next.js + TypeScript)
- Modern React components with TypeScript
- Tailwind CSS for styling
- User authentication (signin/signup)
- Protected routes and dashboard
- Responsive design
- Form validation with react-hook-form

### Backend (FastAPI + Python)
- RESTful API with FastAPI
- JWT-based authentication
- SQLite database with SQLAlchemy ORM
- Password hashing with bcrypt
- CORS support
- Interactive API documentation

## 📁 Project Structure

```
InteliMaster/
├── frontend/                 # Next.js frontend application
│   ├── src/
│   │   ├── app/             # Next.js app router pages
│   │   ├── components/      # React components
│   │   ├── contexts/        # React context providers
│   │   └── lib/            # Utility functions and API client
│   ├── package.json
│   └── ...
├── backend/                 # FastAPI backend application
│   ├── main.py             # FastAPI application entry point
│   ├── models.py           # SQLAlchemy database models
│   ├── schemas.py          # Pydantic schemas
│   ├── auth.py             # Authentication utilities
│   ├── database.py         # Database configuration
│   ├── requirements.txt    # Python dependencies
│   └── README.md           # Backend-specific documentation
├── start-dev.sh            # Linux/Mac development script
├── start-dev.bat           # Windows development script
└── README.md               # This file
```

## 🛠️ Quick Start

### Prerequisites
- Node.js (v18 or higher)
- Python (v3.8 or higher)
- Git

### Option 1: Using the Development Scripts

**For Linux/Mac:**
```bash
./start-dev.sh
```

**For Windows:**
```bash
start-dev.bat
```

### Option 2: Manual Setup

#### 1. Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python run.py
```

The backend will be available at `http://localhost:8000`

#### 2. Frontend Setup
```bash
cd frontend
npm install
npm run dev
```

The frontend will be available at `http://localhost:3000`

## 🔧 Configuration

### Backend Environment Variables
Create a `.env` file in the `backend` directory:
```
SECRET_KEY=your-super-secret-key-change-this-in-production-12345
DATABASE_URL=sqlite:///./intelimaster.db
```

### Frontend Environment Variables
Create a `.env.local` file in the `frontend` directory:
```
NEXT_PUBLIC_API_URL=http://localhost:8000
```

## 📚 API Documentation

Once the backend is running, you can access:
- Interactive API docs: `http://localhost:8000/docs`
- Alternative docs: `http://localhost:8000/redoc`

## 🔐 Authentication Flow

1. **Sign Up**: Users can create accounts with email, password, and full name
2. **Sign In**: Users authenticate with email and password to receive JWT tokens
3. **Protected Routes**: Authenticated users are redirected to the dashboard
4. **Token Management**: JWT tokens are stored in HTTP-only cookies for security

## 🎨 Frontend Pages

- `/` - Home page (redirects to dashboard if authenticated)
- `/signin` - Sign in page
- `/signup` - Sign up page
- `/dashboard` - User dashboard (protected)
- `/services` - Services page
- `/about` - About page
- `/contact` - Contact page
- `/portfolios` - Portfolio page

## 🗄️ Database

The application uses SQLite for simplicity. The database file (`intelimaster.db`) is created automatically when you first run the backend.

### User Model
- `id`: Primary key
- `email`: Unique email address
- `hashed_password`: Bcrypt hashed password
- `full_name`: User's full name
- `is_active`: Account status
- `created_at`: Account creation timestamp
- `updated_at`: Last update timestamp

## 🚀 Deployment

### Backend Deployment
1. Set up a production database (PostgreSQL recommended)
2. Update `DATABASE_URL` in environment variables
3. Set a strong `SECRET_KEY`
4. Deploy using a service like Railway, Heroku, or AWS

### Frontend Deployment
1. Update `NEXT_PUBLIC_API_URL` to point to your production backend
2. Deploy using Vercel, Netlify, or your preferred platform

## 🧪 Testing

### Backend Testing
```bash
cd backend
python -m pytest
```

### Frontend Testing
```bash
cd frontend
npm test
```

## 📝 Development

### Adding New Features
1. Backend: Add new endpoints in `main.py`, models in `models.py`
2. Frontend: Create components in `src/components/`, pages in `src/app/`

### Code Style
- Backend: Follow PEP 8 Python style guide
- Frontend: Use Prettier and ESLint configurations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

If you encounter any issues:
1. Check the API documentation at `http://localhost:8000/docs`
2. Review the console logs for both frontend and backend
3. Ensure all dependencies are properly installed
4. Verify environment variables are set correctly

## 🔄 Updates

- **v1.0.0**: Initial release with authentication and basic dashboard
- Future updates will include more features and improvements

---

**Happy coding! 🎉**








