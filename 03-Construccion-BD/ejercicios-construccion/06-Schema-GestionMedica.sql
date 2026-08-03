--/================================================================================================================
--Archivo: 06-Schema-GestionMedica.sql
--Base de Datos: control_expedientes_clinicos
--Diccionario de datos fuente: 02-Modelado-BD/Diccionariodedatos/002-Gestionmedica.md

--Descripcion: crea la base de datos y el esquema de tablas del control de
--expedientes clinicos (Gestion Medica). Administra la informacion personal
--de los pacientes y la gestion, apertura e integridad de sus expedientes
--clinicos individuales.

--Reglas de negocio e integridad referencial (referencia documental):
--  RN-01: Un paciente puede tener asignado solamente un unico expediente clinico.
--  RN-02: Un expediente clinico no puede ser compartido entre dos o mas pacientes.
--  RN-03: La fecha de apertura del expediente no puede ser anterior a la fecha de
--         nacimiento del paciente relacionado (validacion de aplicacion, no expresable como CHECK).
--  IR-01: No se puede crear ni asignar un expediente a un paciente inexistente (FK).
--  IR-02: No se puede eliminar un paciente con expediente asociado (NO ACTION por defecto).
--================================================================================================================

CREATE DATABASE control_expedientes_clinicos;
GO

USE control_expedientes_clinicos;
GO

/*==========================================================
TABLA PACIENTE (tabla maestra)
Almacena los datos de identificacion personal e informacion
basica de los pacientes de la clinica.
RN-03: fecha_nacimiento es referencia para la edad del paciente.
==========================================================*/

CREATE TABLE paciente
(
num_paciente INT IDENTITY(1,1) NOT NULL,
nombre VARCHAR(50) NOT NULL,
apellido_paterno VARCHAR(50) NOT NULL,
apellido_materno VARCHAR(50) NULL,
fecha_nacimiento DATE NOT NULL,

CONSTRAINT pk_paciente
PRIMARY KEY(num_paciente)
);
GO

/*==========================================================
TABLA EXPEDIENTE (tabla dependiente)
Almacena la informacion de los expedientes clinicos y el
historial medico asignado a cada paciente.
RN-01 / RN-02: relacion 1:1 con Paciente, garantizada por
la restriccion UNIQUE sobre num_paciente (FK UQ).
RN-03: fecha_apertura >= fecha_nacimiento del paciente
(regla de negocio de aplicacion; no expresable como CHECK).
==========================================================*/

CREATE TABLE expediente
(
num_expediente INT IDENTITY(1,1) NOT NULL,
fecha_apertura DATE NOT NULL,
tipo_sangre VARCHAR(5) NOT NULL,
num_paciente INT NOT NULL,

CONSTRAINT pk_expediente
PRIMARY KEY(num_expediente),

CONSTRAINT uq_expediente_num_paciente
UNIQUE(num_paciente),

CONSTRAINT fk_expediente_paciente
FOREIGN KEY(num_paciente)
REFERENCES paciente(num_paciente)
);
GO

/*==========================================================
VERIFICACION
==========================================================*/

SELECT * FROM paciente;
SELECT * FROM expediente;
GO

![Ejercicio1](../../img/construccion/Comercializadora.png)