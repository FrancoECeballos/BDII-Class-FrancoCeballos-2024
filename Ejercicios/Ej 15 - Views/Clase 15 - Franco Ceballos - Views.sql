USE sakila;

-- QUERY 1
-- Create a view named list_of_customers, it should contain the following columns:
--    customer id
--    customer full name,
--    address
--    zip code
--    phone
--    city
--    country
--    status (when active column is 1 show it as 'active', otherwise is 'inactive')
--    store id

CREATE VIEW list_of_customers AS 
	SELECT cus.customer_id AS 'Customeer ID', CONCAT(cus.first_name, ' ', cus.last_name) AS 'Customer Name',
    a.address AS 'Address', a.postal_code AS 'Zip code', a.phone AS 'Phone', ci.city AS 'City', co.country AS 'Country',
    CASE WHEN cus.active = 1 THEN 'active' ELSE 'inactive' END AS 'Status', cus.store_id AS 'Store ID' 
    FROM customer cus INNER JOIN address a USING (address_id) INNER JOIN city ci USING (city_id) INNER JOIN country co USING (country_id);
    
SELECT * FROM list_of_customers;

-- QUERY 2
-- Create a view named film_details, it should contain the following columns: 
-- film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. 
-- Hint use GROUP_CONCAT

CREATE VIEW film_details AS
	SELECT f.film_id AS 'Film ID', f.title AS 'Title', f.description AS 'Description', cat.name AS 'Category', f.rental_rate AS 'Price',
    f.length AS 'Length', f.rating AS 'Rating', GROUP_CONCAT(' ', a.first_name, ' ', a.last_name) AS 'Actors'
    FROM film f INNER JOIN film_category fc USING (film_id) INNER JOIN category cat USING (category_id) 
    INNER JOIN film_actor fa USING (film_id) INNER JOIN actor a USING (actor_id) GROUP BY f.film_id, cat.name;

SELECT * FROM film_details;
DROP VIEW film_details;

-- QUERY 3
-- Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.

CREATE VIEW sales_by_film_category_the_sequel AS
	SELECT c.name AS 'Category', COUNT(r.rental_id) AS 'Total_rental' 
    FROM category c INNER JOIN film_category USING (category_id) INNER JOIN film f USING (film_id) 
    INNER JOIN inventory i USING (film_id) INNER JOIN rental r USING (inventory_id) GROUP BY c.category_id;
    
SELECT * FROM sales_by_film_category_the_sequel;

-- QUERY 4
-- Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.

CREATE VIEW actor_information AS
	SELECT a.actor_id AS 'Actor ID', a.first_name AS 'Name', a.last_name AS 'Surname', COUNT(fa.film_id) AS 'Films acted'
    FROM actor a INNER JOIN film_actor fa USING (actor_id) GROUP BY a.actor_id;
    
SELECT * FROM actor_information;

-- QUERY 5
-- Analyze view actor_info, explain the entire query and specially how the sub query works. 
-- Be very specific, take some time and decompose each part and give an explanation for each.

SELECT * FROM actor_info;
/*
This view is meant to return information for each actor in the database, along with the films they have participated in, grouped by the film’s category. 
The view selects the actor_id, first_name, last_name, and a field named film_info, which consists of a concatenation of each distinct category and 
a list of all films that are part of that category and in which the actor has appeared. This is achieved using a LEFT JOIN from the actor table to film_actor, 
film_category, and category tables to gather data on the films each actor worked on and their respective categories, ensuring that actors who are not in any film are still included.

The subquery that builds film_info works as follows: First, the outer GROUP_CONCAT joins each distinct category name with the result of the inner subquery, separated by a colon (:). 
The inner subquery returns a GROUP_CONCAT of all film titles (ordered alphabetically and separated by commas) for every film that matches both the category_id of 
the current category (from the film_category table) and the actor_id of the current actor (from the film_actor table). This way, the entire view will return: 
actor_id, actor_name, actor_surname, and a field like [category1: film1, film2..., category2:...] for each actor.
*/

-- QUERY 6
-- Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.

/*
A materialized view is a type of view that stores the result of a query as a physical table on disk. The main difference between this type and regular views is that 
materialized views store the specific result of a query at a given time directly on the disk, instead of being stored virtually and updated dynamically when required. 
This means that the information can be accessed without consuming the resources it would take to fetch the data, which is especially beneficial 
for larger queries with many joins and filters. However, due to the way it is stored, the data in a materialized view will not be updated unless it is manually refreshed, 
so the information might become stale and outdated.

This type of view is useful when you have tables with a large amount of operations—such as joins, aggregations, and filters—that do not need to be updated frequently. 
An example of this would be a periodic report that captures the current state of the database and does not need to be refreshed in real-time.

Some alternatives to materialized views are regular views and indexes. Regular views have the benefit of being updated constantly, but this can cause performance problems. 
Indexes can be used to store specific columns in RAM, which are also updated automatically but have a limited range and decrease performance as more indexes are used.

Some of the DBMS (Database Management Systems) that support materialized views include Oracle, PostgreSQL, Snowflake, and Google’s BigQuery. 
Although MySQL does not natively support materialized views, they can be simulated using regular views and triggers.
*/

