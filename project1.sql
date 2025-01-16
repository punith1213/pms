
create database park;
use park;

-- Visitors Table:--
-- Stores information about park visitors.--

create table visitor(
visitor_id int primary key auto_increment,
name varchar(20) not null,
contact_number int,
visit_date date not null,
ticket_type enum('Day Pass', 'Season Pass') not null);

-- Facilities Table: --
-- Tracks park facilities (e.g., playgrounds, picnic areas, restrooms). --

create table Facilities(
facility_id int primary key auto_increment,
facility_name varchar(20) not null,
location varchar(20),
capacity varchar(20));

-- Facility Bookings Table: --
-- Manages visitor bookings for specific facilities. --

CREATE TABLE Facility_Booking (
    booking_id INT PRIMARY KEY auto_increment,
    visitor_id INT,
    facility_id INT,
    booking_date DATE NOT NULL,
    time_slot TIME,
    FOREIGN KEY (visitor_id) REFERENCES visitor(visitor_id),
    FOREIGN KEY (facility_id) REFERENCES facilities(facility_id)
);

-- Maintenance Table:
-- Tracks facility maintenance schedules.

create table maintenance(
maintenance_id int primary key auto_increment, 
facility_id int,
maintenance_date date not null,
status enum('Scheduled', 'Completed') not null,
foreign key (facility_id) references facilities(facility_id));

-- Staff Table:
-- Stores staff details and their roles.


CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role ENUM('Guide', 'Maintenance', 'Security') NOT NULL,
    assigned_facility_id INT,
    FOREIGN KEY (assigned_facility_id) REFERENCES facilities(facility_id)
);


INSERT INTO visitor(name, contact_number, visit_date, ticket_type) 
VALUES 
('Rajesh Kumar', 9876543210, '2025-01-10', 'Day Pass'),
('Anita Sharma', '9123456789', '2025-01-11', 'Season Pass'),
('Vikram Singh', '9234567891', '2025-01-12', 'Day Pass'),
('Pooja Iyer', '9345678902', '2025-01-12', 'Season Pass'),
('Arjun Reddy', '9456789013', '2025-01-13', 'Day Pass');

INSERT INTO facilities (facility_name, location, capacity) 
VALUES 
('Children’s Play Area', 'North Zone', 50),
('Yoga Pavilion', 'South Zone', 30),
('Restroom Block A', 'East Zone', 10),
('Botanical Garden', 'West Zone', 40),
('Parking Area', 'Main Entrance', 100);

INSERT INTO Facility_Booking (booking_id, visitor_id, facility_id, booking_date, time_slot) 
VALUES 
(1, 1, 1, '2025-01-10', '09:30:00'),
(2, 2, 2, '2025-01-11', '10:00:00'),
(3, 3, 3, '2025-01-12', '10:30:00'),
(4, 4, 4, '2025-01-12', '11:00:00'),
(5, 5, 5, '2025-01-13', '11:30:00');

INSERT INTO Maintenance (maintenance_id, facility_id, maintenance_date, status) 
VALUES 
(1, 1, '2025-01-15', 'Scheduled'),
(2, 2, '2025-01-16', 'Completed'),
(3, 3, '2025-01-17', 'Scheduled'),
(4, 4, '2025-01-18', 'Completed'),
(5, 5, '2025-01-19', 'Scheduled');

INSERT INTO Staff (name, role, assigned_facility_id) 
VALUES 
('Suresh Patil', 'Guide', 1),
('Meena Gupta', 'Maintenance', 2),
('Ravi Naik', 'Security', 3),
('Lakshmi Menon', 'Guide', 4),
('Ajay Pandey', 'Maintenance', 5);


select * from visitor;
select * from Facilities;
select * from Facility_Booking;
select * from maintenance;
select * from Staff;

select v.name, b.booking_date
from visitor as v
join facility_booking as b
on v.visitor_id=b.visitor_id;

CREATE TABLE ticket_prices (
    ticket_type VARCHAR(50) PRIMARY KEY,
    price INT
);

INSERT INTO ticket_prices (ticket_type, price)
VALUES 
('Day Pass', 500),
('Season Pass', 3000);

SELECT * FROM ticket_prices;

SELECT 
    v.ticket_type,
    COUNT(*) AS total_tickets,
    tp.price AS ticket_price,
    COUNT(*) * tp.price AS total_revenue
FROM visitor v
JOIN ticket_prices tp
ON v.ticket_type = tp.ticket_type
GROUP BY v.ticket_type, tp.price;


-- Find the Most Frequently Visited Facility

SELECT 
    f.facility_name,
    COUNT(fb.booking_id) AS total_bookings
FROM facilities f
JOIN facility_booking fb
ON f.facility_id = fb.facility_id
GROUP BY f.facility_name
ORDER BY total_bookings DESC
LIMIT 1;


-- List Staff Members Assigned to Each Facility

SELECT 
    s.name AS staff_name,
    s.role,
    f.facility_name
FROM staff s
JOIN facilities f
ON s.assigned_facility_id = f.facility_id
ORDER BY s.name;


-- Find Total Revenue by Facility

SELECT 
    f.facility_name,
    COUNT(fb.booking_id) AS total_visits,
    SUM(tp.price) AS total_revenue
FROM facility_booking fb
JOIN visitor v
ON fb.visitor_id = v.visitor_id
JOIN ticket_prices tp
ON v.ticket_type = tp.ticket_type
JOIN facilities f
ON fb.facility_id = f.facility_id
GROUP BY f.facility_name;


-- Identify Visitors Who Visited on a Specific Date

SELECT 
    visitor_id,
    name,
    contact_number,
    ticket_type
FROM visitor
WHERE visit_date = '2025-01-10';


-- Find Average Ticket Price for All Visitors

SELECT 
    AVG(tp.price) AS average_ticket_price
FROM visitor v
JOIN ticket_prices tp
ON v.ticket_type = tp.ticket_type;
