USE sakila;

-- Query 1: Add a new customer
--   To store 1
--   For address use an existing address. The one that has the biggest address_id in 'United States'


INSERT INTO customer (store_id, first_name, last_name, email, address_id, create_date) VALUES
(1, 'Javier', 'Lamberto', 'javilam@gmail.com', 
(SELECT MAX(a.address_id) FROM address a 
INNER JOIN city ci USING (city_id) 
INNER JOIN country co USING (country_id)
WHERE co.country = 'United States'), 
NOW());
-- Created ID: 600

-- Query 2: Add a rental
--   Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
--   Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
--   Select any staff_id from Store 2.


INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update) VALUES
(NOW(), 
(SELECT MAX(i.inventory_id) FROM inventory i 
INNER JOIN film f USING (film_id) 
WHERE i.store_id = 2
AND f.title = 'MODEL FISH'), -- Ingrese el título de la película que quiera rentar
(SELECT customer_id FROM customer c
WHERE first_name = 'Javier' AND last_name = 'Lamberto' AND email = 'javilam@gmail.com'), -- Customer es el que se creó anteriormente
DATE_ADD(NOW(), INTERVAL 1 MONTH), -- Return date es un mes despues de la fecha de renta
(SELECT s.staff_id FROM staff s WHERE s.store_id = 2 ORDER BY RAND() LIMIT 1), -- Seleccióna un staff aleatorio de la store 2
NOW());
-- Created ID: 16050

-- Query 3: Update film year based on the rating
--   For example if rating is 'G' release date will be '2001'
--   You can choose the mapping between rating and year.
--   Write as many statements are needed.


UPDATE film SET
release_year = 2001
WHERE rating = 'G';

UPDATE film SET
release_year = 2005
WHERE rating = 'PG';

UPDATE film SET
release_year = 2012
WHERE rating = 'PG-13';

UPDATE film SET
release_year = 2017
WHERE rating = 'R';

UPDATE film SET
release_year = 2020
WHERE rating = 'NC-17';

-- Query 4: Return a film
--   Write the necessary statements and queries for the following steps.
--   Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
--   Use the id to return the film.


UPDATE rental SET 
return_date = NOW()
WHERE rental_id = (SELECT MAX(rental_id) WHERE rental_date = 
(SELECT MAX(rental_date) WHERE return_date IS null));
-- Updated ID: 15966

-- Query 5: Try to delete a film
--   Check what happens, describe what to do.
--   Write all the necessary delete statements to entirely remove the film from the DB.


DELETE FROM film 
WHERE film_id = 1000;
/* Response: Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails 
(`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE) */

-- NUEVO ORDEN: Se pueden borrar las filas de la tabla film_actor y film_category que tienen como film_id 1000 (o el id de la tabla que querramos borrar)
DELETE FROM film_actor
WHERE film_id = 1000;

DELETE FROM film_category
WHERE film_id = 1000;

-- Despues tenemos que borrar inventory, pero para ello debemos borrar todas las rentas que dependen de los inventarios de las películas selecionadas
DELETE FROM rental
WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = 1000);

DELETE FROM inventory
WHERE film_id = 1000;

-- Finalmente, podemos borrar la film
DELETE FROM film 
WHERE film_id = 1000;

-- Query 6: Rent a film
--   Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
--   Add a rental entry
--   Add a payment entry
--   Use sub-queries for everything, except for the inventory id that can be used directly in the queries.


SELECT * FROM inventory LEFT JOIN rental USING (inventory_id) WHERE rental_id IS null LIMIT 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update) VALUES
(NOW(), 5, (SELECT customer_id FROM customer ORDER BY RAND() LIMIT 1), DATE_ADD(NOW(), INTERVAL 1 MONTH),
(SELECT staff_id FROM staff WHERE store_id = (SELECT store_id FROM inventory  WHERE inventory_id = 5) ORDER BY RAND() LIMIT 1), NOW());

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date, last_update) VALUES
((SELECT customer_id FROM rental WHERE inventory_id = 5), (SELECT staff_id FROM rental WHERE inventory_id = 5), (SELECT rental_id FROM rental WHERE inventory_id = 5),
3.99, DATE_ADD((SELECT rental_date FROM rental WHERE inventory_id = 5), INTERVAL 1 DAY), NOW());

SELECT * FROM rental WHERE inventory_id = 5;
SELECT * FROM payment WHERE rental_id = 16050;