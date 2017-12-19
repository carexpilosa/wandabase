-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: wanderbase
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `wanderbase`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `wanderbase` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `wanderbase`;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `created` datetime NOT NULL,
  `member_id` int(10) unsigned NOT NULL,
  `event_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,'Es war schön im Brandenburgischen ... Wie immer!','2017-12-09 09:52:38',1,10),(2,'content','2017-12-09 13:05:09',123,123),(3,'content','2017-12-10 21:06:16',123,21),(4,'content','2017-12-10 23:08:54',123,16),(5,'content','2017-12-12 18:09:51',123,21),(6,'asdfasfd','2017-12-14 14:26:04',1,24),(7,'asdfasfd','2017-12-14 14:27:08',1,24),(8,'asdfasfd','2017-12-14 14:27:56',1,24),(9,'Ein Kommentär','2017-12-14 14:28:58',1,24),(10,'Ein Kommentär','2017-12-14 14:30:56',1,24),(11,'Je länger je lieber','2017-12-14 15:00:07',1,22),(12,'Toll, toll, toll','2017-12-14 15:25:05',1,23),(13,'SO SIEHT DAS AUS!','2017-12-14 15:30:34',1,24),(14,'Warum bin ich bloß nicht mitgangen??!','2017-12-14 15:31:03',1,24),(15,'Ja und?','2017-12-14 15:33:13',1,24),(16,'Ne aber auch','2017-12-14 15:33:53',1,24),(17,'Ho he','2017-12-14 15:39:08',20,24),(18,'sadf','2017-12-14 15:40:50',20,24),(19,'RENTE','2017-12-14 15:41:59',20,24),(20,'Oh mann','2017-12-14 15:55:28',20,24),(21,'Rirarutsch','2017-12-14 16:13:05',1,24),(22,'sadfasd','2017-12-14 16:22:19',20,22),(23,'ghk','2017-12-14 16:33:21',1,24),(24,'Ojemineh','2017-12-14 23:48:33',20,24),(25,'Allens kloar, wi kummt langs.','2017-12-14 23:49:28',20,24),(26,'Soy Carlos. Castaneda. Fonseca. Santana. Ay!','2017-12-14 23:50:28',20,24),(27,'Wer bin ich? Eigentlich Carlos','2017-12-14 23:51:15',20,24),(28,'Yo soy desperado ...','2017-12-15 18:28:53',9,24),(29,'Retro!','2017-12-15 18:36:57',9,24),(30,'Seeeehr gut!','2017-12-15 23:45:17',20,22),(31,'Hallo ich bin es','2017-12-17 12:49:16',9,24),(32,'test','2017-12-17 12:50:00',9,22),(33,'Tach','2017-12-18 18:05:17',1,24),(34,'hjhhhhhh','2017-12-18 18:13:36',9,24),(35,'Icke, Hans Hans','2017-12-18 18:15:29',20,18),(36,'Ich bin ähm, wer noch mal?','2017-12-18 18:17:03',10,13),(37,'Raaaaa','2017-12-18 18:41:38',9,20),(38,'Jupp','2017-12-18 20:54:57',1,24);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created` datetime NOT NULL,
  `starttime` datetime NOT NULL,
  `startlocation` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (10,'Käse ist öde','','2017-12-06 04:40:58','2017-12-24 18:00:00',''),(11,'Wandern im Schnee','Holla die Waldfee','2017-12-09 10:08:49','2017-12-24 18:00:00','Rodelbahn 24'),(12,'Konzert Kulturbrauerei','Locker Musike','2017-12-09 17:24:45','2017-12-24 18:00:00','Kulturbrauerei Haupteingang'),(13,'Konzert Kulturbrauerei','Locker Musike','2017-12-09 17:25:08','2017-12-24 18:00:00','Kulturbrauerei Haupteingang'),(14,'asdf','','2017-12-09 17:27:10','2017-12-24 18:00:00',''),(15,'asdf','','2017-12-09 17:27:44','2017-12-24 18:00:00',''),(16,'asdf','','2017-12-09 17:27:54','2017-12-24 18:00:00',''),(17,'asdf','','2017-12-09 17:28:26','2017-12-24 18:00:00',''),(18,'asdfasdf','','2017-12-09 17:32:49','2017-12-24 18:00:00',''),(19,'Abhänge und chille','','2017-12-09 18:12:52','2017-12-24 18:00:00',''),(20,'Eventuell','','2017-12-10 08:21:57','2017-12-24 18:00:00',''),(21,'asdfasdf','','2017-12-10 08:27:11','2017-12-24 18:00:00',''),(22,'Trotteln','','2017-12-10 20:58:45','2017-12-24 18:00:00',''),(23,'EinEvent','','2017-12-12 18:36:03','2017-12-24 18:00:00',''),(24,'EinEvent','','2017-12-12 18:36:22','2017-12-24 18:00:00','');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(56) NOT NULL,
  `gender` enum('f','m','i') DEFAULT NULL,
  `date_of_membership` date NOT NULL,
  `is_admin` tinyint(1) DEFAULT NULL,
  `motto` text,
  `token` varchar(50) DEFAULT NULL,
  `token_created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'markus','markus','m','2017-12-09',0,'',NULL,NULL),(2,'Waldfried','','m','2017-12-09',0,'','3For99UKCHjoLBJ1yZvnIK','2017-12-10 23:08:39'),(3,'Loxley','artus','m','2017-12-10',0,'',NULL,NULL),(4,'Leo','leo','m','2017-12-12',0,'','NRFJAIXp0MCpCauvZv38tw','2017-12-17 12:42:42'),(5,'asdf','asdf','m','2017-12-12',0,'',NULL,NULL),(7,'asdfe','asdf','m','2017-12-12',0,'',NULL,NULL),(9,'Carlos','asdf','m','2017-12-12',0,'',NULL,NULL),(10,'Hein','hein','m','2017-12-12',0,'','T60t6oHGDpSahmXPcQGpD9','2017-12-18 18:16:42'),(13,'Theo','theo','m','2017-12-12',0,'',NULL,NULL),(19,'Theodor','theo','m','2017-12-12',0,'',NULL,NULL),(20,'Hans','hans','m','2017-12-14',1,'JOJO','A1cIguY0jZ9x0vhoQ1u58N','2017-12-18 20:10:18'),(21,'a','','m','2017-12-18',0,'',NULL,NULL);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-12-19 16:50:25
