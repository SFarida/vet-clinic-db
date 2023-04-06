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
   total_amount DECIMAL,
   generated_at TIMESTAMP,
   payed_at TIMESTAMP,
   CONSTRAINT fk_medical_history
      FOREIGN KEY(medical_history_id) 
	  REFERENCES medical_histories(id)
	  ON DELETE CASCADE
);

CREATE TABLE invoice_items(
   id serial PRIMARY KEY,
   invoice_id INT,
   treatment_id INT,
   unit_price DECIMAL,
   quantity INT,
   total_price DECIMAL,
   CONSTRAINT fk_invoice_item
      FOREIGN KEY(invoice_id) 
	  REFERENCES invoices(id)
	  ON DELETE CASCADE,
    CONSTRAINT fk_treatment
      FOREIGN KEY(treatment_id) 
	  REFERENCES treatments(id)
	  ON DELETE CASCADE
);

CREATE TABLE medical_histories_has_treatments (
    medical_history_id INT REFERENCES medical_histories(id),
    treatment_id INT REFERENCES treatments(id)
);
