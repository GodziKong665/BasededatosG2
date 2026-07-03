# Diccionario de Datos de la Base de Datos: Empresa (Company)

## 1. Información General

| Elemento | Valor |
| :--- | :--- |
| **Proyecto** | Sistema de Gestión de Personal, Departamentos y Proyectos |
| **Versión** | 1.0 |
| **Fecha** | Junio 2026 |
| **Elaboró** | Ing. Eduardo Coronado Santana |
| **SGBD** | SQL SERVER |

---

## 2. Descripción de la Base de Datos

La base de datos administra el core operativo de una organización:
- **Employee:** Datos del personal y estructura jerárquica (supervisores).
- **Department:** Divisiones internas y sus gerentes.
- **Locations:** Múltiples sedes geográficas por departamento.
- **Project:** Proyectos ejecutados por la empresa.
- **Works_on:** Registro de horas que cada empleado invierte en cada proyecto.
- **Dependent:** Familiares directos de los empleados para beneficios médicos/seguros.

---

## 3. Catálogo de Restricciones Utilizadas

| Catálogo | Significado |
| :--- | :--- |
| **PK** | Primary Key (Clave Primaria) |
| **FK** | Foreign Key (Clave Foránea) |
| **NN** | Not Null (No Nulo) |
| **UQ** | Unique (Único) |

---

## 4. Diccionario de Datos

### **Tabla:** *EMPLOYEE*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `ssn` | VARCHAR | 11 | PK, NN | Número de Seguro Social. Identificador único del empleado. |
| `first_name` | VARCHAR | 50 | NN | Primer nombre del empleado. |
| `last_name` | VARCHAR | 50 | NN | Apellidos del empleado. |
| `birthdate` | DATE | - | *Null* | Fecha de nacimiento del empleado. |
| `address` | VARCHAR | 100 | *Null* | Dirección de residencia. |
| `sex` | CHAR | 1 | *Null* | Género o sexo biológico (M/F). |
| `salary` | DECIMAL(10,2)| - | *Null* | Salario mensual asignado. |
| `jef_ssn` | VARCHAR | 11 | FK, *Null* | SSN del supervisor directo (Relación reflexiva). |
| `number_department` | INT | - | FK, NN | Número de departamento al que pertenece. |

---

### **Tabla:** *DEPARTMENT*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `number_department` | INT | - | PK, NN | Número único identificador del departamento. |
| `name` | VARCHAR | 100 | UQ, NN | Nombre único de la división. |
| `manager_ssn` | VARCHAR | 11 | FK, UQ, NN | SSN del empleado que funge como gerente (1:1). |
| `startdate` | DATE | - | *Null* | Fecha en que el gerente tomó posesión del cargo. |

---

### **Tabla:** *LOCATIONS*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_location` | INT | - | PK, NN | Identificador interno de la ubicación. |
| `number_department` | INT | - | FK, NN | Departamento al que pertenece la locación. |
| `location_name` | VARCHAR | 100 | NN | Nombre o dirección de la sede física. |

---

### **Tabla:** *PROJECT*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `number_project` | INT | - | PK, NN | Número de identificación único del proyecto. |
| `name` | VARCHAR | 100 | UQ, NN | Nombre representativo del proyecto. |
| `location` | VARCHAR | 100 | *Null* | Ubicación geográfica donde se desarrolla el proyecto. |
| `number_department` | INT | - | FK, NN | Departamento encargado de la administración del proyecto. |

---

### **Tabla:** *WORKS_ON*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `ssn` | VARCHAR | 11 | PK, FK, NN | SSN del empleado asignado al proyecto. |
| `number_project` | INT | - | PK, FK, NN | Número del proyecto asignado. |
| `hours` | DECIMAL(5,2) | - | *Null* | Horas acumuladas de trabajo invertidas por el empleado. |

---

### **Tabla:** *DEPENDENT*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `ssn_employee` | VARCHAR | 11 | PK, FK, NN | SSN del empleado del cual depende familiarmente. |
| `dependent_name` | VARCHAR | 50 | PK, NN | Nombre completo del dependiente. |
| `sex` | CHAR | 1 | *Null* | Sexo biológico del dependiente. |
| `birthdate` | DATE | - | *Null* | Fecha de nacimiento del dependiente. |
| `relationship` | VARCHAR | 50 | *Null* | Parentesco (Hijo, Cónyuge, etc.). |

---

## 5. Relaciones en la Base de Datos
- **Employee (N:1) Employee:** Un supervisor gestiona a varios subordinados.
- **Employee (1:1) Department:** Un empleado lidera como gerente a un único departamento.
- **Department (1:N) Employee:** Un departamento alberga múltiples empleados trabajando en él.
- **Department (1:N) Locations:** Un departamento puede operar en múltiples sedes.
- **Department (1:N) Project:** Un departamento supervisa o financia múltiples proyectos.
- **Project (1:N) Works_on / Employee (1:N) Works_on:** Relación de muchos a muchos desglosada; múltiples empleados trabajan en múltiples proyectos.

---

## 6. Integridad Referencial
- **IR-01:** No se puede asignar un `number_department` a un proyecto o empleado si este no existe en `DEPARTMENT`.
- **IR-02:** No se puede eliminar a un empleado si su SSN está registrado como `manager_ssn` activo de un departamento.
- **IR-03:** Al eliminar un empleado, todos sus dependientes vinculados en la tabla `DEPENDENT` deben eliminarse automáticamente en cascada (`ON DELETE CASCADE`).

---

## 7. Reglas de Negocio
- **RN-01:** Las horas registradas en la tabla `WORKS_ON` no pueden ser negativas.
- **RN-02:** Un empleado no puede ser su propio supervisor directo (`jef_ssn` diferente de `ssn`).
- **RN-03:** El campo `manager_ssn` en la tabla `DEPARTMENT` debe ser único para asegurar que un empleado sea gerente de un solo departamento a la vez.

---

## 8. Diagrama Relacional

![Ejercicio-Relacional5](/img/ER/Ejercicio-Relacional15.jpeg)
---
---
---