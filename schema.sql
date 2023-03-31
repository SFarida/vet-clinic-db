/* Database schema to keep the structure of entire database. */

/* Create tablse animals */
CREATE TABLE IF NOT EXISTS animals (
   id serial PRIMARY KEY,
   name VARCHAR ( 100 ) UNIQUE NOT NULL,
   date_of_birth DATE,
   escape_attempts INT,
   neutered bool,
   weight_kg float(3)
);

/* Add species column */
ALTER TABLE animals ADD species VARCHAR ( 100 );

/* Create table owners */
CREATE TABLE IF NOT EXISTS owners (
   id serial PRIMARY KEY,
   full_name VARCHAR ( 100 ) UNIQUE NOT NULL,
   age INT
);