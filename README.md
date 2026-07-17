# 🎮 Hangman Game Platform

A **full-stack Hangman web application** built using **Python, Flask, MySQL, HTML5, CSS3, and JavaScript**. The application follows a client-server architecture where a responsive frontend communicates with a Flask backend through RESTful APIs to deliver an interactive word-guessing experience.

The project includes secure user authentication, persistent game sessions, dynamic gameplay, a coin-based hint system, player statistics, and a leaderboard backed by a relational MySQL database.

---

## 📖 Overview

Hangman Game Platform modernizes the classic Hangman game by combining a responsive web interface with a scalable backend architecture. Players can register, log in securely, start new games, guess letters, purchase hints using earned coins, and compete against other players on a leaderboard.

The frontend communicates with the backend using REST APIs, while the backend handles authentication, game logic, database operations, and player statistics.

---

# ✨ Features

### 👤 User Authentication

- Secure user registration
- User login authentication
- SHA-256 password hashing
- Persistent player profiles

### 🎯 Gameplay

- Random word generation
- Multiple word categories
- Interactive Hangman board
- Real-time word masking
- Remaining lives tracking
- Win/Loss detection
- Dynamic game state management

### 💡 Hint System

- Coin-based hint purchase
- Automatic letter reveal
- Wallet balance updates
- Transaction tracking

### 🏆 Leaderboard

- Player rankings
- Games played
- Games won
- Coin balance
- Dynamic leaderboard updates

### 💾 Database Features

- Persistent player data
- Game session storage
- Word categories
- Game history
- Transaction records

---

# 🏗️ System Architecture

```
                 Frontend
      HTML5 • CSS3 • JavaScript
                 │
        Fetch API (HTTP Requests)
                 │
                 ▼
          Flask REST API Server
                 │
      Authentication & Game Logic
                 │
                 ▼
         MySQL Relational Database
```

---

# 🛠️ Tech Stack

## Frontend

- HTML5
- CSS3
- JavaScript (ES6)
- Fetch API

## Backend

- Python
- Flask
- Flask-CORS
- PyMySQL
- python-dotenv

## Database

- MySQL

## Development Tools

- Git
- GitHub
- VS Code

---

# 📂 Project Structure

```
hangman-game/
│
├── backend/
│   ├── app.py
│   ├── requirements.txt
│   ├── .env.example
│   └── database/
│       └── schema.sql
│
├── frontend/
│   └── index.html
│
├── .gitignore
└── README.md
```

---

# 🗄️ Database Design

The application uses a normalized MySQL database to manage gameplay and player information.

Main tables include:

- Player
- Category
- Word
- Game
- Game_Word
- Transaction

The database stores:

- Player accounts
- Password hashes
- Word categories
- Random words
- Active game sessions
- Player statistics
- Wallet balance
- Hint transactions

---

# 🔌 REST API Endpoints

| Method | Endpoint | Description |
|---------|----------|-------------|
| POST | `/api/register` | Register a new player |
| POST | `/api/login` | Authenticate a player |
| POST | `/api/start-game` | Start a new Hangman game |
| POST | `/api/make-guess` | Submit a guessed letter |
| POST | `/api/get-hint` | Purchase and reveal a hint |
| GET | `/api/leaderboard` | Retrieve leaderboard |
| GET | `/api/test` | Test API & database connection |

---

# ⚙️ Installation

## 1. Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/HANGGMAN_GAME.git

cd HANGGMAN_GAME
```

---

## 2. Create MySQL Database

Open MySQL Workbench or Command Prompt.

Run:

```sql
SOURCE backend/database/schema.sql;
```

This creates:

- Database
- Tables
- Categories
- Sample words
- Test data

---

## 3. Create Virtual Environment

```bash
cd backend

python -m venv venv
```

---

## 4. Activate Virtual Environment

### Windows

```powershell
.\venv\Scripts\Activate.ps1
```

If PowerShell blocks execution:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Then activate again.

---

## 5. Install Dependencies

```bash
pip install -r requirements.txt
```

or

```bash
pip install flask flask-cors pymysql python-dotenv
```

---

## 6. Configure Environment Variables

Create a `.env` file inside the backend folder.

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=hangman_game
```

Never commit `.env` to GitHub.

---

## 7. Run Backend

```bash
python app.py
```

Expected output:

```
Running on http://127.0.0.1:5000
```

---

## 8. Launch Frontend

Open:

```
frontend/index.html
```

or

Use Live Server in VS Code.

---

# 🎮 How to Play

1. Register a new account.
2. Log in using your credentials.
3. Start a new game.
4. Guess letters to reveal the hidden word.
5. Use hints by spending coins.
6. Complete the word before running out of lives.
7. Earn coins for winning games.
8. Compete on the leaderboard.

---

# 🔒 Security Features

- SHA-256 password hashing
- Environment-based database configuration
- Server-side validation
- REST API architecture
- Persistent database storage

---

# 💡 Software Engineering Concepts

- Full-Stack Web Development
- Client–Server Architecture
- RESTful API Design
- Authentication
- CRUD Operations
- Relational Database Design
- Game State Management
- JSON Data Exchange
- Responsive Web Design
- Modular Backend Development

---

# 🚀 Future Improvements

- JWT Authentication
- Email Verification
- Multiplayer Mode
- Difficulty Levels
- Admin Dashboard
- Player Profiles
- Achievement System
- Sound Effects
- Dark Mode
- Docker Deployment
- Cloud Database Support

---

# 🐞 Troubleshooting

## ModuleNotFoundError

```bash
pip install -r requirements.txt
```

Ensure the virtual environment is activated.

---

## Database Connection Failed

- Verify MySQL is running.
- Check credentials inside `.env`.
- Confirm the `hangman_game` database exists.

---

## CORS Error

- Ensure the Flask backend is running.
- Verify the frontend communicates with:

```
http://localhost:5000/api
```

---

## Port 5000 Already in Use

Stop the existing Flask process or change the port in `app.py`.

---

# 📄 License

This project is provided for educational and learning purposes. You are free to use, modify, and extend it for personal or academic projects.

---

# 👨‍💻 Author

**Mithesh Manas**

GitHub: **https://github.com/MITHESHMANAS**

---

## ⭐ If you found this project useful, consider giving it a star!
