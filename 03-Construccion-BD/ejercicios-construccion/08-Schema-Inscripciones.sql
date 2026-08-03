--/================================================================================================================
--Archivo: 08-Schema-Inscripciones.sql
--Base de Datos: control_inscripciones
--Diccionario de datos fuente: 02-Modelado-BD/Diccionariodedatos/004-Inscripciones.md

--Descripcion: crea la base de datos y el esquema de tablas del sistema de
--inscripcion de asignaturas. Permite controlar el registro de estudiantes,
--el catalogo de asignaturas disponibles y la inscripcion formal de los
--alumnos en sus materias, incluyendo el seguimiento de sus calificaciones.

--Reglas de negocio e integridad referencial (referencia documental):
--  RN-01: Un alumno no puede inscribirse mas de una vez a la misma materia en el
--         mismo periodo (garantizado por la llave primaria compuesta de Inscribe).
--  RN-02: calificacion debe aceptar valores numericos de 0.00 a 10.00 (CHECK).
--  RN-03: Las asignaturas deben tener cargados sus creditos antes de abrir inscripciones.
--  IR-01: No se puede registrar una inscripcion con num_alumno inexistente (FK).
--  IR-02: No se puede registrar una inscripcion con clave_materia inexistente (FK).
--  IR-03: Si se elimina un alumno o una materia con historial activo en Inscribe,
--         la accion se restringe (NO ACTION por defecto).
--================================================================================================================

CREATE DATABASE control_inscripciones;
GO

USE control_inscripciones;
GO

/*==========================================================
TABLA ALUMNO (tabla maestra)
Almacena el registro de los estudiantes inscritos en la
institucion. La matricula es unica (UQ).
==========================================================*/

CREATE TABLE alumno
(
num_alumno INT IDENTITY(1,1) NOT NULL,
matricula VARCHAR(20) NOT NULL,
nombre VARCHAR(50) NOT NULL,
apellido_paterno VARCHAR(50) NOT NULL,
apellido_materno VARCHAR(50) NULL,
semestre INT NOT NULL,

CONSTRAINT pk_alumno
PRIMARY KEY(num_alumno),

CONSTRAINT uq_alumno_matricula
UNIQUE(matricula)
);
GO

/*==========================================================
TABLA MATERIA (tabla maestra)
Catalogo de asignaturas o unidades de aprendizaje disponibles.
El nombre oficial de la materia es unico (UQ).
RN-03: los creditos son obligatorios.
==========================================================*/

CREATE TABLE materia
(
clave_materia INT IDENTITY(1,1) NOT NULL,
nombre VARCHAR(100) NOT NULL,
creditos INT NOT NULL,

CONSTRAINT pk_materia
PRIMARY KEY(clave_materia),

CONSTRAINT uq_materia_nombre
UNIQUE(nombre)
);
GO

/*==========================================================
TABLA INSCRIBE (tabla intermedia M:N Alumno-Materia)
Registra las materias inscritas por cada alumno y sus notas.
RN-01: la llave primaria compuesta impide inscribir dos veces
la misma materia al mismo alumno.
RN-02: calificacion entre 0.00 y 10.00 (CHECK).
IR-03: eliminacion restringida si existe historial de inscripcion.
==========================================================*/

CREATE TABLE inscribe
(
num_alumno INT NOT NULL,
clave_materia INT NOT NULL,
fecha_inscribe DATE NOT NULL,
calificacion DECIMAL(4,2) NULL,

CONSTRAINT pk_inscribe
PRIMARY KEY(num_alumno, clave_materia),

CONSTRAINT ck_inscribe_calificacion
CHECK (calificacion BETWEEN 0 AND 10),

CONSTRAINT fk_inscribe_alumno
FOREIGN KEY(num_alumno)
REFERENCES alumno(num_alumno),

CONSTRAINT fk_inscribe_materia
FOREIGN KEY(clave_materia)
REFERENCES materia(clave_materia)
);
GO

/*==========================================================
VERIFICACION
==========================================================*/

SELECT * FROM alumno;
SELECT * FROM materia;
SELECT * FROM inscribe;
GO

![Ejercicio1](../../img/construccion/Comercializadora.png)