
import mysql.connector
from mysql.connector import Error
from fastapi import FastAPI, Response, status, HTTPException, Query, Request, APIRouter
from fastapi.params import Body
from pydantic import BaseModel
from typing import List, Dict
from app.database import get_db_connection

router = APIRouter(
    tags=["Vuelo"],
)

@router.get("/data/{vuelo_id}", response_model=List[dict])
async def obtener_detalles_vuelo(vuelo_id: int):
    try:
        # Conectar a la base de datos
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        # Consulta a la vista
        query = "SELECT * FROM Detalles_Vuelo WHERE Vuelo_ID = %s;"
        cursor.execute(query, (vuelo_id,))

        # Recuperar los resultados
        resultados = cursor.fetchall()

        # Manejo si no hay datos
        if not resultados:
            raise HTTPException(status_code=404, detail="No se encontró el vuelo con el ID proporcionado.")

        return resultados
    except mysql.connector.Error as e:
        raise HTTPException(status_code=500, detail=f"Error al conectar con la base de datos: {e}")
    finally:
        # Cerrar la conexión
        if cursor:
            cursor.close()
        if connection:
            connection.close()

# ve los asientos de un vuelo

@router.get("/asientos/{vuelo_id}")
def obtener_asientos(vuelo_id: int):
    try:
        # Conectar a la base de datos
        conn =get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Consulta para obtener los asientos
        query = "SELECT * FROM Vista_Asientos WHERE Vuelo_ID = %s"
        cursor.execute(query, (vuelo_id,))
        resultados = cursor.fetchall()

        # Verificar si se encontraron resultados
        if not resultados:
            raise HTTPException(status_code=404, detail="No se encontraron asientos para el vuelo proporcionado.")

        return resultados

    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Error al conectar con la base de datos: {err}")

    finally:
        # Cerrar conexiones
        cursor.close()
        conn.close()
'''     
@router.get("/aerolinea/{aerolinea_id}", response_model=Dict)
async def get_aerolinea(aerolinea_id: int):
    try:
        # Conexión a la base de datos
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Consulta a la vista con filtro por Aerolinea_ID
        query = "SELECT * FROM Vista_Aerolinea_Origen WHERE Aerolinea_ID = %s"
        cursor.execute(query, (aerolinea_id,))
        resultado = cursor.fetchone()

        # Cerrar conexión
        cursor.close()
        conn.close()

        # Validar si se encontró información
        if not resultado:
            raise HTTPException(status_code=404, detail="Aerolínea no encontrada")

        return resultado

    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Error en la base de datos: {str(err)}")
'''
    
@router.get("/vuelos/destino/")
async def obtener_vuelos_destino(codigo_o_nombre: str = Query(..., description="Parte del nombre del lugar destino")):
    """
    Obtiene vuelos desde la vista por destino basado en un código parcial del destino.
    """
    try:
        # Conexión a la base de datos
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)
        
        # Consulta SQL a la vista
        query = """
            SELECT * 
            FROM proyecto_aeropuerto.vista_vuelos_por_destino_fecha
            WHERE Codigo_Destino LIKE %s OR Destino LIKE %s;
        """
        # Se utiliza el parámetro proporcionado dos veces, para el código y el nombre
        cursor.execute(query, (f"%{codigo_o_nombre}%", f"%{codigo_o_nombre}%"))
        resultados = cursor.fetchall()
        
        # Verificar si hay resultados
        if not resultados:
            raise HTTPException(status_code=404, detail="No se encontraron vuelos para el destino especificado.")
        
        # Cerrar conexión
        cursor.close()
        connection.close()
        
        return resultados
    
    except mysql.connector.Error as err:
        # Manejo de errores de MySQL
        raise HTTPException(status_code=500, detail=f"Error de la base de datos: {err}")
