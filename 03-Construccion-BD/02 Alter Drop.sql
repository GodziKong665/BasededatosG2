-- ALTER

CREATE DATABASE escuelita;
GO

USE escuelita;
GO

CREATE TABLE alumno(
alumno_id INT IDENTITY(1,1),
nombre VARCHAR(20) NOT NULL,
apellido_paterno VARCHAR(15) NOT NULL,
apellido_materno VARCHAR(15),
CONSTRAINT pk_alumno
PRIMARY KEY (alumno_id)
);
GO

-- AGREGAR UNA COLUMNA A UNA TABLA EXISTENTE 

ALTER TABLE alumno 
ADD telefono VARCHAR(20);
GO

-- AGREGAR VARIAS COLUMNA A VARIAS COLUMNAS

ALTER TABLE alumno
ADD
curp CHAR(18),
rfc CHAR(13);


-- Modificar el tipo de dato

ALTER TABLE alumno
ALTER COLUMN
telefono VARCHAR(30)NOT NULL;
GO




CREATE TABLE alumno2(
alumno_id INT IDENTITY(1,1),
nombre VARCHAR(20) NOT NULL,
apellido_paterno VARCHAR(15) NOT NULL,
apellido_materno VARCHAR(15),
);
GO


 -- Agregar una primary key

 ALTER TABLE alumno2
 ADD CONSTRAINT pk_alumno2
 PRIMARY KEY (alumno_id);

 CREATE TABLE carrera(
 carrera_id INT IDENTITY(1,1)
 CONSTRAINT pk_carrera
  PRIMARY KEY (carrera_id),
  nombre VARCHAR(10) NOT NULL
 );

 -- agregar  un capo para forey key

 ALTER TABLE alumno
 ADD
 carrera_id INT;

 -- agregar restriccion FOREIGN KEY
 
 ALTER TABLE alumno
 ADD CONSTRAINT fk_alumno_carrera
 FOREIGN KEY (carrera_id)
 REFERENCES carrera(carrera_id)
 ON delete CASCADE
 ON UPDATE NO ACTION;

 -- AGREGAR CAMPO EDAD A LA T5ABLA ALUMNO 
  ALTER TABLE alumno
 ADD
 edad INT;

 -- agregar una restriccion 
   ALTER TABLE alumno
 ADD CONSTRAINT ck_alumno_edad
 CHECK (edad >= 18);
 GO



 -- default

 ALTER TABLE alumno
 ADD activo BIT NOT NULL;
 GO



  ALTER TABLE alumno
 ADD CONSTRAINT df_alumno_activo
 DEFAULT 1 
 FOR activo;
 GO


 -- eliminar restricciones 

 EXEC sp_help alumno;


 -- exep sp_help_alumno

 SELECT 
	o.name AS NombreRestriccion,
	o.type_desc AS tipo_restriccion
FROM sys.objects AS o 
WHERE o.parent_object_id =OBJECT_ID('alumno')
AND o.type IN ('PK','F','UQ','C','D')
ORDER BY o.type_desc;

-- Eliminar PK

ALTER TABLE alumno
DROP CONSTRAINT pk_alumno;

-- Elimnar un check

ALTER TABLE alumno
DROP CONSTRAINT ck_alumno_edad;

-- Eliminar un UQ

ALTER TABLE alumno
ADD matricula VARCHAR(12) NOT NULL;

ALTER TABLE alumno
ADD COSNTRAINT uq_alumno_matricula
UNIQUE (matricula);

ALTER TABLE alumno
DROP CONSTRAINT uq_alumno_matricula;

-- Eliminar default
ALTER TABLE alumno
DROP CONSTRAINT df_alumno_activo;


ALTER TABLE alumno
DROP CONSTRAINT ck_alumno_edad;

-- Elimnar la FK


ALTER TABLE alumno
DROP CONSTRAINT fk_alumno_carrera;

-- DROP (ELIMNAR OBJETOS COMPLETOS)


--MUESTRA LAS TABLAS DE LA BD

SELECT name
FROM sys.tables;

DROP TABLE alumno;
GO
DROP TABLE alumno2;
GO
DROP TABLE carrera;
GO

USE master;
GO

DROP DATABASE escuelita;
GO

SELECT * FROM alumno;
