# Environment Configuration Guide

This project uses individual environment variables for database configuration instead of a single DATABASE_URL. This approach is more secure and flexible.

## Environment Variables

### Required Variables

| Variable | Description | Default Value | Example |
|----------|-------------|---------------|---------|
| `DB_HOST` | Database host address | `localhost` | `localhost` or `db.example.com` |
| `DB_PORT` | Database port | `5432` | `5432` |
| `DB_NAME` | Database name | `intelimaster` | `intelimaster_prod` |
| `DB_USER` | Database username | `intelimaster_user` | `myapp_user` |
| `DB_PASSWORD` | Database password | `intelimaster123` | `secure_password_123` |

### Optional Variables

| Variable | Description | Default Value | Example |
|----------|-------------|---------------|---------|
| `SECRET_KEY` | JWT secret key | `your-secret-key-change-this-in-production-12345` | `my-super-secret-key-123` |
| `DEBUG` | Debug mode | `True` | `True` or `False` |
| `HOST` | Server host | `0.0.0.0` | `0.0.0.0` or `127.0.0.1` |
| `PORT` | Server port | `8000` | `8000` or `3000` |
| `FRONTEND_URL` | Frontend URL for CORS | `http://localhost:3000` | `https://myapp.com` |

## Quick Setup

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the .env file with your values:**
   ```bash
   nano .env  # or use your preferred editor
   ```

3. **Or use the interactive script:**
   ```bash
   python update_db_config.py
   ```

## Environment Examples

### Development
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=intelimaster_dev
DB_USER=dev_user
DB_PASSWORD=dev_password123
DEBUG=True
```

### Production
```env
DB_HOST=prod-db.example.com
DB_PORT=5432
DB_NAME=intelimaster_prod
DB_USER=prod_user
DB_PASSWORD=secure_production_password_123
DEBUG=False
```

### Docker/Container
```env
DB_HOST=postgres_container
DB_PORT=5432
DB_NAME=intelimaster
DB_USER=intelimaster_user
DB_PASSWORD=intelimaster123
```

## Security Notes

- Never commit the `.env` file to version control
- Use strong, unique passwords for production
- Consider using environment-specific secret keys
- The `.env.example` file is safe to commit as it contains no real credentials

## Database URL Construction

The application automatically constructs the PostgreSQL connection string from individual components:

```
postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}
```

This approach provides better security and flexibility compared to storing the complete URL in a single variable.


