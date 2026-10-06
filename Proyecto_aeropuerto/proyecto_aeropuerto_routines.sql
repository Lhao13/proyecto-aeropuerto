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
-- Temporary view structure for view `detalles_vuelo`
--

DROP TABLE IF EXISTS `detalles_vuelo`;
/*!50001 DROP VIEW IF EXISTS `detalles_vuelo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `detalles_vuelo` AS SELECT 
 1 AS `Vuelo_ID`,
 1 AS `Aerolinea`,
 1 AS `Peso_maximo_maleta`,
 1 AS `Precio_maleta`,
 1 AS `Pais_Origen_Aerolinea`,
 1 AS `Modelo_Aeronave`,
 1 AS `Origen`,
 1 AS `Destino`,
 1 AS `Numero_Puerta`,
 1 AS `Terminal`,
 1 AS `Tipo_Puerta`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_aerolinea_origen`
--

DROP TABLE IF EXISTS `vista_aerolinea_origen`;
/*!50001 DROP VIEW IF EXISTS `vista_aerolinea_origen`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_aerolinea_origen` AS SELECT 
 1 AS `Aerolinea_ID`,
 1 AS `Nombre_Aerolinea`,
 1 AS `Contacto`,
 1 AS `Peso_Maximo`,
 1 AS `Precio_Maleta_Exceso`,
 1 AS `Origen`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_reservas_pasajero`
--

DROP TABLE IF EXISTS `vista_reservas_pasajero`;
/*!50001 DROP VIEW IF EXISTS `vista_reservas_pasajero`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_reservas_pasajero` AS SELECT 
 1 AS `reserva_id`,
 1 AS `precio_total_reserva`,
 1 AS `fecha_creacion_reserva`,
 1 AS `pasajero_dni`,
 1 AS `pasajero_nombre_completo`,
 1 AS `numero_boletos`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_vuelos_por_destino_fecha`
--

DROP TABLE IF EXISTS `vista_vuelos_por_destino_fecha`;
/*!50001 DROP VIEW IF EXISTS `vista_vuelos_por_destino_fecha`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_vuelos_por_destino_fecha` AS SELECT 
 1 AS `Vuelo_ID`,
 1 AS `Fecha_Salida`,
 1 AS `Hora_Salida`,
 1 AS `Aerolinea`,
 1 AS `Destino`,
 1 AS `Codigo_destino`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_asientos`
--

DROP TABLE IF EXISTS `vista_asientos`;
/*!50001 DROP VIEW IF EXISTS `vista_asientos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_asientos` AS SELECT 
 1 AS `Vuelo_ID`,
 1 AS `numero_asiento`,
 1 AS `Precio_Asiento`,
 1 AS `Estado_Asiento`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `detalles_vuelo`
--

/*!50001 DROP VIEW IF EXISTS `detalles_vuelo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `detalles_vuelo` AS select `v`.`ID` AS `Vuelo_ID`,`a`.`nombre_aerolinea` AS `Aerolinea`,`a`.`peso_max` AS `Peso_maximo_maleta`,`a`.`precio_maleta_mayor1` AS `Precio_maleta`,`p`.`Pais` AS `Pais_Origen_Aerolinea`,`ae`.`modelo` AS `Modelo_Aeronave`,`o`.`Aeropuerto` AS `Origen`,`d`.`Aeropuerto` AS `Destino`,`pu`.`numero_puerta` AS `Numero_Puerta`,`pu`.`terminal` AS `Terminal`,`tp`.`tipo` AS `Tipo_Puerta` from ((((((((`vuelo` `v` join `aerolinea` `a` on((`v`.`Aerolinea_ID` = `a`.`ID`))) join `pais` `p` on((`a`.`Pais_ID` = `p`.`ID`))) join `aeronave` `ae` on((`v`.`Aeronave_ID` = `ae`.`ID`))) join `origen_destino` `o` on((`v`.`Origen_ID` = `o`.`ID`))) join `origen_destino` `d` on((`v`.`Destino_ID` = `d`.`ID`))) left join `asignacion_puerta` `ap` on((`v`.`ID` = `ap`.`Vuelo_ID`))) left join `puerta` `pu` on((`ap`.`Puerta_ID` = `pu`.`ID`))) left join `tipo_puerta` `tp` on((`pu`.`tipo_puerta_ID` = `tp`.`ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_aerolinea_origen`
--

/*!50001 DROP VIEW IF EXISTS `vista_aerolinea_origen`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_aerolinea_origen` AS select `ae`.`ID` AS `Aerolinea_ID`,`ae`.`nombre_aerolinea` AS `Nombre_Aerolinea`,`ae`.`contacto` AS `Contacto`,`ae`.`peso_max` AS `Peso_Maximo`,`ae`.`precio_maleta_mayor1` AS `Precio_Maleta_Exceso`,`p`.`Pais` AS `Origen` from (`aerolinea` `ae` join `pais` `p` on((`ae`.`Pais_ID` = `p`.`ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_reservas_pasajero`
--

/*!50001 DROP VIEW IF EXISTS `vista_reservas_pasajero`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_reservas_pasajero` AS select `r`.`ID` AS `reserva_id`,`r`.`precio_total` AS `precio_total_reserva`,`r`.`fecha_reserva` AS `fecha_creacion_reserva`,`p`.`DNI` AS `pasajero_dni`,concat(`p`.`nombre`,' ',`p`.`apellido`) AS `pasajero_nombre_completo`,count(`b`.`Reserva_ID`) AS `numero_boletos` from ((`reserva` `r` join `pasajero` `p` on((`r`.`Pasajero_DNI` = `p`.`DNI`))) left join `boleto` `b` on((`b`.`Reserva_ID` = `r`.`ID`))) group by `r`.`ID`,`r`.`precio_total`,`r`.`fecha_reserva`,`p`.`DNI`,`p`.`nombre`,`p`.`apellido` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_vuelos_por_destino_fecha`
--

/*!50001 DROP VIEW IF EXISTS `vista_vuelos_por_destino_fecha`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_vuelos_por_destino_fecha` AS select `v`.`ID` AS `Vuelo_ID`,`v`.`fecha_salida` AS `Fecha_Salida`,time_format(`v`.`hora_salida`,'%H:%i') AS `Hora_Salida`,`ae`.`nombre_aerolinea` AS `Aerolinea`,`od`.`Aeropuerto` AS `Destino`,`od`.`Codigo_lugar` AS `Codigo_destino` from ((`vuelo` `v` join `aerolinea` `ae` on((`v`.`Aerolinea_ID` = `ae`.`ID`))) join `origen_destino` `od` on((`v`.`Destino_ID` = `od`.`ID`))) where ((`v`.`fecha_salida` is not null) and (`od`.`Aeropuerto` is not null)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_asientos`
--

/*!50001 DROP VIEW IF EXISTS `vista_asientos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_asientos` AS select `a`.`Vuelo_ID` AS `Vuelo_ID`,`a`.`numero_asiento` AS `numero_asiento`,`a`.`precio` AS `Precio_Asiento`,`a`.`Estado` AS `Estado_Asiento` from ((`asiento` `a` join `vuelo` `v` on((`a`.`Vuelo_ID` = `v`.`ID`))) join `aerolinea` `ae` on((`v`.`Aerolinea_ID` = `ae`.`ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping events for database 'proyecto_aeropuerto'
--

--
-- Dumping routines for database 'proyecto_aeropuerto'
--
/*!50003 DROP PROCEDURE IF EXISTS `ActualizarDatosPasajero` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarDatosPasajero`(
    IN p_DNI INT,
    IN p_nombre VARCHAR(45),
    IN p_apellido VARCHAR(45),
    IN p_fecha_nacimiento DATE,
    IN p_correo VARCHAR(45),
    IN p_telefono VARCHAR(45)
)
BEGIN    
    -- Iniciar transacción
    START TRANSACTION;

    -- Verificar si el pasajero existe
    IF EXISTS (
        SELECT 1 
        FROM `proyecto_aeropuerto`.`Pasajero`
        WHERE DNI = p_DNI
    ) THEN
        -- Actualizar los datos del pasajero
        UPDATE `proyecto_aeropuerto`.`Pasajero`
        SET
            nombre = p_nombre,
            apellido = p_apellido,
            fecha_nacimiento = p_fecha_nacimiento,
            correo = p_correo,
            telefono = p_telefono
        WHERE DNI = p_DNI;

        -- Confirmar los cambios
        COMMIT;
    ELSE
        -- Si no existe, deshacer la transacción
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pasajero con el DNI especificado no existe.';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AsignarPuertasYHora` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AsignarPuertasYHora`()
BEGIN
    DECLARE v_vuelo_id INT;
    DECLARE v_hora_salida TIME;
    DECLARE v_puerta_id INT;
    DECLARE i INT DEFAULT 1;

    -- Cursor para seleccionar vuelos con origen en el aeropuerto 1001
    DECLARE vuelos_cursor CURSOR FOR
        SELECT v.ID, v.hora_salida
        FROM `proyecto_aeropuerto`.`Vuelo` v
        WHERE v.Origen_ID = 1001;

    -- Manejo de finalización del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET i = 0;

    -- Abrir el cursor
    OPEN vuelos_cursor;

    vuelos_loop: LOOP
        FETCH vuelos_cursor INTO v_vuelo_id, v_hora_salida;

        IF i = 0 THEN
            LEAVE vuelos_loop;
        END IF;

        -- Seleccionar una puerta aleatoria
        SELECT p.ID INTO v_puerta_id
        FROM `proyecto_aeropuerto`.`Puerta` p
        ORDER BY RAND()
        LIMIT 1;

        -- Insertar la asignación de puerta y ajustar la hora
        INSERT INTO `proyecto_aeropuerto`.`Asignacion_Puerta` (hora_asignacion, Puerta_ID, Vuelo_ID)
        VALUES (SUBTIME(v_hora_salida, '01:00:00'), v_puerta_id, v_vuelo_id);
    END LOOP;

    -- Cerrar el cursor
    CLOSE vuelos_cursor;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EliminarPasajeroYActualizarAsientos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarPasajeroYActualizarAsientos`(
    IN p_pasajero_dni INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Revertir la transacción en caso de error
        ROLLBACK;
        SELECT 'Error al eliminar pasajero y actualizar asientos.';
    END;

    -- Iniciar transacción
    START TRANSACTION;

    -- Actualizar el estado de los asientos a FALSE (no ocupado)
    UPDATE `proyecto_aeropuerto`.`Asiento` a
    INNER JOIN `proyecto_aeropuerto`.`Boleto` b
        ON a.Vuelo_ID = b.Asiento_Vuelo_ID AND a.numero_asiento = b.Asiento_numero_asiento
    INNER JOIN `proyecto_aeropuerto`.`Reserva` r
        ON b.Reserva_ID = r.ID AND r.Pasajero_DNI = p_pasajero_dni
    SET a.Estado = FALSE;

    -- Eliminar al pasajero (DELETE ON CASCADE eliminará sus reservas y boletos automáticamente)
    DELETE FROM `proyecto_aeropuerto`.`Pasajero`
    WHERE DNI = p_pasajero_dni;

    -- Confirmar la transacción
    COMMIT;

    SELECT 'Pasajero eliminado y asientos actualizados correctamente.';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EliminarReservaYActualizarAsientos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarReservaYActualizarAsientos`(
    IN p_reserva_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Revertir cambios en caso de error
        ROLLBACK;
    END;

    -- Iniciar transacción
    START TRANSACTION;

    -- Actualizar los asientos relacionados a no ocupados
    UPDATE `proyecto_aeropuerto`.`Asiento` a
    INNER JOIN `proyecto_aeropuerto`.`Boleto` b
        ON a.Vuelo_ID = b.Asiento_Vuelo_ID
       AND a.numero_asiento = b.Asiento_numero_asiento
    SET a.Estado = FALSE
    WHERE b.Reserva_ID = p_reserva_id;

    -- Eliminar la reserva (ON DELETE CASCADE manejará las tablas relacionadas)
    DELETE FROM `proyecto_aeropuerto`.`Reserva`
    WHERE ID = p_reserva_id;

    -- Confirmar cambios
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GenerarAsientos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerarAsientos`()
BEGIN
    DECLARE v_vuelo_id INT;
    DECLARE v_aeronave_id INT;
    DECLARE v_capacidad INT;
    DECLARE i INT;
    DECLARE precio INT;

    -- Cursor para recorrer todos los vuelos
    DECLARE vuelos_cursor CURSOR FOR
        SELECT v.ID, v.Aeronave_ID, a.capacidad
        FROM `proyecto_aeropuerto`.`Vuelo` v
        JOIN `proyecto_aeropuerto`.`Aeronave` a ON v.Aeronave_ID = a.ID;

    -- Manejo de finalización del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET i = 0;

    -- Abrir el cursor
    OPEN vuelos_cursor;

    vuelos_loop: LOOP
        FETCH vuelos_cursor INTO v_vuelo_id, v_aeronave_id, v_capacidad;

        IF i = 0 THEN
            LEAVE vuelos_loop;
        END IF;

        -- Generar asientos para el vuelo actual
        SET i = 1;
        WHILE i <= v_capacidad DO
            -- Asignar un precio aleatorio entre 200 y 1000
            SET precio = FLOOR(200 + (RAND() * (1000 - 200)));

            -- Insertar el asiento en la tabla
            INSERT INTO `proyecto_aeropuerto`.`Asiento` (numero_asiento, precio, Estado, Vuelo_ID)
            VALUES (i, precio, FALSE, v_vuelo_id);

            SET i = i + 1;
        END WHILE;
    END LOOP;

    -- Cerrar el cursor
    CLOSE vuelos_cursor;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertarBoletoYActualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarBoletoYActualizar`(
    IN p_fisico TINYINT,
    IN p_Reserva_ID INT,
    IN p_Asiento_Vuelo_ID INT,
    IN p_Asiento_numero_asiento INT
)
BEGIN
    DECLARE v_precio DECIMAL(12,2);
    DECLARE v_estado_asiento TINYINT;
    
	-- Declarar un manejador para errores
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- Revertir los cambios en caso de error
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error al insertar el pasajero';
    END;
    
    -- Iniciar la transacción
    START TRANSACTION;

    -- Verificar el estado del asiento (debe ser falso para continuar)
    SELECT Estado
    INTO v_estado_asiento
    FROM `proyecto_aeropuerto`.`Asiento`
    WHERE Vuelo_ID = p_Asiento_Vuelo_ID
      AND numero_asiento = p_Asiento_numero_asiento;

    -- Si el estado del asiento es verdadero, abortar la transacción
    IF v_estado_asiento = TRUE THEN
        -- Si el asiento ya está ocupado, se realiza un ROLLBACK y se sale del procedimiento
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El asiento ya está ocupado.';
    ELSE
        -- Obtener el precio del asiento
        SELECT precio 
        INTO v_precio
        FROM `proyecto_aeropuerto`.`Asiento`
        WHERE Vuelo_ID = p_Asiento_Vuelo_ID
          AND numero_asiento = p_Asiento_numero_asiento;

        -- Insertar el boleto con el subtotal igual al precio del asiento
        INSERT INTO `proyecto_aeropuerto`.`Boleto` 
            (`fisico`, `subtotal`, `Reserva_ID`, `Asiento_Vuelo_ID`, `Asiento_numero_asiento`)
        VALUES (p_fisico, v_precio, p_Reserva_ID, p_Asiento_Vuelo_ID, p_Asiento_numero_asiento);

        -- Actualizar el estado del asiento a TRUE (ocupado)
        UPDATE `proyecto_aeropuerto`.`Asiento`
        SET Estado = TRUE
        WHERE Vuelo_ID = p_Asiento_Vuelo_ID
          AND numero_asiento = p_Asiento_numero_asiento;

        -- Actualizar el precio_total de la reserva sumando el precio del asiento
        UPDATE `proyecto_aeropuerto`.`Reserva`
        SET precio_total = precio_total + v_precio
        WHERE ID = p_Reserva_ID;

        -- Confirmar la transacción si todo se ejecutó correctamente
        COMMIT;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertarMaleta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarMaleta`(
    IN p_peso DECIMAL(12,2),
    IN p_reserva_id INT
)
BEGIN
    DECLARE v_precio_maleta DECIMAL(12,2);
    DECLARE v_peso_max DECIMAL(12,2);
    DECLARE v_vuelo_id INT;
    DECLARE v_cobro_adicional DECIMAL(12,2) DEFAULT 0;
    DECLARE v_cantidad_maletas INT DEFAULT 0;
    
    -- Inicio de la transacción
    START TRANSACTION;

    -- Obtener el Vuelo_ID relacionado a la Reserva
    SELECT Asiento_Vuelo_ID 
    INTO v_vuelo_id
    FROM `proyecto_aeropuerto`.`Boleto`
    WHERE Reserva_ID = p_reserva_id
    LIMIT 1;

    -- Validar que se haya encontrado un Vuelo_ID
    IF v_vuelo_id IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se pudo encontrar un Vuelo relacionado con la Reserva';
    END IF;

    -- Obtener peso máximo y precio adicional de la aerolínea
    SELECT a.peso_max, a.precio_maleta_mayor1
    INTO v_peso_max, v_precio_maleta
    FROM `proyecto_aeropuerto`.`Aerolinea` a
    JOIN `proyecto_aeropuerto`.`Vuelo` v ON v.Aerolinea_ID = a.ID
    WHERE v.ID = v_vuelo_id;

    -- Verificar si ya existe una maleta asociada a la reserva
    SELECT COUNT(*)
    INTO v_cantidad_maletas
    FROM `proyecto_aeropuerto`.`Maleta`
    WHERE Reserva_ID = p_reserva_id;

    -- Permitir solo una maleta gratuita
    IF v_cantidad_maletas = 0 THEN
		IF p_peso > v_peso_max THEN
            SET v_cobro_adicional = v_precio_maleta; -- Primera maleta tiene peso adicional
		ELSE
			SET v_cobro_adicional = 0; -- Primera maleta sin costo
        END IF;
    ELSE
        -- segunda maleta siempre se cobra
		SET v_cobro_adicional = v_precio_maleta;
    END IF;

    -- Insertar la maleta en la base de datos
    INSERT INTO `proyecto_aeropuerto`.`Maleta` (peso, Reserva_ID)
    VALUES (p_peso, p_reserva_id);

    -- Actualizar el precio_total en la tabla Reserva
    UPDATE `proyecto_aeropuerto`.`Reserva`
    SET precio_total = precio_total + v_cobro_adicional
    WHERE ID = p_reserva_id;

    -- Confirmar la transacción
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertarNuevaReserva` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarNuevaReserva`(
    IN p_pasajero_dni INT,
    IN p_tipo_viaje_id INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- Revertir los cambios en caso de error
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error al insertar el pasajero';
    END;
    
    -- Inicia la transacción
    START TRANSACTION;
        -- Inserta la nueva reserva
        INSERT INTO Reserva (fecha_reserva, Pasajero_DNI, precio_total,`Tipo de viaje_ID`)
        VALUES (CURRENT_DATE, p_pasajero_dni, 0, p_tipo_viaje_id);

        -- Confirmar la transacción si todo está correcto
	COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertarNuevoPasajero` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarNuevoPasajero`(
    IN p_DNI INT,
    IN p_nombre VARCHAR(45),
    IN p_apellido VARCHAR(45),
    IN p_fecha_nacimiento DATE,
    IN p_correo VARCHAR(45),
    IN p_telefono VARCHAR(45)
)
BEGIN
    -- Declarar un manejador para errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        -- Revertir los cambios en caso de error
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error al insertar el pasajero';
    END;

    -- Iniciar la transacción
    START TRANSACTION;

    -- Intentar insertar un nuevo pasajero
    INSERT INTO Pasajero (DNI, nombre, apellido, fecha_nacimiento, correo, telefono)
    VALUES (p_DNI, p_nombre, p_apellido, p_fecha_nacimiento, p_correo, p_telefono);

    -- Confirmar la transacción si todo está bien
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-30 22:58:35
