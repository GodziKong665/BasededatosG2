/*=================================================================================

Tema: Funciones de Agregado, GROUP BY y HAVING

ARCHIVO: 06-funciones-agregado-groupby-having.sql

DESCRIPCION: Aplicar funciones de agregado (COUNT, SUM, AVG, MIN, MAX) para
resumir informacion, agrupar datos con GROUP BY y filtrar grupos con HAVING,
usando las tablas reales de la base comercial_db

=================================================================================*/
USE comercial_db;
GO

/*==================================================
1. COUNT: contar filas o valores
==================================================*/

-- COUNT(*) cuenta todas las filas de la tabla clientes
SELECT COUNT(*) AS total_clientes
FROM clientes;

-- COUNT(columna) cuenta solo las filas donde la columna NO es NULL
-- La columna apellido_materno es NULL en algunos clientes
SELECT COUNT(apellido_materno) AS clientes_con_segundo_apellido
FROM clientes;

-- COUNT(DISTINCT columna) cuenta los valores unicos
-- Cuantos sexos distintos existen en la tabla clientes
SELECT COUNT(DISTINCT sexo) AS numero_de_sexos
FROM clientes;

-- Comparacion: total de filas vs total de descuentos no NULL vs descuentos unicos
SELECT
	COUNT(*)					AS filas_detalle,
	COUNT(descuento)			AS descuentos_no_nulos,
	COUNT(DISTINCT descuento)	AS descuentos_unicos
FROM detalle_ventas;
GO

/*==================================================
2. SUM: sumar valores numericos
==================================================*/

-- Importe total de todas las ventas (cantidad por precio en detalle_ventas)
SELECT SUM(dv.cantidad * dv.precio) AS importe_total_ventas
FROM detalle_ventas AS dv;

-- Valor total del inventario (precio por existencia de cada producto)
SELECT SUM(p.precio * p.existencia) AS valor_total_inventario
FROM productos AS p;

-- Suma de existencias de todos los productos
SELECT SUM(existencia) AS total_existencias
FROM productos;
GO

/*==================================================
3. AVG: promedio de valores numericos
==================================================*/

-- Salario promedio de todos los empleados
SELECT AVG(salario) AS salario_promedio
FROM empleados;

-- Descuento promedio aplicado en los detalles de venta
SELECT AVG(descuento) AS descuento_promedio
FROM detalle_ventas;

-- Precio promedio de los productos
SELECT AVG(precio) AS precio_promedio
FROM productos;
GO

/*==================================================
4. MIN y MAX: valor minimo y maximo
==================================================*/

-- Producto mas barato y producto mas caro
SELECT
	MIN(precio) AS precio_minimo,
	MAX(precio) AS precio_maximo
FROM productos;

-- Empleado con mas antiguedad (fecha de ingreso minima) y el mas reciente
SELECT
	MIN(fecha_ingreso) AS ingreso_mas_antiguo,
	MAX(fecha_ingreso) AS ingreso_mas_reciente
FROM empleados;

-- Nombre de pila con la primera y ultima posicion alfabetica
SELECT
	MIN(nombre) AS primer_nombre,
	MAX(nombre) AS ultimo_nombre
FROM clientes;
GO

/*==================================================
5. GROUP BY: agrupar filas con el mismo valor
==================================================*/

-- Numero de clientes por sexo (un grupo para M y otro para F)
SELECT
	sexo,
	COUNT(*) AS cantidad_clientes
FROM clientes
GROUP BY sexo;

-- Cantidad de productos por categoria
-- Se usa JOIN para mostrar el nombre de la categoria y no solo su id
SELECT
	c.nombre AS categoria,
	COUNT(p.id_producto) AS cantidad_productos
FROM categorias AS c
LEFT JOIN productos AS p
	ON p.id_categoria = c.id_categoria
GROUP BY c.nombre;

-- Salario promedio por departamento
SELECT
	d.nombre AS departamento,
	COUNT(e.id_empleado) AS numero_empleados,
	AVG(e.salario) AS salario_promedio
FROM departamentos AS d
LEFT JOIN empleados AS e
	ON e.id_departamento = d.id_departamento
GROUP BY d.nombre;
GO

/*==================================================
6. WHERE vs HAVING
==================================================*/

-- WHERE filtra FILAS antes de agrupar.
-- Aqui se eliminan los salarios menores a 20000 y despues se agrupa
SELECT
	d.nombre AS departamento,
	AVG(e.salario) AS salario_promedio
FROM departamentos AS d
INNER JOIN empleados AS e
	ON e.id_departamento = d.id_departamento
WHERE e.salario > 20000
GROUP BY d.nombre;

-- HAVING filtra GRUPOS despues de agrupar y puede usar funciones de agregado.
-- Aqui se agrupa primero y solo se muestran los departamentos cuyo
-- salario promedio es mayor a 20000
SELECT
	d.nombre AS departamento,
	AVG(e.salario) AS salario_promedio
FROM departamentos AS d
INNER JOIN empleados AS e
	ON e.id_departamento = d.id_departamento
GROUP BY d.nombre
HAVING AVG(e.salario) > 20000;

-- El WHERE no permite funciones de agregado
-- Esta consulta seria un error: NO ejecutar
-- SELECT departamento, AVG(salario) FROM empleados WHERE AVG(salario) > 20000;
GO

/*==================================================
7. HAVING: ejemplos aplicados
==================================================*/

-- Categorias con mas de 10 productos
SELECT
	c.nombre AS categoria,
	COUNT(p.id_producto) AS cantidad_productos
FROM categorias AS c
INNER JOIN productos AS p
	ON p.id_categoria = c.id_categoria
GROUP BY c.nombre
HAVING COUNT(p.id_producto) > 10;

-- Departamentos que tienen mas de 4 empleados
SELECT
	d.nombre AS departamento,
	COUNT(e.id_empleado) AS numero_empleados
FROM departamentos AS d
INNER JOIN empleados AS e
	ON e.id_departamento = d.id_departamento
GROUP BY d.nombre
HAVING COUNT(e.id_empleado) > 4;

-- Sexos con mas de 50 clientes registrados
SELECT
	sexo,
	COUNT(*) AS cantidad_clientes
FROM clientes
GROUP BY sexo
HAVING COUNT(*) > 50;

-- Combinar WHERE (filtra filas) con HAVING (filtra grupos):
-- departamentos cuyo salario promedio supera 25000 considerando
-- solamente a los empleados contratados despues de 2022
SELECT
	d.nombre AS departamento,
	COUNT(e.id_empleado) AS empleados,
	AVG(e.salario) AS salario_promedio
FROM departamentos AS d
INNER JOIN empleados AS e
	ON e.id_departamento = d.id_departamento
WHERE YEAR(e.fecha_ingreso) > 2022
GROUP BY d.nombre
HAVING AVG(e.salario) > 25000;
GO
