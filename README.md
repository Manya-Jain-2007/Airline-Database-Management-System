# Airline Database Management System

## Project Overview
This project implements an Airline Database Management System using SQL and SQLite.

## Entities
- Airline
- Airport
- Passenger
- Flight
- Booking
- Airline_Airport

## Relationships
- Airline – Flight (1:N)
- Flight – Booking (1:N)
- Passenger – Booking (1:N)
- Airport – Flight (1:N, Departure and Arrival)
- Airline – Airport (M:N)

## SQL Concepts Used
- CREATE TABLE and INSERT
- Primary Keys and Foreign Keys
- SELECT, WHERE and ORDER BY
- Joins (INNER JOIN, LEFT JOIN)
- Aggregate Functions
- GROUP BY and HAVING
- Subqueries
- UPDATE and DELETE

## Technology
- SQL
- SQLite

## Files
- Airline_Database.sql – Contains table creation, sample data and SQL queries.
