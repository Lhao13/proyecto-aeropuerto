CREATE DATABASE  IF NOT EXISTS `proyecto_aeropuerto` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `proyecto_aeropuerto`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: proyecto_aeropuerto
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `vuelo`
--

DROP TABLE IF EXISTS `vuelo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vuelo` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `fecha_salida` date DEFAULT NULL,
  `hora_salida` time DEFAULT NULL,
  `Aerolinea_ID` int NOT NULL,
  `Aeronave_ID` int NOT NULL,
  `Origen_ID` int NOT NULL,
  `Destino_ID` int NOT NULL,
  PRIMARY KEY (`ID`,`Aerolinea_ID`,`Aeronave_ID`,`Origen_ID`,`Destino_ID`),
  KEY `fk_Vuelos_Aerolinea1_idx` (`Aerolinea_ID`),
  KEY `fk_Vuelo_Aeronave1_idx` (`Aeronave_ID`),
  KEY `fk_Vuelo_Origen_Destino1_idx` (`Origen_ID`),
  KEY `fk_Vuelo_Origen_Destino2_idx` (`Destino_ID`),
  CONSTRAINT `fk_Vuelo_Aeronave1` FOREIGN KEY (`Aeronave_ID`) REFERENCES `aeronave` (`ID`),
  CONSTRAINT `fk_Vuelo_Origen_Destino1` FOREIGN KEY (`Origen_ID`) REFERENCES `origen_destino` (`ID`),
  CONSTRAINT `fk_Vuelo_Origen_Destino2` FOREIGN KEY (`Destino_ID`) REFERENCES `origen_destino` (`ID`),
  CONSTRAINT `fk_Vuelos_Aerolinea1` FOREIGN KEY (`Aerolinea_ID`) REFERENCES `aerolinea` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vuelo`
--

LOCK TABLES `vuelo` WRITE;
/*!40000 ALTER TABLE `vuelo` DISABLE KEYS */;
/*!40000 ALTER TABLE `vuelo` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-30 22:58:34
