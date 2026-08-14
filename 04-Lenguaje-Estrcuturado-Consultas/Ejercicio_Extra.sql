-- Seleccionar la Base de Datos
USE Northwind;

-- Mostra los clientes de Mexico y Alemania y ademas que sean solo sean de Stugart 
SELECT 
	c.CustomerID,
	c.CompanyName,
	c.Region,
	c.City,
	c.Country
FROM Customers AS c
WHERE c.Country = 'Mexico'
	  OR
	  c.Country = 'Germany'
	  AND
	  c.City = 'Stuttgart';


	  SELECT 
	c.CustomerID,
	c.CompanyName,
	c.Region,
	c.City,
	c.Country
FROM Customers AS c
WHERE c.Country IN ('Mexico', 'Germany')
	  OR c.city = 'Stuttgart';

-- MOSTRTAR LAS VENTAS REALIZADAS EN FRANCIA, BRAZIL Y BELGICA
-- DL 10 DE JULIO DE 1996 A 31 DE DICIEMBRE DEL DE 1998, PÈRO QUE TENGAN REGION DE ENVIO
-- PARA LOS CLIENTES VICTE, HANAR Y SUPRD, YORDENADOS POR FECHA DE PEDIDO DE LAS MAS CERCANA A LA MAS LEJANA

SELECT
	o.OrderID AS [numero_orden],
	o.CustomerID AS [cliente],
	o.ShipCountry AS [pais_envio],
	o.OrderDate AS [fecha_pedido],
	UPPER(FORMAT(o.OrderDate, 'MMMM', 'es-ES')) AS [mes_pedido],
	UPPER(FORMAT(o.OrderDate, 'dddd', 'es-ES')) AS [dia_pedido],
	DATEPART(YEAR, o.OrderDate) AS [año_pedido]
FROM Orders AS o
WHERE O.ShipCountry IN ('France', 'Brazil', 'Belgium')
	  AND 
	  o.OrderDate BETWEEN '1996-07-10' AND '1998-12-31'
	  AND o.ShipRegion IS NOT NULL
	  AND
	  o.CustomerID IN ('VICTE', 'HANAR', 'SUPRD')
ORDER BY o.OrderDate DESC;