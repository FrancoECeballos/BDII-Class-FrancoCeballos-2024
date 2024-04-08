USE sakila;

-- Query 1
SELECT f.title AS 'Título', f.special_features AS 'Special Features'
FROM film f
WHERE f.rating = 'PG-13';

-- Query 2
SELECT f.title AS 'Título', f.`length` AS 'Duración'
FROM film f;

-- Query 3
SELECT f.title AS 'Título', f.rental_rate, f.replacement_cost
FROM film f
WHERE f.replacement_cost BETWEEN 20.00 AND 24.00;

-- Query 4
SELECT f.title AS 'Título', c.`name` AS 'Categoría', f.rating AS 'Rating'
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE f.special_features LIKE '%Behind the Scenes%';

-- Query 5
SELECT a.first_name AS 'Nombre', a.last_name AS 'Apellido', f.title AS 'Pelicula'
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'ZOOLANDER FICTION';

-- Query 6
SELECT a.address AS 'Dirección', ci.city AS 'Ciudad', co.country AS 'País'
FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
WHERE s.store_id = 1;

-- Query 7
SELECT f1.title AS 'Título 1', f2.title AS 'Título 2', f1.rating AS 'Rating'
FROM film f1, film f2
WHERE f1.rating = f2.rating
AND f1.film_id > f2.film_id;

-- Query 8
SELECT f.title AS 'Título', stf.first_name AS 'Nombre Manager', stf.last_name AS 'Apellido Manager'
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN staff stf ON s.manager_staff_id = stf.staff_id
WHERE s.store_id = 2;