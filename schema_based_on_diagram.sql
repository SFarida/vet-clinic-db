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

CREATE TABLE medical_histories(
   id serial PRIMARY KEY,
   patient_id INT,
   admitted_at TIMESTAMP,
   status VARCHAR(100),
   CONSTRAINT fk_patient
      FOREIGN KEY(patient_id) 
	  REFERENCES patients(id)
	  ON DELETE CASCADE
);

CREATE TABLE invoices(
   id serial PRIMARY KEY,
   medical_history_id INT,
   total_amount REAL,
   generated_at TIMESTAMP,
   payed_at TIMESTAMP,
   CONSTRAINT fk_medical_history
      FOREIGN KEY(medical_history_id) 
	  REFERENCES medical_histories(id)
	  ON DELETE CASCADE
);