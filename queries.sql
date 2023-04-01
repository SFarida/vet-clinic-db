/*Queries that provide answers to the questions from all projects.*/
SELECT
  *
FROM
  animals
WHERE
  name LIKE '%mon';

SELECT
  name
FROM
  animals
WHERE
  EXTRACT(
    YEAR
    FROM
      date_of_birth
  ) BETWEEN 2016
  AND 2019;

SELECt
  name
FROM
  animals
WHERE
  neutered = true
  AND escape_attempts < 3;

SELECT
  date_of_birth
FROM
  animals
WHERE
  name = 'Agumon'
  OR name = 'Pikachu';

SELECT
  name,
  escape_attempts
FROM
  animals
WHERE
  weight_kg > 10.5;

SELECT
  *
FROM
  animals
WHERE
  neutered = true;

SELECT
  *
FROM
  animals
WHERE
  name <> 'Gabumon';

SELECT
  *
FROM
  animals
WHERE
  weight_kg BETWEEN 10.4
  AND 17.3;

/* Setting species column and rolling back */
BEGIN TRANSACTION;

UPDATE
  animals
SET
  species = 'unspecified';

ROLLBACK TRANSACTION;

/* Setting species colum and persisting the change */
BEGIN TRANSACTION;

UPDATE
  animals
SET
  species = 'digimon'
WHERE
  name LIKE '%mon';

UPDATE
  animals
SET
  species = 'pokemon'
WHERE
  species = '';

COMMIT TRANSACTION;

/* Deleting all records and rolling back */
BEGIN TRANSACTION;

DELETE FROM
  animals;

ROLLBACK TRANSACTION;

/* Update weight_kg */
BEGIN TRANSACTION;

DELETE FROM
  animals
WHERE
  date_of_birth > '2022-01-01';

SAVEPOINT first_savepoint;

UPDATE
  animals
SET
  weight_kg = weight_kg * - 1;

ROLLBACK TO SAVEPOINT first_savepoint;

UPDATE
  animals
SET
  weight_kg = weight_kg * - 1
WHERE
  weight_kg < 0;

COMMIT TRANSACTION;

/* Queries to get some statistics */
SELECT
  COUNT(*)
FROM
  animals;

SELECT
  COUNT(*)
FROM
  animals
WHERE
  escape_attempts = 0;

SELECT
  AVG(weight_kg)
FROM
  animals;

SELECT
  *
FROM
  animals
WHERE
  escape_attempts = (
    SELECT
      MAX(escape_attempts)
    FROM
      animals
  );

SELECT
  species,
  MAX(weight_kg),
  MIN(weight_kg)
FROM
  animals
GROUP BY
  species;

SELECT
  species,
  AVG(escape_attempts)
FROM
  animals
WHERE
  EXTRACT(
    YEAR
    FROM
      date_of_birth
  ) BETWEEN 1990
  AND 2000
GROUP BY
  species;

/* What animals belong to Melody Pond? */
SELECT
  animals.name,
  animals.owner_id,
  owners.full_name,
  owners.id
FROM
  animals
  INNER JOIN owners ON animals.owner_id = owners.id
WHERE
  full_name = 'Melody Pond';

/* List of all animals that are pokemon (their type is Pokemon). */
SELECT
  animals.name,
  animals.species_id,
  species.name,
  species.id
FROM
  animals
  INNER JOIN species ON animals.species_id = species.id
WHERE
  species.name = 'Pokemon';

/* List all owners and their animals, remember to include those that don't own any animal. */
SELECT
  owners.full_name,
  animals.name,
  animals.owner_id,
  owners.id
FROM
  owners
  LEFT JOIN animals ON animals.owner_id = owners.id;

/* How many animals are there per species? */
SELECT
  species.name,
  COUNT(animals.name)
FROM
  animals
  JOIN species ON animals.species_id = species.id
GROUP BY
  species.name;

/* List all Digimon owned by Jennifer Orwell. */
SELECT
  owners.full_name AS owner_name,
  animals.name AS animal_name,
  species.name AS species_name
FROM
  owners
  LEFT JOIN animals ON animals.owner_id = owners.id
  LEFT JOIN species ON species_id = species.id
WHERE
  full_name = 'Jennifer Orwell'
  AND species_id = (
    SELECT
      id
    FROM
      species
    WHERE
      name = 'Digimon'
  );

/* List all animals owned by Dean Winchester that haven't tried to escape. */
SELECT
  owners.full_name AS owner_name,
  animals.name AS animal_name
FROM
  owners
  LEFT JOIN animals ON animals.owner_id = owners.id
WHERE
  escape_attempts = 0
  AND full_name = 'Dean Winchester';

/* Who owns the most animals? */
SELECT
  owners.full_name,
  COUNT(animals.name)
FROM
  animals
  JOIN owners ON animals.owner_id = owners.id
GROUP BY
  owners.full_name
ORDER BY
  COUNT(animals.name) DESC
LIMIT
  1;