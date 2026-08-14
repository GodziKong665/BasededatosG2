/*=================================================================================

Tema: Tipos de JOIN en SQL Server

ARCHIVO: 07-tipos-join.sql

DESCRIPCION: Combinar filas de dos o mas tablas usando INNER JOIN, LEFT JOIN,
RIGHT JOIN, FULL OUTER JOIN, CROSS JOIN y SELF JOIN, con las tablas reales
de la base comercial_db

=================================================================================*/
USE comercial_db;
GO

/*==================================================
1. INNER JOIN: solo las filas que coinciden en ambas
==================================================*/

-- Clientes con su ciudad y su estado (JOIN de tres tablas)
-- Se encadenan dos INNER JOIN: clientes -> ciudades -> estados
SELECT
	c.nombre AS cliente,
	ci.nombre AS ciudad,
	e.nombre AS estado
FROM clientes AS c
INNER JOIN ciudades AS ci
	ON c.id_ciudad = ci.id_ciudad
INNER JOIN estados AS e
	ON ci.id_estado = e.id_estado;

-- Productos con el nombre de su categoria y su proveedor
SELECT
	p.codigo,
	p.nombre AS producto,
	p.precio,
	ca.nombre AS categoria,
	pr.empresa AS proveedor
FROM productos AS p
INNER JOIN categorias AS ca
	ON p.id_categoria = ca.id_categoria
INNER JOIN proveedores AS pr
	ON p.id_proveedor = pr.id_proveedor;
GO

/*==================================================
2. LEFT JOIN: todas las filas de la izquierda + coincidencias
==================================================*/

-- Todos los productos, aunque no tengan categoria.
-- Si un producto no tuviera categoria, en categoria apareceria NULL.
-- (En este esquema id_categoria es NOT NULL, pero el LEFT JOIN es la
--  herramienta correcta para detectar registros sin correspondencia)
SELECT
	p.codigo,
	p.nombre AS producto,
	ca.nombre AS categoria
FROM productos AS p
LEFT JOIN categorias AS ca
	ON p.id_categoria = ca.id_categoria;

-- Todos los empleados con el nombre de su departamento.
-- Los departamentos sin empleados no aparecen porque se lee desde empleados
SELECT
	e.nombre AS empleado,
	d.nombre AS departamento
FROM empleados AS e
LEFT JOIN departamentos AS d
	ON e.id_departamento = d.id_departamento;
GO

/*==================================================
3. RIGHT JOIN: todas las filas de la derecha + coincidencias
==================================================*/

-- Todas las ciudades, aunque no tengan clientes.
-- Si una ciudad no tuviera clientes, los campos del cliente serian NULL
SELECT
	c.nombre AS cliente,
	ci.nombre AS ciudad
FROM clientes AS c
RIGHT JOIN ciudades AS ci
	ON c.id_ciudad = ci.id_ciudad;

-- Todos los departamentos, aunque no tengan empleados
SELECT
	e.nombre AS empleado,
	d.nombre AS departamento
FROM empleados AS e
RIGHT JOIN departamentos AS d
	ON e.id_departamento = d.id_departamento;
GO

/*==================================================
4. FULL OUTER JOIN: todas las filas de ambas tablas
==================================================*/

-- SQL Server SI soporta FULL OUTER JOIN (a diferencia de MySQL).
-- Devuelve todos los empleados y todos los departamentos;
-- las filas sin correspondencia quedan con NULL
SELECT
	e.nombre AS empleado,
	d.nombre AS departamento
FROM empleados AS e
FULL OUTER JOIN departamentos AS d
	ON e.id_departamento = d.id_departamento;
GO

/*==================================================
5. CROSS JOIN: producto cartesiano (todas x todas)
==================================================*/

-- No lleva condicion ON: cada fila de productos se combina con cada fila
-- de categorias. En este caso 150 productos x 12 categorias = 1800 filas.
-- Se usa TOP para limitar la salida de ejemplo
SELECT TOP (20)
	p.codigo,
	p.nombre AS producto,
	ca.nombre AS categoria
FROM productos AS p
CROSS JOIN categorias AS ca;
GO

/*==================================================
6. SELF JOIN: la tabla unida consigo misma
==================================================*/

-- La tabla empleados tiene la columna id_jefe que apunta al id_empleado
-- de otro empleado (el jefe). Se usa la misma tabla dos veces con
-- distintos alias: e (empleado) y j (jefe)

-- INNER SELF JOIN: solo empleados que tienen jefe registrado
SELECT
	e.nombre AS empleado,
	j.nombre AS jefe
FROM empleados AS e
INNER JOIN empleados AS j
	ON e.id_jefe = j.id_empleado;

-- LEFT SELF JOIN: todos los empleados; quienes no tienen jefe
-- (id_jefe NULL) muestran NULL en la columna jefe
SELECT
	e.nombre AS empleado,
	j.nombre AS jefe
FROM empleados AS e
LEFT JOIN empleados AS j
	ON e.id_jefe = j.id_empleado;

-- Jerarquia completa: empleado, su jefe y el jefe de su jefe
SELECT
	e.nombre AS empleado,
	j.nombre AS jefe_directo,
	k.nombre AS jefe_del_jefe
FROM empleados AS e
LEFT JOIN empleados AS j
	ON e.id_jefe = j.id_empleado
LEFT JOIN empleados AS k
	ON j.id_jefe = k.id_empleado;
GO
