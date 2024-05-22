USE sakila;

-- Query 4
SELECT f.title AS 'Título', i.inventory_id AS 'Inventario' FROM film f
LEFT OUTER JOIN inventory i USING (film_id)
WHERE i.inventory_id IS NULL;

-- Query 5
SELECT f.title AS 'Título', i.inventory_id AS 'Inventario', r.rental_id AS 'Renta' FROM film f
INNER JOIN inventory i USING (film_id)
LEFT JOIN rental r USING (inventory_id)
WHERE r.rental_id IS NULL;

-- Query 6
SELECT c.first_name AS 'Nombre Cliente', c.last_name AS 'Apellido Cliente', s.store_id AS 'ID Tienda', r.rental_date AS 'Fecha Renta', r.return_date 'Fecha Devolución', f.title AS 'Título de Película' FROM rental r
INNER JOIN customer c USING (customer_id)
INNER JOIN inventory i USING (inventory_id)
INNER JOIN store s ON c.store_id = s.store_id
INNER JOIN film f ON i.film_id = f.film_id
WHERE r.return_date IS NOT NULL
ORDER BY s.store_id, c.last_name;

-- Query 7
SELECT s.store_id AS 'Tienda', CONCAT(co.country, ', ', ci.city) AS 'Location', CONCAT(stf.first_name, ' ', stf.last_name) AS 'Manager', SUM(p.amount) AS 'Ventas Totales' FROM store s
INNER JOIN inventory i USING (store_id)
INNER JOIN rental r USING (inventory_id)
INNER JOIN payment p USING (rental_id)
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci USING (city_id)
INNER JOIN country co USING (country_id)
INNER JOIN staff stf ON s.manager_staff_id = stf.staff_id
GROUP BY s.store_id;

-- Query 8
SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'Actor', COUNT(f.film_id) AS 'Películas Actuadas' FROM film_actor fa
INNER JOIN actor a USING (actor_id)
INNER JOIN film f USING (film_id)
GROUP BY CONCAT(a.first_name, ' ', a.last_name);