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

/* Who was the last animal seen by William Tatcher? */
SELECT
  vets.name AS vet_name,
  animals.name AS animal_name,
  visits.date_of_visit
FROM
  animals
  JOIN visits ON animals.id = visits.animal_id
  JOIN vets ON vets.id = visits.vet_id
WHERE
  visits.vet_id = (
    SELECT
      vets.id
    FROM
      vets
    WHERE
      vets.name = 'William Tatcher'
  )
ORDER BY
  visits.date_of_visit DESC
LIMIT
  1;

/* How many different animals did Stephanie Mendez see? */
SELECT
  vets.name AS vet_name,
  COUNT(animals.name) as number_animals_visited
FROM
  animals
  JOIN visits ON animals.id = visits.animal_id
  JOIN vets ON vets.id = visits.vet_id
WHERE
  visits.vet_id = (
    SELECT
      vets.id
    FROM
      vets
    WHERE
      vets.name = 'Stephanie Mendez'
  )
GROUP by
  vets.name;

/* List all vets and their specialties, including vets with no specialties. */
SELECT
  vets.name AS vet_name,
  species.name AS species_name
FROM
  vets FULL
  JOIN specializations ON vets.id = specializations.vet_id FULL
  JOIN species ON species.id = specializations.species_id
WHERE
  species.name IS NULL
  OR species.name IS NOT NULL;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */
SELECT
  animals.name AS animal_name,
  visits.date_of_visit
from
  animals
  JOIN visits ON visits.animal_id = animals.id
  JOIN vets ON vets.id = visits.vet_id
WHERE
  visits.vet_id = (
    SELECT
      vets.id
    FROM
      vets
    WHERE
      vets.name = 'Stephanie Mendez'
  )
  AND visits.date_of_visit BETWEEN '2020-04-01'
  AND '2020-08-30';

/* What animal has the most visits to vets? */
SELECT
  animals.name AS animal_name,
  COUNT(animal_id) AS number_of_visits
FROM
  animals
  JOIN visits ON visits.animal_id = animals.id
GROUP BY
  name
ORDER BY
  COUNT(visits.animal_id) DESC
LIMIT
  1;

/* Who was Maisy Smith's first visit? */
SELECT
  animals.name AS animal_name,
  vets.name AS vet_name,
  visits.date_of_visit
from
  animals
  JOIN visits ON visits.animal_id = animals.id
  JOIN vets ON vets.id = visits.vet_id
WHERE
  visits.vet_id = (
    SELECT
      vets.id
    FROM
      vets
    WHERE
      vets.name = 'Maisy Smith'
  )
ORDER BY
  visits.date_of_visit ASC
LIMIT
  1;

/* Details for most recent visit: animal information, vet information, and date of visit. */
SELECT
  animals.name AS animal_name,
  animals.date_of_birth AS animal_birth_date,
  animals.escape_attempts,
  species.name AS species_name,
  animals.neutered,
  animals.weight_kg,
  vets.name AS vet_name,
  vets.age as vet_age,
  vets.date_of_graduation AS vet_graduation_date,
  visits.date_of_visit
from
  animals
  JOIN species ON species.id = animals.species_id
  JOIN visits ON visits.animal_id = animals.id
  JOIN vets ON vets.id = visits.vet_id
ORDER BY
  visits.date_of_visit DESC
LIMIT
  1;

/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT
  vets.name AS vet_name,
  COUNT(visits.date_of_visit) AS number_of_visits
FROM
  vets
  JOIN specializations ON specializations.vet_id = vets.id
  JOIN visits ON visits.vet_id = vets.id
  JOIN species ON species.id = specializations.species_id
  JOIN animals ON animals.id = visits.animal_id
WHERE
  animals.species_id != specializations.species_id
GROUP BY
  vets.name;

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */
SELECT
  species.name,
  COUNT(visits.animal_id)
FROM
  visits
  JOIN vets ON visits.vet_id = vets.id FULL
  JOIN animals ON visits.animal_id = animals.id
  JOIN species ON species.id = animals.species_id
WHERE
  vets.name = 'Maisy Smith'
GROUP BY
  species.name;
