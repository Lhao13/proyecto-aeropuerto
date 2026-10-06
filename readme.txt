SISTEMA DE GESTION DE OPERACIONES AEROPORTUARIAS
================================================

Proyecto final de bases de datos. La aplicacion permite registrar o identificar
pasajeros, crear y consultar sus reservas, buscar vuelos por destino, consultar
informacion del vuelo y sus asientos, y agregar boletos y maletas.

ARQUITECTURA Y FLUJO GENERAL
----------------------------

La solucion tiene tres componentes:

1. Aplicacion movil (Flutter):
   Interfaz con la que el usuario registra o identifica un pasajero, administra
   sus reservas y selecciona un vuelo, asiento y boleto.
2. API (FastAPI):
   Recibe las solicitudes HTTP de Flutter, valida y transforma los parametros,
   consulta MySQL o llama a sus procedimientos almacenados, y devuelve JSON.
3. Base de datos (MySQL):
   Guarda las entidades y relaciones aeroportuarias. Sus claves foraneas
   mantienen la integridad; sus vistas simplifican consultas de lectura y sus
   procedimientos almacenados centralizan operaciones de escritura y cambios
   relacionados.

El flujo normal es:

Flutter -> API FastAPI -> MySQL -> API (respuesta JSON) -> Flutter

La API abre una conexion a MySQL para cada operacion. Las escrituras llaman
procedimientos almacenados y confirman los cambios; las lecturas consultan
tablas o vistas. La API tambien devuelve errores HTTP cuando no encuentra
registros o la base de datos rechaza una operacion.

FLUJO DE USO DE LA APLICACION
-----------------------------

1. Inicio y pasajero
   La pantalla inicial permite registrar un pasajero o buscar uno existente
   por DNI y nombre. El alta usa POST /pasajero/ y el procedimiento
   InsertarNuevoPasajero. La busqueda usa GET /pasajero/existe/.

2. Reservas
   Una vez identificado el pasajero, Flutter consulta sus reservas con
   GET /reservas/{dni}. El usuario puede crear una reserva indicando el tipo
   de viaje (ida, ida y vuelta o multiple), mediante POST /reserva/. La lista
   se obtiene de la vista vista_reservas_pasajero. Desde esta pantalla tambien
   se pueden actualizar o eliminar los datos del pasajero y eliminar una
   reserva.

3. Busqueda y seleccion de vuelo
   Desde una reserva, el usuario busca vuelos por codigo o nombre de destino.
   La API consulta vista_vuelos_por_destino_fecha mediante
   GET /vuelos/destino/?codigo_o_nombre=... . GET /data/{vuelo_id} obtiene
   informacion adicional del vuelo a partir de la vista Detalles_Vuelo.

4. Asientos y boleto
   Al seleccionar un vuelo, Flutter solicita sus asientos mediante
   GET /asientos/{vuelo_id}, que consulta Vista_Asientos. La interfaz indica el
   estado y precio de cada asiento. Al confirmar uno, envia POST /boleto/;
   InsertarBoletoYActualizar registra el boleto y actualiza el estado del
   asiento asociado.

5. Maletas y mantenimiento
   POST /maleta/ registra una maleta asociada a la reserva. Las operaciones de
   mantenimiento incluyen PUT /pasajero/ para actualizar datos, DELETE
   /pasajero/{dni} para eliminar un pasajero y sus relaciones, y DELETE
   /reserva/{reserva_id} para eliminar una reserva y liberar los asientos
   asociados.

La aplicacion Flutter usa 10.0.2.2:8000 como direccion de la API, que apunta
al equipo anfitrion desde el emulador Android. Para un telefono fisico u otro
emulador, cambia esa direccion por la IP accesible del equipo donde se ejecuta
FastAPI.

ESTRUCTURA DEL PROYECTO
-----------------------

API/app/main.py
    Crea la aplicacion FastAPI e incluye los routers.
API/app/database.py
    Lee la configuracion del servidor MySQL desde variables de entorno.
API/app/routers/
    Endpoints de pasajero, vuelo, reserva, boleto y maleta.
flutter/reservas_aviones/lib/
    Pantallas y cliente HTTP de Flutter.
Proyecto_aeropuerto/
    Scripts SQL de tablas, datos de referencia y vistas/procedimientos.

El modelo relacional cubre pasajeros, reservas, boletos, maletas, asientos,
vuelos, aerolineas, aeronaves, origenes/destinos, paises, puertas, asignaciones
de puerta y tipos de viaje. Las relaciones principales conectan pasajero con
reserva; reserva con boletos y maletas; vuelo con aeronave, aerolinea,
origen/destino y asientos; y vuelo con asignacion de puerta.

Vistas incluidas:
- Detalles_Vuelo: datos del vuelo, aerolinea, aeronave, ruta y puerta.
- vista_vuelos_por_destino_fecha: vuelos con horario, aerolinea y destino.
- Vista_Asientos: asientos, precio y estado para cada vuelo.
- vista_reservas_pasajero: reservas de un pasajero y cantidad de boletos.
- vista_aerolinea_origen: informacion de aerolineas y pais de origen.

Entre los procedimientos almacenados estan InsertarNuevoPasajero,
ActualizarDatosPasajero, InsertarNuevaReserva,
EliminarReservaYActualizarAsientos, EliminarPasajeroYActualizarAsientos,
InsertarBoletoYActualizar, InsertarMaleta, GenerarAsientos y
AsignarPuertasYHora. Las operaciones de eliminacion relacionadas actualizan
los asientos y registros dependientes segun las reglas definidas en SQL.

REQUISITOS
----------

- MySQL Server 8.0 o compatible con los scripts exportados.
- Python 3.10 o posterior para la API.
- Flutter SDK 3.19.6 y Dart SDK 3.3.4 (versiones usadas en el proyecto).
- Android Studio y un emulador Android, o un dispositivo configurado para
  ejecutar Flutter.

INSTALACION Y EJECUCION
-----------------------

1. Preparar la base de datos

   Inicia MySQL y carga los scripts de tablas de la carpeta
   Proyecto_aeropuerto usando MySQL Workbench o el cliente mysql. Carga primero
   las tablas referenciadas y despues las dependientes, en este orden:

   - proyecto_aeropuerto_pais.sql
   - proyecto_aeropuerto_tipo de viaje.sql
   - proyecto_aeropuerto_tipo_puerta.sql
   - proyecto_aeropuerto_origen_destino.sql
   - proyecto_aeropuerto_aeronave.sql
   - proyecto_aeropuerto_pasajero.sql
   - proyecto_aeropuerto_puerta.sql
   - proyecto_aeropuerto_aerolinea.sql
   - proyecto_aeropuerto_vuelo.sql
   - proyecto_aeropuerto_asiento.sql
   - proyecto_aeropuerto_asignacion_puerta.sql
   - proyecto_aeropuerto_reserva.sql
   - proyecto_aeropuerto_boleto.sql
   - proyecto_aeropuerto_maleta.sql

   Carga proyecto_aeropuerto_routines.sql al final para crear las vistas y los
   procedimientos almacenados. El usuario de MySQL que ejecute los scripts
   debe tener permisos para crear tablas, vistas y rutinas. Si MySQL informa
   que no existe el DEFINER root@localhost, adapta el DEFINER en el script a
   una cuenta local con los permisos necesarios.

   Por privacidad, los INSERT con datos de ejemplo se retiraron de todos los
   volcados SQL publicados. Los scripts conservan las tablas, relaciones,
   vistas y procedimientos, pero la base empieza vacia. Para probar el flujo
   completo, agrega datos de referencia y vuelos, y luego registra pasajeros
   y datos de prueba propios en tu base local.

2. Configurar y ejecutar la API (PowerShell)

   Abre una terminal en la carpeta API y define la conexion a MySQL en esa
   misma terminal. No guardes contrasenas en el codigo ni las subas al repo:

   $env:DB_HOST = "localhost"
   $env:DB_USER = "root"
   $env:DB_PASSWORD = "<tu_contrasena_de_MySQL>"
   $env:DB_NAME = "proyecto_aeropuerto"

   Instala las dependencias y ejecuta FastAPI:

   python -m pip install fastapi "uvicorn[standard]" mysql-connector-python
   fastapi dev app\main.py

   La API se inicia en http://127.0.0.1:8000. Su documentacion interactiva
   esta disponible en http://127.0.0.1:8000/docs.

3. Configurar y ejecutar Flutter

   En otra terminal, entra en flutter\reservas_aviones y descarga las
   dependencias:

   flutter pub get

   Inicia el emulador Android y ejecuta flutter run, o abre esa carpeta en
   VS Code y usa Run and Debug. Asegurate de que FastAPI y MySQL sigan
   ejecutandose. Si usas un dispositivo fisico, sustituye en el cliente la
   direccion 10.0.2.2 por la IP del equipo que ejecuta la API.

COMPROBACION RAPIDA
-------------------

1. Abre http://127.0.0.1:8000/ y comprueba que la API responda.
2. Abre http://127.0.0.1:8000/docs para explorar y probar los endpoints.
3. En la app, registra un pasajero y crea una reserva.
4. Busca vuelos, consulta sus asientos y prueba la seleccion de un asiento.

NOTAS PARA EL REPOSITORIO
-------------------------

Los documentos originales de referencia no se publican junto al codigo.
Tampoco se incluyen credenciales ni los registros de pasajeros y las tablas
que los relacionan. La configuracion de MySQL se proporciona mediante
variables de entorno para evitar guardar secretos en el repositorio.
