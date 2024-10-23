USE sakila;

-- Query 1 : Generar un reporte que muestre los títulos de las películas que tienen una duración mayor que la duración de al menos una película en la categoría 'Action'.  

SELECT f.title AS 'Título', f.length AS 'Duración' FROM film f
WHERE f.length > ANY (SELECT f2.length FROM film f2
INNER JOIN film_category fc2 USING (film_id)
INNER JOIN category c2 USING (category_id)
WHERE f2.film_id > f.film_id AND c2.name = "Action");

-- Query 2 : Obtener los pares de pagos realizados por un mismo cliente, considerando clientes cuyo nombre NO comienza con una vocal. Mostrar el nombre del cliente y los 2 montos.

SELECT c.first_name AS 'Nombre del Customer', c.last_name AS 'Apellido del Customer', p1.amount AS 'Monto 1', p2.amount AS 'Monto 2' FROM payment p1, payment p2
JOIN customer c USING (customer_id)
WHERE p1.customer_id = p2.customer_id AND p1.payment_id > p2.payment_id
AND c.first_name NOT LIKE 'a%' AND c.first_name NOT LIKE 'e%' AND c.first_name NOT LIKE 'i%' AND c.first_name NOT LIKE 'o%' AND c.first_name NOT LIKE 'u%'
AND c.first_name NOT LIKE 'A%' AND c.first_name NOT LIKE 'E%' AND c.first_name NOT LIKE 'I%' AND c.first_name NOT LIKE 'O%' AND c.first_name NOT LIKE 'U%'
ORDER BY c.first_name;

SELECT * FROM payment p1, payment p2
JOIN customer c USING (customer_id);

-- Query 3 : Mostrar aquellas películas cuya cantidad de actores sea menor al promedio de actores por películas. Además mostrar su cantidad de actores y una lista de los nombres de esos actores.

SELECT f.title AS 'Título', COUNT(fa.actor_id) AS 'Cantidad de Actores', GROUP_CONCAT(' ', a.first_name, ' ', a.last_name) AS 'Actores' FROM film f
INNER JOIN film_actor fa USING (film_id)
INNER JOIN actor a USING (actor_id)
GROUP BY f.film_id
HAVING COUNT(fa.actor_id) < (SELECT AVG(cantActores)
FROM (SELECT COUNT(fa2.actor_id) AS cantActores FROM film f2
INNER JOIN film_actor fa2 USING (film_id) GROUP BY f2.film_id) sub);

-- Query 4 : Listar todas las películas cuya duración no sea la máxima ni la mínima, y además no deben tener a los actores cuyas id's son las siguientes(11,56,45,34,89) y el replacement cost no sea el máximo.

SELECT f.title AS 'Título', f.length AS 'Duración', f.replacement_cost AS 'Costo de Reemplazo' FROM film f
WHERE f.length > ANY (SELECT f2.length FROM film f2 WHERE f2.film_id > f.film_id)
AND f.length < ANY (SELECT f2.length FROM film f2 WHERE f2.film_id > f.film_id)
AND f.replacement_cost < ANY (SELECT f2.replacement_cost FROM film f2 WHERE f2.film_id > f.film_id)
AND f.film_id NOT IN (SELECT fa2.film_id FROM film_actor fa2 WHERE fa2.actor_id IN(11,56,45,34,89))
GROUP BY f.film_id;