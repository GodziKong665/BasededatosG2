# Diccionario de Datos de la Base de Datos: Gestión Médica

## 1. Información General

| Elemento | Valor |
| :--- | :--- |
| **Proyecto** | Control de Expedientes Clínicos |
| **Versión** | 1.0 |
| **Fecha** | Junio 2026 |
| **Elaboró** | Ing. Eduardo Coronado Santana |
| **SGBD** | SQL SERVER |

---

## 2. Descripción de la Base de Datos

La base de datos administra:

- Paciente
- Expediente

Permite controlar la información personal de los pacientes y la gestión, apertura e integridad de sus expedientes clínicos individuales.

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

### **Tabla:** *Paciente*
 
**Descripción:** Almacena los datos de identificación personal e información básica de los pacientes de la clínica.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_paciente` | INT | - | PK, AI, NN | Identificador único e irrepetible del paciente (Identity). |
| `nombre` | VARCHAR | 50 | NN | Nombre o nombres del paciente. |
| `apellido_paterno` | VARCHAR | 50 | NN | Apellido paterno del paciente. |
| `apellido_materno` | VARCHAR | 50 | *Null* | Apellido materno del paciente (opcional). |
| `fecha_nacimiento` | DATE | - | NN | Fecha de nacimiento para el cálculo de la edad. |

---

### **Tabla:** *Expediente*
 
**Descripción:** Almacena la información de los expedientes clínicos y el historial médico asignado a cada paciente.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_expediente` | INT | - | PK, AI, NN | Número de folio único y autoincrementable del expediente. |
| `fecha_apertura` | DATE | - | NN | Fecha exacta en la que se aperturó el expediente clínico. |
| `tipo_sangre` | VARCHAR | 5 | NN | Grupo sanguíneo y factor Rh del paciente (ej. O+, A-). |
| `num_paciente` | INT | - | FK, UQ, NN | Enlace exclusivo al paciente dueño del expediente (Garantiza relación 1:1). |

---

## 5. Relaciones en la Base de Datos

| Relación | Cardinalidad | Descripción |
| :--- | :--- | :--- |
| Paciente -> Expediente | 1:1 | Un paciente posee un único expediente clínico y un expediente pertenece a un único paciente. |

---

## 6. Matriz de Claves Foráneas

| Tabla | Campo FK | Referencia |
| :--- | :--- | :--- |
| Expediente | `num_paciente` | Paciente(`num_paciente`) |

---

## 7. Integridad Referencial

| Clave | Regla |
| :--- | :--- |
| **IR-01** | No se puede crear ni asignar un expediente clínico a un número de paciente que no exista previamente en la tabla Paciente. |
| **IR-02** | No se puede eliminar un registro de la tabla Paciente si este ya cuenta con un registro asociado en la tabla Expediente (Restricción de eliminación). |

---

## 8. Reglas de Negocio

| Clave | Regla |
| :--- | :--- |
| **RN-01** | Un paciente puede tener asignado solamente un único expediente clínico en todo el sistema. |
| **RN-02** | Un expediente clínico no puede ser compartido entre dos o más pacientes; es de carácter estrictamente individual. |
| **RN-03** | La fecha de apertura del expediente no puede ser anterior a la fecha de nacimiento del paciente relacionado. |

---

## 9. Diagrama Relacional

![Ejercicio-Relacional1](/img/ER/Ejercicio-Relacional11.jpeg)
---
---
---