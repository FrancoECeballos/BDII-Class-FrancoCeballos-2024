USE sakila;

-- Query 1
SELECT a1.first_name AS 'Nombre', a1.last_name AS 'Apellido'
FROM actor a1
WHERE EXISTS 
	(SELECT * 
    FROM actor a2 
    WHERE a1.first_name = a2.first_name 
    AND a1.actor_id <> a2.actor_id)
ORDER BY a1.first_name;

-- Query 2
SELECT a.first_name AS 'Nombre', a.last_name AS 'Apellido'
FROM actor a
WHERE a.actor_id NOT IN 
	(SELECT fa.actor_id 
    FROM film_actor fa);
    
-- Query 3
