# EJERCICIOS DEL MODELO E-R 
## EJERCICIO 1.

**UN HOSPITAL REGISTRA INFROMACION DE SUS PACIENTES:**

> **DE CADA PACIENTE SE ALMACENA:**
- numero de pasciente que lo identifica
- Nombre
- Fecha de Naciemiento

> **De cada expediente medico se almacena**
- Numero de expediente
- Fecha de apertura
- Tipo de Sangre

> **Reglas del Negocio**
1. Cada pasciente debe tener exactamente  un expediente medico
2. Cada expediente medico pertenece  a un unico pasciente 
3. No puede existir un expediente sin pasciente
4. No puede existir un pasciente     sin expediente

> **Que se debe realizar:**

- Identificar las entidades
- Identifcar atributos
- Dibujar las relaciones
- Determinar la cardianlidad 
- Determinar la participacion de cada entidad

![Ejercicio1](/img/ER/Base%20de%20datos.drawio.png)

## EJERCICIO 2.

Una universidad administra profesores y cursos

> **De cada profesor se alamcena:**

- Numero de profesor ID
- Nombre
-Especialidad

> **De cada Curso se almacena:**

- No. Curso
- Nombre del Curso
- Creditos

> Reglas del Negocio

1. Un Profesor puede impartir varios cursos
2. Un cruso solo puede ser impartido por un profesor.
3. Puede existir un profesor que actualmente no imparta cursos
4. Todo curso debe estar asigando a un profesor

![Ejercicio2](/img/ER/Curso.drawio.png)

## Ejercicio 3.

Una escuela administra alumnos y materias

> **De cada Alumno almacena:**

- Matricula
- Nombre
- Semestre

> **De cada Materia se almacena:**

- ClaveMateria
- NombreMateria
- Creditos

> **Reglas del Negocio**

1. Un alumno puede incribirse en varias materias
2. Una materia puede tener muchis alumnos inscritos
3. Puede existir una materia sin alumno inscritos
4. Todo alumno debe estar inscrito en almenos una materia 
5. De cada inscritpcion se desea almacenar:
   - FechaInscripcion
   - CalificacionFnal
Nota: A la relacion nombrarla **Inscribe**

![Ejercici03](/img/ER/Universidad.drawio.png)

## EJercicio 4.

Una empresa dedicada al por mayor necesita registrar lo siguiente:

> **Para los clientes:**

- NoCliente
- Nombre ( el cual es una persona moral)

> **Pedidos**

- NoPedido
- FechaPedido

> **Productos**

- NoProducto
- Nombre
- Precio

> **Reglas del Negocio**

1. Un cliente puede realizar muchos pedidos
2. Cada pedido pertenece a un solo producto
3. Un pedido contiene varios productos
4. Un producto puede aparecer en muchos pedidos
5. Un pedido debe contener al menos un producto
6. Un producto puede no haber sido vendido
7. El detalle del pedido no existe sin pedido
8. El detalle del pedido no existe sin producto
9. El detalle alamcena la cantidad vendida y el precio de venta 

![Ejercicio04](/img/ER/Diagrama%20sin%20título.drawio.png)