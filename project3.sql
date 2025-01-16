CREATE DATABASE TollGateDB;
USE TollGateDB;

-- Vehicles Table

CREATE TABLE Vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_number VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type ENUM('Car', 'Bike', 'Truck', 'Bus') NOT NULL,
    owner_name VARCHAR(100) NOT NULL
);


-- Toll Booths Table

CREATE TABLE TollBooths (
    booth_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100) NOT NULL,
    operator_name VARCHAR(100) NOT NULL
);

-- Tariff Rates Table

CREATE TABLE TariffRates (
    vehicle_type ENUM('Car', 'Bike', 'Truck', 'Bus') PRIMARY KEY,
    toll_fee DECIMAL(10,2) NOT NULL
);

-- Toll Transactions Table

CREATE TABLE TollTransactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    booth_id INT,
    entry_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    exit_time DATETIME NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_mode ENUM('Cash', 'Card', 'Fastag') NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (booth_id) REFERENCES TollBooths(booth_id)
);


-- inserting data into table

INSERT INTO Vehicles (vehicle_number, vehicle_type, owner_name) 
VALUES 
    ('KA01AB1234', 'Car', 'Rahul Sharma'),
    ('KA02CD5678', 'Truck', 'Ramesh Verma'),
    ('KA03EF9101', 'Bike', 'Sandeep Rao'),
    ('KA04GH2345', 'Bus', 'City Transport'),
    ('KA05IJ6789', 'Car', 'Aditi Nair');

INSERT INTO TollBooths (location, operator_name) 
VALUES 
    ('Bangalore Highway', 'Suresh Kumar'),
    ('Mysore Expressway', 'Ajay Patel'),
    ('Tumkur Road', 'Vikas Shetty'),
    ('Electronic City Toll', 'Pooja Singh'),
    ('Hebbal Flyover', 'Rajesh Kumar');
    
    
INSERT INTO TariffRates (vehicle_type, toll_fee) 
VALUES 
    ('Car', 50.00),
    ('Bike', 20.00),
    ('Truck', 150.00),
    ('Bus', 100.00);


INSERT INTO TollTransactions (vehicle_id, booth_id, amount_paid, payment_mode) 
VALUES 
    (1, 1, 50.00, 'Fastag'),
    (2, 2, 150.00, 'Cash'),
    (3, 3, 20.00, 'Card'),
    (4, 4, 100.00, 'Fastag'),
    (5, 5, 50.00, 'Cash');


-- total Revenue Collected at Each Booth

SELECT tb.location, SUM(tt.amount_paid) AS total_revenue
FROM TollTransactions tt
JOIN TollBooths tb ON tt.booth_id = tb.booth_id
GROUP BY tb.location;

-- Get Details of a Specific Vehicle's Transactions

SELECT v.vehicle_number, v.owner_name, tb.location, tt.amount_paid, tt.payment_mode, tt.entry_time
FROM TollTransactions tt
JOIN Vehicles v ON tt.vehicle_id = v.vehicle_id
JOIN TollBooths tb ON tt.booth_id = tb.booth_id
WHERE v.vehicle_number = 'KA01AB1234';


-- Find Frequently Passing Vehicles

SELECT v.vehicle_number, v.owner_name, COUNT(tt.transaction_id) AS pass_count
FROM TollTransactions tt
JOIN Vehicles v ON tt.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_number
ORDER BY pass_count DESC
LIMIT 5;

-- Find Toll Booth with the Highest Revenue

SELECT tb.location, SUM(tt.amount_paid) AS total_revenue
FROM TollTransactions tt
JOIN TollBooths tb ON tt.booth_id = tb.booth_id
GROUP BY tb.location
ORDER BY total_revenue DESC
LIMIT 1;


-- Get Toll Transactions Within a Specific Date Range

SELECT v.vehicle_number, tb.location, tt.amount_paid, tt.payment_mode, tt.entry_time
FROM TollTransactions tt
JOIN Vehicles v ON tt.vehicle_id = v.vehicle_id
JOIN TollBooths tb ON tt.booth_id = tb.booth_id
WHERE tt.entry_time BETWEEN '2025-01-01' AND '2025-01-15';
