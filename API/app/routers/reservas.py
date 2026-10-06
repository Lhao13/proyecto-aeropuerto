import mysql.connector
from mysql.connector import Error
from fastapi import FastAPI, Response, status, HTTPException, Query, Request, APIRouter
from fastapi.params import Body
from pydantic import BaseModel
from typing import List, Dict
from app.database import get_db_connection

router = APIRouter(
    tags=["Reserva"],
)

# Función lambda para ejecutar el procedimiento de inserción de nueva reserva
@router.post("/reserva/")
async def insertar_reserva(pasajero_dni: int, tipo_viaje_id: int):
    try:
        # Conectar a la base de datos
        conn = get_db_connection()
        cursor = conn.cursor()

        # Llamar al procedimiento almacenado
        cursor.callproc('InsertarNuevaReserva', [pasajero_dni, tipo_viaje_id])
        
        # Confirmar que se ha ejecutado la transacción
        conn.commit()

        # Cerrar conexión
        cursor.close()
        conn.close()

        return {"message": "Reserva insertada exitosamente"}

    except mysql.connector.Error as err:
        # Manejo de errores de MySQL
        raise HTTPException(status_code=500, detail=f"Error al insertar la reserva: {err}")

@router.delete("/reserva/{reserva_id}")
async def eliminar_reserva(reserva_id: int):
    try:
        # Establecer conexión a la base de datos
        connection = get_db_connection()
        cursor = connection.cursor()

        # Llamar al procedimiento almacenado
        cursor.callproc('EliminarReservaYActualizarAsientos', [reserva_id])

        # Confirmar cambios
        connection.commit()

        return {"message": f"La reserva con ID {reserva_id} ha sido eliminada exitosamente."}

    except Error as e:
        # Manejo de errores en la base de datos
        raise HTTPException(status_code=500, detail=f"Error al eliminar la reserva: {e}")

    finally:
        # Cerrar cursor y conexión
        if cursor:
            cursor.close()
        if connection:
            connection.close()
'''
@router.get("/reservas_boleto/{dni}")
async def get_reservas_pasajero(dni: int):
    try:
        # Conexión a la base de datos
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Consulta a la vista para obtener todas las reservas de un pasajero específico
        query = "SELECT * FROM vista_reservas_pasajero WHERE dni_pasajero = %s"
        cursor.execute(query, (dni,))
        resultados = cursor.fetchall()

        # Cerrar conexión
        cursor.close()
        conn.close()

        # Validar si se encontraron resultados
        if not resultados:
            raise HTTPException(status_code=404, detail="No se encontraron reservas para el pasajero")

        # Devolver las reservas como un diccionario
        return resultados

    except Exception as e:
        # Manejo de excepciones
        raise HTTPException(status_code=500, detail=str(e))
'''
@router.get("/reservas/{dni}", response_model=List[Dict])
async def get_reservas(dni: int):
    try:
        # Conexión a la base de datos
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Consulta a la vista con filtro por DNI del pasajero
        query = "SELECT * FROM vista_reservas_pasajero WHERE pasajero_dni = %s"
        cursor.execute(query, (dni,))
        resultados = cursor.fetchall()

        # Cerrar conexión
        cursor.close()
        conn.close()

        # Validar si se encontraron resultados
        if not resultados:
            raise HTTPException(status_code=404, detail="No se encontraron reservas para el pasajero")

        return resultados

    except Exception as e:
        # Manejo de excepciones
        raise HTTPException(status_code=500, detail=str(e))