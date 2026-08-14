--/================================================================================================================
--Archivo: 13-Schema-ControlEscolar.sql
--Base de Datos: control_escolar
--Diccionario de datos fuente: 02-Modelado-BD/Diccionariodedatos/01-diccionariodatos-controlescolar.md

--Descripcion: crea la base de datos y el esquema de tablas del sistema de
--control escolar. Administra la oferta academica (carreras y materias), el
--registro de alumnos y profesores, la formacion de grupos y la inscripcion
--de estudiantes.

--Nota de integridad del diccionario: las tablas Carrera y Alumno estan
--documentadas por completo; las tablas Materia, Profesor, Grupo e
--Inscripcion quedaron sin documentar en el diccionario ("TODO: DOCUMENTA
--LAS SIGUIENTES TABLAS"). Sus columnas se reconstruyeron de forma MINIMA
--a partir de la Matriz de Claves Foraneas y las Relaciones declaradas:
--  - PK propia (id_* INT IDENTITY, siguiendo el patron de id_carrera/id_alumno).
--  - Unicamente las FK declaradas en la matriz; no se inventan columnas
--    adicionales (nombre, etc.).

--Reglas de negocio e integridad referencial (referencia documental):
--  IR-01: No se puede registrar un alumno con una carrera inexistente (FK).
--  IR-02: No se puede crear un grupo para una materia o profesor inexistente (FK).
--  RN-01: Un alumno pertenece a una sola carrera.
--  RN-02/RN-03: Una carrera puede tener muchos alumnos y muchas materias.
--  RN-04: Un profesor puede impartir varios grupos.
--  CK (diccionario): duracion de la carrera debe ser mayor a cero (CHECK).
--================================================================================================================

CREATE DATABASE control_escolar;
GO

USE control_escolar;
GO

/*==========================================================
TABLA CARRERA (tabla maestra)
Almacena las carreras ofertadas por la universidad.
El nombre de la carrera es unico (UQ).
CK (declarado en el diccionario): duracion > 0 (cuatrimestres).
Nota: el diccionario duplica la fila "nombre"; la columna se
incluye una sola vez.
==========================================================*/

CREATE TABLE carrera
(
id_carrera INT IDENTITY(1,1) NOT NULL,
nombre VARCHAR(100) NOT NULL,
duracion INT NOT NULL,

CONSTRAINT pk_carrera
PRIMARY KEY(id_carrera),

CONSTRAINT uq_carrera_nombre
UNIQUE(nombre),

CONSTRAINT ck_carrera_duracion
CHECK (duracion > 0)
);
GO

/*==========================================================
TABLA ALUMNO (tabla dependiente de CARRERA)
Almacena la informacion de los alumnos de la universidad.
Matricula y correo institucional son unicos (UQ).
IR-01: id_carrera debe existir en Carrera (FK).
RN-01: un alumno pertenece a una sola carrera.
==========================================================*/

CREATE TABLE alumno
(
id_alumno INT IDENTITY(1,1) NOT NULL,
matricula VARCHAR(10) NOT NULL,
nombre VARCHAR(50) NOT NULL,
ap_paterno VARCHAR(50) NOT NULL,
ap_materno VARCHAR(50) NOT NULL,
correo VARCHAR(100) NOT NULL,
fecha_nacimiento DATE NOT NULL,
id_carrera INT NOT NULL,

CONSTRAINT pk_alumno
PRIMARY KEY(id_alumno),

CONSTRAINT uq_alumno_matricula
UNIQUE(matricula),

CONSTRAINT uq_alumno_correo
UNIQUE(correo),

CONSTRAINT fk_alumno_carrera
FOREIGN KEY(id_carrera)
REFERENCES carrera(id_carrera)
);
GO

/*==========================================================
TABLA MATERIA (tabla dependiente de CARRERA)
Oferta de materias por carrera (relacion Carrera -> Materia 1:N).
Reconstruida de forma minima desde la Matriz de Claves Foraneas:
Materia.id_carrera -> Carrera(id_carrera).
RN-03: una carrera puede tener muchas materias.
==========================================================*/

CREATE TABLE materia
(
id_materia INT IDENTITY(1,1) NOT NULL,
id_carrera INT NOT NULL,

CONSTRAINT pk_materia
PRIMARY KEY(id_materia),

CONSTRAINT fk_materia_carrera
FOREIGN KEY(id_carrera)
REFERENCES carrera(id_carrera)
);
GO

/*==========================================================
TABLA PROFESOR (tabla maestra)
Registro de profesores de la universidad.
Reconstruida de forma minima: solo PK (no hay columnas documentadas
en el diccionario).
RN-04: un profesor puede impartir varios grupos.
==========================================================*/

CREATE TABLE profesor
(
id_profesor INT IDENTITY(1,1) NOT NULL,

CONSTRAINT pk_profesor
PRIMARY KEY(id_profesor)
);
GO

/*==========================================================
TABLA GRUPO (tabla dependiente de PROFESOR y MATERIA)
Grupos de cada materia impartidos por profesores.
Reconstruida de forma minima desde la Matriz de Claves Foraneas:
Grupo.id_profesor -> Profesor(id_profesor) y
Grupo.id_materia -> Materia(id_materia).
IR-02: no se puede crear un grupo con materia o profesor inexistente.
==========================================================*/

CREATE TABLE grupo
(
id_grupo INT IDENTITY(1,1) NOT NULL,
id_profesor INT NOT NULL,
id_materia INT NOT NULL,

CONSTRAINT pk_grupo
PRIMARY KEY(id_grupo),

CONSTRAINT fk_grupo_profesor
FOREIGN KEY(id_profesor)
REFERENCES profesor(id_profesor),

CONSTRAINT fk_grupo_materia
FOREIGN KEY(id_materia)
REFERENCES materia(id_materia)
);
GO

/*==========================================================
TABLA INSCRIPCION (tabla dependiente de ALUMNO y GRUPO)
Registro de la inscripcion de alumnos en grupos.
Reconstruida de forma minima desde la Matriz de Claves Foraneas:
Inscripcion.id_alumno -> Alumno(id_alumno) e
Inscripcion.id_grupo -> Grupo(id_grupo).
Relaciones: Alumno -> Inscripcion 1:N y Grupo -> Inscripcion 1:N.
==========================================================*/

CREATE TABLE inscripcion
(
id_inscripcion INT IDENTITY(1,1) NOT NULL,
id_alumno INT NOT NULL,
id_grupo INT NOT NULL,

CONSTRAINT pk_inscripcion
PRIMARY KEY(id_inscripcion),

CONSTRAINT fk_inscripcion_alumno
FOREIGN KEY(id_alumno)
REFERENCES alumno(id_alumno),

CONSTRAINT fk_inscripcion_grupo
FOREIGN KEY(id_grupo)
REFERENCES grupo(id_grupo)
);
GO

/*==========================================================
VERIFICACION
==========================================================*/

SELECT * FROM carrera;
SELECT * FROM alumno;
SELECT * FROM materia;
SELECT * FROM profesor;
SELECT * FROM grupo;
SELECT * FROM inscripcion;
GO

![Ejercicio1](../../img/construccion/Escolar.png)