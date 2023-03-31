/* Database schema to keep the structure of entire database. */

CREATE TABLE IF NOT EXISTS animals (
   id serial PRIMARY KEY,
   name VARCHAR ( 100 ) UNIQUE NOT NULL,
   date_of_birth DATE,
   escape_attempts INT,
   neutered bool,
   weight_kg float(3)
);
