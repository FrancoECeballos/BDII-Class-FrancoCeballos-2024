USE sakila;

-- Query 1
SELECT a1.first_name AS 'Nombre Compartido', a1.last_name AS 'Apellido 1', a2.last_name AS 'Apellido 2', 
(SELECT f.title FROM film f WHERE 
a1.actor_id IN (SELECT fa.actor_id FROM film_actor fa WHERE f.film_id = fa.film_id)
AND a2.actor_id IN (SELECT fa.actor_id FROM film_actor fa WHERE f.film_id = fa.film_id)) AS 'Peliculas Compartidas' 
FROM actor a1, actor a2
WHERE a1.first_name = a2.first_name AND a1.actor_id > a2.actor_id 
AND (a1.first_name LIKE 'a%' OR a1.first_name LIKE 'e%' OR a1.first_name LIKE 'i%' OR a1.first_name LIKE 'o%' OR a1.first_name LIKE 'u%');

-- Query 2
SELECT f.title AS 'Título', COUNT(fa.actor_id) AS 'Cantidad Actores', 
GROUP_CONCAT(a.first_name, ' ', a.last_name) AS 'Actores' FROM film f
INNER JOIN film_actor fa USING (film_id)
INNER JOIN actor a USING (actor_id)
GROUP BY f.title
HAVING COUNT(fa.actor_id) > (SELECT AVG(cantActores) FROM 
(SELECT COUNT(fa2.actor_id) AS cantActores FROM film f2 
INNER JOIN film_actor fa2 USING (film_id) GROUP BY f2.title) subquery);

-- Query 3
SELECT stf.first_name AS 'Nombre', stf.last_name AS 'Apellido', s.store_id AS 'Tienda', COUNT(p.payment_id) AS 'Cantidad de Ventas', SUM(p.amount) AS 'Sumatoria de Ventas',
MAX(p.amount) AS 'Venta Máxima', MIN(p.amount) AS 'Venta Mínima',

(SELECT COUNT(p2.payment_id) FROM staff stf2
INNER JOIN payment p2 USING (staff_id)
WHERE p2.amount >= ALL (SELECT p3.amount FROM staff stf3
INNER JOIN payment p3 USING (staff_id)
WHERE YEAR(p2.payment_date) = 2006
AND stf3.staff_id = stf2.staff_id)
AND YEAR(p2.payment_date) = 2006
AND stf2.staff_id = stf.staff_id) AS 'Cantidad de Ventas Máximas Repetidas',

(SELECT COUNT(p2.payment_id) FROM staff stf2
INNER JOIN payment p2 USING (staff_id)
WHERE p2.amount <= ALL (SELECT p3.amount FROM staff stf3
INNER JOIN payment p3 USING (staff_id)
WHERE YEAR(p2.payment_date) = 2006
AND stf3.staff_id = stf2.staff_id)
AND YEAR(p2.payment_date) = 2006
AND stf2.staff_id = stf.staff_id) AS 'Cantidad de Ventas Mínimas Repetidas',

GROUP_CONCAT( ' ', f.title, ' $', p.amount, ' ', r.rental_date) AS 'Títulos'
FROM staff stf
INNER JOIN store s USING (store_id)
INNER JOIN payment p USING (staff_id)
INNER JOIN rental r USING (rental_id)
INNER JOIN inventory i USING (inventory_id)
INNER JOIN film f USING (film_id)
WHERE YEAR(p.payment_date) = 2006
GROUP BY stf.staff_id;