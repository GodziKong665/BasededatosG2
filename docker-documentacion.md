## Contenedor de Tutorial de Docker
![imagen Docker](./img/Gemini_Generated_Image_708zmz708zmz708z.png)
docker pull docker/getting-started

docker run -d -p 80:80 docker/getting-started

- -d detach (El proceso del contenedor se ejuecuta en background)
- -p (port, publish) (Mapea el puerto)
- docker/getting-started (Nombre de la imagen)

## Contenedor del DBMS MariaBD
docker pull mariadb


## Contenedor de MariaDB sin volumen
docker run --name ServerMariaDBG2 -e MARIADB_ROOT_PASSWORD=123456 \
-d -p 3345:3306  e0236

## Contenedor de mariadb  con volumen
docker run --name ServerMariaDBG2 -e MARIADB_ROOT_PASSWORD=123456 \
-d -v V-MariaDBG2:/var/lib/mysql -p 3345:3306  e0236

## Contenedor de postgres  con volumen
docker run --name ServerPostgresG2 -e POSTGRES_PASSWORD=123456 \
-d -p 5457:5432 -v V-PostgreG2:/var/lib/potstgresql/data \
eba8d

## Contenedor de SQLServer 2022 con Volumen
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
-u 0 \
-p 1451:1433 --name SQLServerG3 \ 
-d -v v-sqlserverg2:/var/opt/mssql/data \
d01cc






## Comandos Docker
| Comando | Descripción | 
| :--- | :--- |
| docker pull nombre_imagen |
**Descarga una imagen de DockerHub**[Docker Hub](https://hub.docker.com/) |
| docker images | **Visualizar las imagenes que se encuentran en el docker** |
| docker ps| **Visualiza todos los contenedores que estan encendidos encendidos** |
| docker ps -a| **Visualiza todos los contenedores que estan encendidos encendidos o apagados** |
| docker stop idcontenedor o nombrecontenedor| **VDetiene un contenedor** | 
| docker start idcontenedor o nombrecontenedor| **Ensiden un contenedor** | 
| docker rm idcontenedor o nombrecontenedor| **ELimina un contenedor pero si esta apagado** | 
| docker rm -f idcontenedor o nombrecontenedor| **ELimina un contenedor pero si esta apagado** | 

