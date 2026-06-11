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
('Cricket','Cricket terms and players'),
('Football','Football clubs and players'),
('Basketball','Basketball terms and players'),
('Tennis','Tennis legends and tournaments'),
('Badminton','Badminton players and terms'),
('Programming','Programming languages and concepts'),
('Technology','Tech companies and innovations'),
('Space','Space missions and astronomy'),
('Science','Scientific discoveries'),
('Mathematics','Math concepts'),
('Countries','Countries around the world'),
('Capitals','World capitals'),
('Animals','Animals and wildlife'),
('Birds','Bird species'),
('Food','Foods and cuisines'),
('Movies','Popular movies'),
('Marvel','Marvel characters'),
('DC','DC superheroes'),
('Cars','Automobile brands'),
('Motorcycles','Bike brands'),
('Music','Music artists and genres'),
('Video Games','Gaming titles'),
('Artificial Intelligence','AI concepts'),
('Cyber Security','Security concepts'),
('Data Structures','DSA concepts');

INSERT INTO Word (category_id, word_text, hint, difficulty) VALUES

-- Cricket
(1,'VIRAT','Indian cricket legend','easy'),
(1,'BUMRAH','Indian fast bowler','medium'),
(1,'YORKER','Deadly bowling delivery','medium'),
(1,'WICKET','Important cricket term','easy'),
(1,'CENTURY','100 runs in cricket','easy'),

-- Football
(2,'MESSI','Argentinian football legend','easy'),
(2,'RONALDO','Portuguese football star','easy'),
(2,'BARCELONA','Spanish football club','medium'),
(2,'LIVERPOOL','English football club','medium'),
(2,'STRIKER','Attacking football position','easy'),

-- Basketball
(3,'JORDAN','NBA legend','easy'),
(3,'CURRY','Golden State superstar','easy'),
(3,'DUNK','Basketball scoring move','easy'),
(3,'LAKERS','NBA franchise','medium'),
(3,'DRIBBLE','Ball control skill','easy'),

-- Tennis
(4,'FEDERER','Swiss tennis legend','easy'),
(4,'NADAL','King of clay','easy'),
(4,'DJOKOVIC','Serbian champion','medium'),
(4,'WIMBLEDON','Grand Slam tournament','hard'),
(4,'ACE','Unreturnable serve','easy'),

-- Badminton
(5,'SINDHU','Indian Olympic medalist','easy'),
(5,'PRANNOY','Indian badminton player','medium'),
(5,'SHUTTLE','Used in badminton','easy'),
(5,'SMASH','Powerful badminton shot','easy'),
(5,'NETSHOT','Net play shot','medium'),

-- Programming
(6,'PYTHON','Popular programming language','easy'),
(6,'JAVA','Object oriented language','easy'),
(6,'COMPILER','Converts code to machine language','medium'),
(6,'ALGORITHM','Step by step procedure','medium'),
(6,'DEBUGGING','Finding code errors','medium'),

-- Technology
(7,'GOOGLE','Tech giant','easy'),
(7,'MICROSOFT','Windows creator','easy'),
(7,'TESLA','Electric vehicle company','easy'),
(7,'OPENAI','Creator of ChatGPT','easy'),
(7,'BLOCKCHAIN','Distributed ledger technology','hard'),

-- Space
(8,'MARS','Red planet','easy'),
(8,'APOLLO','Moon mission program','easy'),
(8,'SATURN','Planet with rings','easy'),
(8,'GALAXY','Collection of stars','medium'),
(8,'HUBBLE','Space telescope','medium'),

-- Science
(9,'GRAVITY','Force attracting objects','easy'),
(9,'ATOM','Basic unit of matter','easy'),
(9,'NEWTON','Scientist behind laws of motion','easy'),
(9,'PHYSICS','Study of matter and energy','medium'),
(9,'CHEMISTRY','Study of substances','easy'),

-- Mathematics
(10,'ALGEBRA','Branch of mathematics','easy'),
(10,'MATRIX','Rectangular array','medium'),
(10,'CALCULUS','Study of change','hard'),
(10,'THEOREM','Mathematical statement','medium'),
(10,'GEOMETRY','Study of shapes','easy'),

-- Countries
(11,'INDIA','Largest democracy','easy'),
(11,'CANADA','Known for maple syrup','easy'),
(11,'BRAZIL','Largest South American nation','medium'),
(11,'JAPAN','Land of the rising sun','easy'),
(11,'GERMANY','European industrial power','medium'),

-- Capitals
(12,'DELHI','Capital of India','easy'),
(12,'TOKYO','Capital of Japan','easy'),
(12,'LONDON','Capital of UK','easy'),
(12,'PARIS','Capital of France','easy'),
(12,'OTTAWA','Capital of Canada','medium'),

-- Animals
(13,'ELEPHANT','Largest land animal','easy'),
(13,'TIGER','National animal of India','easy'),
(13,'GIRAFFE','Tallest animal','easy'),
(13,'KANGAROO','Australian marsupial','medium'),
(13,'PLATYPUS','Egg laying mammal','hard'),

-- Birds
(14,'PEACOCK','National bird of India','easy'),
(14,'EAGLE','Bird of prey','easy'),
(14,'SPARROW','Small common bird','easy'),
(14,'PENGUIN','Flightless bird','medium'),
(14,'OSTRICH','Largest bird','medium'),

-- Food
(15,'PIZZA','Italian dish','easy'),
(15,'BURGER','Fast food item','easy'),
(15,'SUSHI','Japanese dish','medium'),
(15,'PASTA','Italian cuisine staple','easy'),
(15,'GUACAMOLE','Avocado dip','hard'),

-- Movies
(16,'TITANIC','Famous ship movie','easy'),
(16,'INCEPTION','Dream based thriller','medium'),
(16,'AVATAR','Highest grossing movie','easy'),
(16,'INTERSTELLAR','Space exploration movie','medium'),
(16,'PSYCHO','Classic thriller','hard'),

-- Marvel
(17,'IRONMAN','Genius billionaire hero','easy'),
(17,'THOR','God of thunder','easy'),
(17,'HULK','Green superhero','easy'),
(17,'LOKI','God of mischief','medium'),
(17,'VISION','Android Avenger','medium'),

-- DC
(18,'BATMAN','Dark Knight','easy'),
(18,'SUPERMAN','Man of Steel','easy'),
(18,'FLASH','Fastest superhero','easy'),
(18,'CYBORG','Half human half machine','medium'),
(18,'AQUAMAN','King of Atlantis','easy'),

-- Cars
(19,'TESLA','Electric car brand','easy'),
(19,'BMW','German luxury brand','easy'),
(19,'AUDI','German automaker','easy'),
(19,'FERRARI','Italian sports car','medium'),
(19,'TOYOTA','Japanese automobile giant','easy'),

-- Motorcycles
(20,'YAMAHA','Japanese bike brand','easy'),
(20,'HONDA','Popular motorcycle company','easy'),
(20,'DUCATI','Italian superbike brand','medium'),
(20,'SUZUKI','Motorcycle manufacturer','easy'),
(20,'KAWASAKI','Ninja series maker','medium'),

-- Music
(21,'ARIJIT','Popular Indian singer','easy'),
(21,'MOZART','Classical composer','medium'),
(21,'BEETHOVEN','German composer','medium'),
(21,'GUITAR','String instrument','easy'),
(21,'PIANO','Keyboard instrument','easy'),

-- Video Games
(22,'MINECRAFT','Sandbox game','easy'),
(22,'FORTNITE','Battle royale game','easy'),
(22,'VALORANT','Tactical shooter','easy'),
(22,'PUBG','Battle royale pioneer','easy'),
(22,'TETRIS','Classic puzzle game','medium'),

-- Artificial Intelligence
(23,'NEURAL','Used in deep learning','easy'),
(23,'CHATBOT','Conversational AI system','easy'),
(23,'DATASET','Training data collection','easy'),
(23,'TRANSFORMER','Modern NLP architecture','hard'),
(23,'EMBEDDING','Vector representation','hard'),

-- Cyber Security
(24,'FIREWALL','Network security system','easy'),
(24,'MALWARE','Malicious software','easy'),
(24,'PHISHING','Fraud attack method','medium'),
(24,'ENCRYPTION','Data protection technique','medium'),
(24,'RANSOMWARE','Extortion malware','hard'),

-- Data Structures
(25,'STACK','LIFO structure','easy'),
(25,'QUEUE','FIFO structure','easy'),
(25,'HEAP','Priority based structure','medium'),
(25,'TRIE','Prefix search structure','hard'),
(25,'GRAPH','Network data structure','easy');

INSERT INTO Player (username, email, password) VALUES
('test', 'test@test.com', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08');