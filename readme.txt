# Sistema de Gestión de Operaciones Aeroportuarias

Proyecto final de bases de datos. La aplicación permite registrar o identificar pasajeros, crear y consultar sus reservas, buscar vuelos por destino, consultar información del vuelo y sus asientos, y agregar boletos y maletas.

## Arquitectura y flujo general

La solución tiene tres componentes principales:

1. **Aplicación móvil (Flutter):**  
   Interfaz con la que el usuario registra o identifica un pasajero, administra sus reservas y selecciona un vuelo, asiento y boleto.

2. **API (FastAPI):**  
   Recibe las solicitudes HTTP de Flutter, valida y transforma los parámetros, consulta MySQL o llama a sus procedimientos almacenados, y devuelve respuestas en formato JSON.

3. **Base de datos (MySQL):**  
   Guarda las entidades y relaciones aeroportuarias. Sus claves foráneas mantienen la integridad; sus vistas simplifican consultas de lectura y sus procedimientos almacenados centralizan operaciones de escritura y cambios relacionados.

### Flujo general

```text
Flutter → API FastAPI → MySQL → API (respuesta JSON) → Flutter
```

La API abre una conexión a MySQL para cada operación. Las escrituras llaman procedimientos almacenados y confirman los cambios; las lecturas consultan tablas o vistas.

La API también devuelve errores HTTP cuando no encuentra registros o la base de datos rechaza una operación.

---

## Flujo de uso de la aplicación

### 1. Inicio y pasajero

La pantalla inicial permite registrar un pasajero o buscar uno existente por DNI y nombre.

- Registro: `POST /pasajero/`
- Búsqueda: `GET /pasajero/existe/`
- Procedimiento utilizado: `InsertarNuevoPasajero`

### 2. Reservas

Una vez identificado el pasajero, Flutter consulta sus reservas mediante:

```http
GET /reservas/{dni}
```

El usuario puede crear una reserva indicando el tipo de viaje:

- Ida
- Ida y vuelta
- Múltiple

Para crear una reserva se utiliza:

```http
POST /reserva/
```

La lista de reservas se obtiene de la vista `vista_reservas_pasajero`.

Desde esta pantalla también se pueden:

- Actualizar los datos del pasajero.
- Eliminar los datos del pasajero.
- Eliminar una reserva.

### 3. Búsqueda y selección de vuelo

Desde una reserva, el usuario puede buscar vuelos por código o nombre de destino.

La API consulta la vista `vista_vuelos_por_destino_fecha` mediante:

```http
GET /vuelos/destino/?codigo_o_nombre=...
```

Para obtener información adicional del vuelo se utiliza:

```http
GET /data/{vuelo_id}
```

Este endpoint obtiene los datos a partir de la vista `Detalles_Vuelo`.

### 4. Asientos y boleto

Al seleccionar un vuelo, Flutter solicita sus asientos mediante:

```http
GET /asientos/{vuelo_id}
```

Este endpoint consulta la vista `Vista_Asientos`.

La interfaz muestra el estado y precio de cada asiento.

Al confirmar un asiento, la aplicación envía:

```http
POST /boleto/
```

El procedimiento `InsertarBoletoYActualizar` registra el boleto y actualiza el estado del asiento asociado.

### 5. Maletas y mantenimiento

Para registrar una maleta asociada a una reserva se utiliza:

```http
POST /maleta/
```

Las operaciones de mantenimiento incluyen:

```http
PUT /pasajero/
DELETE /pasajero/{dni}
DELETE /reserva/{reserva_id}
```

La eliminación de una reserva permite liberar los asientos asociados según las reglas definidas en la base de datos.

### Dirección de la API en Android

La aplicación Flutter utiliza:

```text
10.0.2.2:8000
```

Esta dirección permite que el emulador Android acceda al servidor FastAPI que se ejecuta en el equipo anfitrión.

Si se utiliza un teléfono físico u otro emulador, se debe reemplazar esta dirección por la IP accesible del equipo donde se ejecuta FastAPI.

---

## Estructura del proyecto

```text
API/
└── app/
    ├── main.py
    ├── database.py
    └── routers/

flutter/
└── reservas_aviones/
    └── lib/

Proyecto_aeropuerto/
└── Scripts SQL
```

### Componentes principales

| Archivo / Carpeta | Descripción |
|---|---|
| `API/app/main.py` | Crea la aplicación FastAPI e incluye los routers. |
| `API/app/database.py` | Lee la configuración del servidor MySQL desde variables de entorno. |
| `API/app/routers/` | Contiene los endpoints de pasajero, vuelo, reserva, boleto y maleta. |
| `flutter/reservas_aviones/lib/` | Contiene las pantallas y el cliente HTTP de Flutter. |
| `Proyecto_aeropuerto/` | Contiene los scripts SQL de tablas, datos de referencia, vistas y procedimientos. |

---

## Modelo de datos

El modelo relacional cubre las siguientes entidades:

- Pasajeros
- Reservas
- Boletos
- Maletas
- Asientos
- Vuelos
- Aerolíneas
- Aeronaves
- Orígenes y destinos
- Países
- Puertas
- Asignaciones de puerta
- Tipos de viaje

Las principales relaciones conectan:

- Pasajero → Reserva
- Reserva → Boletos
- Reserva → Maletas
- Vuelo → Aeronave
- Vuelo → Aerolínea
- Vuelo → Origen/Destino
- Vuelo → Asientos
- Vuelo → Asignación de puerta

---

## Vistas

La base de datos incluye las siguientes vistas:

| Vista | Descripción |
|---|---|
| `Detalles_Vuelo` | Datos del vuelo, aerolínea, aeronave, ruta y puerta. |
| `vista_vuelos_por_destino_fecha` | Vuelos con horario, aerolínea y destino. |
| `Vista_Asientos` | Asientos, precio y estado para cada vuelo. |
| `vista_reservas_pasajero` | Reservas de un pasajero y cantidad de boletos. |
| `vista_aerolinea_origen` | Información de aerolíneas y país de origen. |

---

## Procedimientos almacenados

Entre los principales procedimientos almacenados se encuentran:

- `InsertarNuevoPasajero`
- `ActualizarDatosPasajero`
- `InsertarNuevaReserva`
- `EliminarReservaYActualizarAsientos`
- `EliminarPasajeroYActualizarAsientos`
- `InsertarBoletoYActualizar`
- `InsertarMaleta`
- `GenerarAsientos`
- `AsignarPuertasYHora`

Las operaciones de eliminación relacionadas actualizan los asientos y registros dependientes de acuerdo con las reglas definidas en SQL.

---

## Requisitos

- **MySQL Server 8.0** o compatible con los scripts exportados.
- **Python 3.10** o posterior para la API.
- **Flutter SDK 3.19.6**.
- **Dart SDK 3.3.4**.
- **Android Studio** y un emulador Android, o un dispositivo físico configurado para ejecutar Flutter.

---

## Instalación y ejecución

### 1. Preparar la base de datos

Inicia MySQL y carga los scripts de tablas de la carpeta `Proyecto_aeropuerto` utilizando MySQL Workbench o el cliente `mysql`.

Carga primero las tablas referenciadas y después las dependientes, siguiendo este orden:

```text
proyecto_aeropuerto_pais.sql
proyecto_aeropuerto_tipo de viaje.sql
proyecto_aeropuerto_tipo_puerta.sql
proyecto_aeropuerto_origen_destino.sql
proyecto_aeropuerto_aeronave.sql
proyecto_aeropuerto_pasajero.sql
proyecto_aeropuerto_puerta.sql
proyecto_aeropuerto_aerolinea.sql
proyecto_aeropuerto_vuelo.sql
proyecto_aeropuerto_asiento.sql
proyecto_aeropuerto_asignacion_puerta.sql
proyecto_aeropuerto_reserva.sql
proyecto_aeropuerto_boleto.sql
proyecto_aeropuerto_maleta.sql
```

Finalmente, carga:

```text
proyecto_aeropuerto_routines.sql
```

Este último script crea las vistas y los procedimientos almacenados.

El usuario de MySQL que ejecute los scripts debe tener permisos para crear:

- Tablas
- Vistas
- Rutinas

> **Nota:** Si MySQL informa que no existe el `DEFINER root@localhost`, adapta el `DEFINER` del script a una cuenta local que tenga los permisos necesarios.

### Datos de ejemplo

Por privacidad, los `INSERT` con datos de ejemplo fueron retirados de todos los volcados SQL publicados.

Los scripts conservan:

- Tablas
- Relaciones
- Vistas
- Procedimientos almacenados

Sin embargo, la base de datos comienza vacía.

Para probar el flujo completo, agrega datos de referencia y vuelos, y posteriormente registra pasajeros y datos de prueba propios en tu base local.

---

### 2. Configurar y ejecutar la API

Abre una terminal de **PowerShell** en la carpeta `API`.

Define la conexión a MySQL en esa misma terminal:

```powershell
$env:DB_HOST = "localhost"
$env:DB_USER = "root"
$env:DB_PASSWORD = "<tu_contrasena_de_MySQL>"
$env:DB_NAME = "proyecto_aeropuerto"
```

> **Importante:** No guardes contraseñas directamente en el código ni las subas al repositorio.

Instala las dependencias:

```powershell
python -m pip install fastapi "uvicorn[standard]" mysql-connector-python
```

Ejecuta FastAPI:

```powershell
fastapi dev app\main.py
```

La API se iniciará en:

```text
http://127.0.0.1:8000
```

La documentación interactiva estará disponible en:

```text
http://127.0.0.1:8000/docs
```

---

### 3. Configurar y ejecutar Flutter

En otra terminal, entra en:

```text
flutter\reservas_aviones
```

Descarga las dependencias:

```powershell
flutter pub get
```

Inicia el emulador Android y ejecuta:

```powershell
flutter run
```

También puedes abrir la carpeta en VS Code y utilizar **Run and Debug**.

Asegúrate de que tanto **FastAPI** como **MySQL** continúen ejecutándose.

Si utilizas un dispositivo físico, reemplaza `10.0.2.2` en el cliente Flutter por la IP del equipo donde se ejecuta la API.

---

## Comprobación rápida

Una vez iniciados MySQL y FastAPI:

1. Abre:

   ```text
   http://127.0.0.1:8000/
   ```

   y comprueba que la API responda.

2. Abre:

   ```text
   http://127.0.0.1:8000/docs
   ```

   para explorar y probar los endpoints.

3. En la aplicación Flutter, registra un pasajero.

4. Crea una reserva.

5. Busca vuelos disponibles.

6. Consulta los asientos.

7. Prueba la selección de un asiento y la generación del boleto.

---

## Notas para el repositorio

Los documentos originales de referencia no se publican junto con el código.

Tampoco se incluyen:

- Credenciales.
- Registros de pasajeros.
- Datos sensibles.
- Tablas o registros relacionados con información personal.

La configuración de MySQL se proporciona mediante **variables de entorno** para evitar almacenar secretos directamente en el repositorio.
