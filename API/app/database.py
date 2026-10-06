import os

import mysql.connector
from fastapi import HTTPException
from mysql.connector import Error


def get_db_connection():
    settings = {
        "host": os.getenv("DB_HOST"),
        "user": os.getenv("DB_USER"),
        "password": os.getenv("DB_PASSWORD"),
        "database": os.getenv("DB_NAME"),
    }
    missing = [name for name, value in (
        ("DB_HOST", settings["host"]),
        ("DB_USER", settings["user"]),
        ("DB_PASSWORD", settings["password"]),
        ("DB_NAME", settings["database"]),
    ) if not value]
    if missing:
        raise HTTPException(
            status_code=500,
            detail=f"Faltan variables de conexión a MySQL: {', '.join(missing)}",
        )

    try:
        return mysql.connector.connect(**settings)
    except Error as e:
        print(f"Error al conectar a la base de datos: {e}")
        raise HTTPException(
            status_code=500,
            detail="Error de conexión a la base de datos.",
        ) from e
