--/================================================================================================================
--Archivo: 10-Schema-Empresa.sql
--Base de Datos: empresa
--Diccionario de datos fuente: 02-Modelado-BD/Diccionariodedatos/006-EMpresa.md

--Descripcion: crea la base de datos y el esquema de tablas del sistema de
--gestion de personal, departamentos y proyectos. Administra el core operativo
--de una organizacion: empleados y jerarquia de supervision, departamentos y
--sus gerentes, sedes fisicas (locations), proyectos, horas invertidas por
--empleado en cada proyecto (works_on) y familiares directos para beneficios
--medicos/seguros (dependent).

--Nota: este diccionario no presenta "Matriz de Claves Foraneas"; las claves
--foraneas se derivaron de la seccion de Relaciones y de las restricciones
--declaradas por columna (FK).

--Reglas de negocio e integridad referencial (referencia documental):
--  RN-01: Las horas registradas en WORKS_ON no pueden ser negativas (CHECK).
--  RN-02: Un empleado no puede ser su propio supervisor directo
--         (jef_ssn <> ssn; validacion de aplicacion, no expresable como CHECK).
--  RN-03: manager_ssn en DEPARTMENT debe ser unico para asegurar que un empleado
--         sea gerente de un solo departamento (UNIQUE).
--  IR-01: No se puede asignar un number_department inexistente a un proyecto o empleado (FK).
--  IR-02: No se puede eliminar un empleado si su SSN es manager_ssn activo de un
--         departamento (NO ACTION por defecto).
--  IR-03: Al eliminar un empleado, sus dependientes se eliminan en cascada
--         (ON DELETE CASCADE en DEPENDENT).
--================================================================================================================

CREATE DATABASE empresa;
GO

USE empresa;
GO

/*==========================================================
TABLA DEPARTMENT (tabla maestra, creada primero)
Divisiones internas de la organizacion.
RN-03: manager_ssn unico (1:1 con EMPLOYEE); por la dependencia
circular DEPARTMENT <-> EMPLOYEE, la columna manager_ssn y su
constraint se agregan despues de crear EMPLOYEE (ver ALTER al final).
Nota: el diccionario declara manager_ssn como NN; con la dependencia
circular se agrega nulo via ALTER para poder resolver la referencia.
==========================================================*/

CREATE TABLE department
(
number_department INT NOT NULL,
name VARCHAR(100) NOT NULL,
startdate DATE NULL,

CONSTRAINT pk_department
PRIMARY KEY(number_department),

CONSTRAINT uq_department_name
UNIQUE(name)
);
GO

/*==========================================================
TABLA EMPLOYEE (tabla dependiente de DEPARTMENT)
Datos del personal y estructura jerarquica (supervisores).
RN-02: jef_ssn debe ser distinto de ssn (validacion de aplicacion).
Relacion reflexiva N:1 (supervisor -> subordinados).
IR-01: number_department debe existir en DEPARTMENT (FK).
IR-03: los dependientes de un empleado se eliminan en cascada.
==========================================================*/

CREATE TABLE employee
(
ssn VARCHAR(11) NOT NULL,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
birthdate DATE NULL,
address VARCHAR(100) NULL,
sex CHAR(1) NULL,
salary DECIMAL(10,2) NULL,
jef_ssn VARCHAR(11) NULL,
number_department INT NOT NULL,

CONSTRAINT pk_employee
PRIMARY KEY(ssn),

CONSTRAINT fk_employee_employee
FOREIGN KEY(jef_ssn)
REFERENCES employee(ssn),

CONSTRAINT fk_employee_department
FOREIGN KEY(number_department)
REFERENCES department(number_department)
);
GO

/*==========================================================
DEPENDENCIA CIRCULAR: DEPARTMENT.manager_ssn -> EMPLOYEE(ssn)
Se agrega la columna del gerente despues de que EMPLOYEE existe.
RN-03 / IR-02: UNIQUE sobre manager_ssn (1:1, un solo departamento
por gerente) y NO ACTION al eliminar al gerente.
Nota: el diccionario declara manager_ssn como NN; se agrega NULL para
resolver el orden de creacion (la restriccion NN exigiria el registro
del gerente antes de insertar el departamento).
==========================================================*/

ALTER TABLE department
ADD manager_ssn VARCHAR(11) NULL;
GO

ALTER TABLE department
ADD CONSTRAINT uq_department_manager_ssn
UNIQUE(manager_ssn);

ALTER TABLE department
ADD CONSTRAINT fk_department_employee
FOREIGN KEY(manager_ssn)
REFERENCES employee(ssn);
GO

/*==========================================================
TABLA LOCATIONS (tabla dependiente de DEPARTMENT)
Multiples sedes geograficas por departamento.
==========================================================*/

CREATE TABLE locations
(
num_location INT NOT NULL,
number_department INT NOT NULL,
location_name VARCHAR(100) NOT NULL,

CONSTRAINT pk_locations
PRIMARY KEY(num_location),

CONSTRAINT fk_locations_department
FOREIGN KEY(number_department)
REFERENCES department(number_department)
);
GO

/*==========================================================
TABLA PROJECT (tabla dependiente de DEPARTMENT)
Proyectos ejecutados por la empresa.
El nombre del proyecto es unico (UQ).
==========================================================*/

CREATE TABLE project
(
number_project INT NOT NULL,
name VARCHAR(100) NOT NULL,
location VARCHAR(100) NULL,
number_department INT NOT NULL,

CONSTRAINT pk_project
PRIMARY KEY(number_project),

CONSTRAINT uq_project_name
UNIQUE(name),

CONSTRAINT fk_project_department
FOREIGN KEY(number_department)
REFERENCES department(number_department)
);
GO

/*==========================================================
TABLA WORKS_ON (tabla intermedia M:N Employee-Project)
Registro de horas que cada empleado invierte en cada proyecto.
RN-01: hours >= 0 (CHECK).
==========================================================*/

CREATE TABLE works_on
(
ssn VARCHAR(11) NOT NULL,
number_project INT NOT NULL,
hours DECIMAL(5,2) NULL,

CONSTRAINT pk_works_on
PRIMARY KEY(ssn, number_project),

CONSTRAINT ck_works_on_hours
CHECK (hours >= 0),

CONSTRAINT fk_works_on_employee
FOREIGN KEY(ssn)
REFERENCES employee(ssn),

CONSTRAINT fk_works_on_project
FOREIGN KEY(number_project)
REFERENCES project(number_project)
);
GO

/*==========================================================
TABLA DEPENDENT (tabla dependiente de EMPLOYEE)
Familiares directos de los empleados para beneficios medicos/seguros.
IR-03: ON DELETE CASCADE al eliminar el empleado.
==========================================================*/

CREATE TABLE dependent
(
ssn_employee VARCHAR(11) NOT NULL,
dependent_name VARCHAR(50) NOT NULL,
sex CHAR(1) NULL,
birthdate DATE NULL,
relationship VARCHAR(50) NULL,

CONSTRAINT pk_dependent
PRIMARY KEY(ssn_employee, dependent_name),

CONSTRAINT fk_dependent_employee
FOREIGN KEY(ssn_employee)
REFERENCES employee(ssn)
ON DELETE CASCADE
);
GO

/*==========================================================
VERIFICACION
==========================================================*/

SELECT * FROM department;
SELECT * FROM employee;
SELECT * FROM locations;
SELECT * FROM project;
SELECT * FROM works_on;
SELECT * FROM dependent;
GO

![Ejercicio1](../../img/construccion/Empresa.png)