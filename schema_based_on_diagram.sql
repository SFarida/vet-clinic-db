CREATE TABLE patients(
   id serial PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   date_of_birth DATE
);

CREATE TABLE treatments(
   id serial PRIMARY KEY,
   type VARCHAR(100),
   name VARCHAR(250)
);