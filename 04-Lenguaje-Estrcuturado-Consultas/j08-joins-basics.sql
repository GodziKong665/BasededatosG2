/*
QUE ES UN JOIN PERMITE 
*/


USE Northwind;

SELECT 
	ProductID AS [numero_producto],
	ProductName AS [nombre_producto],
	UnitPrice AS [precio_producto],
	UnitsInStock AS [existencia],
	p.UnitPrice * p.UnitsInStock AS [valor_inventario],
	c.CategoryID AS [numero_categoria],
	c.CategoryName AS [nombre_categoria],
	s.CompanyName AS [nombre_proovedor]
FROM Products AS p
INNER JOIN
Categories AS c
ON c.CategoryID = p.CategoryID
INNER JOIN Suppliers AS s
ON s.SupplierID = p.SupplierID
WHERE p.UnitsInStock <> 0
AND
c.CategoryName IN ('Seafood', 'Confections', 'Beverages')
AND 
p.ProductName LIKE  'C%'
ORDER BY  [valor_inventario] ASC;


-- Seleccionar los Datos de Los clientes que han hecho pedidos  (orders),
-- mostrados en el numero de cliente el nombre del cliente (CompanyName),
-- Numero de Orden y la fecha de Orden

SELECT
  o.OrderID AS [numero_orden],
  o.OrderDate AS [fecha_orden],
  UPPER(FORMAT(o.OrderDate, 'MMMM', 'es-ES')) AS [mes_orden],
  UPPER(FORMAT(o.OrderDate, 'dddd', 'es-ES')) AS [dia_orden],
  DATEPART(YEAR, o.OrderDate ) AS [año_orden],
  o.CustomerID AS [numero_cliente],
  UPPER(c.CompanyName) AS [nombre_cliente]
FROM Orders AS o
INNER JOIN
Customers AS c
ON c.CustomerID = o.CustomerID;

-- SELECCIONAR ADEMAS DEL CLIENTE AL QUE SE VENDUIERON LOS PRODUCTOS,
-- QUEREMOS SABER EL NOMBRE DEL EMPLEADOR EN FORMATO FULLNAME QUE ATENDIO EL PEDIDO


SELECT
  o.OrderID AS [numero_orden],
  o.OrderDate AS [fecha_orden],
  UPPER(FORMAT(o.OrderDate, 'MMMM', 'es-ES')) AS [mes_orden],
  UPPER(FORMAT(o.OrderDate, 'dddd', 'es-ES')) AS [dia_orden],
  DATEPART(YEAR, o.OrderDate ) AS [año_orden],
  o.CustomerID AS [numero_cliente],
  UPPER(c.CompanyName) AS [nombre_cliente],
  CONCAT (e.FirstName, ' ', e.LastName) AS [nombre_completo]
FROM Orders AS o
INNER JOIN
Customers AS c
ON c.CustomerID = o.CustomerID


SELECT
  o.OrderID AS [numero_orden],
  o.OrderDate AS [fecha_orden],
  UPPER(FORMAT(o.OrderDate, 'MMMM', 'es-ES')) AS [mes_orden],
  UPPER(FORMAT(o.OrderDate, 'dddd', 'es-ES')) AS [dia_orden],
  DATEPART(YEAR, o.OrderDate) AS [año_orden],
  o.CustomerID AS [numero_cliente],
  UPPER(c.CompanyName) AS [nombre_cliente],
  UPPER(CONCAT(e.FirstName, ' ', e.LastName)) AS [nombre_empleado]

FROM Orders AS o
INNER JOIN
Customers AS c ON c.CustomerID = o.CustomerID
INNER JOIN
Employees AS e ON e.EmployeeID = o.EmployeeID;