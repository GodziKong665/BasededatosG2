--/================================================================================================================
--Archivo: 09-Schema-ControlPedidos.sql
--Base de Datos: control_pedidos
--Diccionario de datos fuente: 02-Modelado-BD/Diccionariodedatos/005-ControlPedidos.md

--Descripcion: crea la base de datos y el esquema de tablas del sistema de
--gestion de pedidos y productos. Permite controlar el registro de clientes,
--el seguimiento de sus pedidos, el catalogo de productos disponibles y el
--desglose detallado de los articulos incluidos en cada orden (cantidad y
--precio real de venta).

--Reglas de negocio e integridad referencial (referencia documental):
--  RN-01: Un pedido no puede incluir el mismo producto repetido en multiples filas
--         del detalle (garantizado por la llave primaria compuesta de Detalle_Pedido).
--  RN-02: precio_venta y cantidad_vendida deben ser mayores a cero (CHECK).
--  RN-03: fecha_pedido se registra de forma automatica al momento de la captura,
--         impidiendo fechas futuras (DEFAULT GETDATE(); la validacion de fechas
--         futuras es de aplicacion, no expresable como CHECK).
--  IR-01: No se puede asentar un pedido si el cliente no esta dado de alta (FK).
--  IR-02: No se pueden anadir detalles con num_pedido o num_producto inexistentes (FK).
--  IR-03: Borrado restringido (RESTRICT / NO ACTION) si un producto o pedido cuenta
--         con historial en Detalle_Pedido.
--================================================================================================================

CREATE DATABASE control_pedidos;
GO

USE control_pedidos;
GO

/*==========================================================
TABLA CLIENTE (tabla maestra)
Almacena los datos personales de identificacion de los compradores.
==========================================================*/

CREATE TABLE cliente
(
num_clientes INT IDENTITY(1,1) NOT NULL,
nombre VARCHAR(50) NOT NULL,
apellido_paterno VARCHAR(50) NOT NULL,
apellido_materno VARCHAR(50) NULL,

CONSTRAINT pk_cliente
PRIMARY KEY(num_clientes)
);
GO

/*==========================================================
TABLA PEDIDO (tabla dependiente)
Registra las ordenes de compra generadas por los clientes.
Relacion N:1 con Cliente.
RN-03: fecha_pedido se asigna automaticamente (DEFAULT GETDATE()).
IR-03: no se permite borrar un cliente con pedidos (NO ACTION).
==========================================================*/

CREATE TABLE pedido
(
num_pedido INT IDENTITY(1,1) NOT NULL,
fecha_pedido DATE NOT NULL,
num_clientes INT NOT NULL,

CONSTRAINT pk_pedido
PRIMARY KEY(num_pedido),

CONSTRAINT df_pedido_fecha_pedido
DEFAULT (GETDATE()) FOR fecha_pedido,

CONSTRAINT fk_pedido_cliente
FOREIGN KEY(num_clientes)
REFERENCES cliente(num_clientes)
);
GO

/*==========================================================
TABLA PRODUCTO (tabla maestra)
Catalogo maestro de los articulos disponibles para la venta.
El nombre comercial es unico (UQ).
==========================================================*/

CREATE TABLE producto
(
num_producto INT IDENTITY(1,1) NOT NULL,
nombre_producto VARCHAR(100) NOT NULL,
precio DECIMAL(10,2) NOT NULL,

CONSTRAINT pk_producto
PRIMARY KEY(num_producto),

CONSTRAINT uq_producto_nombre_producto
UNIQUE(nombre_producto)
);
GO

/*==========================================================
TABLA DETALLE_PEDIDO (tabla intermedia M:N Pedido-Producto)
Desglosa los productos contenidos en cada pedido, congelando el
precio de venta historico y la cantidad vendida.
RN-01: llave primaria compuesta (num_pedido, num_producto).
RN-02: precio_venta > 0 y cantidad_vendida > 0 (CHECK).
IR-03: borrado restringido para pedidos y productos con detalle.
==========================================================*/

CREATE TABLE detalle_pedido
(
num_pedido INT NOT NULL,
num_producto INT NOT NULL,
precio_venta DECIMAL(10,2) NOT NULL,
cantidad_vendida INT NOT NULL,

CONSTRAINT pk_detalle_pedido
PRIMARY KEY(num_pedido, num_producto),

CONSTRAINT ck_detalle_pedido_precio_venta
CHECK (precio_venta > 0),

CONSTRAINT ck_detalle_pedido_cantidad_vendida
CHECK (cantidad_vendida > 0),

CONSTRAINT fk_detalle_pedido_pedido
FOREIGN KEY(num_pedido)
REFERENCES pedido(num_pedido),

CONSTRAINT fk_detalle_pedido_producto
FOREIGN KEY(num_producto)
REFERENCES producto(num_producto)
);
GO

/*==========================================================
VERIFICACION
==========================================================*/

SELECT * FROM cliente;
SELECT * FROM pedido;
SELECT * FROM producto;
SELECT * FROM detalle_pedido;
GO

![Ejercicio1](../../img/construccion/Pedidos.png)