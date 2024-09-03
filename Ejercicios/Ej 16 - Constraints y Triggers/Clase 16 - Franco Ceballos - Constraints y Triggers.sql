USE sakila;

-- Needs the employee table (defined in the triggers section) created and populated.

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

INSERT INTO `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) VALUES 
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');


-- QUERY 1
-- Insert a new employee to , but with an null email. Explain what happens.

INSERT INTO `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) VALUES
(3856,'Pedro','Leche','x0486',NULL,'1','1002','RH Manager');

/*
This query return the following response: Error Code: 1048. Column 'email' cannot be null.
This is because, when creating the employees table, a NOT NULL constraint was added to the email field to prevent null values from being inserted.
When attempting to, the previously error is thrown and the values are not inserted.
*/

-- QUERY 2
-- Run the first the query
-- What did happen? Explain. Then run this other
-- Explain this case also.

UPDATE employees SET employeeNumber = employeeNumber - 20;
UPDATE employees SET employeeNumber = employeeNumber + 20;

/*
When running the first query, every instance of employeeNumber in employees is decreased by 20. For example, the values of the inserted employees were (1002, 1056, 1076)
and became (982, 1036, 1056) after the query.
When running the second query, the following error is thrown: Error Code: 1062. Duplicate entry '1056' for key 'employees.PRIMARY'
This is because each employeeNumber is increased in the order they were declared in, and the second employee instance is set to 1056, which already exists, before the existing
employeeNumber with that value is increased. Since there cannot be two equal primary key values, the previous error is thrown.
*/

-- QUERY 3
-- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.

ALTER TABLE employees ADD COLUMN age INT(3) CHECK (age >= 16 AND age <= 70);

-- QUERY 4
-- Describe the referential integrity between tables film, actor and film_actor in sakila db.

/*
The film and actor tables exist independently from one another, each with its own ID (film_id and actor_id respectively). 
Since a film can have multiple actors and an actor can be in multiple films, a many-to-many relationship should be established to connect both of them, 
but this is not recommended due to its complexity.

Instead, a detail table (known as a junction table) is created to connect them, which in this case is the film_actor table. 
The film_actor table uses two foreign keys: one referencing film_id from the film table and one referencing actor_id from the actor table. 
These foreign keys must reference an existing, valid record in their respective tables. Both of these keys together form a composite primary key, 
which ensures that each film_actor entry is unique.

The ON DELETE RESTRICT constraint on both foreign keys prevents films and actors from being deleted if a film_actor entry referencing them exists, 
while ON UPDATE CASCADE means that any updates made to the referenced film or actor are also made to film_actor.
*/

-- QUERY 5
-- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. 
-- Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row 
-- (assume multiple users, other than root, can connect to MySQL and change this table).

ALTER TABLE employees ADD COLUMN lastUpdate DATETIME, ADD COLUMN lastMySqlUser VARCHAR(100);
CREATE TRIGGER before_employees_update BEFORE UPDATE ON employees FOR EACH ROW SET NEW.lastUpdate = NOW(), NEW.lastMySqlUser = USER();

-- QUERY 6
-- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.

/*
film_text has 3 triggers related to loading it:

CREATE TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END;;
  
This trigger creates an insert into the film_text table after a film is created taking the values of the newly created
film for its fields. This means after film is inserted, the values of its film_id, title and description will also be used to create
a film_text insert. 


CREATE TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END;;
  
This trigger is very similar to the previous one, except that it works after a film is updated instead of inserted. If a film has is title, description or
film_id modified, the corresponding film_text whose film_id matched the changed film will also recive these modifications.


CREATE TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END;;
  
The final trigger follows similar logic to the previous two. After a film is deleted, the film_text that matched the film's film_id will also be deleted.

These triggers are made to create a film_text whenever a film is inserted using its values. Whenever a film is updated or deleted, the same treatment is being applied
to its corresponding film_text.
*/
