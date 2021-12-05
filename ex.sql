--SECTION 2

--dvdrental.tar database



--lecture 13 

SELECT first_name, last_name FROM customer;


--Challenge 15.) What unique movie ratings are there?
SELECT DISTINCT rating FROM film;

--Challenge 19.) email address of Nancy Thomas 
SELECT email FROM customer
WHERE first_name = 'Nancy' AND last_name = 'Thomas';

--description of film Outlaw Hanky
SELECT description FROM film
WHERE title = 'Outlaw Hanky';

--Phone number of customer living at 259 Ipoh Drive 
SELECT phone FROM address 
WHERE address = '259 Ipoh Drive';  --1st adress is table name, second is a seperate column name

--challenge 22.) find first 10 paying customers
SELECT customer_id FROM payment
ORDER BY payment_date ASC
LIMIT 10

-- shortest 5 movies
SELECT title, length FROM film
ORDER BY length ASC
LIMIT 5

--How many films have runtime less than or equal to 50 mins
SELECT COUNT(*) FROM film
WHERE length <= 50;


--GENERAL CHALLENGE 26.)

--How many payment transactions greater than $5?
SELECT COUNT(*) FROM payment
WHERE amount > 5;

--How actors have first naming starting with 'P'
SELECT COUNT(*) FROM actor
WHERE first_name LIKE 'P%';

--How many unique districts are customers from, pt  2 what are their names?
SELECT COUNT(DISTINCT district) FROM address;

SELECT DISTINCT district FROM address;

--How many films rated R and replacement vost between $5 and $15?
SELECT COUNT(*) FROM film 
WHERE rating = 'R' AND (replacement_cost BETWEEN 5 AND 15);

--How Many films have 'Truman' somewhere in title?
SELECT COUNT(*) FROM film
WHERE title LIKE '%Truman%';


--SECTION 3

--31.) how many payments did each staff member handle (who gets bonus for mosts payments?)
SELECT staff_id, COUNT(amount) FROM payment
GROUP BY staff_id
ORDER BY COUNT(amount) DESC;

--What is average replacement_cost per MPAA rating?
SELECT rating, AVG(replacement_cost) FROM film
GROUP BY rating;

--Who are top 5 customers by amount spent?
SELECT customer_id, SUM(amount) FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5


--33.) Which customers have had 40 or more payments?
SELECT customer_id, COUNT(amount) FROM payment
GROUP BY customer_id
HAVING COUNT(amount) >= 40;

--Customers who have spent more than $100 with staff id 2
SELECT customer_id, SUM(amount) FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 100;


--SECTION 4

--Assesment Test 1

--1. Return the customer IDs of customers who have spent at least $110 with the staff member who has an ID of 2.
SELECT customer_id, SUM(amount) FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) >= 110;

--2  How many films begin with the letter J?
SELECT COUNT(title) FROM film
WHERE title LIKE 'J%';

--3 What customer has the highest customer ID number whose name starts with an 'E' and has an address ID lower than 500?
SELECT customer_id, first_name, last_name FROM customer
WHERE first_name LIKE 'E%' AND address_id < 500
ORDER BY customer_id DESC
LIMIT 1;

--SECTION 5

-- 45.) JOIN CHALLENGE TASKS

--What are the emails of the customers who live in California?
SELECT customer.email,address.district FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
WHERE district = 'California' ;

--All films nick wahlberg has been in
SELECT title, first_name, last_name FROM film
INNER JOIN film_actor 
ON film.film_id = film_actor.film_id
INNER JOIN actor
ON actor.actor_id = film_actor.actor_id 
WHERE first_name = 'Nick' AND last_name = 'Wahlberg' ;

--SECTION 6 

--50.) During which months did payments occur (format answer to return back fulll month name)
SELECT DISTINCT(TO_CHAR(payment_date, 'MONTH')) FROM payment;


--How many payments occured on a Monday?
SELECT COUNT(*) FROM payment 
WHERE TO_CHAR(payment_date, 'ID') = '1' ;   -- 'ID' ISO 8601 day of the week, Monday (1) to Sunday (7)
--alt soln
SELECT COUNT(*) FROM payment
WHERE EXTRACT(dow from payment_date) = 1 ;


--SECTION 7: ASSESMENT TEST 2
-- questions and expected results: https://docs.google.com/document/d/1wiuYbTQslmfolQWgeVPB356csjK6yqOUBhgC7fM44o8/edit

--1.) How can you retrieve all the information from the cd.facilities table?
SELECT * FROM cd.facilities;

--2.) You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of only facility names and costs?
SELECT name,membercost FROM cd.facilities;

--3.) How can you produce a list of facilities that charge a fee to members?
SELECT * FROM cd.facilities
WHERE membercost > 0 ;

--4.) How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.
SELECT facid, name, membercost, monthlymaintenance FROM cd.facilities
WHERE membercost > 0 AND (membercost < (monthlymaintenance/50.0))

--5.) How can you produce a list of all facilities with the word 'Tennis' in their name?
SELECT * FROM cd.facilities
WHERE name LIKE '%Tennis%'

--6.) How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.
SELECT * FROM cd.facilities
WHERE facid IN (1,5)

--7.) How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.
SELECT memid, surname, firstname, joindate FROM cd.members
WHERE joindate > '2012-09-01'

--8.) How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain duplicates.
SELECT DISTINCT surname FROM cd.members
ORDER BY surname ASC
LIMIT 10

--9.) You'd like to get the signup date of your last member. How can you retrieve this information?
SELECT joindate FROM cd.members
ORDER BY joindate DESC
LIMIT 1;
--alt sln
SELECT MAX(joindate) FROM cd.members;

--10.) Produce a count of the number of facilities that have a cost to guests of 10 or more.
SELECT COUNT(*) FROM cd.facilities
WHERE guestcost >= 10.0

--11.) Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.
SELECT facid, SUM(slots) AS Total_slots FROM cd.bookings 
WHERE starttime >= '2012-09-01' AND starttime <= '2012-10-01'
GROUP BY facid
ORDER BY SUM(slots) ASC

--12.) Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and total slots, sorted by facility id.
SELECT facid, SUM(slots) AS Total_slots FROM cd.bookings 
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY facid ASC

--13.) How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
SELECT starttime AS start, name FROM cd.bookings
INNER JOIN cd.facilities ON cd.bookings.facid = cd.facilities.facid
WHERE name LIKE 'Tennis Court %' AND (starttime >= '2012-09-21') AND starttime < '2012-09-22'  --could use facid in (0,1) instead of LIKE 'Tennis Court %'
ORDER BY starttime ASC

--14.) How can you produce a list of the start times for bookings by members named 'David Farrell'?
SELECT starttime FROM cd.bookings 
WHERE memid in 
(SELECT memid FROM cd.members
WHERE firstname = 'David' AND surname = 'Farrell' )

-- alt sln using join instead of subquery
SELECT starttime FROM cd.bookings
INNER JOIN cd.members ON cd.bookings.memid = cd.members.memid
WHERE firstname = 'David' AND surname = 'Farrell'




--SECTION 8 

--creating account,job, account_job table example
CREATE TABLE account(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(50) NOT NULL,
	email VARCHAR(250) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
	last_login TIMESTAMP
) 

CREATE TABLE job(
	job_id SERIAL PRIMARY KEY,
	job_name VARCHAR(200) UNIQUE NOT NULL
) 

CREATE TABLE account_job(
	user_id INTEGER REFERENCES account(user_id),
	job_id INTEGER REFERENCES job(job_id),
	hire_date TIMESTAMP 	
)


--SECTION 9
/*
Create a new database called "School" this database should have two tables: teachers and students.

The students table should have columns for student_id, first_name,last_name, homeroom_number, phone,email, and graduation year.

The teachers table should have columns for teacher_id, first_name, last_name,

homeroom_number, department, email, and phone.

The constraints are mostly up to you, but your table constraints do have to consider the following:

 We must have a phone number to contact students in case of an emergency.

 We must have ids as the primary key of the tables

Phone numbers and emails must be unique to the individual.

Once you've made the tables, insert a student named Mark Watney (student_id=1) who has a phone number of 777-555-1234 and doesn't have an email. He graduates in 2035 and has 5 as a homeroom number.

Then insert a teacher names Jonas Salk (teacher_id = 1) who as a homeroom number of 5 and is from the Biology department. His contact info is: jsalk@school.org and a phone number of 777-555-432
*/


--creating students table
CREATE TABLE students(
	student_id SERIAL PRIMARY KEY, 
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL, 
	homeroom_number SMALLINT, 
	phone_number VARCHAR(50) UNIQUE NOT NULL,
	email VARCHAR(50) UNIQUE,  
	graduation_year SMALLINT
)

--creating teachers table
CREATE TABLE teachers(
	teacher_id SERIAL PRIMARY KEY, 
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL, 
	homeroom_number SMALLINT, 
	phone_number VARCHAR(50) UNIQUE NOT NULL,
	email VARCHAR(50) UNIQUE,  
	department VARCHAR(50) 
)


--Insert record for Mark Watney in students 
INSERT INTO students(first_name, last_name, homeroom_number, phone_number, graduation_year)
VALUES
('Mark', 'Watney', 5, '777-555-1234', 2035)

--Insert record for Jonas Salk in teachers
INSERT INTO teachers(first_name, last_name, homeroom_number, phone_number, email, department)
VALUES
('Jonas', 'Salk', 5, '777-555-432', 'jsalk@school.org', 'Biology')
	
--Section 10 74.)
-- number of films that have r,pg,pg-13 rating
SELECT
SUM(CASE rating
	WHEN 'R' THEN 1
	ELSE 0
END) AS r,
SUM(CASE rating 
    WHEN 'PG' THEN 1
    ELSE 0
END) AS pg,
SUM(CASE rating 
    WHEN 'PG-13' THEN 1
    ELSE 0
END) AS pg13	
	
FROM film


