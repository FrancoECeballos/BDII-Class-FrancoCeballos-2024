USE sakila;

-- QUERY 1
-- Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.

DELIMITER //
	CREATE PROCEDURE FetchFilmsFromStore(IN titleOrID VARCHAR(50), IN storeID INT, OUT total INT)
    BEGIN
		SELECT COUNT(i.film_id) INTO total FROM inventory i INNER JOIN film f USING (film_id) 
        WHERE i.store_id = storeID AND (i.film_id = titleOrID OR f.title = titleOrID) GROUP BY f.film_id;
	END //
DELIMITER ;

CALL FetchFilmsFromStore('ACE GOLDFINGER', 1, @total);
SELECT @total;

-- QUERY 2
-- Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. 
-- You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS).

DELIMITER //
	CREATE PROCEDURE FetchCustomerListInCountry(IN countryNameOrID VARCHAR(50), OUT customerList VARCHAR(5000))
    BEGIN
		DECLARE finished INT DEFAULT 0;
        DECLARE customerInfo VARCHAR(100) DEFAULT "";
    
		DECLARE customer_cursor CURSOR FOR
			SELECT CONCAT(c.first_name, ' ', c.last_name) FROM customer c INNER JOIN address a USING (address_id) 
            INNER JOIN city ci USING (city_id) INNER JOIN country co USING (country_id) WHERE co.country_id = countryNameOrID OR co.country = countryNameOrID;
		
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
		
        SET customerList = "";
        
        OPEN customer_cursor;
        
        get_customer_info: LOOP
			FETCH customer_cursor INTO customerInfo;
            
            IF finished = 1 THEN
				LEAVE get_customer_info;
			END IF;
            
            SET customerList = CONCAT(customerInfo, '; ', customerList);
		END LOOP get_customer_info;
        
        CLOSE customer_cursor;
	END //
DELIMITER ;

CALL FetchCustomerListInCountry(2, @customerList);
SELECT @customerList;

-- QUERY 3
-- Review the function inventory_in_stock and the procedure film_in_stock explain the code, write usage examples.

/*
The function inventory_in_stock is designed to check whether a specific item in the store's inventory is available (in stock). 
It works as follows: An inventory_id is passed as a parameter. The first step checks whether any rentals have been made for that item by counting the rows in the rental table 
that match the given inventory_id. If no rentals are found, the function returns TRUE, indicating that the item is in stock. If rentals exist, the function proceeds to the next step. 
In this second step, the function checks whether any of the rows in the rental table for this item have a return_date that is still NULL. It counts how many rentals lack a return date 
(meaning they have not been returned). If the count is zero, meaning all rentals have been returned, the function returns TRUE, as the item is now back in stock. 
If at least one return_date is still NULL, the function returns FALSE, meaning the item is still out on rent.

The procedure film_in_stock has a similar purpose, but instead of checking one item, it returns the total number of copies of a particular film that are available in a specific store. 
The procedure takes two input parameters: p_film_id and p_store_id. The procedure works in two parts: First, it retrieves the inventory_id for all items in 
the inventory table that match the provided film_id and store_id and are currently available for rent. Availability is checked using the inventory_in_stock function explained earlier. 
Second, it counts the number of available film copies (those that passed the inventory_in_stock check) and stores the result in the p_film_count variable, which is returned to indicate 
how many copies of the film are available for rent in that store.
*/