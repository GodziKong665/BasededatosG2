# Diccionario de la Base de Datos del Control Escolar 

1. Informacion General


Elemento | Valor |
| :--- | :--- |
| Proyecto | Control Escolar|
| Version | 1.0 |
| Fecha | Junio 2026|
| Elaboro | Yeshua Emmanuel Navarro Perez |
| SGBD| SQLSERVER |
---
2. Descripcion de la Base de Datos

El de Base de Datos administra:

- Carrera
- Alumno
- Profesor
- Materia
- Grupo
- Inscripcion

Permite controlar la oferta academica y la inscripcion de estudiantes

3. Catalogo de Resytricciones utilizadas

|Catalogo |Significado |
| :--- | :--- |
| PK | Primary Key|
| FK | Foreign Key|
| NN | Not Null |
| UQ | Unique|
| AI | Autoincrement o Indentify|
| CK | Check |
| DF | Default|
---
4. Diccionario de Datos

**Tabla:** _Carrera_

**Descripcion**
Almacena las carreras ofertadas por la universidad


| Campo | Tipo | Longitud| Restricciones | Descripcion|
| :--- | :--- | :--- | :--- | :--- |
| id_carrera | INT | -| PK, AI, NN | Identificador unico de la carrera  |
|nombre | VARCHAR |100 | UQ, NN | Nombre de la carrera  |
| duracion| INT | - | NN, CK (>0)| Duracion en cuatrimestre  |
|nombre | VARCHAR |100 | UQ, NN | Nombre de la carrera  |

---



**Tabla:** _Alumno_

**Descripcion**
Almacena la Informacion ofertadas por la universidad


| Campo | Tipo | Longitud| Restricciones | Descripcion|
| :--- | :--- | :--- | :--- | :--- |
| id_alumno | INT | -| PK, AI, NN | Identificador del alumno  |
|matricula | VARCHAR |10| UQ, NN | Matricula Institucional  |
|nombre | VARCHAR |50 | NN | Nombre del Alumno  |
|ap_paterno | VARCHAR |50 | NN | Apellido Paterno  |
|ap_materno | VARCHAR |50 | NN |Apellido Materno  |
|correo | VARCHAR |100 | UQ, NN | Correo Institucional  |
|fecha_nacimiento | DATE |- | NN | Fecha de Nacimeinto  |
|id_carrera | INT | -| FK, NN | Carrera a la que pertenece  |

---

TODO: DOCUMENTA LAS SIGUIENTES TABLAS

5. Relaciones de la Base de Datos

| Relacion | Cardinalidad | Descripcion |
| :--- | :--- | :--- | 
| Carrera -> Alumno | 1:N| Una Carrera tiene muchos Alumnos | 
| Carrera -> Materia | 1:N| Una carrera tiene muchas materias|
| Profesor -> Grupo | 1:N| Un profesor puede tener muchos grupos|
| Materia -> Grupo | 1:N| Una materia puede tener varios grupos|
| Alumno -> Inscripcion | 1:N| Un Alumno puede tener varias Inscripciones|
| Grupo -> Inscripcion | 1:N| Un Grupo puede tener varias Inscripciones|
---
6. Matriz de Claves Foraneas

| Tabla | Campo FK | Referencia |
| :--- | :--- | :--- | 
| Alumno | id_carrera| Carrera(id_carrera) | 
| Materia | id_carrera| Carrera(id_carrera)|
| Grupo | id_profesor| Profesor(id_profesor)|
| Grupo | id_materia| Materia(id_materia)|
| Inscripcion | id_alumno| Alumno(id_alumno)|
| Inscripcion |id_grupo| Grupo(id_grupo)|
---
7. Integridad Relacional

|Clave | Regla |
| :--- | :--- |
| IR-01 | No se puede registrar un alumno con una carrera inexistente|
|IR-02 | No se puede crear un grupo para una materia inexistente|
| IR-02 | No se puede crear un grupo para un profesor inexistente|

8. Reglas de Negocio

|Clave | Regla |
| :--- | :--- |
| IR-01 | Un Alumno pertence a una sola carrera |
|IR-02 | Una carrera ouede tener muchos alumnos|
| IR-03 | Una carrera puede tener muchas materias|
| IR-04 | Un profesor puede impartir varios grupos|

9. Diagrama Relacional

![EjercicioRelacional]()