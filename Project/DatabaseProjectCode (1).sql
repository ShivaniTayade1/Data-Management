SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'local_infile';
SELECT VERSION();
SHOW VARIABLES;


SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'datadir';


SELECT user, host FROM mysql.user;
SHOW GRANTS FOR 'root'@'localhost';
SELECT CURRENT_USER();
SHOW VARIABLES LIKE 'secure_file_priv';

USE DatabaseProject;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS museums;
DROP TABLE IF EXISTS MUSEUM_INFORMATION;
DROP TABLE IF EXISTS INSTITUTION_INFORMATION;
DROP TABLE IF EXISTS ADMINISTRATIVE_LOCATION;
DROP TABLE IF EXISTS PHYSICAL_LOCATION;
DROP TABLE IF EXISTS CONTACT_AND_CODES;
DROP TABLE IF EXISTS FINANCIAL_INFORMATION;

-- Create museums table to load CSV data
CREATE TABLE museums (
    `Museum ID` BIGINT, 
    `Museum Name` VARCHAR(255),
    `Legal Name` VARCHAR(255),
    `Alternate Name` VARCHAR(255),
    `Museum Type` VARCHAR(100),
    `Institution Name` VARCHAR(255),
    `Street Address (Administrative Location)` VARCHAR(255),
    `City (Administrative Location)` VARCHAR(100),
    `State (Administrative Location)` VARCHAR(100),
    `Zip Code (Administrative Location)` VARCHAR(20),
    `Street Address (Physical Location)` VARCHAR(255),
    `City (Physical Location)` VARCHAR(100),
    `State (Physical Location)` VARCHAR(100),
    `Zip Code (Physical Location)` VARCHAR(20),
    `Phone Number` VARCHAR(20),
    `Latitude` FLOAT,
    `Longitude` FLOAT,
    `Locale Code (NCES)` FLOAT,
    `County Code (FIPS)` FLOAT,
    `State Code (FIPS)` FLOAT,
    `Region Code (AAM)` INT,
    `Employer ID Number` VARCHAR(50),
    `Tax Period` FLOAT,
    `Income` FLOAT,
    `Revenue` FLOAT
);

-- Load the CSV data into museums table
LOAD DATA LOCAL INFILE '/Users/shivanitayade/Desktop/MSBA/DATA_Management/museumsdatasql.csv'
INTO TABLE museums
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`Museum ID`, `Museum Name`, `Legal Name`, `Alternate Name`, `Museum Type`, `Institution Name`,
 `Street Address (Administrative Location)`, `City (Administrative Location)`, `State (Administrative Location)`, `Zip Code (Administrative Location)`,
 `Street Address (Physical Location)`, `City (Physical Location)`, `State (Physical Location)`, `Zip Code (Physical Location)`,
 `Phone Number`, `Latitude`, `Longitude`, `Locale Code (NCES)`, `County Code (FIPS)`, `State Code (FIPS)`,
 `Region Code (AAM)`, `Employer ID Number`, `Tax Period`, `Income`, `Revenue`);

-- Create MUSEUM_INFORMATION table
CREATE TABLE MUSEUM_INFORMATION (
    museum_id BIGINT PRIMARY KEY,
    museum_name VARCHAR(255),
    legal_name VARCHAR(255),
    alternate_name VARCHAR(255),
    museum_type VARCHAR(255)
);

-- Create INSTITUTION_INFORMATION table (one-to-many relationship)
CREATE TABLE INSTITUTION_INFORMATION (
    museum_id BIGINT,  -- Foreign key referencing MUSEUM_INFORMATION
    institution_name VARCHAR(255),
    FOREIGN KEY (museum_id) REFERENCES MUSEUM_INFORMATION (museum_id)
);

-- Create ADMINISTRATIVE_LOCATION table (one-to-one)
CREATE TABLE ADMINISTRATIVE_LOCATION (
    museum_id BIGINT PRIMARY KEY,
    street_address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(15),
    FOREIGN KEY (museum_id) REFERENCES MUSEUM_INFORMATION (museum_id)
);

-- Create PHYSICAL_LOCATION table (one-to-one)
CREATE TABLE PHYSICAL_LOCATION (
    museum_id BIGINT PRIMARY KEY,
    street_address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(15),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    FOREIGN KEY (museum_id) REFERENCES MUSEUM_INFORMATION (museum_id)
);

-- Create CONTACT_AND_CODES table (one-to-one)
CREATE TABLE CONTACT_AND_CODES (
    museum_id BIGINT PRIMARY KEY,
    phone_number VARCHAR(30),
    locale_code INT,
    county_code INT,
    state_code INT,
    region_code INT,
    FOREIGN KEY (museum_id) REFERENCES MUSEUM_INFORMATION (museum_id)
);

-- Create FINANCIAL_INFORMATION table (one-to-one)
CREATE TABLE FINANCIAL_INFORMATION (
    museum_id BIGINT PRIMARY KEY,
    employer_id_num VARCHAR(20),
    tax_period INT,
    income DECIMAL(15, 2),
    revenue DECIMAL(15, 2),
    FOREIGN KEY (museum_id) REFERENCES MUSEUM_INFORMATION (museum_id)
);

-- Insert into MUSEUM_INFORMATION from museums table
INSERT INTO MUSEUM_INFORMATION (museum_id, museum_name, legal_name, alternate_name, museum_type)
SELECT 
    `Museum ID` as museum_id, 
    `Museum Name` as museum_name, 
    `Legal Name` as legal_name, 
    `Alternate Name` as alternate_name, 
    `Museum Type` as museum_type
FROM museums;

-- Insert into INSTITUTION_INFORMATION from museums table (One-to-Many relationship)
INSERT INTO INSTITUTION_INFORMATION (museum_id, institution_name)
SELECT 
    `Museum ID` as museum_id, 
    `Institution Name` as institution_name
FROM museums;

-- Insert into ADMINISTRATIVE_LOCATION from museums table
INSERT INTO ADMINISTRATIVE_LOCATION (museum_id, street_address, city, state, zip_code)
SELECT 
    `Museum ID` as museum_id, 
    `Street Address (Administrative Location)` as street_address, 
    `City (Administrative Location)` as city, 
    `State (Administrative Location)` as state, 
    `Zip Code (Administrative Location)` as zip_code
FROM museums;

-- Insert into PHYSICAL_LOCATION from museums table
INSERT INTO PHYSICAL_LOCATION (museum_id, street_address, city, state, zip_code, latitude, longitude)
SELECT 
    `Museum ID` as museum_id, 
    `Street Address (Physical Location)` as street_address, 
    `City (Physical Location)` as city, 
    `State (Physical Location)` as state, 
    `Zip Code (Physical Location)` as zip_code, 
    `Latitude` as latitude, 
    `Longitude` as longitude
FROM museums;

-- Insert into CONTACT_AND_CODES from museums table
INSERT INTO CONTACT_AND_CODES (museum_id, phone_number, locale_code, county_code, state_code, region_code)
SELECT 
    `Museum ID` as museum_id, 
    `Phone Number` as phone_number, 
    `Locale Code (NCES)` as locale_code, 
    `County Code (FIPS)` as county_code, 
    `State Code (FIPS)` as state_code, 
    `Region Code (AAM)` as region_code
FROM museums;

-- Insert into FINANCIAL_INFORMATION from museums table
INSERT INTO FINANCIAL_INFORMATION (museum_id, employer_id_num, tax_period, income, revenue)
SELECT 
    `Museum ID` as museum_id, 
    `Employer ID Number` as employer_id_num, 
    `Tax Period` as tax_period, 
    `Income` as income, 
    `Revenue` as revenue
FROM museums;

-- Verify data is inserted correctly
SELECT * FROM MUSEUM_INFORMATION;
SELECT * FROM INSTITUTION_INFORMATION;
SELECT * FROM ADMINISTRATIVE_LOCATION;
SELECT * FROM PHYSICAL_LOCATION;
SELECT * FROM CONTACT_AND_CODES;
SELECT * FROM FINANCIAL_INFORMATION;
