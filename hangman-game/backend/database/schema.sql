CREATE DATABASE IF NOT EXISTS hangman_game;
USE hangman_game;

CREATE TABLE Player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    games_played INT DEFAULT 0,
    games_won INT DEFAULT 0,
    wallet_balance DECIMAL(10,2) DEFAULT 100.00
);

CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE Word (
    word_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    word_text VARCHAR(50) NOT NULL,
    hint TEXT,
    difficulty ENUM('easy', 'medium', 'hard') DEFAULT 'medium',
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Game (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMP NULL,
    status ENUM('ongoing', 'won', 'lost') DEFAULT 'ongoing',
    remaining_lives INT DEFAULT 6,
    total_attempts INT DEFAULT 0,
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

CREATE TABLE Game_Word (
    game_id INT,
    word_id INT,
    attempts_made INT DEFAULT 0,
    correct_guesses INT DEFAULT 0,
    revealed_mask VARCHAR(100) DEFAULT '',
    assigned_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (game_id, word_id),
    FOREIGN KEY (game_id) REFERENCES Game(game_id),
    FOREIGN KEY (word_id) REFERENCES Word(word_id)
);

CREATE TABLE Transaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    amount DECIMAL(10,2) NOT NULL,
    transaction_type ENUM('earn', 'spend') NOT NULL,
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(255),
    FOREIGN KEY (player_id) REFERENCES Player(player_id)
);

INSERT INTO Category (category_name, description) VALUES
('Animals', 'Various animals from around the world'),
('Countries', 'Names of countries'),
('Food', 'Different types of food and dishes'),
('Movies', 'Popular movie titles'),
('Sports', 'Sports and athletic activities');

INSERT INTO Word (category_id, word_text, hint, difficulty) VALUES
(1, 'ELEPHANT', 'Largest land animal', 'easy'),
(1, 'KANGAROO', 'Australian marsupial with a pouch', 'medium'),
(1, 'PLATYPUS', 'Egg-laying mammal from Australia', 'hard'),
(2, 'CANADA', 'North American country known for maple syrup', 'easy'),
(2, 'BRAZIL', 'Largest country in South America', 'medium'),
(2, 'MADAGASCAR', 'Island nation known for unique wildlife', 'hard'),
(3, 'PIZZA', 'Popular Italian dish with toppings', 'easy'),
(3, 'SUSHI', 'Japanese dish with rice and seafood', 'medium'),
(3, 'GUACAMOLE', 'Avocado-based dip from Mexico', 'hard'),
(4, 'TITANIC', 'Famous ship disaster movie', 'easy'),
(4, 'INCEPTION', 'Mind-bending movie about dreams', 'medium'),
(4, 'PSYCHO', 'Classic Hitchcock thriller', 'hard'),
(5, 'SOCCER', 'Most popular sport worldwide', 'easy'),
(5, 'BASKETBALL', 'Sport played with a hoop and ball', 'medium'),
(5, 'BADMINTON', 'Racquet sport with a shuttlecock', 'hard');

INSERT INTO Player (username, email, password) VALUES
('test', 'test@test.com', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08');