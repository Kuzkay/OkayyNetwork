-- --------------------------------------------------------
-- Host:                         185.158.249.251
-- Server version:               5.7.28-0ubuntu0.18.04.4 - (Ubuntu)
-- Server OS:                    Linux
-- HeidiSQL Version:             9.5.0.5338
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for basic
CREATE DATABASE IF NOT EXISTS `basic` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `basic`;

-- Dumping structure for table basic.items
CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item` varchar(50) NOT NULL DEFAULT '0',
  `title` varchar(50) NOT NULL DEFAULT '0',
  `title_plural` varchar(50) DEFAULT NULL,
  `max` int(11) NOT NULL DEFAULT '1',
  `model` int(11) DEFAULT NULL,
  `model_scale` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `item` (`item`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

-- Dumping data for table basic.items: ~31 rows (approximately)
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` (`id`, `item`, `title`, `title_plural`, `max`, `model`, `model_scale`) VALUES
	(1, 'cocaine', 'Cocaine', 'Cocaine', 5, 619, 0.5),
	(2, 'weed', 'Weed', 'Weed', 10, NULL, 0.4),
	(3, 'empty', 'Test Item', 'Test Items', 10, NULL, NULL),
	(4, 'bandage', 'Bandage', 'Bandages', 3, 803, 2.5),
	(5, 'medkit', 'First Aid Kit', 'First Aid Kits', 1, 800, 1),
	(6, 'ammo', 'Ammo Box', 'Ammo Boxes', 3, 989, 1),
	(7, 'donut', 'Donut', 'Donuts', 12, NULL, NULL),
	(8, 'cannabis', 'Cannabis', 'Cannabis', 20, NULL, NULL),
	(9, 'meth', 'Meth', 'Meth', 10, NULL, NULL),
	(10, 'coca', 'Coca leaf', 'Coca leaves', 8, NULL, NULL),
	(11, 'garbage', 'Garbage', 'Garbage', 1, 514, 0.7),
	(12, 'asphalt', 'Asphalt', 'Asphalt', 1, NULL, NULL),
	(13, 'package', 'Package', 'Packages', 1, NULL, NULL),
	(14, 'firework', 'Fireworks', 'Fireworks', 5, NULL, NULL),
	(15, 'bigfirework', 'Fireworks Pack', 'Fireworks Pack', 1, NULL, NULL),
	(16, 'gas', 'Gasoline', 'Gasoline', 2, 507, 0.9),
	(17, 'acetone', 'Acetone', 'Acetone', 2, 564, 0.7),
	(18, 'calcium', 'Calcium Chloride', 'Calcium Chloride', 3, 807, 3),
	(19, 'poppy', 'Opium Poppy', 'Opium Poppies', 12, NULL, NULL),
	(20, 'heroin', 'Heroin', 'Heroin', 5, NULL, NULL),
	(21, 'repairkit', 'Repair kit', 'Repair kits', 1, 551, 0.7),
	(22, 'ore', 'Ore', 'Ores', 1, NULL, NULL),
	(23, 'ziptie', 'Ziptie', 'Zipties', 1, NULL, NULL),
	(24, 'cuffs', 'Cuffs', 'Cuffs', 1, 1439, 1.2),
	(25, 'beer', 'Beer', 'Beers', 6, 1630, 1),
	(26, 'vodka', 'Vodka', 'Vodka', 2, 1613, 1),
	(27, 'tequilla', 'Tequilla', 'Tequilla', 2, 1238, 1),
	(28, 'pliers', 'Pliers', 'Pliers', 1, 552, 1.2),
	(29, 'pizza', 'Pizza', 'Pizzas', 1, NULL, NULL),
	(30, 'fastfood', 'Fastfood bag', 'Fastfood Bags', 1, NULL, NULL),
	(31, 'lumber', 'Lumber', 'Lumber', 4, NULL, NULL);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;

-- Dumping structure for table basic.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(50) DEFAULT NULL,
  `title` char(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- Dumping data for table basic.jobs: ~12 rows (approximately)
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` (`id`, `name`, `title`) VALUES
	(1, 'unemployed', 'Unemployed'),
	(2, 'police', 'Police'),
	(3, 'roadworker', 'Roadworker'),
	(4, 'garbage', 'Garbage'),
	(5, 'delivery', 'Delivery'),
	(6, 'offpolice', 'Police'),
	(7, 'ems', 'EMS'),
	(8, 'offems', 'EMS'),
	(9, 'miner', 'Miner'),
	(10, 'pizza', 'Pizza'),
	(11, 'fastfood', 'Fastfood'),
	(12, 'lumberjack', 'Lumberjack');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;

-- Dumping structure for table basic.jobs_grades
CREATE TABLE IF NOT EXISTS `jobs_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` char(50) NOT NULL DEFAULT '0',
  `job_grade` int(11) NOT NULL DEFAULT '0',
  `job_grade_title` char(50) NOT NULL DEFAULT '0',
  `paycheck` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;

-- Dumping data for table basic.jobs_grades: ~34 rows (approximately)
/*!40000 ALTER TABLE `jobs_grades` DISABLE KEYS */;
INSERT INTO `jobs_grades` (`id`, `job`, `job_grade`, `job_grade_title`, `paycheck`) VALUES
	(1, 'unemployed', 1, 'Citizen', 350),
	(2, 'police', 1, 'Cadet', 460),
	(3, 'police', 2, 'Officer', 650),
	(4, 'police', 3, 'Corporal', 780),
	(5, 'police', 4, 'Sergeant', 850),
	(6, 'police', 5, 'Lieutenant', 900),
	(7, 'police', 6, 'Captain', 1100),
	(8, 'police', 7, 'Deputy Chief', 1550),
	(9, 'police', 8, 'Chief', 2000),
	(10, 'roadworker', 1, 'Worker', 350),
	(11, 'garbage', 1, 'Worker', 350),
	(12, 'delivery', 1, 'Driver', 350),
	(13, 'offpolice', 1, 'Off-duty', 400),
	(14, 'offpolice', 2, 'Off-duty', 500),
	(15, 'offpolice', 3, 'Off-duty', 600),
	(16, 'offpolice', 4, 'Off-duty', 700),
	(17, 'offpolice', 5, 'Off-duty', 800),
	(18, 'offpolice', 6, 'Off-duty', 900),
	(19, 'offpolice', 7, 'Off-duty', 1000),
	(20, 'offpolice', 8, 'Off-duty', 1200),
	(21, 'ems', 1, 'Trainee', 500),
	(22, 'ems', 2, 'EMT', 600),
	(23, 'ems', 3, 'Paramedic', 900),
	(24, 'ems', 4, 'Deputy-Chief', 1500),
	(25, 'ems', 5, 'Chief', 2000),
	(26, 'offems', 1, 'Off-duty', 400),
	(27, 'offems', 2, 'Off-duty', 500),
	(28, 'offems', 3, 'Off-duty', 700),
	(29, 'offems', 4, 'Off-duty', 900),
	(30, 'offems', 5, 'Off-duty', 1100),
	(31, 'miner', 1, 'Worker', 350),
	(32, 'pizza', 1, 'Delivery', 350),
	(33, 'fastfood', 1, 'Delivery', 350),
	(34, 'lumberjack', 1, 'Worker', 350);
/*!40000 ALTER TABLE `jobs_grades` ENABLE KEYS */;

-- Dumping structure for table basic.profiles
CREATE TABLE IF NOT EXISTS `profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steamid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `money` int(11) DEFAULT '0',
  `bank` int(11) DEFAULT '0',
  `role` varchar(50) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `experience` int(11) DEFAULT NULL,
  `position` text,
  `inventory` longtext NOT NULL,
  `job` varchar(50) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT '1',
  `phone` int(6) DEFAULT NULL,
  `dead` int(11) NOT NULL DEFAULT '0',
  `donator` int(11) DEFAULT '0',
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;

-- Dumping data for table basic.profiles: ~0 rows (approximately)
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;

-- Dumping structure for table basic.server_info
CREATE TABLE IF NOT EXISTS `server_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` varchar(50) DEFAULT NULL,
  `value` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Dumping data for table basic.server_info: ~1 rows (approximately)
/*!40000 ALTER TABLE `server_info` DISABLE KEYS */;
INSERT INTO `server_info` (`id`, `data`, `value`) VALUES
	(1, 'time', '12');
/*!40000 ALTER TABLE `server_info` ENABLE KEYS */;

-- Dumping structure for table basic.storages
CREATE TABLE IF NOT EXISTS `storages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server` int(11) NOT NULL DEFAULT '1',
  `storage` varchar(50) NOT NULL DEFAULT '0',
  `slots` int(11) DEFAULT NULL,
  `inventory` longtext,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=latin1;

-- Dumping data for table basic.storages: ~0 rows (approximately)
/*!40000 ALTER TABLE `storages` DISABLE KEYS */;
/*!40000 ALTER TABLE `storages` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
