
-- 1. AIRLINE TABLE
CREATE TABLE Airline (
    AirlineID INT PRIMARY KEY,
    AirlineName VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15),
    OperatingRegion VARCHAR(100)
);

-- 2. AIRPORT TABLE
CREATE TABLE Airport (
    AirportCode VARCHAR(10) PRIMARY KEY,
    AirportName VARCHAR(100) NOT NULL
);

-- 3. PASSENGER TABLE
CREATE TABLE Passenger (
    PassengerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PassportNo VARCHAR(30) UNIQUE
);

-- 4. FLIGHT TABLE
CREATE TABLE Flight (
    FlightID INT PRIMARY KEY,
    FlightNo VARCHAR(20) NOT NULL,
    DepartureDateTime DATETIME,
    ArrivalDateTime DATETIME,
    AvailableSeats INT,
    AirlineID INT,
    DepartureAirportCode VARCHAR(10),
    ArrivalAirportCode VARCHAR(10),

    FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID),
    FOREIGN KEY (DepartureAirportCode) REFERENCES Airport(AirportCode),
    FOREIGN KEY (ArrivalAirportCode) REFERENCES Airport(AirportCode)
);

-- 5. BOOKING TABLE
CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    FlightID INT,
    PassengerID INT,
    PaymentStatus VARCHAR(30),

    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID),
    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID)
);

-- 6. AIRLINE_AIRPORT TABLE (M:N RELATIONSHIP)
CREATE TABLE Airline_Airport (
    AirlineID INT,
    AirportCode VARCHAR(10),

    PRIMARY KEY (AirlineID, AirportCode),
    FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID),
    FOREIGN KEY (AirportCode) REFERENCES Airport(AirportCode)
);

-- INSERT AIRLINE RECORDS
INSERT INTO Airline VALUES
(1, 'IndiGo', '9876543210', 'Domestic'),
(2, 'Air India', '9876543211', 'International'),
(3, 'SpiceJet', '9876543212', 'Domestic');

-- INSERT AIRPORT RECORDS
INSERT INTO Airport VALUES
('DEL', 'Delhi Airport'),
('BOM', 'Mumbai Airport'),
('BLR', 'Bangalore Airport'),
('HYD', 'Hyderabad Airport');

-- INSERT PASSENGER RECORDS
INSERT INTO Passenger VALUES
(101, 'Rahul Sharma', 'rahul@gmail.com', 'P12345'),
(102, 'Priya Singh', 'priya@gmail.com', 'P12346'),
(103, 'Aman Verma', 'aman@gmail.com', 'P12347'),
(104, 'Neha Jain', 'neha@gmail.com', 'P12348');

-- INSERT FLIGHT RECORDS
INSERT INTO Flight VALUES
(1001, '6E201', '2026-11-05 10:00:00', '2026-11-05 12:00:00', 50, 1, 'DEL', 'BOM'),
(1002, 'AI302', '2026-11-06 12:00:00', '2026-11-06 15:00:00', 40, 2, 'BOM', 'BLR'),
(1003, '6E405', '2026-11-07 16:00:00', '2026-11-07 18:00:00', 30, 1, 'DEL', 'HYD'),
(1004, 'SG501', '2026-11-08 09:00:00', '2026-11-08 11:00:00', 25, 3, 'BLR', 'DEL');

-- INSERT BOOKING RECORDS
INSERT INTO Booking VALUES
(501, 1001, 101, 'Paid'),
(502, 1001, 102, 'Paid'),
(503, 1002, 103, 'Pending'),
(504, 1003, 101, 'Paid'),
(505, 1004, 104, 'Paid');

-- INSERT AIRLINE_AIRPORT RECORDS
INSERT INTO Airline_Airport VALUES
(1, 'DEL'), (1, 'BOM'), (1, 'HYD'),
(2, 'BOM'), (2, 'BLR'),
(3, 'BLR'), (3, 'DEL');


-- ========== SQL QUERIES ==========

-- 1. Display all passengers
SELECT * FROM Passenger;

-- 2. Display all flights
SELECT * FROM Flight;

-- 3. Find flights with more than 30 available seats
SELECT * FROM Flight
WHERE AvailableSeats > 30;

-- 4. Display flight details with airline names
SELECT F.FlightNo, A.AirlineName,
       F.DepartureDateTime, F.ArrivalDateTime
FROM Flight F
JOIN Airline A ON F.AirlineID = A.AirlineID;

-- 5. Display passenger names and their booked flights
SELECT P.Name, F.FlightNo, B.PaymentStatus
FROM Passenger P
JOIN Booking B ON P.PassengerID = B.PassengerID
JOIN Flight F ON B.FlightID = F.FlightID;

-- 6. Display departure and arrival airport names
SELECT F.FlightNo,
       A1.AirportName AS DepartureAirport,
       A2.AirportName AS ArrivalAirport
FROM Flight F
JOIN Airport A1 ON F.DepartureAirportCode = A1.AirportCode
JOIN Airport A2 ON F.ArrivalAirportCode = A2.AirportCode;

-- 7. Count total bookings for each flight
SELECT FlightID, COUNT(*) AS TotalBookings
FROM Booking
GROUP BY FlightID;

-- 8. Find average available seats
SELECT AVG(AvailableSeats) AS AverageSeats
FROM Flight;

-- 9. Display airlines operating more than one flight
SELECT A.AirlineName, COUNT(*) AS TotalFlights
FROM Airline A
JOIN Flight F ON A.AirlineID = F.AirlineID
GROUP BY A.AirlineID, A.AirlineName
HAVING COUNT(*) > 1;

-- 10. Find passengers who booked a particular flight
SELECT Name FROM Passenger
WHERE PassengerID IN (
    SELECT PassengerID FROM Booking
    WHERE FlightID = 1001
);

-- 11. Display flights from Delhi to Mumbai
SELECT * FROM Flight
WHERE DepartureAirportCode = 'DEL'
AND ArrivalAirportCode = 'BOM';

-- 12. Update payment status
UPDATE Booking
SET PaymentStatus = 'Paid'
WHERE BookingID = 503;

-- 13. Update available seats
UPDATE Flight
SET AvailableSeats = 45
WHERE FlightID = 1001;

-- 14. Delete a booking
DELETE FROM Booking
WHERE BookingID = 505;

-- 15. Display passengers who have not booked any flight
SELECT * FROM Passenger P
WHERE NOT EXISTS (
    SELECT 1 FROM Booking B
    WHERE B.PassengerID = P.PassengerID
);

-- 16. Display all paid bookings
SELECT P.Name, F.FlightNo, B.BookingID
FROM Passenger P
JOIN Booking B ON P.PassengerID = B.PassengerID
JOIN Flight F ON B.FlightID = F.FlightID
WHERE B.PaymentStatus = 'Paid';


-- 17. Display passengers whose names start with A
SELECT * FROM Passenger
WHERE Name LIKE 'A%';

-- 18. Display flights in ascending order of available seats
SELECT * FROM Flight
ORDER BY AvailableSeats ASC;

-- 19. Count total passengers
SELECT COUNT(*) AS TotalPassengers
FROM Passenger;

-- 20. Find maximum available seats
SELECT MAX(AvailableSeats) AS MaximumSeats
FROM Flight;

-- 21. Display flights having more seats than average
SELECT * FROM Flight
WHERE AvailableSeats > (
    SELECT AVG(AvailableSeats) FROM Flight
);

-- 22. Display flights having no bookings
SELECT * FROM Flight F
WHERE NOT EXISTS (
    SELECT 1 FROM Booking B
    WHERE B.FlightID = F.FlightID
);

-- 23. Count passengers booked on each airline
SELECT A.AirlineName,
       COUNT(B.BookingID) AS TotalBookings
FROM Airline A
JOIN Flight F ON A.AirlineID = F.AirlineID
LEFT JOIN Booking B ON F.FlightID = B.FlightID
GROUP BY A.AirlineID, A.AirlineName;

-- 24. Find airlines operating at Delhi airport
SELECT A.AirlineName
FROM Airline A
JOIN Airline_Airport AA ON A.AirlineID = AA.AirlineID
WHERE AA.AirportCode = 'DEL';

-- 25. Display total bookings for each flight
SELECT FlightID, COUNT(*) AS TotalBookings
FROM Booking
GROUP BY FlightID;