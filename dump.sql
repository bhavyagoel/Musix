-- MySQL dump 10.13  Distrib 8.0.21, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: musix
-- ------------------------------------------------------
-- Server version	8.0.21-0ubuntu0.20.04.4

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
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `Name` varchar(20) NOT NULL,
  `DOB` varchar(15) NOT NULL,
  `User_ID` char(7) NOT NULL,
  PRIMARY KEY (`User_ID`),
  UNIQUE KEY `User_ID` (`User_ID`),
  CONSTRAINT `User_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `Register` (`Register_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES ('Bhavya Goel','2020-10-30','UID0001'),('Bhavya Goel','2020-10-30','UID0002');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Song_Artist`
--

DROP TABLE IF EXISTS `Song_Artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Song_Artist` (
  `Song_ID` char(7) NOT NULL,
  `Artist_ID` char(8) NOT NULL,
  UNIQUE KEY `Song_ID` (`Song_ID`,`Artist_ID`),
  KEY `Artist_ID` (`Artist_ID`),
  CONSTRAINT `Song_Artist_ibfk_1` FOREIGN KEY (`Song_ID`) REFERENCES `Song` (`Song_ID`),
  CONSTRAINT `Song_Artist_ibfk_2` FOREIGN KEY (`Artist_ID`) REFERENCES `Artist` (`Artist_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Song_Artist`
--

LOCK TABLES `Song_Artist` WRITE;
/*!40000 ALTER TABLE `Song_Artist` DISABLE KEYS */;
INSERT INTO `Song_Artist` VALUES ('0000006','00000010'),('0000007','00000011'),('0000009','00000011'),('0000007','00000012'),('0000007','00000013'),('0000007','00000014'),('0000008','00000015'),('0000008','00000016'),('0000008','00000017'),('0000009','00000018'),('0000009','00000019'),('0000009','00000020'),('0000010','00000021'),('0000012','00000021'),('0000011','00000022'),('0000011','00000023'),('0000012','00000024');
/*!40000 ALTER TABLE `Song_Artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Song`
--

DROP TABLE IF EXISTS `Song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Song` (
  `Song_ID` char(7) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Year` char(4) NOT NULL,
  `Duration` varchar(4) NOT NULL,
  `Genre_ID` char(7) NOT NULL,
  `SongLocation` varchar(200) NOT NULL,
  `ImageLocation` varchar(200) NOT NULL,
  PRIMARY KEY (`Song_ID`),
  UNIQUE KEY `Song_ID` (`Song_ID`),
  UNIQUE KEY `SongLocation` (`SongLocation`),
  UNIQUE KEY `ImageLocation` (`ImageLocation`),
  UNIQUE KEY `Song_ID_2` (`Song_ID`,`Genre_ID`),
  KEY `Genre_ID` (`Genre_ID`),
  CONSTRAINT `Song_ibfk_1` FOREIGN KEY (`Genre_ID`) REFERENCES `Genre` (`Genre_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Song`
--

LOCK TABLES `Song` WRITE;
/*!40000 ALTER TABLE `Song` DISABLE KEYS */;
INSERT INTO `Song` VALUES ('0000006','Gangnam Style (강남스타일)','2012','222','GID0001','static/songs/Gangnam Style (강남스타일).mp3','static/images/Gangnam Style (강남스타일).jpeg'),('0000007','Baby Ko Bass Pasand Hai (Remix) (From \"Sultan\")','2019','228','GID0001','static/songs/Baby Ko Bass Pasand Hai (Remix) (From Sultan).mp3','static/images/Baby Ko Bass Pasand Hai (Remix) (From Sultan).jpeg'),('0000008','Despacito - Remix','2017','232','GID0001','static/songs/Despacito - Remix.mp3','static/images/Despacito - Remix.jpeg'),('0000009','Munna Badnaam Hua (From \"Dabangg 3\")','2019','248','GID0001','static/songs/Munna Badnaam Hua (From Dabangg 3).mp3','static/images/Munna Badnaam Hua (From Dabangg 3).jpeg'),('0000010','Dabangg Reloaded','2012','250','GID0001','static/songs/Dabangg Reloaded.mp3','static/images/Dabangg Reloaded.jpeg'),('0000011','Tere Mast Mast Do Nain (From \"Dabangg\")','2018','360','GID0001','static/songs/Tere Mast Mast Do Nain (From Dabangg).mp3','static/images/Tere Mast Mast Do Nain (From Dabangg).jpeg'),('0000012','Hud Hud Dabangg','2010','254','GID0001','static/songs/Hud Hud Dabangg.mp3','static/images/Hud Hud Dabangg.jpeg');
/*!40000 ALTER TABLE `Song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Register`
--

DROP TABLE IF EXISTS `Register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Register` (
  `Name` varchar(20) NOT NULL,
  `Gender` varchar(8) DEFAULT NULL,
  `Address` varchar(50) NOT NULL,
  `Mobile` varchar(20) NOT NULL,
  `Email_ID` varchar(20) NOT NULL,
  `Password` varchar(100) NOT NULL,
  `Register_ID` char(7) NOT NULL,
  PRIMARY KEY (`Register_ID`),
  UNIQUE KEY `Register_ID` (`Register_ID`),
  UNIQUE KEY `Email_ID` (`Email_ID`,`Password`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Register`
--

LOCK TABLES `Register` WRITE;
/*!40000 ALTER TABLE `Register` DISABLE KEYS */;
INSERT INTO `Register` VALUES ('Bhavya Goel','Male','44/5 BM Compound Opp PNB bank','+917042089702','bgoel4132@gmail.com','$5$rounds=535000$3SPOU2TpkIXARcd9$KQWcbxhrWos5qUczjYgQzb2bqaD2MNKG9e7yJzIEo/A','UID0001'),('Bhavya Goel','Male','44/5 BM Compound Opp PNB bank','+919891103166','bgoel4132@gmail.com','$5$rounds=535000$E2TeNbyzcrVFTa9o$oCmkCuLloq78mxW348qlhd9uXRLzgsT/mvwuSzbsJB1','UID0002');
/*!40000 ALTER TABLE `Register` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Login`
--

DROP TABLE IF EXISTS `Login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Login` (
  `Login_ID` char(7) NOT NULL,
  `Password` varchar(100) NOT NULL,
  PRIMARY KEY (`Login_ID`),
  UNIQUE KEY `Login_ID` (`Login_ID`),
  CONSTRAINT `Login_ibfk_1` FOREIGN KEY (`Login_ID`) REFERENCES `Register` (`Register_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Login`
--

LOCK TABLES `Login` WRITE;
/*!40000 ALTER TABLE `Login` DISABLE KEYS */;
INSERT INTO `Login` VALUES ('UID0001','$5$rounds=535000$3SPOU2TpkIXARcd9$KQWcbxhrWos5qUczjYgQzb2bqaD2MNKG9e7yJzIEo/A'),('UID0002','$5$rounds=535000$E2TeNbyzcrVFTa9o$oCmkCuLloq78mxW348qlhd9uXRLzgsT/mvwuSzbsJB1');
/*!40000 ALTER TABLE `Login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Genre`
--

DROP TABLE IF EXISTS `Genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Genre` (
  `Genre_ID` char(7) NOT NULL,
  `Name` varchar(20) NOT NULL,
  PRIMARY KEY (`Genre_ID`),
  UNIQUE KEY `Genre_ID` (`Genre_ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genre`
--

LOCK TABLES `Genre` WRITE;
/*!40000 ALTER TABLE `Genre` DISABLE KEYS */;
INSERT INTO `Genre` VALUES ('GID0004','Classical'),('GID0002','Jazz'),('GID0003','Pop'),('GID0001','Spotify');
/*!40000 ALTER TABLE `Genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Artist`
--

DROP TABLE IF EXISTS `Artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Artist` (
  `Name` varchar(50) NOT NULL,
  `Artist_ID` char(8) NOT NULL,
  `DOB` varchar(15) NOT NULL,
  PRIMARY KEY (`Artist_ID`),
  UNIQUE KEY `Artist_ID` (`Artist_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Artist`
--

LOCK TABLES `Artist` WRITE;
/*!40000 ALTER TABLE `Artist` DISABLE KEYS */;
INSERT INTO `Artist` VALUES ('PSY','00000010','2020-10-30'),('Badshah','00000011','2020-10-30'),('Vishal Dadlani','00000012','2020-10-30'),('Shalmali Kholgade','00000013','2020-10-30'),('Dj Chetas','00000014','2020-10-30'),('Luis Fonsi','00000015','2020-10-30'),('Daddy Yankee','00000016','2020-10-30'),('Justin Bieber','00000017','2020-10-30'),('Kamaal Khan','00000018','2020-10-30'),('Mamta Sharma','00000019','2020-10-30'),('Sajid-Wajid','00000020','2020-10-30'),('Sukhwinder Singh','00000021','2020-10-30'),('Rahat Fateh Ali Khan','00000022','2020-10-30'),('Shreya Ghoshal','00000023','2020-10-30'),('Wajid','00000024','2020-10-30');
/*!40000 ALTER TABLE `Artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Album`
--

DROP TABLE IF EXISTS `Album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Album` (
  `Name` varchar(20) NOT NULL,
  `Album_ID` char(8) NOT NULL,
  PRIMARY KEY (`Album_ID`),
  UNIQUE KEY `Album_ID` (`Album_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Album`
--

LOCK TABLES `Album` WRITE;
/*!40000 ALTER TABLE `Album` DISABLE KEYS */;
INSERT INTO `Album` VALUES ('Dabangg','ALID0001'),('Top Hits','ALID0002'),('International Hits','ALID0003'),('All Songs','ALID0004');
/*!40000 ALTER TABLE `Album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Album_Song`
--

DROP TABLE IF EXISTS `Album_Song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Album_Song` (
  `Album_ID` char(8) NOT NULL,
  `Song_ID` char(7) NOT NULL,
  UNIQUE KEY `Album_ID` (`Album_ID`,`Song_ID`),
  KEY `Song_ID` (`Song_ID`),
  CONSTRAINT `Album_Song_ibfk_1` FOREIGN KEY (`Album_ID`) REFERENCES `Album` (`Album_ID`),
  CONSTRAINT `Album_Song_ibfk_2` FOREIGN KEY (`Song_ID`) REFERENCES `Song` (`Song_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Album_Song`
--

LOCK TABLES `Album_Song` WRITE;
/*!40000 ALTER TABLE `Album_Song` DISABLE KEYS */;
INSERT INTO `Album_Song` VALUES ('ALID0003','0000006'),('ALID0004','0000006'),('ALID0002','0000007'),('ALID0004','0000007'),('ALID0003','0000008'),('ALID0004','0000008'),('ALID0002','0000009'),('ALID0004','0000009'),('ALID0001','0000010'),('ALID0004','0000010'),('ALID0001','0000011'),('ALID0004','0000011'),('ALID0001','0000012'),('ALID0004','0000012');
/*!40000 ALTER TABLE `Album_Song` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-30 23:44:11
