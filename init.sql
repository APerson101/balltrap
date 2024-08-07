-- Create your database
CREATE DATABASE IF NOT EXISTS balltrap;
create user 'ball'@'%' identified by "11111111";
grant all privileges on balltrap.* to `ball`@`%`;
flush privileges;
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
create table if not exists sessions_players(
id varchar(45) not null primary key,
session_id varchar(45) ,
player_id varchar(45),
score int
);