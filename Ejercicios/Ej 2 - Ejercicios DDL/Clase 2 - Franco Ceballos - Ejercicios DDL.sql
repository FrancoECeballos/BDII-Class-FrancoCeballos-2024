DROP DATABASE IF EXISTS imdb;

CREATE DATABASE imdb;

USE imdb;

CREATE TABLE IF NOT EXISTS Film (
	film_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    descript VARCHAR(400),
    release_year YEAR,
	primary key (film_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Actor (
	actor_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
	primary key (actor_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Film_Actor (
	film_id INT,
	actor_id INT,
	primary key (film_id,actor_id)
)ENGINE=INNODB;

ALTER TABLE Film
  ADD last_update date
	AFTER release_year;
    
ALTER TABLE Actor
  ADD last_update date
	AFTER last_name;

ALTER TABLE Film_Actor ADD 
  CONSTRAINT fk_Film_Actor_Film
    FOREIGN KEY (film_id)
    REFERENCES Film (film_id);
    
ALTER TABLE Film_Actor ADD 
  CONSTRAINT fk_Film_Actor_Actor
    FOREIGN KEY (actor_id)
    REFERENCES Actor (actor_id);
    
INSERT INTO Film (title, descript, release_year, last_update) VALUES 
('Shrek','Mujer prefiere casarse con un ogro antes que un petiso','2002','2023-02-13'),
('Cars','Como funciona la anatomía','2006','2023-04-23'),
('Megamente','La sequela nunca existió','2010','2023-05-01'),
('Toy Story','Hoy me voy al soooooooool','1995','2023-06-18');

INSERT INTO Actor (first_name, last_name, last_update) VALUES 
('John','Lithgow','2024-02-15'),
('Owen','Wilson','2023-10-29'),
('Will','Ferrell','2024-01-05'),
('Tim','Allen','2023-09-25');

INSERT INTO Film_Actor (film_id, actor_id) VALUES 
('1','1'),
('2','2'),
('3','3'),
('4','4');

SELECT title AS 'Titulo', descript AS 'Descripción', release_year AS 'Año de Lanzamiento', last_update AS 'Última Actualización' FROM Film;

SELECT first_name AS 'Nombre', last_name AS 'Apellido', last_update AS 'Última Actualización' FROM Actor;

SELECT Film.title AS 'Titulo', Film.descript AS 'Descripción', Actor.first_name AS 'Nombre Actor', Actor.last_name AS 'Apellido Actor' FROM Film_Actor
INNER JOIN Film ON Film_Actor.film_id=Film.film_id
INNER JOIN Actor ON Film_Actor.actor_id=Actor.actor_id;