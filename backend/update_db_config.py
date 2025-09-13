#!/usr/bin/env python3
"""
Database Configuration Updater
This script helps you easily update database configuration in the .env file
"""

import os
import sys
from pathlib import Path

def update_database_config():
    """Interactive script to update database configuration"""
    env_file = Path(".env")
    
    if not env_file.exists():
        print("❌ .env file not found!")
        print("Please run this script from the backend directory where .env file exists.")
        return
    
    print("🔧 Database Configuration Updater")
    print("=" * 40)
    
    # Read current values
    current_config = {}
    with open(env_file, 'r') as f:
        for line in f:
            if '=' in line and not line.strip().startswith('#'):
                key, value = line.strip().split('=', 1)
                current_config[key] = value
    
    print("Current configuration:")
    print(f"  DB_HOST: {current_config.get('DB_HOST', 'Not set')}")
    print(f"  DB_PORT: {current_config.get('DB_PORT', 'Not set')}")
    print(f"  DB_NAME: {current_config.get('DB_NAME', 'Not set')}")
    print(f"  DB_USER: {current_config.get('DB_USER', 'Not set')}")
    print(f"  DB_PASSWORD: {'*' * len(current_config.get('DB_PASSWORD', '')) if current_config.get('DB_PASSWORD') else 'Not set'}")
    print()
    
    # Get new values
    new_config = {}
    new_config['DB_HOST'] = input(f"Enter DB_HOST [{current_config.get('DB_HOST', 'localhost')}]: ").strip() or current_config.get('DB_HOST', 'localhost')
    new_config['DB_PORT'] = input(f"Enter DB_PORT [{current_config.get('DB_PORT', '5432')}]: ").strip() or current_config.get('DB_PORT', '5432')
    new_config['DB_NAME'] = input(f"Enter DB_NAME [{current_config.get('DB_NAME', 'intelimaster')}]: ").strip() or current_config.get('DB_NAME', 'intelimaster')
    new_config['DB_USER'] = input(f"Enter DB_USER [{current_config.get('DB_USER', 'intelimaster_user')}]: ").strip() or current_config.get('DB_USER', 'intelimaster_user')
    new_config['DB_PASSWORD'] = input(f"Enter DB_PASSWORD [{current_config.get('DB_PASSWORD', 'intelimaster123')}]: ").strip() or current_config.get('DB_PASSWORD', 'intelimaster123')
    
    # Update .env file
    lines = []
    with open(env_file, 'r') as f:
        lines = f.readlines()
    
    # Update the lines
    for i, line in enumerate(lines):
        if line.strip().startswith('DB_HOST='):
            lines[i] = f"DB_HOST={new_config['DB_HOST']}\n"
        elif line.strip().startswith('DB_PORT='):
            lines[i] = f"DB_PORT={new_config['DB_PORT']}\n"
        elif line.strip().startswith('DB_NAME='):
            lines[i] = f"DB_NAME={new_config['DB_NAME']}\n"
        elif line.strip().startswith('DB_USER='):
            lines[i] = f"DB_USER={new_config['DB_USER']}\n"
        elif line.strip().startswith('DB_PASSWORD='):
            lines[i] = f"DB_PASSWORD={new_config['DB_PASSWORD']}\n"
    
    # Write back to file
    with open(env_file, 'w') as f:
        f.writelines(lines)
    
    print("\n✅ Database configuration updated successfully!")
    print("\nNew configuration:")
    print(f"  DB_HOST: {new_config['DB_HOST']}")
    print(f"  DB_PORT: {new_config['DB_PORT']}")
    print(f"  DB_NAME: {new_config['DB_NAME']}")
    print(f"  DB_USER: {new_config['DB_USER']}")
    print(f"  DB_PASSWORD: {'*' * len(new_config['DB_PASSWORD'])}")
    print("\nYou can now restart the application to use the new configuration.")

if __name__ == "__main__":
    update_database_config()


