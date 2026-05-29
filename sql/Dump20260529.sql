-- MySQL dump 10.13  Distrib 8.0.45, for macos15 (arm64)
--
-- Host: 127.0.0.1    Database: tracker
-- ------------------------------------------------------
-- Server version	8.0.31

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
-- Table structure for table `Company`
--

DROP TABLE IF EXISTS `Company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Company` (
  `company_id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(255) NOT NULL,
  `industry` varchar(150) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Company`
--

LOCK TABLES `Company` WRITE;
/*!40000 ALTER TABLE `Company` DISABLE KEYS */;
INSERT INTO `Company` VALUES (1,'Ericsson','Telecommunications','https://www.ericsson.com','2026-03-09 11:56:39'),(2,'Ikea','Retail','https://www.ikea.com','2026-03-09 11:56:39'),(3,'Volvo','Automotive','https://www.volvo.com','2026-03-09 11:56:39'),(4,'Spotify','Technology','https://www.spotify.com','2026-03-09 11:56:39'),(5,'H&M','Retail','https://www2.hm.com','2026-03-09 11:56:39'),(6,'Scania','Automotive','https://www.scania.com','2026-03-09 11:56:39'),(7,'Tetra Pak','Packaging','https://www.tetrapak.com','2026-03-09 11:56:39'),(8,'Atlas Copco','Engineering','https://www.atlascopco.com','2026-03-09 11:56:39'),(9,'Electrolux','Home Appliances','https://www.electrolux.com','2026-03-09 11:56:39'),(10,'Skanska','Construction','https://www.skanska.com','2026-03-09 11:56:39');
/*!40000 ALTER TABLE `Company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `JobApplication`
--

DROP TABLE IF EXISTS `JobApplication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `JobApplication` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `contact_person` varchar(255) DEFAULT NULL,
  `contact_email` varchar(255) DEFAULT NULL,
  `interview_date` date DEFAULT NULL,
  `application_date` date NOT NULL,
  `notes` text,
  `deadline` date DEFAULT NULL,
  `user_id` int NOT NULL,
  `status_id` int DEFAULT NULL,
  `company_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`application_id`),
  KEY `user_id` (`user_id`),
  KEY `status_id` (`status_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `jobapplication_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `p_User` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `jobapplication_ibfk_2` FOREIGN KEY (`status_id`) REFERENCES `Status` (`status_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `jobapplication_ibfk_3` FOREIGN KEY (`company_id`) REFERENCES `Company` (`company_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `JobApplication`
--

LOCK TABLES `JobApplication` WRITE;
/*!40000 ALTER TABLE `JobApplication` DISABLE KEYS */;
INSERT INTO `JobApplication` VALUES (1,'Erik Larsson','eriklarsson@gmail.com',NULL,'2026-03-01','note 1',NULL,1,1,1,'2026-03-19 15:02:10'),(2,'Suheyb Hashi','suheybhashi@gmail.com','2026-04-10','2026-03-05','note 2','2026-04-01',2,NULL,2,'2026-03-19 15:02:10'),(3,'Anton Lovstrom','antonlovstrom@gmail.com',NULL,'2026-03-10','note 3',NULL,3,1,3,'2026-03-19 15:02:10'),(4,'James Patterson','jamespatterson@gmail.com','2026-04-15','2026-03-12','note 4','2026-04-10',4,2,4,'2026-03-19 15:02:10'),(5,'Olivia Johansson','oliviajohansson@gmail.com',NULL,'2026-03-14','note 5',NULL,5,3,5,'2026-03-19 15:02:10'),(6,'Max Andersson','maxandersson@gmail.com',NULL,'2026-03-16','note 6',NULL,6,1,6,'2026-03-19 15:02:10'),(7,'Emma Karlsson','emmakarlsson@gmail.com','2026-05-01','2026-03-18','note 7','2026-04-20',7,2,7,'2026-03-19 15:02:10'),(8,'David Olofsson','davidolofsson@gmail.com',NULL,'2026-03-20','note 8',NULL,8,1,8,'2026-03-19 15:02:10'),(9,'Lisa Nordin','lisanordin@gmail.com',NULL,'2026-03-22','note 9',NULL,9,3,9,'2026-03-19 15:02:10'),(10,'Mikael Sundberg','mikaelsundberg@gmail.com',NULL,'2026-03-24','note 10',NULL,10,1,10,'2026-03-19 15:02:10'),(11,'Erik Larsson','eriklarsson@gmail.com',NULL,'2026-04-01','note 11',NULL,1,2,2,'2026-03-19 15:02:10'),(12,'Suheyb Hashi','suheybhashi@gmail.com',NULL,'2026-04-02','note 12',NULL,2,1,3,'2026-03-19 15:02:10'),(13,'Anton Lovstrom','antonlovstrom@gmail.com','2026-05-05','2026-04-03','note 13','2026-05-01',3,2,4,'2026-03-19 15:02:10'),(14,'James Patterson','jamespatterson@gmail.com',NULL,'2026-04-04','note 14',NULL,4,3,5,'2026-03-19 15:02:10'),(15,'Olivia Johansson','oliviajohansson@gmail.com',NULL,'2026-04-05','note 15',NULL,5,1,6,'2026-03-19 15:02:10'),(16,'Max Andersson','maxandersson@gmail.com',NULL,'2026-04-06','note 16',NULL,6,1,7,'2026-03-19 15:02:10'),(17,'Emma Karlsson','emmakarlsson@gmail.com',NULL,'2026-04-07','note 17',NULL,7,3,8,'2026-03-19 15:02:10'),(18,'David Olofsson','davidolofsson@gmail.com',NULL,'2026-04-08','note 18',NULL,8,1,9,'2026-03-19 15:02:10'),(19,'Lisa Nordin','lisanordin@gmail.com',NULL,'2026-04-09','note 19',NULL,9,1,10,'2026-03-19 15:02:10'),(20,'Mikael Sundberg','mikaelsundberg@gmail.com',NULL,'2026-04-10','note 20',NULL,10,2,1,'2026-03-19 15:02:10');
/*!40000 ALTER TABLE `JobApplication` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_status_on_interview` BEFORE UPDATE ON `jobapplication` FOR EACH ROW BEGIN
   IF NEW.interview_date IS NOT NULL THEN
      SET NEW.status_id = (
         SELECT status_id 
         FROM Status 
         WHERE status_name = 'Interview Scheduled'
      );
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `p_User`
--

DROP TABLE IF EXISTS `p_User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `p_User` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `gmail` varchar(255) NOT NULL,
  `p_password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `gmail` (`gmail`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `p_User`
--

LOCK TABLES `p_User` WRITE;
/*!40000 ALTER TABLE `p_User` DISABLE KEYS */;
INSERT INTO `p_User` VALUES (1,'Erik','Larsson','eriklarsson@gmail.com','password4','2026-03-09 11:56:00'),(2,'Suheyb','Hashi','suheybhashi@gmail.com','password1','2026-03-09 11:56:00'),(3,'Anton','Lovstrom','antonlovstrom@gmail.com','password2','2026-03-09 11:56:00'),(4,'James','Patterson','jamespatterson@gmail.com','password3','2026-03-09 11:56:00'),(5,'Olivia','Johansson','oliviajohansson@gmail.com','password5','2026-03-09 11:56:00'),(6,'Max','Andersson','maxandersson@gmail.com','password6','2026-03-09 11:56:00'),(7,'Emma','Karlsson','emmakarlsson@gmail.com','password7','2026-03-09 11:56:00'),(8,'David','Olofsson','davidolofsson@gmail.com','password8','2026-03-09 11:56:00'),(9,'Lisa','Nordin','lisanordin@gmail.com','password9','2026-03-09 11:56:00'),(10,'Mikael','Sundberg','mikaelsundberg@gmail.com','password10','2026-03-09 11:56:00');
/*!40000 ALTER TABLE `p_User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Status`
--

DROP TABLE IF EXISTS `Status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Status` (
  `status_id` int NOT NULL,
  `status_name` varchar(50) NOT NULL,
  PRIMARY KEY (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Status`
--

LOCK TABLES `Status` WRITE;
/*!40000 ALTER TABLE `Status` DISABLE KEYS */;
INSERT INTO `Status` VALUES (1,'Pending'),(2,'Interview'),(3,'Rejected');
/*!40000 ALTER TABLE `Status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'tracker'
--

--
-- Dumping routines for database 'tracker'
--
/*!50003 DROP FUNCTION IF EXISTS `GetApplicationStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetApplicationStatus`(app_id INT) RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE v_status_name VARCHAR(50);

    SELECT s.status_name 
    INTO v_status_name
    FROM Status s
    JOIN JobApplication j 
        ON s.status_id = j.status_id
    WHERE j.application_id = app_id;

    RETURN v_status_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetUserApplications` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserApplications`(IN p_user_id INT)
BEGIN
    SELECT 
        JobApplication.application_id,
        c.company_name,
        s.status_name,
        JobApplication.application_date,
        JobApplication.interview_date,
        JobApplication.deadline
    FROM JobApplication 
    JOIN Company c ON JobApplication.company_id = c.company_id
    LEFT JOIN Status s ON JobApplication.status_id = s.status_id
    WHERE JobApplication.user_id = p_user_id
    ORDER BY JobApplication.application_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetUserApplicationsWithoutStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserApplicationsWithoutStatus`(IN p_user_id INT)
BEGIN
    SELECT 
        JobApplication.application_id, 
        c.company_name, 
        JobApplication.application_date, 
        JobApplication.interview_date, 
        JobApplication.deadline
    FROM JobApplication
    JOIN Company c ON JobApplication.company_id = c.company_id
    WHERE JobApplication.user_id = p_user_id
    ORDER BY JobApplication.application_date DESC;
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

-- Dump completed on 2026-05-29 20:33:37
