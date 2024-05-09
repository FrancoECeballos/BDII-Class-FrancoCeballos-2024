USE sakila;

-- Query 1
SELECT co.country_id AS 'Country ID', co.country AS 'Country', COUNT(ci.city_id) AS 'Cantidad Ciudades'
FROM city ci
INNER JOIN country co ON ci.country_id=co.country_id
GROUP BY co.country_id;

-- Query 2
SELECT co.country_id AS 'Country ID', co.country AS 'Country', COUNT(ci.city_id) AS 'Cantidad Ciudades'
FROM city ci
INNER JOIN country co ON ci.country_id=co.country_id
GROUP BY co.country_id
HAVING COUNT(ci.city_id) > 10
ORDER BY COUNT(ci.city_id) DESC;

-- Query 3
SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', a.address AS 'Dirección Cliente', COUNT(r.rental_id) AS 'Cantidad Rentas', SUM(p.amount) AS 'Gasto Total'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN address a ON c.address_id = a.address_id
GROUP BY c.first_name, c.last_name, a.address
ORDER BY SUM(p.amount) DESC;

-- Query 4
SELECT c.`name` AS 'Nombre', AVG(f.`length`)
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
GROUP BY c.`name`
ORDER BY AVG(f.`length`) DESC;

-- Query 5
SELECT f.rating AS 'Rating', SUM(p.amount) AS 'Gasto Total'
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY SUM(p.amount) DESC;