from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
import pymysql
import random
import hashlib
import os

load_dotenv()

app = Flask(__name__)
CORS(app)

# Database configuration with pymysql
db_config = {
    'host': os.environ.get('DB_HOST', 'localhost'),
    'user': os.environ.get('DB_USER', 'root'),
    'password': os.environ.get('DB_PASSWORD', ''),
    'database': os.environ.get('DB_NAME', 'hangman_game'),
    'charset': 'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor
}

def get_db_connection():
    try:
        conn = pymysql.connect(**db_config)
        return conn
    except Exception as e:
        print(f"Database error: {e}")
        return None

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def generate_mask(word):
    return '_' * len(word)

def update_mask(word, mask, guess):
    new_mask = ''
    for i, letter in enumerate(word):
        if word[i].upper() == guess.upper():
            new_mask += word[i]
        else:
            new_mask += mask[i]
    return new_mask

def is_game_won(mask):
    return '_' not in mask

@app.route('/')
def home():
    return jsonify({"message": "Hangman Game API is running!"})

@app.route('/api/test')
def test():
    conn = get_db_connection()
    if conn:
        conn.close()
        return jsonify({"message": "API and Database are working!"})
    else:
        return jsonify({"error": "Database connection failed"}), 500

@app.route('/api/register', methods=['POST'])
def register():
    data = request.json
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')
    
    if not username or not email or not password:
        return jsonify({'error': 'All fields required'}), 400
    
    hashed_password = hash_password(password)
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO Player (username, email, password) VALUES (%s, %s, %s)",
                (username, email, hashed_password)
            )
            conn.commit()
            return jsonify({'message': 'User registered successfully'}), 201
    except pymysql.IntegrityError:
        return jsonify({'error': 'Username or email already exists'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    username = data.get('username')
    password = data.get('password')
    
    if not username or not password:
        return jsonify({'error': 'Username and password required'}), 400
    
    hashed_password = hash_password(password)
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT player_id, username, email, games_played, games_won, wallet_balance FROM Player WHERE username = %s AND password = %s",
                (username, hashed_password)
            )
            user = cursor.fetchone()
            
            if user:
                return jsonify({
                    'message': 'Login successful', 
                    'user': user
                }), 200
            else:
                return jsonify({'error': 'Invalid username or password'}), 401
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/start-game', methods=['POST'])
def start_game():
    data = request.json
    player_id = data.get('player_id')
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT word_id, word_text, hint FROM Word ORDER BY RAND() LIMIT 1")
            word_data = cursor.fetchone()
            
            if not word_data:
                return jsonify({'error': 'No words available'}), 500
            
            word_id = word_data['word_id']
            word_text = word_data['word_text']
            hint = word_data['hint']
            
            cursor.execute(
                "INSERT INTO Game (player_id, remaining_lives) VALUES (%s, %s)",
                (player_id, 6)
            )
            game_id = cursor.lastrowid
            
            initial_mask = generate_mask(word_text)
            cursor.execute(
                "INSERT INTO Game_Word (game_id, word_id, revealed_mask) VALUES (%s, %s, %s)",
                (game_id, word_id, initial_mask)
            )
            
            conn.commit()
            
            return jsonify({
                'game_id': game_id,
                'word_length': len(word_text),
                'mask': initial_mask,
                'hint': hint,
                'remaining_lives': 6
            }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/make-guess', methods=['POST'])
def make_guess():
    data = request.json
    game_id = data.get('game_id')
    letter = data.get('letter')
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT g.game_id, g.player_id, g.remaining_lives, g.status, 
                       gw.word_id, gw.revealed_mask, gw.attempts_made, gw.correct_guesses,
                       w.word_text
                FROM Game g
                JOIN Game_Word gw ON g.game_id = gw.game_id
                JOIN Word w ON gw.word_id = w.word_id
                WHERE g.game_id = %s
            """, (game_id,))
            
            game_data = cursor.fetchone()
            
            if not game_data:
                return jsonify({'error': 'Game not found'}), 404
            
            word_text = game_data['word_text']
            current_mask = game_data['revealed_mask']
            remaining_lives = game_data['remaining_lives']
            
            letter_upper = letter.upper()
            is_correct = letter_upper in word_text.upper()
            
            if is_correct:
                new_mask = update_mask(word_text, current_mask, letter)
            else:
                new_mask = current_mask
                remaining_lives -= 1
            
            cursor.execute(
                "UPDATE Game_Word SET revealed_mask = %s, attempts_made = attempts_made + 1, correct_guesses = correct_guesses + %s WHERE game_id = %s",
                (new_mask, 1 if is_correct else 0, game_id)
            )
            
            game_won = is_game_won(new_mask)
            game_lost = remaining_lives <= 0
            
            if game_won:
                status = 'won'
                cursor.execute(
                    "UPDATE Player SET games_played = games_played + 1, games_won = games_won + 1, wallet_balance = wallet_balance + 20 WHERE player_id = %s",
                    (game_data['player_id'],)
                )
                cursor.execute(
                    "INSERT INTO Transaction (player_id, amount, transaction_type, remarks) VALUES (%s, %s, %s, %s)",
                    (game_data['player_id'], 20, 'earn', 'Game won reward')
                )
            elif game_lost:
                status = 'lost'
                cursor.execute(
                    "UPDATE Player SET games_played = games_played + 1 WHERE player_id = %s",
                    (game_data['player_id'],)
                )
            else:
                status = 'ongoing'
            
            cursor.execute(
                "UPDATE Game SET remaining_lives = %s, status = %s, total_attempts = total_attempts + 1 WHERE game_id = %s",
                (remaining_lives, status, game_id)
            )
            
            conn.commit()
            
            return jsonify({
                'is_correct': is_correct,
                'new_mask': new_mask,
                'remaining_lives': remaining_lives,
                'game_status': status,
                'game_won': game_won,
                'game_lost': game_lost
            }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/get-hint', methods=['POST'])
def get_hint():
    data = request.json
    game_id = data.get('game_id')
    player_id = data.get('player_id')
    
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT wallet_balance FROM Player WHERE player_id = %s", (player_id,))
            player = cursor.fetchone()
            
            if not player or player['wallet_balance'] < 10:
                return jsonify({'error': 'Insufficient coins'}), 400
            
            cursor.execute("""
                SELECT gw.word_id, gw.revealed_mask, w.word_text, w.hint
                FROM Game_Word gw
                JOIN Word w ON gw.word_id = w.word_id
                WHERE gw.game_id = %s
            """, (game_id,))
            
            game_word = cursor.fetchone()
            
            word_text = game_word['word_text']
            current_mask = game_word['revealed_mask']
            
            hidden_indices = [i for i, char in enumerate(current_mask) if char == '_']
            if not hidden_indices:
                return jsonify({'error': 'No hidden letters to reveal'}), 400
            
            reveal_index = random.choice(hidden_indices)
            revealed_letter = word_text[reveal_index]
            
            new_mask = current_mask[:reveal_index] + revealed_letter + current_mask[reveal_index+1:]
            
            cursor.execute(
                "UPDATE Game_Word SET revealed_mask = %s WHERE game_id = %s",
                (new_mask, game_id)
            )
            
            cursor.execute(
                "UPDATE Player SET wallet_balance = wallet_balance - 10 WHERE player_id = %s",
                (player_id,)
            )
            
            cursor.execute(
                "INSERT INTO Transaction (player_id, amount, transaction_type, remarks) VALUES (%s, %s, %s, %s)",
                (player_id, 10, 'spend', 'Purchased hint')
            )
            
            conn.commit()
            
            return jsonify({
                'revealed_letter': revealed_letter,
                'new_mask': new_mask,
                'coins_deducted': 10
            }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/leaderboard')
def get_leaderboard():
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT username, games_played, games_won, wallet_balance
                FROM Player
                ORDER BY games_won DESC, wallet_balance DESC
                LIMIT 10
            """)
            leaderboard = cursor.fetchall()
            return jsonify({'leaderboard': leaderboard}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

@app.route('/api/player/<int:player_id>')
def get_player_stats(player_id):
    conn = get_db_connection()
    if not conn:
        return jsonify({'error': 'Database connection failed'}), 500
        
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT username, email, games_played, games_won, wallet_balance FROM Player WHERE player_id = %s",
                (player_id,)
            )
            player = cursor.fetchone()
            if player:
                return jsonify({'player': player}), 200
            else:
                return jsonify({'error': 'Player not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

if __name__ == '__main__':
    app.run(debug=True, port=5000)