
--Crea una base de datos
CREATE DATABASE universidad;

--Utilizar la Base de datos
Use universidad;
GO

--Crear una Tabla
CREATE TABLE alumno (
alumno_id INT,
nombre VARCHAR (100),
edad INT
);
GO

CREATE TABLE alumno_2 (
alumno_id INT,
nombre_paterno VARCHAR (50),
apellido_materno VARCHAR (50),
fecha_nacimiento DATE,
correo VARCHAR (45)
);
GO

-- Restricciones
CREATE TABLE alumno_3 (
alumno_id INT PRIMARY KEY,
nombre VARCHAR(100),
correo VARCHAR(40)
);

CREATE TABLE alumno_4 (
alumno_id INT NOT NULL,
nombre VARCHAR(100),
correo VARCHAR(40)
CONSTRAINT pk_alumno_4
PRIMARY KEY (alumno_id)
);

INSERT INTO alumno_4
VALUES (1, 'Panfilo', 'patasdepollo@gmail');

INSERT INTO alumno_4
VALUES (2, 'Gestrudis', 'ancasdeperro@gmail');

-- Primary key con identify
CREATE TABLE profesor (
profesor_id INT NOT NULL IDENTITY (1, 1),
nombre VARCHAR (50) NOT NULL,
edad INT NULL
CONSTRAINT pk_profesor
PRIMARY KEY(profesor_id)
);
GO

INSERT INTO profesor
VALUES ('German', 29),
       ('Maricha', 22);

SELECT * FROM profesor

-- Restricciones Unique
CREATE TABLE materia(
materia_id INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
correo VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE materia_2(
materia_id INT NOT NULL IDENTITY(1, 1),
correo VARCHAR(50) NOT NULL,
CONSTRAINT pk_materia_2
PRIMARY KEY (materia_id),
CONSTRAINT uq_materia_2_correo
UNIQUE (correo)
);

INSERT INTO materia_2
VALUES ('ancasderana@gmail.com');


INSERT INTO materia_2
VALUES ('ancas2derana@gmail.com');
