import mysql.connector
from mysql.connector import Error
from fastapi import FastAPI, Response, status, HTTPException, Query, Request, APIRouter
from fastapi.params import Body
from pydantic import BaseModel
from typing import List, Dict
from app.database import get_db_connection

router = APIRouter(
    tags=["Pasajero"],
)

# Modelo para el cuerpo de la solicitud
class Pasajero(BaseModel):
    dni: int
    nombre: str
    apellido: str
    fecha_nacimiento: str
    correo: str
    telefono: str

# agregar un nuevo pasajero         
@router.post("/pasajero/")
async def insertar_pasajero(dni: int, nombre: str, apellido: str, fecha_nacimiento: str, correo: str, telefono: str):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        # Llamar al procedimiento almacenado
        cursor.callproc("InsertarNuevoPasajero", [dni, nombre, apellido, fecha_nacimiento, correo, telefono])
        connection.commit()
        
        return {"message": "Pasajero insertado exitosamente"}
    
    except mysql.connector.Error as e:
        connection.rollback()
        raise HTTPException(status_code=500, detail=f"Error al insertar el pasajero: {e}")
    
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()
    
@router.post("/boleto/")
async def insertar_boleto(fisico: bool, Reserva_ID: int, Asiento_Vuelo_ID: int, Asiento_numero_asiento: int):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        # Llamar al procedimiento almacenado
        cursor.callproc("InsertarBoletoYActualizar", [fisico, Reserva_ID, Asiento_Vuelo_ID, Asiento_numero_asiento])
        connection.commit()
        
        return {"message": "boleto insertado exitosamente"}
    
    except mysql.connector.Error as e:
        connection.rollback()
        raise HTTPException(status_code=500, detail=f"Error al insertar el boleto: {e}")
    
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

@router.post("/maleta/")
async def insertar_maleta(peso: float, reserva_id: int):
    try:
        # Establecer conexión con la base de datos
        conn = get_db_connection()
        cursor = conn.cursor()

        # Llamar al procedimiento almacenado
        cursor.callproc('InsertarMaleta', [peso, reserva_id])

        # Confirmar la transacción
        conn.commit()

        return {"mensaje": "Maleta insertada correctamente."}

    except Error as e:
        # Manejar errores de MySQL
        raise HTTPException(status_code=400, detail=f"Error al insertar maleta: {str(e)}")

    finally:
        # Cerrar el cursor y la conexión
        if cursor:
            cursor.close()
        if conn:
            conn.close()

@router.delete("/pasajero/{dni}")
async def eliminar_pasajero(dni: int):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Llamar al procedimiento almacenado
        cursor.callproc("EliminarPasajeroYActualizarAsientos", [dni])
        
        # Confirmar cambios
        conn.commit()

        return {"message": f"Pasajero con DNI {dni} eliminado correctamente y asientos actualizados."}

    except Error as e:
        # En caso de error, revertir la transacción y mostrar mensaje
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Error al eliminar pasajero: {str(e)}")

    finally:
        # Cerrar conexión a la base de datos
        if conn.is_connected():
            cursor.close()
            conn.close()

@router.put("/pasajero/")
async def actualizar_datos_pasajero(dni: int, nombre: str, apellido: str, fecha_nacimiento: str, correo: str, telefono: str):
    try:
        # Establecer conexión con la base de datos
        conn = get_db_connection()
        cursor = conn.cursor()

        # Llamar al procedimiento almacenado
        cursor.callproc("ActualizarDatosPasajero", [dni, nombre, apellido, fecha_nacimiento, correo, telefono])

        # Commit de la transacción
        conn.commit()

        # Verificar si hubo algún cambio
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Pasajero no encontrado o no se realizaron cambios")

        # Cerrar la conexión
        cursor.close()
        conn.close()

        return {"message": "Datos del pasajero actualizados con éxito"}

    except Error as e:
        # Manejo de excepciones de MySQL
        if conn:
            conn.rollback()
        raise HTTPException(status_code=500, detail=f"Error al actualizar los datos del pasajero: {e}")

    finally:
        # Asegurarse de cerrar la conexión
        if conn and conn.is_connected():
            conn.close()

@router.get("/pasajero/existe/", response_model=Dict)
async def verificar_pasajero(dni: int, nombre: str):
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)
        
        # Consulta a la base de datos
        query = """
            SELECT * 
            FROM pasajero 
            WHERE DNI = %s AND Nombre = %s
        """
        cursor.execute(query, (dni, nombre))
        resultado = cursor.fetchone()
        
        # Cerrar conexión
        cursor.close()
        connection.close()

        if resultado:
            return {"message": "Pasajero encontrado", "pasajero": resultado}
        else:
            raise HTTPException(status_code=404, detail="Pasajero no encontrado")
    
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Error en la base de datos: {e}")