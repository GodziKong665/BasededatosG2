/*======================================================
TEMA: filtrado de ejercicios con where
ARCHIVO: 06-filtrado-where.sql
DESCRIPCION: en este tema se 
desarrollara la capacidad de filtrar registros de una tabla mediante el uso de la clausula where
 */

 -- seleccionar filas y columnas 

 -- ORDER DE EJECUCION
 /*====================================
 FROM/JOIN
 WHERE
 GROUP BY
 HAVING
 SELECT
 DISTINCT
 ORDER BY
 TOP
 ========================================*/

  -- ORDER DE ESCRITURA DIAGRAMA SINTACTICO
 /*====================================
 SELECT / TOP
 FROM / JOIN
 WHERE
 GROUP BY
 HAVING
 ORDER BY
 
 ========================================*/


 select
 codigo,
 nombre,
 precio
 from productos
 WHERE( precio > 400);

 -- monstrar el producto cuyo precio esexactamente 200

 SELECT
 p.codigo as [CODIGO],
 p.nombre,
 p.precio
 FROM productos AS p
 WHERE precio = 400; 

 -- seleccionar los datos del cliente 25

 SELECT 
	c.id_cliente,
	c.nombre,
	c.apellido_paterno,
	c.correo
 FROM clientes AS c
 WHERE c.id_cliente =25;

 --comparacion de cadena de texto

 -- los valores de texto deben escribirse entre comillas
 -- simples

 -- seleccionar todas las categorias , donde el nombre sea computo

 SELECT
	c.id_categoria,
	c.nombre
FROM categorias AS c
WHERE c.nombre = 'Cómputo';

-- mostrar los datos de los empleados que no pertenezcan 
-- al empleado 1 (numero de empleado , nombre,salario y 
-- numero del departamento)

-- seleccionar los productos cuyo precio sea superior a 450
SELECT
	e.id_empleado,
	e.nombre,
	e.salario,
	e.id_departamento
FROM empleados AS e
WHERE e.id_departamento > 1;


-- selecciono los precios cuyo precio sea superior a 450

 SELECT
 p.codigo as [Codigo],
 p.nombre as [Nombre],
 p.precio as [Precio],
 p.existencia as [Existencias]
 FROM productos AS p
 WHERE precio > 450; 

  SELECT
 p.codigo as [Codigo],
 p.nombre as [Nombre],
 p.precio as [Precio],
 p.existencia as [Existencias]
 FROM productos AS p
 WHERE precio < 450; 

   SELECT
 p.codigo as [Codigo],
 p.nombre as [Nombre],
 p.precio as [Precio],
 p.existencia as [Existencias]
 FROM productos AS p
 WHERE precio <> 450; 


 -- filtrar fechas

 -- se recomienda utilizar formato AAA-MM-DD

 -- se recomienda todas las ventas seleccionadas el 24 de diciembre de 2024 ,

 SELECT 
	v.id_venta AS [numero de venta],
	v.fecha AS [Fechas Venta],
	v.id_cliente AS [cliente],
	v.id_empleado as [empleado]
from ventas as v
inner join
clientes AS c
on v.id_cliente = c.id_cliente
where v.fecha = '2025-12-24'

 SELECT 
	v.id_venta AS [numero de venta],
	v.fecha AS [Fechas Venta],
	v.id_cliente AS [cliente],
	v.id_empleado as [empleado]
from ventas as v
inner join
clientes AS c
on v.id_cliente = c.id_cliente
inner join
empleados as e
ON v.id_empleado =  e.id_empleado

 SELECT 
	v.id_venta AS [numero de venta],
	v.fecha AS [Fechas Venta],
	v.id_cliente AS [cliente],
	v.id_empleado as [empleado]
from ventas as v
where v.fecha = '2025-02-01'
GO

-- selecciona todas las ventas desde el 1 de octubre de 2025


 SELECT 
	v.id_venta AS [numero de venta],
	v.fecha AS [Fechas Venta],
	v.id_cliente AS [cliente],
	v.id_empleado as [empleado]
from ventas as v
where v.fecha < '2025-02-01'
GO

-- Seleccionar todas las ventas desde el 1 de octubre de 2025 en adelante

SELECT
    d.id_venta AS venta,
    d.fecha AS [fecha de venta],
    d.id_cliente AS cliente
FROM ventas AS d
WHERE d.fecha >= '2025-10-01';
GO

-- Seleccionar los productos cuyo valor del inventario sea mayor a $50000
-- Valor_inventario = precio * existencia
-- Nota: SQL SERVER NO RECONOCE EL VALOR DEL ALIAS DENTRO DEL WHERE EN EL MISMO NIVEL DE CONSULTA,
-- ESTO OCURRE POR EL ORDEN LOGICO DE QUE EN SQL SERVER PROCESA LAS PARTES DE UNA CONSULTA
SELECT
    p.codigo,
    p.nombre,
    p.precio,
    p.existencia,
    (precio * existencia) AS Inventariado
FROM productos AS p
WHERE (precio * existencia) >= 50000.0
ORDER BY Inventariado DESC;

-- Forma 2
SELECT
    p.codigo,
    p.nombre,
    p.precio,
    p.existencia,
    (precio * existencia) AS Inventariado
FROM productos AS p
WHERE (precio * existencia) >= 50000.0
ORDER BY (precio * existencia) DESC;

-- Forma 3
SELECT
    p.codigo,
    p.nombre,
    p.precio,
    p.existencia,
    (precio * existencia) AS Inventariado
FROM productos AS p
WHERE (precio * existencia) >= 50000.0
ORDER BY 3 DESC;

-- Forma 4
SELECT
    p.codigo,
    p.nombre,
    p.precio,
    p.existencia,
    (precio * existencia) AS Inventariado
FROM productos AS p
WHERE (precio * existencia) >= 50000.0
ORDER BY p.precio ASC;


/* CONSULTAS CON OPERADORES LOGICOS (NOT, AND Y OR) */

-- OPERADOR LOGICO AND

/*
	CONDICION 1 | CONDICION 2 | RESULTADO
		TRUE        TRUE          TRUE
		TRUE        FALSE         FALSE
		FALSE       TRUE          FALSE
		FALSE       FALSE         FALSE

*/

-- MOSTRAR PRODUCTOS CON PRECIO ENTRE $200 Y $300 QUE ADEMAS TENGAN MENOS DE 50 UNIDADES

SELECT
    p.id_producto,
    p.nombre,
    p.precio,
    p.existencia
FROM productos AS p
WHERE precio >= 200.0
  AND precio <= 300.0
  AND p.existencia < 50.0;
GO
-- ========================
SELECT
    p.id_producto,
    p.nombre,
    p.precio,
    p.existencia
FROM productos AS p
WHERE precio BETWEEN 200 AND 300
  AND p.existencia < 50;
GO

-- Seleccionar los empleados del departamento 1 cuyo salario sea
-- superior a $25.0

SELECT
    e.id_empleado,
    CONCAT(e.nombre, '', 
    e.apellido_paterno, '',
    e.apellido_materno) AS [nombre_completo],
    id_departamento AS departamento,
    e.salario
FROM empleados AS e
WHERE id_departamento = 1
  AND e.salario > 25.0;
GO

-- Operador Logico OR

/*=========================================
    OR REQUIERE QUE AL MENOS UNA CONDICION SEA VERDADERA

    CONDICION 1 | CONDICION 2 | RESULTADO
		TRUE        TRUE          TRUE
		TRUE        FALSE         FALSE
		FALSE       TRUE          FALSE
		FALSE       FALSE         FALSE


==========================================*/

-- SELECCIONAR LOS PRODUCTOS CON EXISTENCIA INFERIOR A 10 O SUPERIOR A 190
SELECT TOP
    s.id_producto,
    s.nombre,
    s.precio,
    s.existencia
FROM productos AS s
WHERE s.existencia < 10
   OR s.existencia > 190
   ORDER BY nombre DESC;
GO

-- OPERADOR LOGICO NOT

/*=========================================
    NOT NIEGA UNA CONDICION SEA VERDADERA

    CONDICION 1 | RESULTADO
		TRUE        FALSE
		FALSE       TRUE


==========================================*/
-- seleccionar los productos no sea mayor a 400
SELECT
	p.nombre,
	p.id_producto,
	p.precio
FROM productos AS p
WHERE NOT p.precio > 400
ORDER BY p.precio DESC;
GO


-- MOSTRAR LOS PRODUCTOS utilizando not que no se encuentrar dentro del rango 
--de 100 a 400 pesos 
SELECT
	p.nombre,
	p.id_producto,
	p.precio
FROM productos AS p
WHERE NOT p.precio <= 400 
AND p.precio >=100
ORDER BY p.precio DESC;
GO


-- MOSTRAR los empleados de los departamentos 1 o 2 que tengan 
-- salario mayor a $25,000

SELECT 
	e.nombre,
	e.id_empleado
FROM empleados AS e
WHERE e.id_empleado = 1 AND e.id_empleado = 2;

[12:15 p.m., 10/8/2026] Lalo:
--Operardor BETWEEN

USE comercial_db;
[12:16 p.m., 10/8/2026] cristofer: NOT(precio>=100 AND precio<=400);

-- Mostrar los empleados de los departamentos 1 o 2 que tengan
-- salario mayor a $25,000

SELECT
    e.id_empleado,
    CONCAT(e.nombre, ' ',
    e.apellido_paterno, ' ',
    e.apellido_materno) AS [nombre_completo],
    e.id_departamento AS departamento,
    e.salario
FROM empleados AS e
WHERE
    (e.id_departamento = 1
    OR e.id_departamento+++