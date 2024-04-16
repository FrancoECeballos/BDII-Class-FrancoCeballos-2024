USE sakila;

-- Query 1
SELECT f.title AS 'Título', f.rating AS 'Rating', f.`length` AS 'Duración'
FROM film f
WHERE f.`length` <= ALL (SELECT `length` FROM film);

-- Query 2
SELECT f.title AS 'Título', f.`length` AS 'Duración'
FROM film f
WHERE f.`length` < ALL (SELECT `length` FROM film);

-- Query 3
SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', a.address AS 'Dirección', p.amount AS 'Cantidad'
FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id
INNER JOIN address a ON c.address_id = a.address_id
WHERE p.amount <= ALL (SELECT p2.amount FROM payment p2 INNER JOIN customer c2 ON p2.customer_id = c2.customer_id WHERE c.customer_id != c2.customer_id);