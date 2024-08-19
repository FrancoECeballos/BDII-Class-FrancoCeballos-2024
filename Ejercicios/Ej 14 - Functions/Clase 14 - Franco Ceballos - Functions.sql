USE sakila;

-- QUERY 1
-- Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.

SELECT CONCAT(c.first_name, ' ', c.last_name) AS 'Customer', 
CONCAT(a.address, ', ', a.district) AS 'Address', 
CONCAT(ci.city, ', ', co.country) AS 'City' FROM customer c 
INNER JOIN address a USING (address_id)
INNER JOIN city ci USING (city_id) 
INNER JOIN country co USING (country_id)
WHERE co.country = 'Argentina';

-- QUERY 2
-- Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here: 
-- https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.

SELECT f.title AS 'Título', l.name AS 'Lenguaje', CASE f.rating 
WHEN 'G' THEN 'G (General Audiences) – All ages admitted.'
WHEN 'PG' THEN 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.'
WHEN 'PG-13' THEN 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'
WHEN 'R' THEN 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'
WHEN 'NC-17' THEN 'NC-17 (Adults Only) – No one 17 and under admitted.' END AS 'Rating' 
FROM film f INNER JOIN language l USING (language_id);

-- QUERY 3
-- Write a search query that shows all the films (title and release year) an actor was part of. 
-- Assume the actor comes from a text box introduced by hand from a web page. 
-- Make sure to "adjust" the input text to try to find the films as effectively as you think is possible. 

SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'Actor', GROUP_CONCAT(' ', f.title, ' ', f.release_year) AS 'Película'
FROM actor a INNER JOIN film_actor fa USING (actor_id) INNER JOIN film f USING (film_id)
WHERE CONCAT(a.first_name, ' ', a.last_name) LIKE '%%' -- <- Insertar el actor entre los %
GROUP BY a.actor_id; 

-- QUERY 4
-- Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. 
-- There should be returned column with two possible values 'Yes' and 'No'.

SELECT f.title AS 'Título', r.rental_date AS 'Fecha de Renta', CONCAT(c.first_name, ' ', c.last_name) AS 'Customer', IF(r.return_date IS NOT NULL, 'Yes', 'No') AS 'Devuelto'
FROM rental r INNER JOIN inventory i USING (inventory_id) INNER JOIN customer c USING (customer_id) INNER JOIN film f USING (film_id)
WHERE MONTH(r.rental_date) BETWEEN 5 AND 6;

-- QUERY 5
-- Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.

/*
CAST and CONVERT only has one minor difference when using MySQL, and that is its syntax:
CAST(expr AS type) // CONVERT(expr, type)
However, in SQL Server, this isn't the case. While CAST remains the same, CONVERT has an extra 'style' input that allows more formating options.
Another important aspect is that CONVERT can be used in 2 ways. Using the syntax previously mentioned is the same as using CAST, while using it as
CONVERT(expr USING type) converts the character set of a string.
In the end, CAST and CONVERT should be interchangable when operating in MySQL, but this can vary in different sql dialects. 
This means CAST is best when trying to make portable code, while CONVERT can make use of more flexible customization options depending on the dialect.
Here is an example using both:
*/

SELECT CAST(rental_date AS DATE) AS 'Date from CAST' FROM rental; -- Converts datetime field rental_date into a date.
SELECT CONVERT(rental_date, DATE) AS 'Date from CONVERT' FROM rental; -- Same as using CAST


-- QUERY 6
-- Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.

/*
NVL is a function meant check if a value is NULL and replace it with a specified value if it is. However, it is NOT available on MySQL (it is used in Oracle databases)
Syntax: NVL(field, replacement_value), Example: NVL(rental_date, '2005-05-24') <- Would replace rental_date with the given date if it is NULL;

IFNULL serves the same function as NVL, the key difference is that this one IS available in MySQL.
Syntax: IFNULL(field, replacement_value);

ISNULL is different in MySQL than the other two. Instead of replacing a value, it returns 1 if the value is null, and 0 if it isn't.
Syntax: ISNULL(value);

Finally, COALESCE returns the first non-NULL value in a list of expressions. If all the values listed are NULL, it returns NULL aswell This means you must give it a list of
values in the order you wish them to be checked in.
Syntax: COALESCE(value1, value2, value3, value4, value5... );

There is also NULLIF, which compares 2 values and returns NULL if they are equal. If they aren't it returns the first value.
Syntax: NULLIF(value1, value2);
*/

SELECT address AS 'Address', IFNULL(address2, 'Esta dirección no tiene address 2') FROM address; -- Some address2 are ''
SELECT address AS 'Address', ISNULL(address2) AS 'Any NULL return dates?' FROM address;
SELECT COALESCE(address2, address) AS 'Address' FROM address; -- This will return the address if address2 is null becouse of the order of the syntax
SELECT NULLIF(c.first_name, s.first_name) AS 'Customer name' -- Returns customer name if the customer and the staff don't have the same name
FROM rental r INNER JOIN customer c USING (customer_id) INNER JOIN staff s USING (staff_id);