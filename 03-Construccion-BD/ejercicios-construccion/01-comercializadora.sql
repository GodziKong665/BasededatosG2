-- 1. CREACIÓN Y USO DE LA BASE DE DATOS
CREATE DATABASE comercializadora;
GO

USE comercializadora;
GO
-- =============================================
-- 2. TABLA OFICINA
-- =============================================
CREATE TABLE oficina (
    numero_oficina INT NOT NULL IDENTITY (1,1),
    ciudad VARCHAR(30) NOT NULL,
    region VARCHAR(20),
    objetivo DECIMAL (10,2) NOT NULL,
    ventas DECIMAL (10,2) NOT NULL,
    numero_empl INT NOT NULL,
    
    CONSTRAINT pk_oficina PRIMARY KEY (numero_oficina),
    CONSTRAINT ck_oficina_region CHECK (region IN ('Este', 'Oeste'))
);
GO

-- Constraint de unicidad para ciudad
ALTER TABLE oficina 
ADD CONSTRAINT uq_oficina_ciudad UNIQUE (ciudad);
GO

-- =============================================
-- 3. TABLA CLIENTE
-- =============================================
CREATE TABLE cliente (
    cliente_id INT NOT NULL IDENTITY (1,1),
    empresa VARCHAR(30) NOT NULL,
    limite_credito DECIMAL (10,2) NOT NULL,
    representante_id INT NOT NULL,

    CONSTRAINT pk_cliente PRIMARY KEY (cliente_id),
    CONSTRAINT uq_cliente_empresa UNIQUE (empresa),
    CONSTRAINT ck_cliente_limite_credito CHECK (limite_credito BETWEEN 1000 AND 100000)
);
GO

-- =============================================
-- 4. TABLA REPRESENTANTE
-- =============================================
CREATE TABLE representante (
    representante_id INT NOT NULL IDENTITY(1,1),
    nombre VARCHAR(20) NOT NULL,
    apellido_paterno VARCHAR(18) NOT NULL,
    apellido_materno VARCHAR(18) NULL,
    cuota DECIMAL (10,2) NOT NULL,
    venta DECIMAL (10,2),
    fecha_nacimiento DATE NOT NULL,
    puesto VARCHAR (30) NOT NULL,
    representante_id_jefe INT NULL, -- Foreign key recursiva / jerárquica
    numero_oficina INT NOT NULL,    -- Foreign key de Oficina

    CONSTRAINT pk_representante PRIMARY KEY (representante_id),
    CONSTRAINT ck_representante_cuota CHECK (cuota > 0.0),
    CONSTRAINT ck_representante_venta CHECK (venta > 0.0),
    
    -- Clave foránea jerárquica (jefe)
    CONSTRAINT fk_representante_representante 
        FOREIGN KEY (representante_id_jefe) REFERENCES representante (representante_id),
        
    -- Clave foránea hacia oficina
    CONSTRAINT fk_representante_oficina 
        FOREIGN KEY (numero_oficina) REFERENCES oficina (numero_oficina)
);
GO

-- =============================================
-- 5. TABLA PRODUCTO 
-- =============================================
CREATE TABLE producto (
    numero_producto INT NOT NULL,
    numero_fab CHAR(5) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    existencia INT NOT NULL,

    CONSTRAINT pk_producto PRIMARY KEY (numero_producto, numero_fab)
);
GO

-- =============================================
-- 6. TABLA PEDIDO 
-- =============================================
CREATE TABLE pedido (
    pedido_id CHAR(3) NOT NULL,
    fecha_pedido DATE NOT NULL,
    representante_id INT NOT NULL,
    cliente_id INT NOT NULL,

    CONSTRAINT pk_pedido PRIMARY KEY (pedido_id),
    CONSTRAINT fk_pedido_representante 
        FOREIGN KEY (representante_id) REFERENCES representante (representante_id),
    CONSTRAINT fk_pedido_cliente 
        FOREIGN KEY (cliente_id) REFERENCES cliente (cliente_id)
);
GO

-- =============================================
-- 7. TABLA DETALLE_PEDIDO
-- =============================================
CREATE TABLE detalle_pedido (
    pedido_id CHAR(3) NOT NULL,
    numero_producto INT NOT NULL,
    numero_fab CHAR(5) NOT NULL,
    precio DECIMAL (10,2) NOT NULL,
    cantidad INT NOT NULL,

    CONSTRAINT ck_detalle_pedido_precio CHECK (precio > 0.0),
    CONSTRAINT ck_detalle_pedido_cantidad CHECK (cantidad > 0),
    CONSTRAINT pk_detalle_pedido PRIMARY KEY (pedido_id, numero_producto, numero_fab),
    
    CONSTRAINT fk_detalle_pedido_pedido 
        FOREIGN KEY (pedido_id) REFERENCES pedido (pedido_id),
    CONSTRAINT fk_detalle_pedido_producto 
        FOREIGN KEY (numero_producto, numero_fab) REFERENCES producto (numero_producto, numero_fab)
);
GO

-- =============================================
-- 8. RELACIONES ADICIONALES (FOREIGN KEYS PENDIENTES)
-- =============================================

-- Relación: Oficina -> Representante (Jefe de oficina)
ALTER TABLE oficina 
ADD CONSTRAINT fk_oficina_representante 
FOREIGN KEY (numero_empl) REFERENCES representante (representante_id);
GO

-- Relación: Cliente -> Representante
ALTER TABLE cliente
ADD CONSTRAINT fk_cliente_representante
FOREIGN KEY (representante_id) REFERENCES representante (representante_id);
GO