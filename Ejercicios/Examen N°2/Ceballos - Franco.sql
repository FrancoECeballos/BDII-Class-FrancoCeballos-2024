USE northwind;

-- QUERY 1

CREATE OR REPLACE VIEW order_annual_inform AS 

	SELECT sub.ShipVia AS 'ShipVia', sub.CategoryName AS 'Categoría', COUNT(sub.OrderID) AS 'Cantidad de Ordenes', SUM(sub.Quantity) AS 'Cantidad de Productos',
	SUM(sub.UnitPrice * (1 - sub.Discount)) AS 'Total Recaudado en el Momento', SUM(sub.CurrentUnitPrice) AS 'Recaudo con precios Actuales', 
    MAX(sub.OrderDate) AS 'Orden más Reciente', MIN(sub.OrderDate) AS 'Orden más Antigua'

	FROM (SELECT o.OrderID, o.OrderDate, o.ShipVia, p.ProductName, c.CategoryName, od.Quantity, p.QuantityPerUnit, od.UnitPrice AS UnitPrice, od.Discount, p.UnitPrice AS CurrentUnitPrice
	FROM Orders o INNER JOIN OrderDetails od USING (OrderID) INNER JOIN Products p USING (ProductID) INNER JOIN Categories c USING (CategoryID) 
	WHERE o.OrderDate >= (SELECT MAX(orderDate) - 10000000000 FROM Orders) ORDER BY OrderDate) sub
    
	GROUP BY sub.ShipVia, sub.CategoryName
	HAVING (SUM(sub.CurrentUnitPrice) - SUM(sub.UnitPrice * (1 - sub.Discount))) > 4000
    ORDER BY sub.ShipVia;

SELECT * FROM order_annual_inform;

-- QUERY 2

DELIMITER // 
	DROP PROCEDURE IF EXISTS EmpleadosEnCiudad;
	CREATE PROCEDURE IF NOT EXISTS EmpleadosEnCiudad(IN nombreCiudad VARCHAR(50), OUT listaEmpleados TEXT)
	BEGIN
		DECLARE empleado VARCHAR(50) DEFAULT "";
        DECLARE done BOOLEAN DEFAULT FALSE;
        
        DECLARE cursor_empleados CURSOR FOR
        SELECT CONCAT(e.FirstName, ' ', e.LastName) FROM Employees e WHERE e.City = nombreCiudad;
        
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        SET listaEmpleados = "LISTA DE EMPLEADOS";
        
        OPEN cursor_empleados;
        
			loop_empleados : LOOP
				FETCH cursor_empleados INTO empleado;
        
				IF done THEN
					LEAVE loop_empleados;
				END IF;
        
				SET listaEmpleados = CONCAT(listaEmpleados, '; ', empleado);
			END LOOP loop_empleados;
        
        CLOSE cursor_empleados; 
    END
// DELIMITER ;

CALL EmpleadosEnCiudad('London',@listaEmpleados);
SELECT @listaEmpleados;

-- QUERY 3

ALTER TABLE Orders ADD COLUMN lastModification DATETIME DEFAULT NOW();
ALTER TABLE Orders ADD COLUMN lastModifierUser VARCHAR(50);

DELIMITER //
CREATE TRIGGER before_orders_update BEFORE UPDATE ON Orders FOR EACH ROW
BEGIN
	SET NEW.lastModification = NOW();
    SET NEW.lastModifierUser = USER();
    IF NEW.ShipVia = 1 THEN
		SET NEW.ShippedDate = NOW();
	END IF;
END;

CREATE TRIGGER before_orders_insert BEFORE INSERT ON Orders FOR EACH ROW
BEGIN
	SET NEW.lastModification = NOW();
    SET NEW.lastModifierUser = USER();
    IF NEW.ShipVia = 1 THEN
		SET NEW.ShippedDate = NOW();
	END IF;
END;
// DELIMITER ;

SELECT * FROM Orders;
UPDATE Orders SET ShipVia = 1 WHERE OrderID = 11077;
INSERT INTO Orders(OrderDate) VALUES (NOW());

-- QUERY 4

/*
Los Indexes (índices) en una base de datos son columnas especificadas de una tabla que se guardarán en memoria para aumentar la velocidad de operación y facilitar su filtrado.
Con esto me refiero a que podemos seleccionar una o más columnas de una tabla y crear un Index con ellas (Usamos el comando CREATE INDEX `OrderDate` ON `Orders` (`OrderDate`);
por ejemplo). Este indice permitirá que cualquier operación o query que hagamos con respecto a estas columnas será mucho más rápido y eficiente, ya que estas estarán
cargadas por defecto al iniciar la base de datos y el sistema no tendra que escanear la tabla completa para buscar su información. La información guardada en los Indexes
se actualizará cuando se actualizen las columnas contenidas.

Las indexes pueden ser UNIQUE (No muestran combinaciónes repetidas), SPATIAL (No muestran combinaciónes Nullas) o FULLTEXT (Facilita el manejo de textos grande y permite usar
MATCH / AGAINST). Por defecto, las PRIMARY KEYS de las tablas son tanto UNIQUE como SPATIAL.

Se recomienda usar Indexes para aquellos datos guardados en nuestras tablas que son usados frecuentemente en procedimientos. Esto reducira el tiempo de demora de las queries que 
involucren las columnas almacenadas y hará más eficiente la base de datos. Hay que tener cuidado con crear muchos Indexes, ya que, como ocupan espacio en la memoria, 
tener una gran cantidad de ellas tomara parte de la memoria disponible, lo que puede tener el efecto contrario y realentizar todas las operaciónes. 
También es importante recordar que si usamos muchos Indexes, se tendran que actualizar cada vez que modificamos un valor dentro de las columnas correspondientes, 
lo que realentizará incluso más las operaciones. Debemos priorizar las columnas y tablas que más usamos y asignar los Indexes que veamos necesarias.

Se diferencian de los constraints ya que estos son atributos de las columnas, como NOT NULL que especifica que los valores de esa columna no pueden ser nullos. Los Indexes, por
otra parte, son conjuntos de datos enteros creados a partir de las columnas que especificamos, cada una con sus atributos definidos por sus constraints.

Podemos ver algunos ejemplos de Indexes dentro de la base de datos Northwind, como los siguientes casos:

CREATE INDEX `LastName` ON `Employees` (`LastName`); <- (Crea una constraint llamada `LastName` que guarda la columna LastName de la tabla Employees)
CREATE INDEX `PostalCode` ON `Employees` (`PostalCode`);
*/