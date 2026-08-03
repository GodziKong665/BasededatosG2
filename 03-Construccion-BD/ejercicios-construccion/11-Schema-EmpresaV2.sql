--/================================================================================================================
--Archivo: 11-Schema-EmpresaV2.sql
--Base de Datos: empresa_v2
--Diccionario de datos fuente: 02-Modelado-BD/Diccionariodedatos/007-Empresav2.md

--Descripcion: crea la base de datos y el esquema de tablas de la version 2 del
--sistema de gestion organizacional, proyectos y personal. Esta version utiliza
--identificadores numericos puros (Surrogate Keys) como claves primarias para
--agilizar las consultas y desvincular la logica de negocio (como el SSN) de la
--integridad referencial. Administra personal, jerarquia de supervision,
--managers de departamentos, ubicaciones fisicas, control de horas en proyectos
--y el padron de dependientes.

--Reglas de negocio e integridad referencial (referencia documental):
--  RN-01: El ID del jef debe ser estrictamente diferente al num_employee del
--         propio registro (validacion de aplicacion, no expresable como CHECK).
--  RN-02: manager en DEPARTMENT es UNIQUE: un trabajador es manager de una sola
--         division a la vez (UNIQUE).
--  RN-03: hours >= 0 en WORKS_ON (CHECK).
--  IR-01: manager en DEPARTMENT debe corresponder a un id real en EMPLOYEE (FK).
--  IR-02: Al eliminar un empleado, sus registros en WORKS_ON y DEPENDENT se
--         eliminan en cascada (ON DELETE CASCADE).
--  IR-03: No se puede registrar un proyecto o ubicacion con number_department
--         inexistente (FK).
--================================================================================================================

CREATE DATABASE empresa_v2;
GO

USE empresa_v2;
GO

/*==========================================================
TABLA DEPARTMENT (tabla maestra, creada primero)
Divisiones internas de la organizacion.
RN-02: manager unico (1:1 con EMPLOYEE); por la dependencia
circular DEPARTMENT <-> EMPLOYEE, la columna manager y su
constraint se agregan despues de crear EMPLOYEE (ver ALTER al final).
Nota: el diccionario declara manager como NN; con la dependencia
circular se agrega nulo via ALTER para poder resolver la referencia.
==========================================================*/

CREATE TABLE department
(
number INT NOT NULL,
name VARCHAR(100) NOT NULL,
startdate DATE NULL,

CONSTRAINT pk_department
PRIMARY KEY(number),

CONSTRAINT uq_department_name
UNIQUE(name)
);
GO

/*==========================================================
TABLA EMPLOYEE (tabla dependiente de DEPARTMENT)
Personal de la organizacion con jerarquia de supervision.
RN-01: jef <> num_employee (validacion de aplicacion).
IR-02: WORKS_ON y DEPENDENT se eliminan en cascada con el empleado.
==========================================================*/

CREATE TABLE employee
(
num_employee INT IDENTITY(1,1) NOT NULL,
ssn VARCHAR(11) NOT NULL,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
birthdate DATE NULL,
address VARCHAR(100) NULL,
salary DECIMAL(10,2) NULL,
sex CHAR(1) NULL,
number_department INT NOT NULL,
jef INT NULL,

CONSTRAINT pk_employee
PRIMARY KEY(num_employee),

CONSTRAINT uq_employee_ssn
UNIQUE(ssn),

CONSTRAINT fk_employee_department
FOREIGN KEY(number_department)
REFERENCES department(number),

CONSTRAINT fk_employee_employee
FOREIGN KEY(jef)
REFERENCES employee(num_employee)
);
GO

/*==========================================================
DEPENDENCIA CIRCULAR: DEPARTMENT.manager -> EMPLOYEE(num_employee)
Se agrega la columna del manager despues de que EMPLOYEE existe.
RN-02 / IR-01: UNIQUE sobre manager (1:1, un solo departamento por
manager) y FK hacia EMPLOYEE.
Nota: el diccionario declara manager como NN; se agrega NULL para
resolver el orden de creacion (la restriccion NN exigiria el registro
del manager antes de insertar el departamento).
==========================================================*/

ALTER TABLE department
ADD manager INT NULL;
GO

ALTER TABLE department
ADD CONSTRAINT uq_department_manager
UNIQUE(manager);

ALTER TABLE department
ADD CONSTRAINT fk_department_employee
FOREIGN KEY(manager)
REFERENCES employee(num_employee);
GO

/*==========================================================
TABLA LOCATIONS (tabla dependiente de DEPARTMENT)
Ubicaciones fisicas (sedes) por departamento.
IR-03: number_department debe existir en DEPARTMENT (FK).
==========================================================*/

CREATE TABLE locations
(
num_location INT IDENTITY(1,1) NOT NULL,
number_department INT NOT NULL,
location VARCHAR(100) NOT NULL,

CONSTRAINT pk_locations
PRIMARY KEY(num_location),

CONSTRAINT fk_locations_department
FOREIGN KEY(number_department)
REFERENCES department(number)
);
GO

/*==========================================================
TABLA PROJECT (tabla dependiente de DEPARTMENT)
Proyectos que financia/administra un departamento.
IR-03: number_department debe existir en DEPARTMENT (FK).
==========================================================*/

CREATE TABLE project
(
number_project INT NOT NULL,
location VARCHAR(100) NULL,
number_department INT NOT NULL,

CONSTRAINT pk_project
PRIMARY KEY(number_project),

CONSTRAINT fk_project_department
FOREIGN KEY(number_department)
REFERENCES department(number)
);
GO

/*==========================================================
TABLA WORKS_ON (tabla intermedia M:N Project-Employee)
Horas acumuladas trabajadas por empleado en cada proyecto.
RN-03: hours >= 0 (CHECK).
IR-02: ON DELETE CASCADE al eliminar el empleado.
==========================================================*/

CREATE TABLE works_on
(
number_project INT NOT NULL,
number_employee INT NOT NULL,
hours DECIMAL(5,2) NULL,

CONSTRAINT pk_works_on
PRIMARY KEY(number_project, number_employee),

CONSTRAINT ck_works_on_hours
CHECK (hours >= 0),

CONSTRAINT fk_works_on_project
FOREIGN KEY(number_project)
REFERENCES project(number_project),

CONSTRAINT fk_works_on_employee
FOREIGN KEY(number_employee)
REFERENCES employee(num_employee)
ON DELETE CASCADE
);
GO

/*==========================================================
TABLA DEPENDENT (tabla dependiente de EMPLOYEE)
Familiares directos del empleado proveedor del seguro/beneficio.
IR-02: ON DELETE CASCADE al eliminar el empleado.
==========================================================*/

CREATE TABLE dependent
(
number_dependent INT IDENTITY(1,1) NOT NULL,
name VARCHAR(50) NOT NULL,
num_employ INT NOT NULL,
sex CHAR(1) NULL,
birthdate DATE NULL,
relationship VARCHAR(50) NULL,

CONSTRAINT pk_dependent
PRIMARY KEY(number_dependent),

CONSTRAINT fk_dependent_employee
FOREIGN KEY(num_employ)
REFERENCES employee(num_employee)
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

![Ejercicio1](../../img/construccion/Comercializadora.png)