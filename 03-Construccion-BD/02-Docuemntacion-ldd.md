# Construccion de Base de Datos en SQL Server, My SQL y Postgress

Para la construccion de objetos de la base de datops se utilizara el lenguaje SQL (Structure Query Languaje)
se divide en "*Cinco Grandes Categorias*"

## SQL
> DDL (Data Definition Languaje)
> DDL (Data Manipulation Languaje)
> DQl (Data Query Languaje)
> DCL (Data Control Languaje)
> TCLc (Transaction Control Languaje)

## DDl
Lenguaje de Definicion de Datos

Se utiliza para **Crear y modificar la estructura** de una base de datos

Con DDL trabajamos sobre los objetos de la base de dtos:

- Base de Datos
- Tablas
- Vistas
- Indices
- Restricciones
- Esquemas
- Procedimientos Alamcenados
- Funciones
- Disparadores

**COMANDOS PRINCIPALES**

| Comando | Funcion |
| :--- | :--- |
|Create | crear Objetos |
|Alter | modificar Obejtos |
| Drop | Eliminar Objetos |
| Truncate | Vaciar una Tabla |
| Rename | Renombrar Objetpos segun en SGBD|

### SQL-DML

**Lenguaje de Manipulacion de Datos**

Sirve para **trabajar con la informacion almacenada**

Nota: Aqui no cambia la estructura, sino los registros

**Comandos Principales**

| Comando | Funcion |
| :--- | :--- |
|INSERT | Inserta registros |
|UPDATE | Actualiza registros |
|DELETE | Eliminar regitros |

### SQL_DQL

Su Funcion es **consultar informacion**

**Comando Principal**

| Comando | Funcion |
| :--- | :--- |
|SELECT | Consultar Informacion |

Generalmente se Combina con:

- WHERE
- ORDER BY
- GROUP BY
- HAVING
- JOIN (LEFT, RIGHT, INNER, CROSS, FULL)
- TOP / LIMIT
- FUNCIONES DE VENTANA 

## NOMENCLATURA DE CONSTRUCCION
Utilizaremos la convencion **Snake-case**

| Objeto | Convencion | Ejemplo |
| :--- | :--- | :--- |
| Base de Datos | snake_case | control_escolar |
| Esquema | snake_case | ventas, rh, seguridad |
| Tabla | snake_case | cliente, pedido, detalle,_pedido |
| Columna | snake_case | cliente_id, fecha_registro, correo_electronico |
| pk | <tabla_id> | cliente_id, producto_id |
| FK | Igual que las PK referenciada | cliente_id, categoria_id|
| Tabla puente | <tabla1>_<tabla2> | alumno_curso, producto_proveedor |
| FK | Igual que las PK referenciada | cliente_id, categoria_id|

**Restricciones**

pk_cliente
fk_pedio_cliente
uq_cliente_correo_electronico
ck_producto_precio
df_cliente_activo


### DDL EN SQL SERVER CREATE ALTER Y DROP para la creacion y modficacion de tablas

**Sintaxis de Creacion de Tablas**

```sql
CREATE TABLE nombre_tabla
(
    columna tipo_dato restricciones,
    columna tipo_dato restricciones
)
```










## SQL SERVER

```sql
CREATE
ALTER
DROP
```
