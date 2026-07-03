# Diccionario de Datos de la Base de Datos: Control de Inscripciones

## 1. Información General

| Elemento | Valor |
| :--- | :--- |
| **Proyecto** | Sistema de Inscripción de Asignaturas |
| **Versión** | 1.0 |
| **Fecha** | Junio 2026 |
| **Elaboró** | Ing. Eduardo Coronado Santana |
| **SGBD** | SQL SERVER |

---

## 2. Descripción de la Base de Datos

La base de datos administra:

- Alumno
- Materia
- Inscribe

Permite controlar el registro de estudiantes, el catálogo de asignaturas disponibles y la inscripción formal de los alumnos en sus materias, incluyendo el seguimiento de sus calificaciones.

---

## 3. Catálogo de Restricciones Utilizadas

| Catálogo | Significado |
| :--- | :--- |
| **PK** | Primary Key (Clave Primaria) |
| **FK** | Foreign Key (Clave Foránea) |
| **NN** | Not Null (No Nulo) |
| **UQ** | Unique (Único) |
| **AI** | Identity (Autoincrementable) |

---

## 4. Diccionario de Datos

### **Tabla:** *Alumno*
 
**Descripción:** Almacena el registro de los estudiantes inscritos en la institución.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_alumno` | INT | - | PK, AI, NN | Identificador interno único del alumno. |
| `matricula` | VARCHAR | 20 | UQ, NN | Matrícula institucional única del alumno. |
| `nombre` | VARCHAR | 50 | NN | Nombre o nombres del estudiante. |
| `apellido_paterno` | VARCHAR | 50 | NN | Apellido paternal del estudiante. |
| `apellido_materno` | VARCHAR | 50 | *Null* | Apellido maternal del estudiante (opcional). |
| `semestre` | INT | - | NN | Semestre académico actual que cursa el alumno. |

---

### **Tabla:** *Materia*
 
**Descripción:** Catálogo de asignaturas o unidades de aprendizaje disponibles.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `clave_materia` | INT | - | PK, AI, NN | Clave o identificador único de la materia. |
| `nombre` | VARCHAR | 100 | UQ, NN | Nombre oficial y único de la materia. |
| `creditos` | INT | - | NN | Valor en créditos académicos de la asignatura. |

---

### **Tabla:** *Inscribe*
 
**Descripción:** Tabla intermedia (entidad asociativa) que registra las materias inscritas por cada alumno y sus respectivas notas.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_alumno` | INT | - | PK, FK, NN | Clave foránea que referencia al alumno inscrito. |
| `clave_materia` | INT | - | PK, FK, NN | Clave foránea que referencia a la materia seleccionada. |
| `fecha_inscribe` | DATE | - | NN | Fecha exacta en la que se formalizó la inscripción. |
| `calificacion` | DECIMAL(4,2) | - | *Null* | Calificación final obtenida por el alumno (admite decimales). |

---

## 5. Relaciones en la Base de Datos

| Relación | Cardinalidad | Descripción |
| :--- | :--- | :--- |
| Alumno -> Inscribe | 1:N | Un alumno puede generar muchos registros de inscripción. |
| Materia -> Inscribe | 1:N | Una materia puede estar presente en muchas inscripciones de alumnos. |

---

## 6. Matriz de Claves Foráneas

| Tabla | Campo FK | Referencia |
| :--- | :--- | :--- |
| Inscribe | `num_alumno` | Alumno(`num_alumno`) |
| Inscribe | `clave_materia` | Materia(`clave_materia`) |

---

## 7. Integridad Referencial

| Clave | Regla |
| :--- | :--- |
| **IR-01** | No se puede registrar una inscripción para un `num_alumno` que no exista en la tabla Alumno. |
| **IR-02** | No se puede registrar una inscripción para una `clave_materia` que no exista en la tabla Materia. |
| **IR-03** | Si se elimina un alumno o una materia, se debe restringir la acción si cuenta con historial activo en la tabla Inscribe. |

---

## 8. Reglas de Negocio

| Clave | Regla |
| :--- | :--- |
| **RN-01** | Un alumno no puede inscribirse más de una vez a la misma materia en el mismo periodo (Llave primaria compuesta). |
| **RN-02** | El campo `calificacion` debe aceptar valores numéricos dentro del rango aprobatorio o reprobatorio de la institución (ej. 0.00 a 10.00). |
| **RN-03** | Las asignaturas deben tener cargados obligatoriamente sus créditos correspondientes antes de abrir su proceso de inscripción. |

---

## 9. Diagrama Relacional

![Ejercicio-Relacional3](/img/ER/Ejercicio-Relacional13.jpeg)
---
---
