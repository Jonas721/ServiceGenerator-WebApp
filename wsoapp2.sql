-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: wsoapp2
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ensemble`
--

DROP TABLE IF EXISTS `ensemble`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ensemble` (
  `Ensemble_ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  PRIMARY KEY (`Ensemble_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ensemble`
--

LOCK TABLES `ensemble` WRITE;
/*!40000 ALTER TABLE `ensemble` DISABLE KEYS */;
INSERT INTO `ensemble` VALUES (1,'Lewis Family'),(2,'Adult Choir'),(3,'7-9th Choir');
/*!40000 ALTER TABLE `ensemble` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_type`
--

DROP TABLE IF EXISTS `event_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_type` (
  `Event_Type_ID` int NOT NULL AUTO_INCREMENT,
  `Description` varchar(50) NOT NULL,
  PRIMARY KEY (`Event_Type_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_type`
--

LOCK TABLES `event_type` WRITE;
/*!40000 ALTER TABLE `event_type` DISABLE KEYS */;
INSERT INTO `event_type` VALUES (1,'Opener'),(2,'Prelude'),(3,'Welcome'),(4,'Scripture Reading'),(5,'Cong. Song'),(6,'Prayer'),(7,'Offertory'),(8,'Choir'),(9,'Special Music'),(10,'Message'),(11,'Closing Song'),(12,'Postlude'),(13,'Lord\'s Supper'),(14,'Prayer/Announcements');
/*!40000 ALTER TABLE `event_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fills_role`
--

DROP TABLE IF EXISTS `fills_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fills_role` (
  `Person_ID` int NOT NULL,
  `Service_ID` int NOT NULL,
  `Role_Type` char(1) NOT NULL,
  `Confirmed` char(1) NOT NULL,
  PRIMARY KEY (`Person_ID`,`Service_ID`),
  KEY `Service_ID` (`Service_ID`),
  CONSTRAINT `fills_role_ibfk_1` FOREIGN KEY (`Person_ID`) REFERENCES `person` (`Person_ID`),
  CONSTRAINT `fills_role_ibfk_2` FOREIGN KEY (`Service_ID`) REFERENCES `service` (`Service_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fills_role`
--

LOCK TABLES `fills_role` WRITE;
/*!40000 ALTER TABLE `fills_role` DISABLE KEYS */;
INSERT INTO `fills_role` VALUES (2,1,'O','Y'),(6,2,'P','Y'),(10,1,'P','Y'),(14,2,'O','Y'),(15,2,'S','Y'),(16,1,'S','Y');
/*!40000 ALTER TABLE `fills_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_of`
--

DROP TABLE IF EXISTS `member_of`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_of` (
  `Ensemble_ID` int NOT NULL,
  `Person_ID` int NOT NULL,
  PRIMARY KEY (`Ensemble_ID`,`Person_ID`),
  KEY `FK_member_of_Person` (`Person_ID`),
  CONSTRAINT `FK_member_of_Ensemble` FOREIGN KEY (`Ensemble_ID`) REFERENCES `ensemble` (`Ensemble_ID`),
  CONSTRAINT `FK_member_of_Person` FOREIGN KEY (`Person_ID`) REFERENCES `person` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_of`
--

LOCK TABLES `member_of` WRITE;
/*!40000 ALTER TABLE `member_of` DISABLE KEYS */;
INSERT INTO `member_of` VALUES (2,7),(1,9),(2,10),(2,13),(3,16),(3,18);
/*!40000 ALTER TABLE `member_of` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `Person_ID` int NOT NULL AUTO_INCREMENT,
  `First_Name` varchar(15) NOT NULL,
  `Last_Name` varchar(20) NOT NULL,
  `Email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Person_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES (1,'Rebekah','Hawkey','rhawkey@gmail.com'),(2,'Amanda','Bixby','abixby@gmail.com'),(3,'Steve','Lee','slee@gmail.com'),(4,'Robert','Everett','reveret@gmail.com'),(5,'Sam','Martin','smartin@gmail.com'),(6,'Judy','Jackson','jjackson@gmail.com'),(7,'Jon','Avery','javery@gmail.com'),(8,'Sarah','Dobney','sdobney@gmail.com'),(9,'Tomothy','Lewis','tlewis@gmail.com'),(10,'Nathan','Martin','nmartin@gmail.com'),(11,'Stan','Bush','sbush@gmail.com'),(12,'Holly','Fordham','hfordham@gmail.com'),(13,'Cyndi','Wright','cwright@gmail.com'),(14,'Ed','Jackson','ejackson@gmail.com'),(15,'Jason','Boyle','jboyle@gmail.com'),(16,'Alan','Kennedy','akennedy@gmail.com'),(18,'Stephan','Griggs','sgriggs@gmail.com');
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service` (
  `Service_ID` int NOT NULL AUTO_INCREMENT,
  `Svc_DateTime` datetime(6) NOT NULL,
  `Theme_Event` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`Service_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES (1,'2019-10-03 10:30:00.000000','let the peace of christ rule'),(2,'2019-10-03 17:30:00.000000','Lord\'s Supper'),(6,'2019-10-10 10:30:00.000000','Drawing Nearer'),(7,'2020-10-03 10:30:00.000000','example service based on svc1');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_item`
--

DROP TABLE IF EXISTS `service_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_item` (
  `Service_Item_ID` int NOT NULL AUTO_INCREMENT,
  `Service_ID` int NOT NULL,
  `Seq_Num` int NOT NULL,
  `Event_Type_ID` int NOT NULL,
  `Title` varchar(45) DEFAULT NULL,
  `Notes` varchar(40) DEFAULT NULL,
  `Confirmed` char(1) NOT NULL,
  `Person_ID` int DEFAULT NULL,
  `Ensemble_ID` int DEFAULT NULL,
  `Song_ID` int DEFAULT NULL,
  PRIMARY KEY (`Service_Item_ID`),
  KEY `FK_service_event_Ensemble` (`Ensemble_ID`),
  KEY `FK_service_event_EventType` (`Event_Type_ID`),
  KEY `FK_service_event_Person` (`Person_ID`),
  KEY `FK_service_event_Service` (`Service_ID`),
  KEY `FK_service_event_Song` (`Song_ID`),
  CONSTRAINT `FK_service_event_Ensemble` FOREIGN KEY (`Ensemble_ID`) REFERENCES `ensemble` (`Ensemble_ID`),
  CONSTRAINT `FK_service_event_Person` FOREIGN KEY (`Person_ID`) REFERENCES `person` (`Person_ID`),
  CONSTRAINT `FK_service_event_Service` FOREIGN KEY (`Service_ID`) REFERENCES `service` (`Service_ID`),
  CONSTRAINT `FK_service_event_Song` FOREIGN KEY (`Song_ID`) REFERENCES `song` (`song_id`),
  CONSTRAINT `FK_service_item_event_type` FOREIGN KEY (`Event_Type_ID`) REFERENCES `event_type` (`Event_Type_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=703 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_item`
--

LOCK TABLES `service_item` WRITE;
/*!40000 ALTER TABLE `service_item` DISABLE KEYS */;
INSERT INTO `service_item` VALUES (1,1,1,1,'It is Well','flute','Y',1,NULL,1),(2,1,2,2,NULL,NULL,'Y',2,NULL,1),(3,1,3,3,NULL,NULL,'Y',3,NULL,1),(4,1,4,2,NULL,NULL,'Y',2,NULL,1),(5,1,5,4,NULL,NULL,'Y',3,NULL,1),(6,1,6,5,NULL,NULL,'Y',NULL,NULL,1),(7,1,7,6,NULL,NULL,'Y',4,NULL,1),(8,1,8,5,NULL,NULL,'Y',NULL,NULL,1),(9,1,9,7,'May the Mind of Christ my Savior','From organ well, need MIC','Y',NULL,1,1),(10,1,10,8,NULL,NULL,'Y',NULL,2,1),(11,1,11,5,NULL,NULL,'Y',NULL,NULL,1),(12,1,12,9,'Jesus, I am Resting',NULL,'Y',5,NULL,1),(13,1,13,10,NULL,NULL,'Y',4,NULL,1),(14,1,14,11,NULL,NULL,'Y',NULL,NULL,1),(15,1,15,12,NULL,NULL,'Y',2,NULL,1),(16,2,1,2,NULL,NULL,'Y',10,NULL,1),(17,2,2,6,NULL,NULL,'N',3,NULL,1),(18,2,3,5,NULL,NULL,'Y',NULL,NULL,1),(19,2,4,5,NULL,NULL,'Y',NULL,NULL,1),(21,2,5,5,NULL,NULL,'Y',NULL,NULL,1),(22,2,6,5,NULL,NULL,'Y',NULL,NULL,1),(23,2,7,14,NULL,NULL,'Y',11,NULL,1),(33,6,1,1,NULL,NULL,'N',2,NULL,1),(34,6,2,5,NULL,NULL,'Y',NULL,NULL,1),(673,7,1,1,NULL,NULL,'Y',NULL,NULL,NULL),(674,7,2,2,NULL,NULL,'Y',NULL,NULL,NULL),(675,7,3,3,NULL,NULL,'Y',NULL,NULL,NULL),(676,7,4,2,NULL,NULL,'Y',NULL,NULL,NULL),(677,7,5,4,NULL,NULL,'Y',NULL,NULL,NULL),(678,7,6,5,NULL,NULL,'Y',NULL,NULL,10),(679,7,7,6,NULL,NULL,'Y',NULL,NULL,NULL),(680,7,8,5,NULL,NULL,'Y',NULL,NULL,15),(681,7,9,7,NULL,NULL,'Y',NULL,NULL,NULL),(682,7,10,8,NULL,NULL,'Y',NULL,NULL,NULL),(683,7,11,5,NULL,NULL,'Y',NULL,NULL,6),(684,7,12,9,NULL,NULL,'Y',NULL,NULL,NULL),(685,7,13,10,NULL,NULL,'Y',NULL,NULL,NULL),(686,7,14,11,NULL,NULL,'Y',NULL,NULL,NULL),(687,7,15,12,NULL,NULL,'Y',NULL,NULL,NULL);
/*!40000 ALTER TABLE `service_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song` (
  `Song_ID` int NOT NULL AUTO_INCREMENT,
  `Song_Type` char(1) NOT NULL,
  `Title` varchar(50) NOT NULL,
  `Hymnbook_Num` varchar(5) DEFAULT NULL,
  `Arranger` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Song_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'C','It is Well',NULL,NULL),(2,'H','My Faith has Found','60',NULL),(3,'H','Hiding in Thee','608',NULL),(4,'C','May the Mind of Christ my Savior',NULL,NULL),(5,'C','If You Search with All Your Hearts',NULL,NULL),(6,'H','Like a River','352',NULL),(7,'C','Jesus, I am Resting',NULL,NULL),(8,'H','For All the Saints','643',NULL),(9,'H','At the Cross','140',NULL),(10,'H','He Died For ME','154',NULL),(13,'H','When I Survey','137',NULL),(14,'H','It is Finished','138',NULL),(15,'H','Jesus Paid It All','390',NULL);
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `songusageview`
--

DROP TABLE IF EXISTS `songusageview`;
/*!50001 DROP VIEW IF EXISTS `songusageview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `songusageview` AS SELECT 
 1 AS `Song_ID`,
 1 AS `Song_Type`,
 1 AS `Title`,
 1 AS `Hymnbook_Num`,
 1 AS `Arranger`,
 1 AS `LastUsedDate`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `unavailable_for`
--

DROP TABLE IF EXISTS `unavailable_for`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unavailable_for` (
  `Person_ID` int NOT NULL,
  `Service_ID` int NOT NULL,
  PRIMARY KEY (`Person_ID`,`Service_ID`),
  KEY `FK_unavailable_for_Service` (`Service_ID`),
  CONSTRAINT `FK_unavailable_for_Person` FOREIGN KEY (`Person_ID`) REFERENCES `person` (`Person_ID`),
  CONSTRAINT `FK_unavailable_for_Service` FOREIGN KEY (`Service_ID`) REFERENCES `service` (`Service_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unavailable_for`
--

LOCK TABLES `unavailable_for` WRITE;
/*!40000 ALTER TABLE `unavailable_for` DISABLE KEYS */;
INSERT INTO `unavailable_for` VALUES (6,1),(10,1),(14,1),(10,2),(2,6),(16,6);
/*!40000 ALTER TABLE `unavailable_for` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'wsoapp2'
--
/*!50003 DROP PROCEDURE IF EXISTS `create_service` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_service`(dt DATETIME, themeVar VARCHAR(40), songleaderID INT, svcID INT, oldSvcID INT)
BEGIN
	INSERT INTO service (service_ID, svc_DateTime, theme_event) 
    VALUES(svcID, dt, themeVar);
    
    INSERT INTO service_item(service_id, seq_num, event_type_id, confirmed)
		select (service_id - service_id + svcID), Seq_Num, event_type.Event_Type_ID, confirmed
		from service_item
		left join event_type on service_item.Event_Type_ID = event_type.Event_Type_ID
		where service_ID = oldSvcID
		order by Seq_Num; 
    
    IF songleaderID != -1 THEN
		INSERT INTO fills_role (Person_ID, Service_ID, Role_Type, Confirmed) 
		VALUES(songleaderID, svcID, 'S', 'Y');
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `songusageview`
--

/*!50001 DROP VIEW IF EXISTS `songusageview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `songusageview` AS select `song`.`Song_ID` AS `Song_ID`,`song`.`Song_Type` AS `Song_Type`,`song`.`Title` AS `Title`,`song`.`Hymnbook_Num` AS `Hymnbook_Num`,`song`.`Arranger` AS `Arranger`,`service`.`Svc_DateTime` AS `LastUsedDate` from ((`song` left join `service_item` on((`song`.`Song_ID` = `service_item`.`Song_ID`))) left join `service` on((`service_item`.`Service_ID` = `service`.`Service_ID`))) where (`song`.`Song_Type` <> 'C') order by `service`.`Svc_DateTime`,`song`.`Title` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-03 23:51:23
