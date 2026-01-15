INSERT INTO test_categories (category_name) VALUES
('Blood'),('Urine'),('Imaging'),('Pathology');

INSERT INTO lab_branches VALUES
('Central Lab','Bangalore','Karnataka','2022-01-01'),
('North Lab','Delhi','Delhi','2021-06-15'),
('West Lab','Mumbai','Maharashtra','2020-03-10');

INSERT INTO doctors VALUES
('Dr. Amit Sharma','Physician','Apollo Hospital','Delhi'),
('Dr. Neha Verma','Endocrinologist','Fortis Hospital','Bangalore'),
('Dr. Raj Malhotra','Cardiologist','Max Hospital','Delhi'),
('Dr. Pooja Iyer','Gynecologist','Manipal Hospital','Bangalore'),
('Dr. Sameer Khan','Orthopedic','Lilavati Hospital','Mumbai');

INSERT INTO medical_tests VALUES
('Hemoglobin',1,12,16,300),
('WBC Count',1,4000,11000,350),
('Blood Sugar Fasting',1,70,100,250),
('Urine Routine',2,0,0,200),
('X-Ray Chest',3,NULL,NULL,1200),
('ECG',3,NULL,NULL,900),
('Thyroid TSH',4,0.4,4.0,500);

INSERT INTO technicians VALUES
('Ravi Kumar',1,5),
('Anita Singh',1,3),
('Mohit Jain',2,6),
('Suresh Rao',3,4);
