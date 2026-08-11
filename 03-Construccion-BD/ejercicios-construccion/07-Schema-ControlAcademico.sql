--/================================================================================================================
--Archivo: 07-Schema-ControlAcademico.sql
--Base de Datos: control_academico
--Diccionario de datos fuente: 02-Modelado-BD/Diccionariodedatos/003.ControlAcademico.md

--Descripcion: crea la base de datos y el esquema de tablas del sistema de
--control academico y profesores. Administra la oferta de cursos, la asignacion
--y datos personales de los profesores, asi como el registro de las
--especialidades profesionales que posee cada docente.

--Reglas de negocio e integridad referencial (referencia documental):
--  RN-01: Muchos profesores pueden estar calificados para impartir un mismo curso base.
--  RN-02: Un profesor puede registrar multiples especialidades.
--  RN-03: Todo curso registrado debe contar con creditos asignados mayor a cero (CHECK).
--  IR-01: No se puede dar de alta un profesor con numero_curso inexistente (FK).
--  IR-02: No se puede registrar una especialidad con numero_profesor inexistente (FK).
--  IR-03: Si se elimina un curso con profesores dependientes, la accion se restringe
--         (NO ACTION por defecto, sin borrado en cascada).
--================================================================================================================

CREATE DATABASE control_academico;
GO

USE control_academico;
GO

/*==========================================================
TABLA CURSO (tabla maestra)
Almacena los cursos o asignaturas que oferta la institucion.
RN-03: los creditos deben ser mayores a cero (CHECK).
==========================================================*/

CREATE TABLE curso
(
numero_curso INT IDENTITY(1,1) NOT NULL,
nombre_curso VARCHAR(100) NOT NULL,
creditos INT NOT NULL,

CONSTRAINT pk_curso
PRIMARY KEY(numero_curso),

CONSTRAINT ck_curso_creditos
CHECK (creditos > 0)
);
GO

/*==========================================================
TABLA PROFESOR (tabla dependiente)
Almacena los datos de identificacion de los profesores y los
vincula al curso al que pertenecen.
Relacion N:1 con Curso (muchos profesores a un curso).
IR-03: la eliminacion de un curso con profesores asociados
se restringe (NO ACTION).
==========================================================*/

CREATE TABLE profesor
(
numero_profesor INT IDENTITY(1,1) NOT NULL,
nombre VARCHAR(50) NOT NULL,
apellido_paterno VARCHAR(50) NOT NULL,
apellido_materno VARCHAR(50) NULL,
numero_curso INT NOT NULL,

CONSTRAINT pk_profesor
PRIMARY KEY(numero_profesor),

CONSTRAINT fk_profesor_curso
FOREIGN KEY(numero_curso)
REFERENCES curso(numero_curso)
);
GO

/*==========================================================
TABLA ESPECIALIDAD (tabla dependiente)
Almacena las distintas especialidades, maestrias o
certificaciones tecnicas que ostentan los profesores.
Relacion N:1 con Profesor.
==========================================================*/

CREATE TABLE especialidad
(
id_especialidad INT IDENTITY(1,1) NOT NULL,
nombre VARCHAR(100) NOT NULL,
numero_profesor INT NOT NULL,

CONSTRAINT pk_especialidad
PRIMARY KEY(id_especialidad),

CONSTRAINT fk_especialidad_profesor
FOREIGN KEY(numero_profesor)
REFERENCES profesor(numero_profesor)
);
GO

/*==========================================================
VERIFICACION
==========================================================*/

SELECT * FROM curso;
SELECT * FROM profesor;
SELECT * FROM especialidad;
GO

![Ejercicio1](../../img/construccion/Academico.png)