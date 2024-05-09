USE sakila;

-- Query 1
SELECT f.title AS 'Título', f.rating AS 'Rating', f.`length` AS 'Duración'
FROM film f
WHERE f.`length` <= ALL (SELECT `length` FROM film);

-- Query 2
SELECT f.title AS 'Título', f.`length` AS 'Duración'
FROM film f
WHERE f.`length` < ALL (SELECT `length` FROM film);

-- Query 3 (ALL)
SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', a1.address AS 'Dirección Cliente', a2.address AS 'Dirección Tienda', p.amount AS 'Cantidad', f.title AS 'Película'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN address a2 ON s.address_id = a2.address_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN address a1 ON c.address_id = a1.address_id
WHERE p.amount <= ALL (SELECT p2.amount FROM customer c2 INNER JOIN payment p2 ON c2.customer_id = p2.customer_id WHERE c.customer_id = c2.customer_id)
ORDER BY c.first_name;

-- Query 3 (ANY)
SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', a1.address AS 'Dirección Cliente', a2.address AS 'Dirección Tienda', p.amount AS 'Cantidad', f.title AS 'Película'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN address a2 ON s.address_id = a2.address_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN address a1 ON c.address_id = a1.address_id
WHERE p.amount = ANY (SELECT MIN(p2.amount) FROM customer c2 INNER JOIN payment p2 ON c2.customer_id = p2.customer_id WHERE c.customer_id = c2.customer_id)
ORDER BY c.first_name;

-- Query 4
SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', MAX(p.amount) AS 'Cantidad Máxima', MIN(p.amount) AS 'Cantidad Máxima'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;