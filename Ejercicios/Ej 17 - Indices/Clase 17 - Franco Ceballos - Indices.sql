USE sakila;

-- QUERY 1
-- Create two or three queries using address table in sakila db:
--    include postal_code in where (try with in/not it operator)
--    eventually join the table with city/country tables.
--    measure execution time.
--    Then create an index for postal_code on address table.
--    measure execution time again and compare with the previous ones.
--    Explain the results

-- Here are some example queries
SELECT postal_code AS 'Postal Code' FROM address WHERE postal_code IN (SELECT postal_code FROM address WHERE address_id > 500);

SELECT district AS 'District', GROUP_CONCAT('Address: ', address, ' ', address2, ', Postal Code: ', postal_code SEPARATOR ' // ') AS 'Address & Postal Code' FROM address GROUP BY district;

SELECT CONCAT(a.address, ' ', a.address2) AS 'Address', a.postal_code AS 'Postal Code', CONCAT(ci.city, ', ', co.country) AS 'City & Country' FROM address a INNER JOIN city ci USING (city_id) INNER JOIN country co USING (country_id)
WHERE a.postal_code NOT IN (SELECT a.postal_code FROM address a INNER JOIN city ci USING (city_id) INNER JOIN country co USING (country_id) WHERE ci.city NOT LIKE 'A%' AND ci.city NOT LIKE 'E%' AND ci.city NOT LIKE 'I%' AND ci.city NOT LIKE 'O%' AND ci.city NOT LIKE 'U%');

DROP INDEX postal_code ON address;
/*
Durations without Indexes:
Query 1 Duration: 0.00094 sec / 0.000017 sec
Query 2 Duration: 0.0010 sec / 0.00018 sec
Query 3 Duration: 0.0082 sec / 0.000021 sec
*/

CREATE INDEX postal_code ON address(postal_code);
/*
Durations with Indexes:
Query 1 Duration: 0.00066 sec / 0.000016 sec
Query 2 Duration: 0.00093 sec / 0.00018 sec
Query 3 Duration: 0.0061 sec / 0.000021 sec
*/

/*
Indexes in MySQL work by physically storing the row of the indexed tables in the disks storage in order to quickly retrieve the information within. This leads to lower query
durations since it won't be necesary to scan the entire table when getting the information.

Although it is hard to notice, there is an improvement in the queries search and comparison speed, mainly in queries 1 and 3 where postal_code is used for filtering and
comparing. Since these queries are fairly simple, the differences in duration can be rather small. However, in requests of larger scale, the changes in speed will be aparent.
*/

-- QUERY 2
-- Run queries using actor table, searching for first and last name columns independently. 
-- Explain the differences and why is that happening?

SELECT first_name FROM actor WHERE first_name LIKE 'A%';
SELECT last_name FROM actor WHERE last_name LIKE 'A%';

/*
When running these two queries, there is a slightly clearer difference in their execution times compared to the previous activity.
The first query, which fetches each actor's `first_name` (a column that is not indexed), has an average duration of 0.0011 sec / 0.000025 sec,
While the second query, which uses the indexed column `last_name`, has an average duration of 0.00076 sec / 0.000016 sec.

Since the dataset is relatively small, just like in Activity N°1, the difference remains minimal. However, the gap in execution times would become significantly
more pronounced with a larger dataset. This is because `last_name` benefits from the presence of an index, which allows the database to quickly locate rows
that match the criteria, while `first_name` has no index and requires a full scan of each row to find the matching values.

*/

-- QUERY 3
-- Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.

SELECT f.film_id AS 'ID', f.title AS 'Title', f.description AS 'Description Text' FROM film f WHERE f.description LIKE '%Girl%';
SELECT ft.film_id AS 'ID', ft.title AS 'Title', ft.description AS 'Description Text' FROM film_text ft WHERE MATCH(ft.title, ft.description) AGAINST ('Girl');

/*
When comparing these two queries, the most important difference is that the query using MATCH / AGAINST executes faster than the one using LIKE. 
This is because the LIKE operator scans the entire table, checking each description row individually to see if it contains 'Girl', which is inefficient for large text fields. 
On the other hand, MATCH / AGAINST utilizes the FULLTEXT index created in the film_text table to quickly find all matching results without having to scan each row.

This means that, for queries that need to analyze records with large text fields, creating a FULLTEXT index would be ideal to efficiently filter the results, 
while LIKE can still be used for smaller text objects or simple patterns. This means that, depending on the size and type of text data being searched, 
using FULLTEXT indexing can greatly improve performance compared to LIKE.
*/
