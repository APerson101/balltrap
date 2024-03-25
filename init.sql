-- Create your database
CREATE DATABASE IF NOT EXISTS balltrap;

-- Use the database
USE balltrap;

-- Create your tables
CREATE TABLE IF NOT EXISTS players (
    id varchar(45) not null PRIMARY KEY,
    name VARCHAR(45),
    subscriptionsLeft INT
);

CREATE TABLE IF NOT EXISTS sessions (
    id varchar(45) not null PRIMARY KEY,
    data json
);

create table if not exists templates(
id varchar(42) not null primary key,
templateInfo json
);
create table if not exists session_players(
session_id varchar(45) not null primary key,
player_id varchar(45),
score int
);