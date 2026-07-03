# Diccionario de Datos de la Base de Datos: Empresa (V2)

## 1. Información General

| Elemento | Valor |
| :--- | :--- |
| **Proyecto** | Sistema de Gestión Organizacional, Proyectos y Personal - V2 |
| **Versión** | 2.0 |
| **Fecha** | Junio 2026 |
| **Elaboró** | Ing. Eduardo Coronado Santana |
| **SGBD** | SQL SERVER |

---

## 2. Descripción de la Base de Datos

Esta versión optimizada administra los recursos de la empresa utilizando identificadores numéricos puros (Surrogate Keys) como claves primarias para agilizar las consultas y desvincular la lógica de negocio (como el SSN) de la integridad referencial. Administra el personal, la jerarquía de supervisión, los mánagers de departamentos, ubicaciones físicas, control de horas en proyectos y el padrón de dependientes.

---

## 3. Catálogo de Restricciones Utilizadas

| Catálogo | Significado |
| :--- | :--- |
| **PK** | Primary Key (Clave Primaria) |
| **FK** | Foreign Key (Clave Foránea) |
| **NN** | Not Null (No Nulo) |
| **UQ** | Unique (Único) |
| **AI** | Identity / Autoincrementable |

---

## 4. Diccionario de Datos

### **Tabla:** *EMPLOYEE*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_employee` | INT | - | PK, AI, NN | Identificador numérico único del empleado. |
| `ssn` | VARCHAR | 11 | UQ, NN | Número de Seguro Social (Llave natural alternativa). |
| `first_name` | VARCHAR | 50 | NN | Primer nombre del trabajador. |
| `last_name` | VARCHAR | 50 | NN | Apellidos del trabajador. |
| `birthdate` | DATE | - | *Null* | Fecha de nacimiento del empleado. |
| `address` | VARCHAR | 100 | *Null* | Dirección residencial. |
| `salary` | DECIMAL(10,2)| - | *Null* | Sueldo mensual asignado. |
| `sex` | CHAR | 1 | *Null* | Sexo biológico (M/F). |
| `number_department` | INT | - | FK, NN | Departamento al que está adscrito. |
| `jef` | INT | - | FK, *Null* | `num_employee` del supervisor directo (Reflexiva). |

---

### **Tabla:** *DEPARTMENT*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `number` | INT | - | PK, NN | Número único de identificación del departamento. |
| `name` | VARCHAR | 100 | UQ, NN | Nombre de la división o departamento. |
| `startdate` | DATE | - | *Null* | Fecha en que el mánager asumió el puesto. |
| `manager` | INT | - | FK, UQ, NN | `num_employee` del empleado que dirige la división (1:1). |

---

### **Tabla:** *LOCATIONS*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_location` | INT | - | PK, AI, NN | Identificador secuencial de la ubicación. |
| `number_department` | INT | - | FK, NN | Código del departamento dueño de esta sede. |
| `location` | VARCHAR | 100 | NN | Dirección o nombre de la zona geográfica. |

---

### **Tabla:** *PROJECT*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `number_project` | INT | - | PK, NN | Número único de control del proyecto. |
| `location` | VARCHAR | 100 | *Null* | Sede donde se ejecuta el proyecto. |
| `number_department` | INT | - | FK, NN | Departamento que financia/administra el proyecto. |

---

### **Tabla:** *WORKS_ON*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `number_project` | INT | - | PK, FK, NN | Número del proyecto asignado. |
| `number_employee` | INT | - | PK, FK, NN | Código del empleado asignado a dicho proyecto. |
| `hours` | DECIMAL(5,2) | - | *Null* | Horas acumuladas trabajadas en este proyecto. |

---

### **Tabla:** *DEPENDENT*
| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `number_dependent` | INT | - | PK, AI, NN | ID único y autoincrementable del dependiente. |
| `name` | VARCHAR | 50 | NN | Nombre completo del familiar. |
| `num_employ` | INT | - | FK, NN | Código del empleado proveedor del seguro/beneficio. |
| `sex` | CHAR | 1 | *Null* | Sexo biológico del dependiente. |
| `birthdate` | DATE | - | *Null* | Fecha de nacimiento. |
| `relationship` | VARCHAR | 50 | *Null* | Tipo de lazo familiar (Hijo, Hija, Cónyuge, etc.). |

---

## 5. Relaciones en la Base de Datos

| Relación | Cardinalidad | Descripción |
| :--- | :--- | :--- |
| Employee -> Employee | 1:N | Un supervisor (jefe) coordina a múltiples empleados subordinados. |
| Employee -> Department | 1:1 | Un empleado único ejerce el cargo de mánager de un departamento. |
| Department -> Employee | 1:N | Un departamento cuenta con múltiples empleados adscritos a su área. |
| Department -> Locations | 1:N | Un departamento puede tener presencia en múltiples ubicaciones físicas. |
| Department -> Project | 1:N | Un departamento puede estar a cargo de la gestión de múltiples proyectos. |
| Project -> Works_On | 1:N | Un proyecto desglosa sus horas asignadas a través de la tabla intermedia. |
| Employee -> Works_On | 1:N | Un empleado registra sus horas invertidas a través de la tabla intermedia. |
| Employee -> Dependent | 1:N | Un empleado puede tener uno o más dependientes registrados en el sistema. |

---

## 6. Matriz de Claves Foráneas

| Tabla | Campo FK | Referencia |
| :--- | :--- | :--- |
| EMPLOYEE | `number_department` | DEPARTMENT(`number`) |
| EMPLOYEE | `jef` | EMPLOYEE(`num_employee`) |
| DEPARTMENT | `manager` | EMPLOYEE(`num_employee`) |
| LOCATIONS | `number_department` | DEPARTMENT(`number`) |
| PROJECT | `number_department` | DEPARTMENT(`number`) |
| WORKS_ON | `number_project` | PROJECT(`number_project`) |
| WORKS_ON | `number_employee` | EMPLOYEE(`num_employee`) |
| DEPENDENT | `num_employ` | EMPLOYEE(`num_employee`) |

---

## 7. Integridad Referencial

| Clave | Regla |
| :--- | :--- |
| **IR-01** | El campo `manager` en la tabla `DEPARTMENT` debe corresponder de forma obligatoria a un identificador real en `EMPLOYEE`. |
| **IR-02** | Si un empleado es eliminado del sistema, sus registros vinculados en `WORKS_ON` y `DEPENDENT` deben borrarse en cascada (`ON DELETE CASCADE`) para no dejar información huérfana. |
| **IR-03** | No se puede registrar un proyecto o una ubicación asociada a un número de departamento que no exista previamente en la tabla matriz. |

---

## 8. Reglas de Negocio

| Clave | Regla |
| :--- | :--- |
| **RN-01** | La asignación jerárquica exige que el ID del `jef` sea estrictamente diferente al `num_employee` del propio registro para evitar ciclos infinitos de autosupervisión. |
| **RN-02** | El campo `manager` de la tabla `DEPARTMENT` es de tipo `UNIQUE`, limitando a que un trabajador sea mánager de una sola división a la vez. |
| **RN-03** | El número de horas acumuladas registradas en la tabla `WORKS_ON` por empleado y proyecto debe ser igual o superior a cero. |

---

## 9. Diagrama Relacional

![DiagramaEmpresaV2](/img/ER/Ejercicio-Relacional16.jpeg)
---
---
---