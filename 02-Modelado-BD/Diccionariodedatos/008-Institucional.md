# Diccionario de Datos de la Base de Datos: Control Académico e Institucional

## 1. Información General

| Elemento | Valor |
| :--- | :--- |
| **Proyecto** | Sistema de Control de Alumnos, Profesores, Materias y Proyectos |
| **Fecha** | Junio 2026 |
| **Elaboró** | Ing. Eduardo Coronado Santana |
| **SGBD** | SQL SERVER |

---

## 2. Descripción de la Base de Datos

La base de datos administra el flujo académico y operativo de una institución educativa, permitiendo el control de:
- **Alumnos y sus Credenciales:** Registro único de estudiantes, sus medios de contacto, teléfonos (atendiendo atributos multivalorados) y su credencial institucional (relación 1:1).
- **Control de Asignaturas (CURSA e IMPARTE):** Inscripción histórica de alumnos en materias con sus respectivas evaluaciones y la asignación de profesores que las imparten.
- **Estructura Docente (DEPTO y PROFESOR):** Organización de los profesores dentro de sus respectivos departamentos adscritos.
- **Investigación y Desarrollo (PARTICIPA):** Registro de la participación de los docentes en proyectos institucionales bajo roles específicos.
- **Prestaciones y Beneficios (DEPENDIENTE):** Padrón de los familiares directos que dependen del profesor.

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

## 4. Diccionario de Datos por Tabla

### **Tabla:** *ALUMNO*
**Descripción:** Almacena la información de identificación y datos generales de los estudiantes.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `matricula` | VARCHAR | 20 | PK, NN | Clave única e institucional del alumno. |
| `pila_nombre` | VARCHAR | 50 | NN | Nombre o nombres de pila del estudiante. |
| `apellido_paterno`| VARCHAR | 50 | NN | Apellido paterno del alumno. |
| `apellido_materno`| VARCHAR | 50 | *Null* | Apellido materno del alumno. |
| `correo` | VARCHAR | 100 | UQ, NN | Correo electrónico institucional único. |

---

### **Tabla:** *ALUMNO_TEL*
**Descripción:** Entidad que resuelve el atributo multivalorado de teléfonos del alumno, permitiendo registrar múltiples números.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `id_telefono` | INT | - | PK, NN | Identificador secuencial del teléfono para el alumno. |
| `matricula` | VARCHAR | 20 | PK, FK, NN | Enlace con la matrícula del alumno (Clave compuesta). |
| `numero_telefono`| VARCHAR | 20 | NN | Número telefónico de la línea. |

---

### **Tabla:** *CREDENCIAL*
**Descripción:** Entidad que registra los folios de identificación física expedidos para cada alumno (Relación 1:1).

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_credencial` | VARCHAR | 20 | PK, NN | Número de folio único de la credencial física. |
| `fecha_inscripcion`| DATE | - | NN | Fecha en la que se emitió o renovó el plástico. |
| `matricula` | VARCHAR | 20 | FK, UQ, NN | Matrícula del alumno dueño de la credencial. |

---

### **Tabla:** *MATERIA*
**Descripción:** Catálogo maestro de asignaturas ofertadas por la institución. Incluye al profesor que la imparte.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `clave_materia` | VARCHAR | 20 | PK, NN | Código único identificador de la materia. |
| `nombre_materia` | VARCHAR | 100 | NN | Nombre oficial de la asignatura. |
| `id_profesor` | VARCHAR | 20 | FK, NN | ID del profesor que dicta la materia (Relación IMPARTE). |

---

### **Tabla:** *CURSA*
**Descripción:** Tabla intermedia (N:M) que registra el historial de inscripción y calificaciones de los alumnos en las materias.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `matricula` | VARCHAR | 20 | PK, FK, NN | Matrícula del alumno inscrito. |
| `clave_materia` | VARCHAR | 20 | PK, FK, NN | Clave de la materia que está cursando. |
| `fecha_inscripcion`| DATE | - | NN | Fecha de alta de la materia en el periodo escolar. |
| `calif_final` | DECIMAL(4,2) | - | *Null* | Calificación final obtenida por el alumno. |

---

### **Tabla:** *DEPTO*
**Descripción:** Catálogo de los departamentos o divisiones académicas de la institución.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_depto` | VARCHAR | 20 | PK, NN | Número o código de identificación del departamento. |
| `nombre` | VARCHAR | 100 | NN | Nombre de la división académica. |
| `edificio` | VARCHAR | 50 | *Null* | Nombre o clave del edificio donde se ubica. |

---

### **Tabla:** *PROFESOR*
**Descripción:** Almacena los datos del personal docente adscrito a la institución.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `id_professor` | VARCHAR | 20 | PK, NN | Clave única o número de nómina del profesor. |
| `pila_nombre` | VARCHAR | 50 | NN | Nombre o nombres propios del profesor. |
| `apellido_paterno`| VARCHAR | 50 | NN | Apellido paterno del docente. |
| `apellido_materno`| VARCHAR | 50 | *Null* | Apellido materno del docente. |
| `num_depto` | VARCHAR | 20 | FK, NN | Departamento al que pertenece el profesor (PERTENECE). |

---

### **Tabla:** *PROYECTO*
**Descripción:** Catálogo de proyectos de investigación o desarrollo institucional.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_proyecto` | VARCHAR | 20 | PK, NN | Número o código de control del proyecto. |
| `nombre_proyecto`| VARCHAR | 100 | NN | Título oficial del proyecto. |
| `presupuesto` | DECIMAL(12,2)| - | *Null* | Fondo económico asignado al proyecto. |

---

### **Tabla:** *PARTICIPA*
**Descripción:** Tabla intermedia (N:M) que gestiona la asignación de profesores a proyectos, indicando su rol y fechas.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `id_professor` | VARCHAR | 20 | PK, FK, NN | ID del profesor asignado. |
| `num_proyecto` | VARCHAR | 20 | PK, FK, NN | Número del proyecto en el que colabora. |
| `fecha_inicio` | DATE | - | NN | Fecha de alta del profesor en el proyecto. |
| `rol` | VARCHAR | 50 | NN | Cargo o rol desempeñado (ej. Líder, Colaborador). |

---

### **Tabla:** *DEPENDIENTE*
**Descripción:** Entidad que registra los datos de los familiares a cargo del profesor para temas de prestaciones.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `id_dependiente` | INT | - | PK, AI, NN | ID único autoincrementable del dependiente. |
| `nombre` | VARCHAR | 100 | NN | Nombre completo del familiar. |
| `fecha_naci` | DATE | - | *Null* | Fecha de nacimiento del dependiente. |
| `parentesco` | VARCHAR | 50 | *Null* | Relación familiar (ej. Hijo, Hija, Cónyuge). |
| `id_professor` | VARCHAR | 20 | FK, NN | ID del profesor de quien depende (DEPENDE). |

---

## 5. Matriz de Claves Foráneas

| Tabla Origen | Campo FK | Tabla Referenciada | Campo PK Referenciado |
| :--- | :--- | :--- | :--- |
| ALUMNO_TEL | `matricula` | ALUMNO | `matricula` |
| CREDENCIAL | `matricula` | ALUMNO | `matricula` |
| MATERIA | `id_profesor` | PROFESOR | `id_professor` |
| CURSA | `matricula` | ALUMNO | `matricula` |
| CURSA | `clave_materia` | MATERIA | `clave_materia` |
| PROFESOR | `num_depto` | DEPTO | `num_depto` |
| PARTICIPA | `id_professor` | PROFESOR | `id_professor` |
| PARTICIPA | `num_proyecto` | PROYECTO | `num_proyecto` |
| DEPENDIENTE | `id_professor` | PROFESOR | `id_professor` |

---

## 6. Integridad Referencial

- **IR-01 (Materia - Profesor):** No se puede registrar una materia si el `id_profesor` asignado no existe previamente en la tabla `PROFESOR`.
- **IR-02 (Credencial 1:1):** Para garantizar la relación uno a uno, el campo `matricula` en la tabla `CREDENCIAL` tiene una restricción `UNIQUE`. No puede haber dos credenciales asociadas a la misma matrícula.
- **IR-03 (Borrado en Cascada):** Al dar de baja a un alumno (`ALUMNO`), sus registros telefónicos en `ALUMNO_TEL` y su `CREDENCIAL` deben eliminarse en cascada (`ON DELETE CASCADE`) para evitar registros huérfanos.

---

## 7. Reglas de Negocio

- **RN-01 (Atributo Derivado):** El campo `total_materias` visualizado en el DER no se implementa como columna física en la tabla `MATERIA` para cumplir con las reglas de normalización. Se calculará dinámicamente mediante consultas de agregación (`COUNT`).
- **RN-02 (Rango de Calificaciones):** Los valores insertados en el campo `calif_final` dentro de la tabla `CURSA` deben oscilar de forma obligatoria en el rango permitido por el SGBD institucional (ej. 0.00 a 10.00).
- **RN-03 (Clave Compuesta en Teléfonos):** Un mismo alumno puede registrar múltiples números, pero no puede repetir el mismo identificador interno `id_telefono` en sus registros personales.

![Ejercicio-Relacional6](/img/ER/Ejercicio-Relacional16.jpeg)