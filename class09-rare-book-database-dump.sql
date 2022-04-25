-- MariaDB dump 10.19  Distrib 10.4.24-MariaDB, for Linux (x86_64)
--
-- Host: classmysql.engr.oregonstate.edu    Database: cs340_ramseyst
-- ------------------------------------------------------
-- Server version	10.6.7-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `author` (
  `author_numb` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `author_last_first` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`author_numb`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES (1,'Bronte, Charlotte'),(2,'Doyle, Sir Aurthor Conan'),(3,'Twain, Mark'),(4,'Stevenson, Robert Louis'),(5,'Rand, Ayn'),(6,'Barrie, James'),(7,'Ludlum, Robert'),(8,'Barth, John'),(9,'Herbert, Frank'),(10,'Asimov, Isaac'),(11,'Funke, Cornelia'),(12,'Stephenson, Neal');
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `book` (
  `isbn` varchar(20) NOT NULL DEFAULT '',
  `work_numb` int(11) unsigned DEFAULT NULL,
  `publisher_id` int(11) unsigned DEFAULT NULL,
  `edition` int(11) unsigned DEFAULT NULL,
  `binding` enum('Board','Leather') DEFAULT NULL,
  `copyright_year` smallint(11) DEFAULT NULL,
  PRIMARY KEY (`isbn`),
  KEY `Books_Work` (`work_numb`),
  KEY `Books_Publisher` (`publisher_id`),
  CONSTRAINT `Books_Publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`publisher_id`),
  CONSTRAINT `Books_Work` FOREIGN KEY (`work_numb`) REFERENCES `work` (`work_numb`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES ('978-1-11111-111-1',1,1,2,'Board',1857),('978-1-11111-112-1',1,1,1,'Board',1847),('978-1-11111-113-1',2,4,1,'Board',1842),('978-1-11111-114-1',3,4,1,'Board',1801),('978-1-11111-115-1',3,4,10,'Leather',1925),('978-1-11111-116-1',4,3,1,'Board',1805),('978-1-11111-117-1',5,5,1,'Board',1808),('978-1-11111-118-1',5,2,19,'Leather',1956),('978-1-11111-119-1',6,2,3,'Board',1956),('978-1-11111-120-1',8,4,5,'Board',1906),('978-1-11111-121-1',8,1,12,'Leather',1982),('978-1-11111-122-1',9,1,12,'Leather',1982),('978-1-11111-123-1',11,2,1,'Board',1998),('978-1-11111-124-1',12,2,1,'Board',1989),('978-1-11111-125-1',13,2,3,'Board',1965),('978-1-11111-126-1',13,2,9,'Leather',2001),('978-1-11111-127-1',14,2,1,'Board',1960),('978-1-11111-128-1',16,2,12,'Board',1960),('978-1-11111-129-1',16,2,14,'Leather',2002),('978-1-11111-130-1',17,3,6,'Leather',1905),('978-1-11111-131-1',18,4,6,'Board',1957),('978-1-11111-132-1',19,4,1,'Board',1962),('978-1-11111-133-1',20,4,1,'Board',1964),('978-1-11111-134-1',21,5,1,'Board',1964),('978-1-11111-135-1',23,5,1,'Board',1962),('978-1-11111-136-1',23,5,4,'Leather',2001),('978-1-11111-137-1',24,5,4,'Leather',2001),('978-1-11111-138-1',23,5,4,'Leather',2001),('978-1-11111-139-1',25,5,4,'Leather',2001),('978-1-11111-140-1',26,5,1,'Board',2001),('978-1-11111-141-1',27,5,1,'Board',2005),('978-1-11111-142-1',28,5,1,'Board',2008),('978-1-11111-143-1',29,5,1,'Board',1992),('978-1-11111-144-1',30,1,1,'Board',1952),('978-1-11111-145-1',30,5,1,'Board',2001),('978-1-11111-146-1',31,5,1,'Board',1999);
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `condition_code`
--

DROP TABLE IF EXISTS `condition_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `condition_code` (
  `condition_code` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `condition_description` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`condition_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `condition_code`
--

LOCK TABLES `condition_code` WRITE;
/*!40000 ALTER TABLE `condition_code` DISABLE KEYS */;
INSERT INTO `condition_code` VALUES (1,'New'),(2,'Excellent'),(3,'Fine'),(4,'Good'),(5,'Poor');
/*!40000 ALTER TABLE `condition_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `customer_numb` int(11) unsigned NOT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `street` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state_province` char(2) DEFAULT NULL,
  `zip_postcode` char(5) DEFAULT NULL,
  `contact_phone` char(12) DEFAULT NULL,
  PRIMARY KEY (`customer_numb`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Janice','Jones','125 Center Road','Anytown','NY','11111','518-555-1111'),(2,'Jon','Jones','25 Elm Road','Next Town','NJ','18888','209-555-2222'),(3,'John','Doe','821 Elm Street','Next Town','NJ','18888','209-555-3333'),(4,'Jane','Doe','852 Main Street','Anytown','NY','11111','518-555-4444'),(5,'Jane','Smith','1919 Main Street','New Village','NY','13333','518-555-5555'),(6,'Janice','Smith','800 Center Road','Anytown','NY','11111','518-555-6666'),(7,'Helen','Brown','25 Front Street','Anytown','NY','11111','518-555-7777'),(8,'Helen','Jerry','16 Main Street','Newtown','NJ','18886','518-555-8888'),(9,'Mary','Collins','301 Pine Road, Apt. ','Newtown','NJ','18886','518-555-9999'),(10,'Peter','Collins','18 Main Street','Newtown','NJ','18888','518-555-1010'),(11,'Edna','Hayes','209 Circle Road','Anytown','NY','11111','518-555-1110'),(12,'Franklin','Hayes','615 Circle Road','Anytown','NY','11111','518-555-1212'),(13,'Peter','Johnson','22 Rose Court','Next Town','NJ','18888','209-555-1212'),(14,'Peter','Johnson','881 Front Street','Next Town','NJ','18888','209-555-1414'),(15,'John','Smith','881 Manor Lane','Next Town','NJ','18888','209-555-1515');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publisher` (
  `publisher_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `publisher_name` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`publisher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (1,'Wiley'),(2,'Simon & Schuster'),(3,'Macmillan'),(4,'Tor'),(5,'DAW');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale`
--

DROP TABLE IF EXISTS `sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sale` (
  `sale_id` int(11) unsigned NOT NULL,
  `customer_numb` int(11) unsigned DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `sale_total_amt` decimal(13,2) DEFAULT NULL,
  `credit_card_numb` varchar(25) DEFAULT '1234-5678-9101-1121',
  `exp_month` tinyint(2) DEFAULT NULL,
  `exp_year` tinyint(2) DEFAULT NULL,
  PRIMARY KEY (`sale_id`),
  KEY `Sale_Customer` (`customer_numb`),
  CONSTRAINT `Sale_Customer` FOREIGN KEY (`customer_numb`) REFERENCES `customer` (`customer_numb`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale`
--

LOCK TABLES `sale` WRITE;
/*!40000 ALTER TABLE `sale` DISABLE KEYS */;
INSERT INTO `sale` VALUES (1,1,'2021-05-29',510.00,'1234-5678-9101-1121',10,18),(2,1,'2021-07-05',125.00,'1234-5678-9101-1121',10,18),(3,1,'2021-06-15',58.00,'1234-5678-9101-1121',10,18),(4,4,'2021-06-30',110.00,'1234-5678-9101-5555',7,17),(5,6,'2021-06-30',110.00,'1234-5678-9101-6666',12,17),(6,12,'2021-07-05',505.00,'1234-5678-9101-7777',7,16),(7,8,'2021-07-05',80.00,'1234-5678-9101-8888',8,16),(8,5,'2021-07-07',90.00,'1234-5678-9101-9999',9,15),(9,8,'2021-07-07',50.00,'1234-5678-9101-8888',8,16),(10,11,'2021-07-10',125.00,'1234-5678-9101-1010',11,16),(11,9,'2021-07-10',200.00,'1234-5678-9101-0909',11,15),(12,10,'2021-07-10',200.00,'1234-5678-9101-0101',10,15),(13,2,'2021-07-10',25.95,'1234-5678-9101-2222',2,15),(14,6,'2021-07-10',80.00,'1234-5678-9101-6666',12,17),(15,11,'2021-07-12',75.00,'1234-5678-9101-1231',11,17),(16,2,'2021-07-25',130.00,'1234-5678-9101-2222',2,15),(17,1,'2021-07-25',100.00,'1234-5678-9101-1121',10,18),(18,5,'2021-08-22',100.00,'1234-5678-9101-9999',9,15),(19,6,'2021-09-01',95.00,'1234-5678-9101-7777',7,16),(20,2,'2021-09-01',75.00,'1234-5678-9101-2222',2,15);
/*!40000 ALTER TABLE `sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volume`
--

DROP TABLE IF EXISTS `volume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `volume` (
  `inventory_id` int(11) unsigned NOT NULL,
  `isbn` varchar(20) NOT NULL DEFAULT '',
  `condition_code` int(11) unsigned NOT NULL,
  `date_acquired` date DEFAULT NULL,
  `asking_price` decimal(13,2) DEFAULT NULL,
  `selling_price` decimal(13,2) DEFAULT NULL,
  `sale_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`inventory_id`),
  KEY `Volume_Books` (`isbn`),
  KEY `Volume_Condition` (`condition_code`),
  CONSTRAINT `Volume_Books` FOREIGN KEY (`isbn`) REFERENCES `book` (`isbn`),
  CONSTRAINT `Volume_Condition` FOREIGN KEY (`condition_code`) REFERENCES `condition_code` (`condition_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volume`
--

LOCK TABLES `volume` WRITE;
/*!40000 ALTER TABLE `volume` DISABLE KEYS */;
INSERT INTO `volume` VALUES (1,'978-1-11111-111-1',3,'2019-06-12',175.00,175.00,1),(2,'978-1-11111-131-1',4,'2020-01-23',50.00,50.00,1),(3,'978-1-11111-133-1',2,'2018-04-05',300.00,285.00,1),(4,'978-1-11111-142-1',1,'2018-04-05',25.95,25.95,2),(5,'978-1-11111-146-1',1,'2018-04-05',22.95,22.95,2),(6,'978-1-11111-144-1',2,'2019-05-15',80.00,76.10,2),(7,'978-1-11111-137-1',2,'2019-06-20',80.00,NULL,NULL),(8,'978-1-11111-137-1',3,'2020-06-20',50.00,NULL,NULL),(9,'978-1-11111-136-1',1,'2019-12-20',75.00,NULL,NULL),(10,'978-1-11111-136-1',2,'2019-12-15',50.00,NULL,NULL),(11,'978-1-11111-143-1',1,'2020-04-05',25.00,25.00,3),(12,'978-1-11111-132-1',1,'2020-06-12',15.00,15.00,3),(13,'978-1-11111-133-1',3,'2020-04-20',18.00,18.00,3),(14,'978-1-11111-121-1',2,'2020-04-20',110.00,110.00,4),(15,'978-1-11111-121-1',2,'2020-04-20',110.00,110.00,5),(16,'978-1-11111-121-1',2,'2020-04-20',110.00,NULL,NULL),(17,'978-1-11111-124-1',2,'2021-01-12',75.00,NULL,NULL),(18,'978-1-11111-146-1',1,'2020-05-11',30.00,30.00,6),(19,'978-1-11111-122-1',2,'2020-06-06',75.00,75.00,6),(20,'978-1-11111-130-1',2,'2020-04-20',150.00,120.00,6),(21,'978-1-11111-126-1',2,'2020-04-20',110.00,110.00,6),(22,'978-1-11111-139-1',2,'2020-05-16',200.00,170.00,6),(23,'978-1-11111-125-1',2,'2020-05-16',45.00,45.00,7),(24,'978-1-11111-131-1',3,'2020-04-20',35.00,35.00,7),(25,'978-1-11111-126-1',2,'2020-11-16',75.00,75.00,8),(26,'978-1-11111-133-1',3,'2020-11-16',35.00,55.00,8),(27,'978-1-11111-141-1',1,'2020-11-06',24.95,NULL,NULL),(28,'978-1-11111-141-1',1,'2020-11-06',24.95,NULL,NULL),(29,'978-1-11111-141-1',1,'2020-11-06',24.95,NULL,NULL),(30,'978-1-11111-145-1',1,'2020-11-06',27.95,NULL,NULL),(31,'978-1-11111-145-1',1,'2020-11-06',27.95,NULL,NULL),(32,'978-1-11111-145-1',1,'2020-11-06',27.95,NULL,NULL),(33,'978-1-11111-139-1',2,'2020-10-06',75.00,50.00,9),(34,'978-1-11111-133-1',1,'2020-11-16',125.00,125.00,10),(35,'978-1-11111-126-1',1,'2020-10-06',75.00,75.00,11),(36,'978-1-11111-130-1',3,'2019-12-06',50.00,50.00,11),(37,'978-1-11111-136-1',3,'2019-12-06',75.00,75.00,11),(38,'978-1-11111-130-1',2,'2020-04-06',200.00,150.00,12),(39,'978-1-11111-132-1',3,'2020-04-06',75.00,75.00,12),(40,'978-1-11111-129-1',1,'2020-04-06',25.95,25.95,13),(41,'978-1-11111-141-1',1,'2020-05-16',40.00,40.00,14),(42,'978-1-11111-141-1',1,'2020-05-16',40.00,40.00,14),(43,'978-1-11111-132-1',1,'2020-11-12',17.95,NULL,NULL),(44,'978-1-11111-138-1',1,'2020-11-12',75.95,NULL,NULL),(45,'978-1-11111-138-1',1,'2020-11-12',75.95,NULL,NULL),(46,'978-1-11111-131-1',3,'2020-11-12',15.95,NULL,NULL),(47,'978-1-11111-140-1',3,'2020-11-12',25.95,NULL,NULL),(48,'978-1-11111-123-1',2,'2020-08-16',24.95,NULL,NULL),(49,'978-1-11111-127-1',2,'2020-08-16',27.95,NULL,NULL),(50,'978-1-11111-127-1',2,'2021-01-06',50.00,50.00,15),(51,'978-1-11111-141-1',2,'2021-01-06',50.00,50.00,15),(52,'978-1-11111-141-1',2,'2021-01-06',50.00,50.00,16),(53,'978-1-11111-123-1',2,'2021-01-06',40.00,40.00,16),(54,'978-1-11111-127-1',2,'2021-01-06',40.00,40.00,16),(55,'978-1-11111-133-1',2,'2021-02-06',40.00,40.00,17),(56,'978-1-11111-127-1',2,'2021-02-16',40.00,40.00,17),(57,'978-1-11111-135-1',2,'2021-02-16',40.00,40.00,18),(59,'978-1-11111-127-1',2,'2021-02-25',35.00,35.00,18),(60,'978-1-11111-128-1',2,'2020-12-16',50.00,45.00,NULL),(61,'978-1-11111-136-1',3,'2020-10-22',50.00,50.00,19),(62,'978-1-11111-115-1',2,'2020-10-22',75.00,75.00,20),(63,'978-1-11111-130-1',2,'2020-07-16',500.00,NULL,NULL),(64,'978-1-11111-136-1',2,'2020-03-06',125.00,NULL,NULL),(65,'978-1-11111-136-1',2,'2020-03-06',125.00,NULL,NULL),(66,'978-1-11111-137-1',2,'2020-03-06',125.00,NULL,NULL),(67,'978-1-11111-137-1',2,'2020-03-06',125.00,NULL,NULL),(68,'978-1-11111-138-1',2,'2020-03-06',125.00,NULL,NULL),(69,'978-1-11111-138-1',2,'2020-03-06',125.00,NULL,NULL),(70,'978-1-11111-139-1',2,'2020-03-06',125.00,NULL,NULL),(71,'978-1-11111-139-1',2,'2020-03-06',125.00,NULL,NULL);
/*!40000 ALTER TABLE `volume` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work`
--

DROP TABLE IF EXISTS `work`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `work` (
  `work_numb` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `author_numb` int(11) unsigned NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`work_numb`),
  KEY `author_numb` (`author_numb`),
  CONSTRAINT `Work_Author` FOREIGN KEY (`author_numb`) REFERENCES `author` (`author_numb`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work`
--

LOCK TABLES `work` WRITE;
/*!40000 ALTER TABLE `work` DISABLE KEYS */;
INSERT INTO `work` VALUES (1,1,'Jane Eyre'),(2,1,'Villette'),(3,2,'Hound of the Baskervilles'),(4,2,'Lost World, The'),(5,2,'Complete Sherlock Holmes'),(6,3,'Connecticut Yankee in King Arthur\'s Court, A'),(7,3,'Prince and the Pauper'),(8,3,'Tom Sawyer'),(9,3,'Adventures of Huckleberry Finn, The'),(10,7,'Bourne Identity, The'),(11,7,'Matarese Circle, The'),(12,7,'Bourne Supremacy, The'),(13,5,'Fountainhead, The'),(14,5,'Atlas Shrugged'),(15,6,'Peter Pan'),(16,4,'Kidnapped'),(17,4,'Treasure Island'),(18,8,'Sot Weed Factor, The'),(19,8,'Lost in the Funhouse'),(20,8,'Giles Goat Boy'),(21,9,'Dune'),(22,9,'Dune Messiah'),(23,10,'Foundation'),(24,10,'Last Foundation'),(25,10,'I, Robot'),(26,11,'Inkheart'),(27,11,'Inkdeath'),(28,12,'Anathem'),(29,12,'Snow Crash'),(30,5,'Anthem'),(31,12,'Cryptonomicon');
/*!40000 ALTER TABLE `work` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-25 12:11:50
