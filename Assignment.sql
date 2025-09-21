-- 1. Create a table called employees with the following structure?
-- emp_id (integer, should not be NULL and should be a primary key)Q
-- emp_name (text, should not be NULL)Q
-- age (integer, should have a check constraint to ensure the age is at least 18)Q
-- email (text, should be unique for each employee)Q
-- salary (decimal, with a default value of 30,000).
-- Write the SQL query to create the above table with all constraints.

create database sagar;

use sagar;

create table employees (
	emp_id integer primary key not null, 
	age integer check(age >= 18), 
	email varchar(50) unique, 
	salary decimal default 30000 
);

select * from employees;


-- 2. Explain the purpose of constraints and how they help maintain data integrity in a database. 
-- Provide examples of common types of constraints.

-- Ans ->
	-- Purpose of Constraints in a Database
		-- Constraints are rules applied to columns or tables in a relational database to enforce data integrity, accuracy, and consistency. 
        -- They prevent invalid data from being inserted, updated, or deleted, ensuring the database remains reliable and trustworthy.

	-- Constraints help:
		-- Prevent data entry errors (e.g., negative prices, duplicate IDs).
		-- Maintain relationships between tables (e.g., customer linked to valid address).
		-- Ensure business rules are enforced automatically at the database level.
		-- Improve query performance by enabling indexing (e.g., via primary keys).
        
	-- Constraint Types
		-- PRIMARY KEY
			-- Description -> Ensures each row is unique and not null.
			-- Example -> customer_id INT PRIMARY KEY
		-- FOREIGN KEY
			-- Description -> Enforces a relationship between tables. Refers to the primary key in another table.
			-- Example -> customer_id INT REFERENCES customer(customer_id)
		-- NOT NULL
			-- Description -> 	Prevents null (empty) values in a column.
			-- Example -> first_name VARCHAR(50) NOT NULL
		-- UNIQUE
			-- Description -> Ensures all values in a column are different.
			-- Example -> 	email VARCHAR(100) UNIQUE
		-- CHECK
			-- Description -> 	Restricts the range or format of values.
			-- Example -> 	age INT CHECK (age >= 18)
		-- DEFAULT
			-- Description ->  Assigns a default value when none is provided.
			-- Example -> 	status VARCHAR(10) DEFAULT 'active'

	-- Example:
        CREATE TABLE students (
            student_id INT PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            age INT CHECK (age >= 5),
            email VARCHAR(100) UNIQUE
        );

-- 3.Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? 
-- Justify your answer.

-- Ans ->
	-- The NOT NULL constraint is applied to a column to ensure that every row must have a value in that column — it cannot be left empty.
	-- Reasons to use NOT NULL:
		-- 1. Data Integrity: It prevents missing or incomplete data.
			-- Example: A first_name field in a customer table should never be empty.
		-- 2. Business Logic Enforcement: Some fields are essential for operations.
			-- Example: A price field in a products table must always have a valid value.
		-- 3. Indexing & Performance: NULLs can interfere with indexing and sorting, so eliminating them can improve performance.

	-- Can a Primary Key Contain NULL Values?
		-- No, a Primary Key Cannot Contain NULL Values.
		-- A Primary Key (PK) must:
			-- Uniquely identify each row in a table.
			-- Be non-null (every row must have a value).
		-- If NULLs were allowed:
			-- Multiple rows could have a NULL in the primary key column.
			-- That would violate the uniqueness requirement of primary keys.
	-- Example:
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL
);
	-- Here:
		-- user_id must be unique and cannot be NULL.
		-- username must have a value (enforced by NOT NULL).
	

-- 4. Explain the steps and SQL commands used to add or remove constraints on an existing table. 
-- Provide an example for both adding and removing a constraint.

-- Ans ->
	-- Steps to Add or Remove Constraints
		-- In SQL (especially MySQL, PostgreSQL, SQL Server), we use the ALTER TABLE statement to add or drop constraints on existing tables.
		-- 1. Adding Constraints
			-- Syntax:

    ALTER TABLE table_name
    ADD CONSTRAINT constraint_name constraint_type (column_name);
	
	-- Example – Add a UNIQUE Constraint:
    
    ALTER TABLE customers
    ADD CONSTRAINT unique_email UNIQUE (email);
		-- This ensures all values in the email column are unique.

	-- Example – Add a FOREIGN KEY Constraint:

    ALTER TABLE orders
    ADD CONSTRAINT fk_customer_id
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
		-- This enforces referential integrity between orders.customer_id and customers.customer_id.

	-- 2. Removing (Dropping) Constraints
		-- Syntax:

    ALTER TABLE table_name
    DROP CONSTRAINT constraint_name;

		-- Example – Remove a FOREIGN KEY Constraint (MySQL):

    ALTER TABLE orders
    DROP FOREIGN KEY fk_customer_id;

		-- Example – Remove a UNIQUE Constraint (MySQL):

    ALTER TABLE customers
    DROP INDEX unique_email;

	-- How to Find Constraint Names (MySQL):

    SHOW CREATE TABLE table_name;

    SELECT constraint_name, table_name
    FROM information_schema.table_constraints
    WHERE table_name = 'orders';


-- 5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. 
-- Provide an example of an error message that might occur when violating a constraint.

-- Ans ->
	-- When a constraint is violated:
		-- The operation (INSERT, UPDATE, DELETE) fails.
		-- An error message is returned.
		-- No changes are made to the data (ensuring data integrity is preserved).

	-- Examples of Violating Common Constraints
	-- 1. NOT NULL Constraint Violation
		-- Rule:
			-- A column must have a value — it cannot be NULL.
		-- Example:

    INSERT INTO customer (customer_id, first_name, last_name)
    VALUES (1, NULL, 'Smith');

		-- Error (MySQL):
    ERROR 1048 (23000): Column 'first_name' cannot be null

		-- 2. PRIMARY KEY Constraint Violation
			-- Rule:
				-- The primary key must be unique and not null.
			-- Example:

    INSERT INTO customer (customer_id, first_name, last_name)
    VALUES (1, 'John', 'Doe');  -- Assume ID 1 already exists

			-- Error:
    ERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'

		-- 3. UNIQUE Constraint Violation
			-- Rule:
				-- All values in the column must be unique.
			-- Example:

    INSERT INTO customer (customer_id, email)
    VALUES (2, 'john@example.com');  -- If that email already exists

			-- Error:
	ERROR 1062 (23000): Duplicate entry 'john@example.com' for key 'unique_email'

		-- 4. FOREIGN KEY Constraint Violation
			-- Rule:
				-- A foreign key must match a value in the referenced table or be NULL (if allowed).
			-- Example:

    INSERT INTO orders (order_id, customer_id)
    VALUES (1, 999);  -- No customer with ID 999 exists

			-- Error:
    ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails

		-- 5. CHECK Constraint Violation
			-- Rule:
				-- The value must satisfy a custom condition.
			-- Example:

    INSERT INTO employees (age)
    VALUES (15);  -- If CHECK(age >= 18) is set

			-- Error (in PostgreSQL):
    ERROR: new row for relation "employees" violates check constraint "age_check"


-- 6. You created a products table without constraints as follows:
-- CREATE TABLE products (
--     product_id INT,
--     product_name VARCHAR(50),
--     price DECIMAL(10, 2));
-- Now, you realise that?
-- : The product_id should be a primary key
-- : The price should have a default value of 50.00

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL (10, 2));

ALTER TABLE products
ADD CONSTRAINT product_id PRIMARY KEY (product_id);

ALTER TABLE products
ALTER COLUMN price SET DEFAULT 50.00;

select * from products;

-- 7. You have two tables:
-- Write a query to fetch the student_name and class_name for each student 
-- using an INNER JOIN.

create table Classes(
	class_id int primary key,
    class_name varchar(100)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

INSERT INTO Students (student_id, student_name, class_id) 
VALUES
    (1, 'Alice', 101), 
    (2, 'Bob', 102), 
    (3, 'Charlie', 101);

insert into Classes values
	(101, 'Math'),
    (102, 'Science'),
    (103, 'History');

select * from Students;
select * from Classes;

select s.student_name, c.class_name from Students s
inner join Classes c on s.class_id = c.class_id;


-- 8. Consider the following three tables:
-- Write a query that shows all order_id, customer_name, and product_name, 
-- ensuring that all products are listed even if they are not associated with an order 
-- Hint: (use INNER JOIN and LEFT JOIN)5

create table Customers (
	customer_id int primary key,
    customer_name varchar(100)
);

create table Orders (
	order_id int primary key,
    order_date date,
    customer_id int,
    foreign key (customer_id) references Customers(customer_id)
);

ALTER TABLE Products ADD order_id INT;

INSERT INTO Products (product_id, product_name, order_id)
VALUES (1, 'Laptop', 1), 
		(2, 'Phone', NULL);

insert into Customers values
		(101, 'Alice'),
		(102, 'Bob');
        
insert into Orders values
		(1, '2024-01-01', 101),
        (2, '2024-01-03', 102);
	
SELECT p.order_id, 
	c.customer_name,
    p.product_name
FROM Products p
LEFT JOIN 
    Orders o ON p.order_id = o.order_id
INNER JOIN 
    Customers c ON o.customer_id = c.customer_id;


-- 9 Given the following tables:
-- Write a query to find the total sales amount for each product using an 
-- INNER JOIN and the SUM() function.

UPDATE Products SET product_id = 101
WHERE product_id = 1;

UPDATE Products SET product_id = 102
WHERE product_id = 2;

select * from products;

create table Sales (
	sale_id int primary key,
    product_id int,
    amount decimal,
    foreign key (product_id) references Products(product_id)
);
        
insert into Sales values
		(1, 101, 500),
        (2, 102, 300),
        (3, 101, 700);
        
SELECT p.product_name,
    SUM(s.amount) AS total_sales
FROM Sales s
INNER JOIN 
    Products p ON s.product_id = p.product_id
GROUP BY p.product_name;

## OR
        
SELECT p.product_name,
    SUM(s.amount) AS total_sales 
FROM Products p 
INNER JOIN 
    Sales s ON p.product_id = s.product_id
GROUP BY p.product_name;

-- 10. You are given three tables:
-- Write a query to display the order_id, customer_name, and the quantity of products ordered by each
-- customer using an INNER JOIN between all three tables.

UPDATE Orders SET order_date = '2024-01-02'
WHERE Customer_Id = 101;

UPDATE Orders SET order_date = '2024-01-05'
WHERE Customer_Id = 102;

CREATE TABLE Order_Details (
    order_id INT PRIMARY KEY,
    product_id INT,
    quantity INT
);

select customer_id from customers;

INSERT INTO Order_Details (order_id, product_id, quantity) VALUES 
    (1, 101, 2), 
    (1, 102, 1), 
    (2, 101, 3);
    
    
SELECT 
    o.order_id,
    c.customer_name,
    o.quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id;


## SQL Commands

-- 1-Identify the primary keys and foreign keys in maven movies db. Discuss the differences
-- Ans ->
	-- Primary Keys (PK)
		-- A primary key uniquely identifies each record in a table.
		-- It must be unique and not null.
		-- Usually a single column but can be composite (multiple columns).
		-- Example in a Movies DB:
			-- movies table: movie_id is the primary key.
			-- actors table: actor_id is the primary key.
			-- directors table: director_id is the primary key.

	-- Foreign Keys (FK)
		-- A foreign key is a column (or set of columns) in one table that references the primary key in another table.
		-- It establishes a relationship between tables.
		-- Ensures referential integrity (e.g., you can’t have a movie referencing a non-existent director).
		-- Example:
			-- movies table has a director_id column, which is a foreign key referencing directors.director_id.
			-- cast table might have movie_id and actor_id as foreign keys referencing movies.movie_id and actors.actor_id.


-- 2- List all details of actors

SELECT * FROM actor;

-- 3 -List all customer information from DB.

SELECT * FROM customer;

-- 4 -List different countries.

SELECT country_id, country FROM country;

SELECT DISTINCT country FROM country;

-- 5 -Display all active customers.

SELECT * FROM customer
WHERE active = 1;

-- 6 -List of all rental IDs for customer with ID 1.

SELECT rental_id FROM rental
WHERE customer_id = 1;

-- 7 - Display all the films whose rental duration is greater than 5 .

SELECT * FROM film
WHERE rental_duration > 5;

-- 8 - List the total number of films whose replacement cost is greater than $15 and less than $20.

SELECT COUNT(*) AS total_films FROM film
WHERE replacement_cost > 15 AND replacement_cost < 20;

-- 9 - Display the count of unique first names of actors.

SELECT COUNT(DISTINCT first_name) AS unique_first_names_count FROM actor;

-- 10- Display the first 10 records from the customer table .

SELECT * FROM customer
LIMIT 10;

-- 11 - Display the first 3 records from the customer table whose first name starts with ‘b’.

SELECT * FROM customer
WHERE first_name LIKE 'b%'
LIMIT 3;

SELECT * FROM customer
WHERE LOWER(first_name) LIKE 'b%'
LIMIT 3;

-- 12 -Display the names of the first 5 movies which are rated as ‘G’.

SELECT title FROM film
WHERE rating = 'G'
LIMIT 5;

-- 13-Find all customers whose first name starts with "a".

SELECT * FROM customer
WHERE first_name LIKE 'a%';

SELECT * FROM customer
WHERE LOWER(first_name) LIKE 'a%';

-- 14- Find all customers whose first name ends with "a".

SELECT * FROM customer
WHERE first_name LIKE '%a';

SELECT * FROM customer
WHERE LOWER(first_name) LIKE '%a';

-- 15- Display the list of first 4 cities which start and end with ‘a’ .

SELECT city FROM city
WHERE city LIKE 'a%' AND city LIKE '%a'
LIMIT 4;

-- 16- Find all customers whose first name have "NI" in any position.

SELECT * FROM customer
WHERE first_name LIKE '%NI%';

SELECT * FROM customer
WHERE LOWER(first_name) LIKE '%ni%';

-- 17- Find all customers whose first name have "r" in the second position .

SELECT * FROM customer
WHERE first_name LIKE '_r%';

SELECT * FROM customer
WHERE LOWER(first_name) LIKE '_r%';

-- 18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.

SELECT * FROM customer
WHERE first_name LIKE 'a%' AND LENGTH(first_name) >= 5;

SELECT * FROM customer
WHERE LOWER(first_name) LIKE 'a%' AND LENGTH(first_name) >= 5;

-- 19- Find all customers whose first name starts with "a" and ends with "o".

SELECT * FROM customer
WHERE first_name LIKE 'a%o';

SELECT * FROM customer
WHERE LOWER(first_name) LIKE 'a%o';

-- 20 - Get the films with pg and pg-13 rating using IN operator.

SELECT * FROM film
WHERE rating IN ('PG', 'PG-13');

-- 21 - Get the films with length between 50 to 100 using between operator.

SELECT * FROM film
WHERE length BETWEEN 50 AND 100;

-- 22 - Get the top 50 actors using limit operator.

SELECT * FROM actor
LIMIT 50;

SELECT * FROM actor
ORDER BY actor_id
LIMIT 50;

-- 23 - Get the distinct film ids from inventory table.

SELECT DISTINCT film_id FROM inventory;



## Functions

## Basic Aggregate Functions:

-- Question 1:
-- Retrieve the total number of rentals made in the Sakila database.
-- Hint: Use the COUNT() function.

use sakila;

SELECT COUNT(*) AS total_rentals
FROM rental;

-- Question 2:
-- Find the average rental duration (in days) of movies rented from the Sakila database.
-- Hint: Utilize the AVG() function.

SELECT AVG(DATEDIFF(return_date, rental_date)) AS average_rental_duration
FROM rental
WHERE return_date IS NOT NULL;

## String Functions:

-- Question 3:
-- Display the first name and last name of customers in uppercase.
-- Hint: Use the UPPER () function.

SELECT 
    UPPER(first_name) AS first_name_upper,
    UPPER(last_name) AS last_name_upper
FROM customer;

-- Question 4:
-- Extract the month from the rental date and display it alongside the rental ID.
-- Hint: Employ the MONTH() function.

SELECT rental_id,
    MONTH(rental_date) AS rental_month
FROM rental;

## GROUP BY:

-- Question 5:
-- Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
-- Hint: Use COUNT () in conjunction with GROUP BY.

SELECT customer_id,
    COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

-- Question 6:
-- Find the total revenue generated by each store.
-- Hint: Combine SUM() and GROUP BY.

SELECT s.store_id,
    SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.store_id;

-- Question 7:
-- Determine the total number of rentals for each category of movies.
-- Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.

SELECT c.name AS category_name,
    COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_rentals DESC;

-- Question 8:
-- Find the average rental rate of movies in each language.
-- Hint: JOIN film and language tables, then use AVG () and GROUP BY.

SELECT l.name AS language,
    AVG(f.rental_rate) AS average_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

## Joins

-- Questions 9 -
-- Display the title of the movie, customer s first name, and last name who rented it.
-- Hint: Use JOIN between the film, inventory, rental, and customer tables.

SELECT f.title,
    c.first_name,
    c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;

-- Question 10:
-- Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
-- Hint: Use JOIN between the film actor, film, and actor tables.

SELECT a.first_name,
    a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

-- Question 11:
-- Retrieve the customer names along with the total amount they've spent on rentals.
-- Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.

SELECT c.first_name,
    c.last_name,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Question 12:
-- List the titles of movies rented by each customer in a particular city (e.g., 'London').
-- Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY.

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    f.title AS movie_title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
ORDER BY customer_name, f.title;


## Advanced Joins and GROUP BY:

-- Question 13:
-- Display the top 5 rented movies along with the number of times they've been rented.
-- Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results.

SELECT f.title,
    COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC
LIMIT 5;

-- Question 14:
-- Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
-- Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY.

SELECT r.customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY r.customer_id
HAVING COUNT(DISTINCT i.store_id) = 2;

select * from sakila;


## Windows Function :

-- 1. Rank the customers based on the total amount they've spent on rentals.

SELECT c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS spending_rank
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY spending_rank;

-- 2. Calculate the cumulative revenue generated by each film over time.

SELECT f.title,
    p.payment_date,
    p.amount,
    SUM(p.amount) OVER (
        PARTITION BY f.film_id 
        ORDER BY p.payment_date
    ) AS cumulative_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY f.title, p.payment_date;

-- 3. Determine the average rental duration for each film, considering films with similar lengths.

SELECT f.length AS film_length_minutes,
    ROUND(AVG(DATEDIFF(r.return_date, r.rental_date)), 2) AS avg_rental_duration_days
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY f.length
ORDER BY f.length;

-- 4. Identify the top 3 films in each category based on their rental counts.

SELECT category_name,
    title,
    rental_count,
    film_rank
FROM (
    SELECT c.name AS category_name,
        f.title,
        COUNT(r.rental_id) AS rental_count,
        DENSE_RANK() OVER (
            PARTITION BY c.name
            ORDER BY COUNT(r.rental_id) DESC
        ) AS film_rank
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, f.title
) AS ranked_films
WHERE film_rank <= 3
ORDER BY category_name, film_rank;

-- 5. Calculate the difference in rental counts between each customer's total rentals and the average rentalsacross all customers.

WITH customer_rentals AS (
    SELECT customer_id,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY customer_id
),
avg_rentals AS (
    SELECT AVG(total_rentals) AS average_rentals
    FROM customer_rentals
)
SELECT cr.customer_id,
    cr.total_rentals,
    ar.average_rentals,
    cr.total_rentals - ar.average_rentals AS rental_count_difference
FROM customer_rentals cr
CROSS JOIN avg_rentals ar
ORDER BY rental_count_difference DESC;

-- 6. Find the monthly revenue trend for the entire rental store over time.

SELECT DATE_FORMAT(payment_date, '%Y-%m') AS yearmonth,
    SUM(amount) AS total_monthly_revenue
FROM payment
GROUP BY yearmonth
ORDER BY yearmonth;

-- 7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.

WITH customer_spending AS (
    SELECT c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
percentiles AS (
    SELECT customer_id,
        customer_name,
        total_spent,
        PERCENT_RANK() OVER (ORDER BY total_spent) AS pct_rank
    FROM customer_spending
)
SELECT customer_id,
    customer_name,
    total_spent
FROM percentiles
WHERE pct_rank >= 0.8
ORDER BY total_spent DESC;


-- 8. Calculate the running total of rentals per category, ordered by rental count.

SELECT c.name AS category,
    COUNT(r.rental_id) AS rental_count,
    SUM(COUNT(r.rental_id)) OVER (ORDER BY COUNT(r.rental_id) DESC) AS running_total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY rental_count DESC;

-- 9. Find the films that have been rented less than the average rental count for their respective categories.

WITH film_rentals AS (
    SELECT f.film_id,
        f.title,
        c.category_id,
        c.name AS category_name,
        COUNT(r.rental_id) AS rental_count
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    LEFT JOIN inventory i ON f.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id, f.title, c.category_id, c.name
),
category_avg AS (
    SELECT category_id,
        AVG(rental_count) AS avg_rental_count
    FROM film_rentals
    GROUP BY category_id
)
SELECT fr.film_id,
    fr.title,
    fr.category_name,
    fr.rental_count,
    ca.avg_rental_count
FROM film_rentals fr
JOIN category_avg ca ON fr.category_id = ca.category_id
WHERE fr.rental_count < ca.avg_rental_count
ORDER BY fr.category_name, fr.rental_count;

-- 10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.

SELECT DATE_FORMAT(payment_date, '%Y-%m') AS yearmonth,
    SUM(amount) AS total_revenue
FROM payment
GROUP BY yearmonth
ORDER BY total_revenue DESC
LIMIT 5;


## Normalisation & CTE :

--  1. First Normal Form (1NF):
-- a. Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF.

-- Ans ->

	-- First Normal Form (1NF) Requirements:
		-- All attributes (columns) must contain atomic values (i.e., indivisible).
		-- No repeating groups or arrays/lists.
		-- Each field should contain only one value per record.

	-- Find a table in Sakila that violates 1NF
		-- The Sakila database is a sample schema designed for a DVD rental store. Let's look at a candidate:

		-- Candidate Table: customer (Example of Violation)
		-- In some older versions or poorly designed variants of the database, a customer table might look like this:

| customer\_id | first\_name | last\_name | phone\_numbers     |
| ------------ | ----------- | ---------- | ------------------ |
| 1            | John        | Doe        | 123-4567, 234-5678 |
| 2            | Jane        | Smith      | 345-6789           |

		-- Violation of 1NF:
			-- The column phone_numbers contains multiple values (a list of numbers separated by commas).
			-- This is not atomic — it violates 1NF.
		-- Normalization to 1NF
			-- We need to break this into atomic values by creating a separate table for phone numbers:

		-- Step 1: Create a new table — customer_phone
        
CREATE TABLE customer_phone (
    customer_id INT,
    phone_number VARCHAR(20),
    PRIMARY KEY (customer_id, phone_number),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

		-- Step 2: Split the data

| customer\_id | phone\_number |
| ------------ | ------------- |
| 1            | 123-4567      |
| 1            | 234-5678      |
| 2            | 345-6789      |



-- 2. Second Normal Form (2NF):
--  a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. 
-- If it violates 2NF, explain the steps to normalize it.

-- Ans ->
	
    -- Second Normal Form (2NF) :
		-- A table is in 2NF if:
			-- It is already in First Normal Form (1NF).
			-- All non-key attributes are fully functionally dependent on the entire primary key — not just part of it.
		-- This applies mainly to tables with composite primary keys (more than one column in the key).

	-- Candidate Table: film_category
		-- This table links films to categories (e.g., Action, Comedy, etc.)
		-- Table structure:
        
| Column Name  | Data Type |
| ------------ | --------- |
| film\_id     | SMALLINT  |
| category\_id | TINYINT   |
| last\_update | TIMESTAMP |

		-- Primary Key: (film_id, category_id)
        
	-- Hypothetical 2NF Violation:
		-- Assume the last_update column actually only depends on film_id, not on the full composite key (film_id, category_id). That means:
			-- last_update is partially dependent on the primary key → 2NF violation.

	-- Normalize to 2NF:
    -- Split the table into two:
		-- Table 1: film_category
        
| film\_id | category\_id |
| -------- | ------------ |

		-- Composite Primary Key: (film_id, category_id)
		-- No last_update column here.

		-- Table 2: film_last_update
        
| film\_id | last\_update        |
| -------- | ------------------- |
| 1        | 2025-09-20 13:45:00 |
| 2        | 2025-09-21 08:20:00 |

		-- Primary Key: film_id
		-- last_update now fully depends on film_id alone — not on the composite key.


-- 3. Third Normal Form (3NF):
-- a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies 
-- present and outline the steps to normalize the table to 3NF.

-- Ans ->

	-- Third Normal Form (3NF) :
		-- A table is in 3NF if:
			-- It is already in Second Normal Form (2NF).
			-- All attributes are only dependent on the primary key — no transitive dependencies.
		-- A transitive dependency exists when:
			-- A non-key attribute depends on another non-key attribute.
			-- Example: A → B → C, where A is the primary key, C is transitively dependent on A through B.

	-- Candidate Table: address 
		-- Table structure:
        
| Column Name  | Description           |
| ------------ | --------------------- |
| address\_id  | Primary key           |
| address      | Street address        |
| address2     | Optional second line  |
| district     | Administrative region |
| city\_id     | Foreign key to `city` |
| postal\_code | ZIP or postal code    |
| phone        | Contact number        |
| last\_update | Timestamp of update   |

	-- 3NF Violation (Transitive Dependency):
		-- city_id is a foreign key to the city table.
		-- district, postal_code, and possibly even city are location-related data.
	-- Here's the issue:
		-- address_id → city_id
		-- city_id → city_name, country_id
		-- So: address_id → city_id → city_name

	-- That means city_name is transitively dependent on address_id, via city_id.
	-- In a denormalized version of the table, if we included city_name or country directly in the address table, that would violate 3NF.
	
	-- Normalize to 3NF:
    
    | address\_id | address | city\_name | country\_name |
	| ----------- | ------- | ---------- | ------------- |

	-- In this case:
		-- address_id → city_name
		-- city_name → country_name
		-- Therefore: address_id → city_name → country_name (transitive dependency)

	-- Step-by-step Normalization:
	-- 1. Extract city info into a separate table (city):
CREATE TABLE city (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(50),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

	-- 2. Reference city_id in the address table, remove city_name, country_name:
CREATE TABLE address (
    address_id INT PRIMARY KEY,
    address VARCHAR(100),
    city_id INT,
    -- other fields...
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

	-- 3. Ensure country_name is only in the country table, not duplicated.

	-- Final Normalized Structure (in 3NF):
		-- address: stores address details + city_id
		-- city: stores city_id, city_name, and country_id
		-- country: stores country_id, country_name


-- 4. Normalization Process:
-- a. Take a specific table in Sakila and guide through the process of normalizing it from the 
-- initial unnormalized form up to at least 2NF.

-- Ans ->

	-- Unnormalized Form (UNF)
	-- UNF Table: rental_unnormalized
    
| rental\_id | rental\_date     | return\_date     | customer\_name | customer\_email                                     | inventory\_id | film\_title | staff\_name   |
| ---------- | ---------------- | ---------------- | -------------- | --------------------------------------------------- | ------------- | ----------- | ------------- |
| 1          | 2025-09-20 14:00 | 2025-09-21 14:00 | John Smith     | [john.smith@email.com](mailto:john.smith@email.com) | 100           | The Matrix  | Alice Johnson |
| 2          | 2025-09-21 10:30 | 2025-09-22 11:00 | Mary Jones     | [mary.jones@email.com](mailto:mary.jones@email.com) | 105           | Inception   | Bob Thomas    |

	-- Issues in UNF:
		-- Customer name and email are stored together — redundancy if a customer rents multiple times.
		-- Film title is repeated for each inventory item.
		-- Staff name is denormalized (if same staff handles many rentals).
		-- Non-atomic values possible (e.g., combining full names).

	-- Step 1: First Normal Form (1NF)
	-- Goal of 1NF:
		-- Remove repeating groups and ensure atomic values.
		-- Separate multivalued or composite fields.
	-- Fixes:
		-- Separate names into first_name and last_name (atomic).
		-- Ensure each row contains single values (no lists or grouped fields).
		-- Each field should represent one piece of information.

	-- 1NF Table: rental_1nf
| rental\_id | rental\_date     | return\_date     | customer\_id | inventory\_id | staff\_id |
| ---------- | ---------------- | ---------------- | ------------ | ------------- | --------- |
| 1          | 2025-09-20 14:00 | 2025-09-21 14:00 | 1            | 100           | 2         |
| 2          | 2025-09-21 10:30 | 2025-09-22 11:00 | 2            | 105           | 3         |

	-- All related information (customer name, film title, staff name) is now stored in separate related tables (e.g., customer, film, staff).
	-- The rental table only stores IDs (foreign keys).

	-- Supporting Tables (Normalized): (customer)
| customer\_id | first\_name | last\_name | email                                               |
| ------------ | ----------- | ---------- | --------------------------------------------------- |
| 1            | John        | Smith      | [john.smith@email.com](mailto:john.smith@email.com) |
| 2            | Mary        | Jones      | [mary.jones@email.com](mailto:mary.jones@email.com) |

	-- staff
| staff\_id | first\_name | last\_name |
| --------- | ----------- | ---------- |
| 2         | Alice       | Johnson    |
| 3         | Bob         | Thomas     |

	-- inventory
| inventory\_id | film\_id |
| ------------- | -------- |
| 100           | 1        |
| 105           | 2        |

	-- film
| film\_id | title      |
| -------- | ---------- |
| 1        | The Matrix |
| 2        | Inception  |

	-- Step 2: Second Normal Form (2NF)
	-- Goal of 2NF:
		-- Ensure the table is in 1NF.
		-- Remove partial dependencies — every non-key attribute must depend on the whole primary key, not just part of it.
	-- Does our rental table violate 2NF?
		-- Let’s say the primary key of rental is rental_id (a single-column PK) → then no partial dependencies exist, so it already satisfies 2NF.
		-- But if (hypothetically) we had a composite key — say: (customer_id, inventory_id) — then we'd need to check:

	-- Hypothetical Composite PK: (customer_id, inventory_id)
| customer\_id | inventory\_id | rental\_date | return\_date | staff\_id |
| ------------ | ------------- | ------------ | ------------ | --------- |

	-- If staff_id only depends on inventory_id, not the whole composite key → partial dependency → violates 2NF.

	-- Use a surrogate primary key: rental_id
	-- Keep foreign keys (customer_id, inventory_id, staff_id) referencing external tables.
	-- All non-key attributes (rental and return dates) depend fully on the single primary key (rental_id).

	-- Final 2NF Table: rental
| rental\_id | rental\_date     | return\_date     | customer\_id | inventory\_id | staff\_id |
| ---------- | ---------------- | ---------------- | ------------ | ------------- | --------- |
| 1          | 2025-09-20 14:00 | 2025-09-21 14:00 | 1            | 100           | 2         |
| 2          | 2025-09-21 10:30 | 2025-09-22 11:00 | 2            | 105           | 3         |

	-- Now:
		-- 1NF: Atomic, no repeating groups.
		-- 2NF: All non-key attributes depend on full primary key (rental_id).


-- 5. CTE Basics:
-- a. Write a query using a CTE to retrieve the distinct list of actor names and the number of 
-- films they have acted in from the actor and film_actor tables.

-- Ans ->

	-- Goal:
		-- Get each actor’s full name.
		-- Count the number of films they've appeared in.
		-- Use a CTE to organize the query.

	-- CTE Query:
WITH actor_film_counts AS (
    SELECT
        fa.actor_id,
        COUNT(fa.film_id) AS film_count
    FROM
        film_actor fa
    GROUP BY
        fa.actor_id
)
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    afc.film_count
FROM
    actor a
JOIN
    actor_film_counts afc ON a.actor_id = afc.actor_id
ORDER BY
    afc.film_count DESC;

	-- Explanation:
		-- CTE (actor_film_counts):
			-- Groups by actor_id and counts the number of films (film_id) for each actor in film_actor.
		-- Main Query:
			-- Joins actor with the CTE on actor_id to get actor names.
			-- Returns actor_id, first_name, last_name, and film_count.
		-- ORDER BY:
			-- Sorts by the number of films in descending order.


-- 6. CTE with Joins:
-- a. Create a CTE that combines information from the film and language 
-- tables to display the film title, language name, and rental rate.

-- Ans ->

	-- Goal:
		-- Use a CTE to:
		-- Join film and language tables.
	-- Display:
		-- film.title
		-- language.name (i.e. language of the film)
		-- film.rental_rate

	-- CTE Query with Join:
WITH film_language_info AS (
    SELECT
        f.film_id,
        f.title,
        l.name AS language_name,
        f.rental_rate
    FROM
        film f
    JOIN
        language l ON f.language_id = l.language_id
)
SELECT
    title,
    language_name,
    rental_rate
FROM
    film_language_info
ORDER BY
    title;

	-- Explanation:
		-- CTE (film_language_info):
			-- Joins the film table with the language table using language_id.
			-- Selects the desired fields: title, language_name, and rental_rate.
		-- Main Query:
			-- Pulls data from the CTE and orders it alphabetically by film title.


-- 7. CTE for Aggregation:
-- a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) 
-- from the customer and payment tables.
 
 -- Ans ->

	-- Goal:
		-- Use a CTE to:
			-- Join customer and payment tables.
			-- Aggregate (SUM) the total amount each customer has paid.
			-- Display:
				-- Customer’s full name.
				-- Total revenue (sum of payments).
	-- CTE Aggregation Query:
WITH customer_revenue AS (
    SELECT
        p.customer_id,
        SUM(p.amount) AS total_revenue
    FROM
        payment p
    GROUP BY
        p.customer_id
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cr.total_revenue
FROM
    customer c
JOIN
    customer_revenue cr ON c.customer_id = cr.customer_id
ORDER BY
    cr.total_revenue DESC;

	-- Explanation:
		-- CTE (customer_revenue):
			-- Groups the payment table by customer_id.
			-- Calculates the SUM(amount) as total_revenue.
		-- Main Query:
			-- Joins customer with the CTE to get the customer’s name and total revenue.
			-- Orders results by total_revenue in descending order.


-- 8. CTE with Window Functions:
-- a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.

-- Ans ->

	-- Goal:
		-- Use a CTE to:
			-- Rank films based on the rental_duration column.
			-- Display:
				-- Film title
				-- rental_duration
				-- RANK or DENSE_RANK (window function)

	-- CTE Query with Window Function:
WITH ranked_films AS (
    SELECT
        film_id,
        title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS rental_rank
    FROM
        film
)

SELECT
    title,
    rental_duration,
    rental_rank
FROM
    ranked_films
ORDER BY
    rental_rank, title;

	-- Explanation:
		-- CTE (ranked_films):
			-- Selects each film and computes a RANK() based on rental_duration, highest first.
			-- RANK() assigns the same rank to films with the same rental duration, skipping the next number(s).
				-- You can use DENSE_RANK() if you want sequential ranking with no gaps.
		-- Main Query:
			-- Retrieves film title, duration, and rank.
			-- Ordered by rank and title for readability.


-- 9. CTE and Filtering:
-- a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the 
-- customer table to retrieve additional customer details.

-- Ans ->

	-- Goal:
		-- Use rental table to count how many rentals each customer has made.
		-- Filter to customers with more than 2 rentals.
		-- Join with customer table to show names and other details.

	-- CTE Query with Filtering and Join:
WITH frequent_customers AS (
    SELECT
        customer_id,
        COUNT(rental_id) AS rental_count
    FROM
        rental
    GROUP BY
        customer_id
    HAVING
        COUNT(rental_id) > 2
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    fc.rental_count
FROM
    customer c
JOIN
    frequent_customers fc ON c.customer_id = fc.customer_id
ORDER BY
    fc.rental_count DESC;

	-- Explanation:
		-- CTE (frequent_customers):
			-- Groups the rental table by customer_id.
			-- Counts the number of rentals.
			-- Filters with HAVING COUNT(...) > 2.
		-- Main Query:
			-- Joins the CTE with the customer table to retrieve:
				-- First and last name
				-- Email
				-- Rental count
			-- Ordered by rental activity (most active first).


-- 10. CTE for Date Calculations:
--  a. Write a query using a CTE to find the total number of rentals made each month, considering the 
-- rental_date from the rental table.

-- Ans ->

	-- Goal:
		-- Use a CTE to extract the month and year from rental_date.
		-- Count the number of rentals per month.
		-- Return a summary with:
			-- Year
			-- Month
			-- Total rentals

	-- SQL Query Using CTE for Monthly Rental Totals:
WITH monthly_rentals AS (
    SELECT
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
        COUNT(*) AS total_rentals
    FROM
        rental
    GROUP BY
        DATE_FORMAT(rental_date, '%Y-%m')
)

SELECT
    rental_month,
    total_rentals
FROM
    monthly_rentals
ORDER BY
    rental_month;

	-- Explanation:
		-- DATE_FORMAT(rental_date, '%Y-%m'):
			-- Extracts the year and month in YYYY-MM format.
		-- COUNT(*):
			-- Counts the number of rentals per month.
		-- CTE monthly_rentals:
			-- Organizes the monthly totals.
		-- Main query:
			-- Selects and orders the results by rental_month.

	-- Alternate (with separate year and month columns):
WITH monthly_rentals AS (
    SELECT
        YEAR(rental_date) AS rental_year,
        MONTH(rental_date) AS rental_month,
        COUNT(*) AS total_rentals
    FROM
        rental
    GROUP BY
        YEAR(rental_date), MONTH(rental_date)
)

SELECT
    rental_year,
    rental_month,
    total_rentals
FROM
    monthly_rentals
ORDER BY
    rental_year, rental_month;


-- 11. CTE and Self-Join:
-- a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film 
-- together, using the film_actor table.

-- Ans ->

	-- Goal:
		-- Find distinct pairs of actors who acted in the same film.
		-- Avoid duplicate and reversed pairs (e.g., (A, B) and (B, A)).
		-- Return:
			-- film_id
			-- actor_1_id
			-- actor_2_id

	-- CTE Query with Self-Join:
WITH actor_pairs AS (
    SELECT
        fa1.film_id,
        fa1.actor_id AS actor_1_id,
        fa2.actor_id AS actor_2_id
    FROM
        film_actor fa1
    JOIN
        film_actor fa2 ON fa1.film_id = fa2.film_id
    WHERE
        fa1.actor_id < fa2.actor_id  -- avoid duplicates and self-pairs
)

SELECT
    ap.film_id,
    a1.first_name || ' ' || a1.last_name AS actor_1_name,
    a2.first_name || ' ' || a2.last_name AS actor_2_name
FROM
    actor_pairs ap
JOIN
    actor a1 ON ap.actor_1_id = a1.actor_id
JOIN
    actor a2 ON ap.actor_2_id = a2.actor_id
ORDER BY
    ap.film_id,
    actor_1_name,
    actor_2_name;

	-- Explanation:
		-- CTE actor_pairs:
			-- Performs a self-join on film_actor to find actors in the same film.
			-- Uses fa1.actor_id < fa2.actor_id to:
				-- Eliminate self-pairs (e.g., actor pairing with themselves).
				-- Avoid duplicates (e.g., (1,2) vs (2,1)).
		-- Main Query:
			-- Joins the actor names from the actor table.
			-- Displays human-readable output.


-- 12. CTE for Recursive Search:
--  a. Implement a recursive CTE to find all employees in the staff table who report to a 
-- specific manager, considering the reports_to column

-- Ans ->

	-- Goal:
		-- Use a recursive CTE to:
			-- Start from a specific manager (e.g., staff_id = 1)
			-- Recursively find all employees who report up to them through the reports_to chain

	-- Recursive CTE Query:
WITH RECURSIVE staff_hierarchy AS (
    -- Anchor member: select the manager
    SELECT
        staff_id,
        first_name,
        last_name,
        reports_to
    FROM
        staff
    WHERE
        staff_id = 1  -- 👈 Change this to the target manager's ID

    UNION ALL

    -- Recursive member: find staff who report to the previous level
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.reports_to
    FROM
        staff s
    INNER JOIN
        staff_hierarchy sh ON s.reports_to = sh.staff_id
)

SELECT
    *
FROM
    staff_hierarchy
WHERE
    staff_id != 1  -- Exclude the original manager (optional)
ORDER BY
    reports_to, staff_id;

	-- Explanation:
		-- Anchor member:
			-- Selects the top-level manager (staff_id = 1).
		-- Recursive member:
			-- Finds employees who report to the previous level of employees.
		-- The recursion continues until no more subordinates are found.
