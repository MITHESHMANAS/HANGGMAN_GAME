# Hanggman Game

A full-stack Hanggman game built with a Python Flask backend, MySQL database, and a clean HTML/CSS frontend.

## Project structure

- `backend/`
  - `app.py` - Flask API server
  - `requirements.txt` - Python dependencies
  - `database/schema.sql` - MySQL schema and sample data
- `frontend/`
  - `index.html` - Single-page frontend UI

## Features

- User registration and login
- Start a new Hangman game with a random word
- Letter guessing with remaining lives and mask updates
- Player stats and leaderboard support
- MySQL persistence for users, words, and game state

## Requirements

- Python 3.8+
- Flask
- Flask-CORS
- PyMySQL
- MySQL / MariaDB

## Setup

### 1. Clone the repository

### 2. Set up MySQL database

Open your MySQL client (Command Prompt or MySQL Workbench) and run:

```sql
SOURCE backend/database/schema.sql;
```

This creates the `hangman_game` database with tables, sample data, and a test user.

### 3. Create a Python virtual environment

From the `backend` folder:

```powershell
cd backend
python -m venv venv
```

Activate the virtual environment:

**Windows PowerShell:**
```powershell
.\venv\Scripts\Activate.ps1
```

If blocked, allow it first:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\venv\Scripts\Activate.ps1
```

### 4. Install Python dependencies

```powershell
pip install flask flask-cors pymysql python-dotenv
```

(Or use: `pip install -r requirements.txt`)

### 5. Configure database credentials

Create a `.env` file in the `backend` folder:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=hangman_game
```

**Important:** Add `.env` to `.gitignore` (already included) so credentials are never committed to Git.

### 6. Run the backend server

From the `backend` folder (with venv activated):

```powershell
python app.py
```

You should see:
```
Running on http://127.0.0.1:5000
```

### 7. Open the frontend

Open `frontend/index.html` in your web browser, or double-click it from your file explorer.

## Usage

- Use the `Register` tab to create a new player.
- Use the `Login` tab to sign in.
- Start a new game and guess letters to reveal the hidden word.
- Check the leaderboard for top players.

## Notes

- The database schema includes sample categories, words, and a test user (username: `test`, password: `test`).
- Passwords are hashed with SHA-256 before storing in the database.
- The frontend communicates with the backend via the Flask API at `http://localhost:5000/api`.
- Update `.env` or `backend/app.py` to customize database connection settings.

## Troubleshooting

**"ModuleNotFoundError: No module named 'flask'"**
- Ensure your virtual environment is activated (you should see `(venv)` in your terminal).
- Run: `pip install -r requirements.txt`

**"Access denied for user 'root'@'localhost'"**
- Check your MySQL credentials in `.env`
- Ensure MySQL is running
- Verify the database user exists and has the correct password

**"CORS error in browser console"**
- Make sure the Flask backend is running (`python app.py`)
- Check that the frontend is accessing `http://localhost:5000/api`

**Port 5000 already in use**
- Another application is using port 5000, or Flask is already running
- Kill the process or change the port in `app.py`

## License

This project is free to use and modify.