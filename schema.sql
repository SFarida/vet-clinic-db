/* Database schema to keep the structure of entire database. */
/* Create tablse animals */
CREATE TABLE IF NOT EXISTS animals (
  id serial PRIMARY KEY,
  name VARCHAR (100) UNIQUE NOT NULL,
  date_of_birth DATE,
  escape_attempts INT,
  neutered bool,
  weight_kg float(3)
);

/* Add species column */
ALTER TABLE
  animals
ADD
  species VARCHAR (100);

/* Create table owners */
CREATE TABLE IF NOT EXISTS owners (
  id serial PRIMARY KEY,
  full_name VARCHAR (100) UNIQUE NOT NULL,
  age INT
);

/* Create table species */
CREATE TABLE IF NOT EXISTS species (
  id serial PRIMARY KEY,
  name VARCHAR (100) UNIQUE NOT NULL
);

/* Remove species from animals table */
ALTER TABLE
  animals DROP COLUMN species;

/* Add foreign keys */
ALTER TABLE
  animals
ADD
  species_id INT;

ALTER TABLE
  animals
ADD
  CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species(id) ON DELETE CASCADE;

ALTER TABLE
  animals
ADD
  owner_id INT;

ALTER TABLE
  animals
ADD
  CONSTRAINT fk_owners FOREIGN KEY (owner_id) REFERENCES owners(id) ON DELETE CASCADE;

/* Create table vets */
CREATE TABLE IF NOT EXISTS vets (
  id serial PRIMARY KEY,
  name VARCHAR (100) UNIQUE NOT NULL,
  age INT,
  date_of_graduation DATE
);

/* Create join table specializations */
CREATE TABLE IF NOT EXISTS specializations (
  vet_id INT,
  species_id INT,
  FOREIGN KEY (vet_id) REFERENCES vets (id),
  FOREIGN KEY (species_id) REFERENCES species (id)
);

/* Create join table visits */
CREATE TABLE IF NOT EXISTS visits (
  animal_id INT,
  vet_id INT,
  date_of_visit DATE,
  FOREIGN KEY (vet_id) REFERENCES vets (id),
  FOREIGN KEY (animal_id) REFERENCES animals (id)
);