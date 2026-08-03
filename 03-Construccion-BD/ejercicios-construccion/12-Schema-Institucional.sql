--/================================================================================================================
--Archivo: 12-Schema-Institucional.sql
--Base de Datos: institucional
--Diccionario de datos fuente: 02-Modelado-BD/Diccionariodedatos/008-Institucional.md

--Descripcion: crea la base de datos y el esquema de tablas del sistema de
--control de alumnos, profesores, materias y proyectos de una institucion
--educativa. Administra alumnos y sus credenciales (relacion 1:1), telefonos
--(atributo multivalorado), inscripcion historica (CURSA) e imparticion de
--materias (IMPARTE), estructura docente (DEPTO/PROFESOR), participacion en
--proyectos (PARTICIPA) y el padron de dependientes (DEPENDIENTE).

--Reglas de negocio e integridad referencial (referencia documental):
--  RN-01: total_materias (DER) NO se implementa como columna fisica en MATERIA;
--         se calcula dinamicamente con COUNT (comentario documental).
--  RN-02: calif_final en CURSA debe oscilar entre 0.00 y 10.00 (CHECK).
--  RN-03: Clave compuesta en ALUMNO_TEL: un alumno registra multiples numeros
--         sin repetir el identificador interno id_telefono.
--  IR-01: No se puede registrar una materia con id_profesor inexistente (FK).
--  IR-02: matricula en CREDENCIAL es UNIQUE para garantizar la relacion 1:1.
--  IR-03: Al dar de baja un alumno, ALUMNO_TEL y CREDENCIAL se eliminan en
--         cascada (ON DELETE CASCADE).
--================================================================================================================

CREATE DATABASE institucional;
GO

USE institucional;
GO

/*==========================================================
TABLA DEPTO (tabla maestra)
Catalogo de los departamentos o divisiones academicas.
==========================================================*/

CREATE TABLE depto
(
num_depto VARCHAR(20) NOT NULL,
nombre VARCHAR(100) NOT NULL,
edificio VARCHAR(50) NULL,

CONSTRAINT pk_depto
PRIMARY KEY(num_depto)
);
GO

/*==========================================================
TABLA PROFESOR (tabla dependiente de DEPTO)
Datos del personal docente adscrito a la institucion.
Relacion N:1 con DEPTO (PERTENECE).
Nota: el diccionario utiliza el nombre de columna id_professor
para la llave primaria; se conserva tal cual (no se traduce).
==========================================================*/

CREATE TABLE profesor
(
id_professor VARCHAR(20) NOT NULL,
pila_nombre VARCHAR(50) NOT NULL,
apellido_paterno VARCHAR(50) NOT NULL,
apellido_materno VARCHAR(50) NULL,
num_depto VARCHAR(20) NOT NULL,

CONSTRAINT pk_profesor
PRIMARY KEY(id_professor),

CONSTRAINT fk_profesor_depto
FOREIGN KEY(num_depto)
REFERENCES depto(num_depto)
);
GO

/*==========================================================
TABLA MATERIA (tabla dependiente de PROFESOR)
Catalogo maestro de asignaturas; incluye al profesor que la
imparte (Relacion IMPARTE).
IR-01: id_profesor debe existir en PROFESOR (FK).
RN-01: el total de materias por profesor se calcula con COUNT,
no se almacena como columna.
==========================================================*/

CREATE TABLE materia
(
clave_materia VARCHAR(20) NOT NULL,
nombre_materia VARCHAR(100) NOT NULL,
id_profesor VARCHAR(20) NOT NULL,

CONSTRAINT pk_materia
PRIMARY KEY(clave_materia),

CONSTRAINT fk_materia_profesor
FOREIGN KEY(id_profesor)
REFERENCES profesor(id_professor)
);
GO

/*==========================================================
TABLA ALUMNO (tabla maestra)
Informacion de identificacion y datos generales de los estudiantes.
El correo institucional es unico (UQ).
IR-03: telefonos y credencial se eliminan en cascada con el alumno.
==========================================================*/

CREATE TABLE alumno
(
matricula VARCHAR(20) NOT NULL,
pila_nombre VARCHAR(50) NOT NULL,
apellido_paterno VARCHAR(50) NOT NULL,
apellido_materno VARCHAR(50) NULL,
correo VARCHAR(100) NOT NULL,

CONSTRAINT pk_alumno
PRIMARY KEY(matricula),

CONSTRAINT uq_alumno_correo
UNIQUE(correo)
);
GO

/*==========================================================
TABLA ALUMNO_TEL (tabla dependiente de ALUMNO)
Resuelve el atributo multivalorado de telefonos del alumno.
RN-03: llave primaria compuesta (id_telefono, matricula).
IR-03: ON DELETE CASCADE al eliminar el alumno.
==========================================================*/

CREATE TABLE alumno_tel
(
id_telefono INT NOT NULL,
matricula VARCHAR(20) NOT NULL,
numero_telefono VARCHAR(20) NOT NULL,

CONSTRAINT pk_alumno_tel
PRIMARY KEY(id_telefono, matricula),

CONSTRAINT fk_alumno_tel_alumno
FOREIGN KEY(matricula)
REFERENCES alumno(matricula)
ON DELETE CASCADE
);
GO

/*==========================================================
TABLA CREDENCIAL (tabla dependiente de ALUMNO, relacion 1:1)
Folios de identificacion fisica expedidos para cada alumno.
IR-02: matricula UNIQUE garantiza una sola credencial por alumno.
IR-03: ON DELETE CASCADE al eliminar el alumno.
==========================================================*/

CREATE TABLE credencial
(
num_credencial VARCHAR(20) NOT NULL,
fecha_inscripcion DATE NOT NULL,
matricula VARCHAR(20) NOT NULL,

CONSTRAINT pk_credencial
PRIMARY KEY(num_credencial),

CONSTRAINT uq_credencial_matricula
UNIQUE(matricula),

CONSTRAINT fk_credencial_alumno
FOREIGN KEY(matricula)
REFERENCES alumno(matricula)
ON DELETE CASCADE
);
GO

/*==========================================================
TABLA CURSA (tabla intermedia N:M Alumno-Materia)
Historial de inscripcion y calificaciones de los alumnos.
RN-02: calif_final entre 0.00 y 10.00 (CHECK).
==========================================================*/

CREATE TABLE cursa
(
matricula VARCHAR(20) NOT NULL,
clave_materia VARCHAR(20) NOT NULL,
fecha_inscripcion DATE NOT NULL,
calif_final DECIMAL(4,2) NULL,

CONSTRAINT pk_cursa
PRIMARY KEY(matricula, clave_materia),

CONSTRAINT ck_cursa_calif_final
CHECK (calif_final BETWEEN 0 AND 10),

CONSTRAINT fk_cursa_alumno
FOREIGN KEY(matricula)
REFERENCES alumno(matricula),

CONSTRAINT fk_cursa_materia
FOREIGN KEY(clave_materia)
REFERENCES materia(clave_materia)
);
GO

/*==========================================================
TABLA PROYECTO (tabla maestra)
Catalogo de proyectos de investigacion o desarrollo institucional.
==========================================================*/

CREATE TABLE proyecto
(
num_proyecto VARCHAR(20) NOT NULL,
nombre_proyecto VARCHAR(100) NOT NULL,
presupuesto DECIMAL(12,2) NULL,

CONSTRAINT pk_proyecto
PRIMARY KEY(num_proyecto)
);
GO

/*==========================================================
TABLA PARTICIPA (tabla intermedia N:M Profesor-Proyecto)
Gestiona la asignacion de profesores a proyectos, con rol y fechas.
==========================================================*/

CREATE TABLE participa
(
id_professor VARCHAR(20) NOT NULL,
num_proyecto VARCHAR(20) NOT NULL,
fecha_inicio DATE NOT NULL,
rol VARCHAR(50) NOT NULL,

CONSTRAINT pk_participa
PRIMARY KEY(id_professor, num_proyecto),

CONSTRAINT fk_participa_profesor
FOREIGN KEY(id_professor)
REFERENCES profesor(id_professor),

CONSTRAINT fk_participa_proyecto
FOREIGN KEY(num_proyecto)
REFERENCES proyecto(num_proyecto)
);
GO

/*==========================================================
TABLA DEPENDIENTE (tabla dependiente de PROFESOR)
Familiares a cargo del profesor para temas de prestaciones
(Relacion DEPENDE).
==========================================================*/

CREATE TABLE dependiente
(
id_dependiente INT IDENTITY(1,1) NOT NULL,
nombre VARCHAR(100) NOT NULL,
fecha_naci DATE NULL,
parentesco VARCHAR(50) NULL,
id_professor VARCHAR(20) NOT NULL,

CONSTRAINT pk_dependiente
PRIMARY KEY(id_dependiente),

CONSTRAINT fk_dependiente_profesor
FOREIGN KEY(id_professor)
REFERENCES profesor(id_professor)
);
GO

/*==========================================================
VERIFICACION
==========================================================*/

SELECT * FROM depto;
SELECT * FROM profesor;
SELECT * FROM materia;
SELECT * FROM alumno;
SELECT * FROM alumno_tel;
SELECT * FROM credencial;
SELECT * FROM cursa;
SELECT * FROM proyecto;
SELECT * FROM participa;
SELECT * FROM dependiente;
GO

![Ejercicio1](../../img/construccion/Comercializadora.png)