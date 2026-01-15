01_database_schema.sql

CREATE DATABASE medical_lab_analytics;
USE medical_lab_analytics;

-- =========================
-- MASTER TABLES
-- =========================
CREATE TABLE patients (
    patient_id INT IDENTITY PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male','Female','Other')),
    dob DATE,
    city VARCHAR(50),
    registration_date DATE
);

CREATE TABLE doctors (
    doctor_id INT IDENTITY PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100),
    hospital_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE lab_branches (
    branch_id INT IDENTITY PRIMARY KEY,
    branch_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    opened_date DATE
);

CREATE TABLE test_categories (
    category_id INT IDENTITY PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE medical_tests (
    test_id INT IDENTITY PRIMARY KEY,
    test_name VARCHAR(100),
    category_id INT,
    normal_range_min DECIMAL(10,2),
    normal_range_max DECIMAL(10,2),
    cost DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES test_categories(category_id)
);

CREATE TABLE technicians (
    technician_id INT IDENTITY PRIMARY KEY,
    technician_name VARCHAR(100),
    branch_id INT,
    experience_years INT,
    FOREIGN KEY (branch_id) REFERENCES lab_branches(branch_id)
);

-- =========================
-- TRANSACTION TABLES
-- =========================
CREATE TABLE test_orders (
    order_id INT IDENTITY PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    branch_id INT,
    order_date DATE,
    order_status VARCHAR(20)
        CHECK (order_status IN ('Pending','Completed','Cancelled')),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (branch_id) REFERENCES lab_branches(branch_id)
);

CREATE TABLE test_order_details (
    order_detail_id INT IDENTITY PRIMARY KEY,
    order_id INT,
    test_id INT,
    FOREIGN KEY (order_id) REFERENCES test_orders(order_id),
    FOREIGN KEY (test_id) REFERENCES medical_tests(test_id)
);

CREATE TABLE test_results (
    result_id INT IDENTITY PRIMARY KEY,
    order_detail_id INT,
    result_value DECIMAL(10,2),
    result_status VARCHAR(10)
        CHECK (result_status IN ('Normal','Abnormal')),
    result_date DATE,
    FOREIGN KEY (order_detail_id) REFERENCES test_order_details(order_detail_id)
);

CREATE TABLE payments (
    payment_id INT IDENTITY PRIMARY KEY,
    order_id INT,
    payment_mode VARCHAR(20)
        CHECK (payment_mode IN ('Cash','Card','UPI','Insurance')),
    amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES test_orders(order_id)
);

CREATE TABLE test_processing (
    processing_id INT IDENTITY PRIMARY KEY,
    order_detail_id INT,
    technician_id INT,
    processed_date DATE,
    FOREIGN KEY (order_detail_id) REFERENCES test_order_details(order_detail_id),
    FOREIGN KEY (technician_id) REFERENCES technicians(technician_id)
);

CREATE TABLE test_equipment (
    equipment_id INT IDENTITY PRIMARY KEY,
    equipment_name VARCHAR(100),
    branch_id INT,
    last_maintenance_date DATE,
    FOREIGN KEY (branch_id) REFERENCES lab_branches(branch_id)
);

CREATE TABLE appointments (
    appointment_id INT IDENTITY PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    branch_id INT,
    appointment_date DATE,
    appointment_status VARCHAR(20)
        CHECK (appointment_status IN ('Scheduled','Completed','No Show','Cancelled')),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (branch_id) REFERENCES lab_branches(branch_id)
);

CREATE TABLE insurance_providers (
    insurance_id INT IDENTITY PRIMARY KEY,
    provider_name VARCHAR(100),
    coverage_percentage DECIMAL(5,2)
);

ALTER TABLE payments
ADD insurance_id INT
FOREIGN KEY (insurance_id) REFERENCES insurance_providers(insurance_id);

CREATE TABLE test_reference_ranges (
    range_id INT IDENTITY PRIMARY KEY,
    test_id INT,
    gender VARCHAR(10),
    min_age INT,
    max_age INT,
    min_value DECIMAL(10,2),
    max_value DECIMAL(10,2),
    FOREIGN KEY (test_id) REFERENCES medical_tests(test_id)
);

CREATE TABLE order_status_history (
    history_id INT IDENTITY PRIMARY KEY,
    order_id INT,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_date DATETIME,
    FOREIGN KEY (order_id) REFERENCES test_orders(order_id)
);

