USE sakila;

-- Query 1
SELECT a1.first_name AS 'Nombre', a1.last_name AS 'Apellido'
FROM actor a1
WHERE EXISTS 
	(SELECT * 
    FROM actor a2 
    WHERE a1.last_name = a2.last_name
    AND a1.actor_id <> a2.actor_id)
ORDER BY a1.last_name;

-- Query 2
SELECT a.first_name AS 'Nombre', a.last_name AS 'Apellido'
FROM actor a
WHERE a.actor_id NOT IN 
	(SELECT fa.actor_id 
    FROM film_actor fa);
    
-- Query 3
SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', COUNT(r.customer_id) AS 'Compras'
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY r.customer_id
HAVING COUNT(r.customer_id) = 1;

-- Query 4
SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', COUNT(r.customer_id) AS 'Compras'
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY r.customer_id
HAVING COUNT(r.customer_id) >= 2;

-- Query 5
SELECT a.first_name AS 'Nombre', a.last_name AS 'Apellido', a.actor_id AS 'ID'
FROM actor a
WHERE a.actor_id IN 
(SELECT fa.actor_id FROM film_actor fa 
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE f.title LIKE '%BETRAYED REAR%' OR f.title LIKE '%CATCH AMISTAD%');

-- Query 6
SELECT a.first_name AS 'Nombre', a.last_name AS 'Apellido'
FROM actor a
WHERE a.actor_id IN 
(SELECT fa.actor_id FROM film_actor fa 
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE f.title LIKE '%BETRAYED REAR%') 
AND a.actor_id NOT IN 
(SELECT fa.actor_id FROM film_actor fa 
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE f.title LIKE '%CATCH AMISTAD%');

-- Query 7
SELECT a.first_name AS 'Nombre', a.last_name AS 'Apellido'
FROM actor a
WHERE a.actor_id IN 
(SELECT fa.actor_id FROM film_actor fa 
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE f.title LIKE '%BETRAYED REAR%') 
AND a.actor_id IN 
(SELECT fa.actor_id FROM film_actor fa 
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE f.title LIKE '%CATCH AMISTAD%');

-- Query 8
SELECT a.first_name AS 'Nombre', a.last_name AS 'Apellido'
FROM actor a
WHERE a.actor_id NOT IN 
(SELECT fa.actor_id FROM film_actor fa 
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE f.title LIKE '%BETRAYED REAR%') 
AND a.actor_id NOT IN 
(SELECT fa.actor_id FROM film_actor fa 
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE f.title LIKE '%CATCH AMISTAD%');