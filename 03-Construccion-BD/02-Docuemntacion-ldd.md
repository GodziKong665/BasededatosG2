
02-documentacion-ldd.md
Página
1
/
1
100 %
# Construcción de BD en SQL Server, Mysql o MariaDB y Postgres

Para la construcción de objetos de la base de datos se utiliza el lenguaje SQL (Structured Query Language) se divide en **cinco grandes categorias**

## SQL
- DDL (Data Definition Language)
- DML (Data Manipulation Language)
- DQL (Data Query Language)
- DCL (Data Control Language)
- TCL (Transaction Control Language)

### SQL-DDL 
Lenguaje de Definición de Datos

Se utiliza para **crear y modificar la estructura** de una base de datos

Con DDL trabajamos sobre los objetos de la base de datos:

- Base de Datos
- Tablas
- Vistas
- Indices
- Restricciones
- Esquemas
- Funciones 
- Procedimientos Almacenados
- Disparadores 

**Comandos Principales**  

| Comando | Función |
| :--- | :--- |
| Create | Crear Objetos |
| Alter  | Modificar Objetos |
| Drop  | Eliminar Objetos |
| Truncate  | Vacia una tabla |
| Rename  | Renombra objetos (Segun el SGBD) |

### SQL- DML

**Lenguaje de manipulación de datos**

Sirve para **trabajar con la información almacenada**

Nota: Aquí no cambia la estructura, sino los registros

**Comandos Principales**

| Comando | Función |
| :--- | :--- |
| INSERT | Inserta Registros |
| UPDATE  | Actualiza Registros |
| DELETE  | Elimina Registros |

### SQL-DQL

**Lenguaje de consulta de datos**

Su función es **Consultar Información**

**Comando Principal**

| Comando | Función |
| :--- | :--- |
| SELECT | Consultar Información |

Generalmente se combina con:

- WHERE
- ORDER BY
- GROUP BY
- HAVING
- JOIN (LEFT, RIGHT, INNER, CROSS, FULL)
- DISTINCT
- TOP / LIMIT
- FUNCIONES DE AGREGADO
- FUNCIONES DE VENTANA


## Nomenclatura de Construcción 

Utilizaremos la convención **snake_case**

| Objeto | Convención | Ejemplo |
| :--- | :--- | :--- | 
| Base de Datos | snake_case | control_escolar | 
| Esquema | snake_case | ventas, rh, seguridad | 
| Tabla | Singular en snake_case | cliente, pedido, detalle_pedido | 
| Columna | snake_case | cliente_id, fecha_registro, correo_electronico | 
| PK | <tabla>_id | cliente_id, producto_id |
| FK | Igual que la PK referenciada | cliente_id, categoria_id|
| Tabla puente | <tabla1>_<tabla2> | alumno_curso, producto_proveedor|

**Restricciones**

pk_cliente
fk_pedido_cliente
uq_cliente_correo_electronico
ck_producto_precio
df_cliente_activo


### DDL en SQL Server CREATE, ALTER Y DROP para la creación y modificación de tablas

**Sintaxis de creación de tablas**

```sql 
  CREATE TABLE nombre_tabla
  (
    columna tipo_dato restricciones, 
    columna tipo_dato restricciones
  ) 
```
### Alter Table 

Permite modificar una tabla existente

Puede:

- Agregar columnas
- Eliminar Columnas
- modificar columnas
- agregar restricciones
- eliminar restricciones
