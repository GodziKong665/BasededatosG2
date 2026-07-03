# Diccionario de Datos de la Base de Datos: Control de Pedidos y Ventas

## 1. Información General

| Elemento | Valor |
| :--- | :--- |
| **Proyecto** | Sistema de Gestión de Pedidos y Productos |
| **Versión** | 1.0 |
| **Fecha** | Junio 2026 |
| **Elaboró** | Ing. Eduardo Coronado Santana |
| **SGBD** | SQL SERVER |

---

## 2. Descripción de la Base de Datos

La base de datos administra:

- Cliente
- Pedido
- Producto
- Detalle_Pedido

Permite controlar el registro de clientes, el seguimiento de sus pedidos, el catálogo de productos disponibles y el desglose detallado de los artículos incluidos en cada orden junto con la cantidad y el precio real de venta.

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

### **Tabla:** *Cliente*
 
**Descripción:** Almacena los datos personales de identificación de los compradores.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_clientes` | INT | - | PK, AI, NN | Identificador único y autoincrementable del cliente. |
| `nombre` | VARCHAR | 50 | NN | Nombre o nombres del cliente. |
| `apellido_paterno` | VARCHAR | 50 | NN | Apellido paterno del cliente. |
| `apellido_materno` | VARCHAR | 50 | *Null* | Apellido materno del cliente (opcional). |

---

### **Tabla:** *Pedido*
 
**Descripción:** Registra las órdenes de compra generadas por los clientes.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_pedido` | INT | - | PK, AI, NN | Identificador único y correlativo del pedido. |
| `fecha_pedido` | DATE | - | NN | Fecha exacta en la que el cliente levantó el pedido. |
| `num_clientes` | INT | - | FK, NN | Enlace al cliente que realizó la compra (Relación N:1). |

---

### **Tabla:** *Producto*
 
**Descripción:** Catálogo maestro de los artículos disponibles para la venta.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_producto` | INT | - | PK, AI, NN | Identificador o código único del producto. |
| `nombre_producto` | VARCHAR | 100 | UQ, NN | Nombre comercial único del artículo. |
| `precio` | DECIMAL(10,2) | - | NN | Precio base o de lista sugerido para el producto. |

---

### **Tabla:** *Detalle_Pedido*
 
**Descripción:** Entidad asociativa que desglosa los productos contenidos en cada pedido, congelando el precio de venta histórico y la cantidad vendida.

| Campo | Tipo | Longitud | Restricciones | Descripción |
| :--- | :--- | :--- | :--- | :--- |
| `num_pedido` | INT | - | PK, FK, NN | Código del pedido al que pertenece este detalle. |
| `num_producto` | INT | - | PK, FK, NN | Código del producto que fue adquirido. |
| `precio_venta` | DECIMAL(10,2) | - | NN | Precio real al que se vendió el artículo. |
| `cantidad_vendida` | INT | - | NN | Unidades totales adquiridas de dicho producto en este pedido. |

---

## 5. Relaciones en la Base de Datos

| Relación | Cardinalidad | Descripción |
| :--- | :--- | :--- |
| Cliente -> Pedido | 1:N | Un cliente puede efectuar múltiples pedidos en el sistema. |
| Pedido -> Detalle_Pedido | 1:N | Un pedido puede contener múltiples artículos desglosados en el detalle. |
| Detalle_Pedido -> Producto | N:1 | Muchos registros de detalle de pedido hacen referencia a un único producto del catálogo. |

---

## 6. Matriz de Claves Foráneas

| Tabla | Campo FK | Referencia |
| :--- | :--- | :--- |
| Pedido | `num_clientes` | Cliente(`num_clientes`) |
| Detalle_Pedido | `num_pedido` | Pedido(`num_pedido`) |
| Detalle_Pedido | `num_producto` | Producto(`num_producto`) |

---

## 7. Integridad Referencial

| Clave | Regla |
| :--- | :--- |
| **IR-01** | No se puede asentar un pedido (`num_clientes`) si el cliente no está dado de alta en la tabla Cliente. |
| **IR-02** | No se pueden añadir registros a `Detalle_Pedido` si el `num_pedido` o el `num_producto` no existen en sus respectivas tablas maestras. |
| **IR-03** | Si se intenta borrar un producto o un pedido que ya cuenta con historial en `Detalle_Pedido`, la acción debe ser restringida (`RESTRICT / NO ACTION`) para evitar inconsistencias financieras. |

---

## 8. Reglas de Negocio

| Clave | Regla |
| :--- | :--- |
| **RN-01** | Un pedido no puede incluir el mismo producto repetido en múltiples filas de `Detalle_Pedido`; en su lugar, se debe incrementar el valor en el campo `cantidad_vendida` (Garantizado por la PK compuesta). |
| **RN-02** | El `precio_venta` y la `cantidad_vendida` deben ser forzosamente valores mayores a cero en cada transacción. |
| **RN-03** | La `fecha_pedido` debe registrarse de forma automática al momento de la captura, impidiendo fechas futuras. |

---

## 9. Diagrama Relacional

![Ejercicio-Relacional4](/img/ER/Ejercicio-Relacional14.jpeg)
---
---
---