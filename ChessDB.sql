CREATE DATABASE ChessDB;
USE ChessDB;
CREATE TABLE Players (
    username VARCHAR(100) PRIMARY KEY,
    password VARCHAR(100),
    name VARCHAR(100),
    surname VARCHAR(100),
    nationality VARCHAR(100),
    date_of_birth DATE,
    elo_rating INT CHECK (elo_rating > 1000),
    fide_ID INT
);

CREATE TABLE Team (
team_ID INT PRIMARY KEY,
team_name VARCHAR(100),
match_win_count INT
);

CREATE TABLE Register (
player_username VARCHAR(100),
team_ID INT,
PRIMARY KEY (player_username, team_ID),
FOREIGN KEY (player_username) REFERENCES Players (username),
FOREIGN KEY (team_ID) REFERENCES Team (team_ID)
);

CREATE TABLE Sponsor (
sponsor_ID INT PRIMARY KEY,
sponsor_name VARCHAR(100) UNIQUE
);

CREATE TABLE Has_Sponsor (
team_ID INT PRIMARY KEY,
sponsor_ID INT,
FOREIGN KEY (sponsor_ID) REFERENCES Sponsor (sponsor_ID),
FOREIGN KEY (team_ID) REFERENCES Team (team_ID)
);

CREATE TABLE Title (
title_ID INT PRIMARY KEY,
title_name VARCHAR(100)
);

CREATE TABLE Has_Title (
title_ID INT,
player_username VARCHAR(100) PRIMARY KEY,
FOREIGN KEY (player_username) REFERENCES Players (username),
FOREIGN KEY (title_ID) REFERENCES Title (title_ID)
);

CREATE TABLE Coaches (
username VARCHAR(100) PRIMARY KEY,
password VARCHAR(100),
name VARCHAR(100),
surname VARCHAR(100),
nationality VARCHAR(100)
);

CREATE TABLE Lead_Team (
coach_username VARCHAR(100),
team_ID INT,
contract_start DATE,
contract_finish DATE,
PRIMARY KEY (coach_username, contract_start, contract_finish),
FOREIGN KEY (coach_username) REFERENCES Coaches (username),
FOREIGN KEY (team_ID) REFERENCES Team (team_ID)
);

CREATE TABLE Specialty (
specialty_name VARCHAR(100) PRIMARY KEY
);


CREATE TABLE Has_Specialty (
coach_username VARCHAR(100),
specialty_name VARCHAR(100),
PRIMARY KEY (coach_username, specialty_name),
FOREIGN KEY (coach_username) REFERENCES Coaches (username),
FOREIGN KEY (specialty_name) REFERENCES Specialty (specialty_name)
);


CREATE TABLE Certification (
certification_name VARCHAR(100) PRIMARY KEY
);


CREATE TABLE Has_Coach_Certification (
coach_username VARCHAR(100),
certification_name VARCHAR(100),
PRIMARY KEY (coach_username, certification_name),
FOREIGN KEY (coach_username) REFERENCES Coaches (username),
FOREIGN KEY (certification_name) REFERENCES Certification (certification_name)
);


CREATE TABLE Arbiter (
    username VARCHAR(100) PRIMARY KEY,
    password VARCHAR(100),
    name VARCHAR(100),
    surname VARCHAR(100),
    nationality VARCHAR(100),
    experience_level ENUM ('beginner', 'intermediate', 'advanced') NOT NULL
);


CREATE TABLE Has_Arbiter_Certification (
arbiter_username VARCHAR(100),
certification_name VARCHAR(100),
PRIMARY KEY (arbiter_username, certification_name),
FOREIGN KEY (arbiter_username) REFERENCES Arbiter (username),
FOREIGN KEY (certification_name) REFERENCES Certification (certification_name)
);

CREATE TABLE Hall (
hall_ID INT PRIMARY KEY,
hall_name VARCHAR(100),
hall_country VARCHAR(100),
hall_capacity INT
);


CREATE TABLE Has_Table (
hall_ID INT,
table_ID INT PRIMARY KEY,
FOREIGN KEY (hall_ID) REFERENCES Hall (hall_ID)
);


CREATE TABLE Matches (
match_ID INT PRIMARY KEY,
hall_ID INT,
table_ID INT,
white_player VARCHAR(100) NOT NULL,
white_player_team INT,
black_player VARCHAR(100) NOT NULL,
black_player_team INT,
result ENUM ('white_wins', 'black_wins', 'draw') NOT NULL,
rating INT CHECK (rating >= 1 AND rating <= 10),
time_slot INT CHECK (time_slot >= 1 AND time_slot <= 4),
date DATE,
assigned_arbiter_username VARCHAR(100),
FOREIGN KEY (white_player_team) REFERENCES Team (team_ID),
FOREIGN KEY (black_player_team) REFERENCES Team (team_ID),
FOREIGN KEY (white_player) REFERENCES Players (username),
FOREIGN KEY (black_player) REFERENCES Players (username),
FOREIGN KEY (hall_ID) REFERENCES Hall (hall_ID),
FOREIGN KEY (table_ID) REFERENCES Has_Table (table_ID)
);

CREATE TABLE Tournament (
tournament_ID INT PRIMARY KEY,
tournament_name VARCHAR(100),
start_date DATE,
end_date DATE,
format VARCHAR(100),
chief_arbiter VARCHAR(100),
FOREIGN KEY (chief_arbiter) REFERENCES Arbiter (username)
);

CREATE TABLE Include (
tournament_ID INT,
match_ID INT PRIMARY KEY,
FOREIGN KEY (tournament_ID) REFERENCES Tournament (tournament_ID),
FOREIGN KEY (match_ID) REFERENCES Matches (match_ID)
);


CREATE TABLE Held_In (
tournament_ID INT,
hall_ID INT,
PRIMARY KEY (tournament_ID, hall_ID),
FOREIGN KEY (tournament_ID) REFERENCES Tournament (tournament_ID),
FOREIGN KEY (hall_ID) REFERENCES Hall (hall_ID)
);