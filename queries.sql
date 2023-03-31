/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 2016 AND 2019; 
SELECt name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name <> 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Setting species column and rolling back */
BEGIN TRANSACTION;
UPDATE animals SET species = 'unspecified';
ROLLBACK TRANSACTION;

/* Setting species colum and persisting the change */
BEGIN TRANSACTION;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species = '';
COMMIT TRANSACTION;

/* Deleting all records and rolling back */
BEGIN TRANSACTION;
DELETE FROM animals;
ROLLBACK TRANSACTION;

/* Update weight_kg */
BEGIN TRANSACTION;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT first_savepoint;
UPDATE animals SET weight_kg = weight_kg * - 1;
ROLLBACK TO SAVEPOINT first_savepoint;
UPDATE animals SET weight_kg = weight_kg * - 1 WHERE weight_kg < 0;
COMMIT TRANSACTION;

/* Queries to get some statistics */
SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT * FROM animals WHERE escape_attempts = ( SELECT MAX(escape_attempts) FROM animals );
SELECT species, MAX(weight_kg), MIN(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000  GROUP BY species;