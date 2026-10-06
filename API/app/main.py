import mysql.connector
from mysql.connector import Error
from fastapi import FastAPI, Response, status, HTTPException, Query, Request
from fastapi.params import Body
from pydantic import BaseModel
from typing import List, Dict
from app.database import get_db_connection
from .routers import pasajero, vuelo, reservas


# Crear la app FastAPI
app = FastAPI()

app.include_router(pasajero.router)
app.include_router(vuelo.router)
app.include_router(reservas.router)

# Endpoint de prueba
@app.get("/")
def root():
    return {"message": "API de Aeropuerto funcionando correctamente"}