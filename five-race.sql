-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         9.5.0 - MySQL Community Server - GPL
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para five-race
CREATE DATABASE IF NOT EXISTS `five-race` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `five-race`;

-- Volcando estructura para tabla five-race.server_logs
CREATE TABLE IF NOT EXISTS `server_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `identifier` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `details` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `action` (`action`),
  KEY `created_at` (`created_at`),
  CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla five-race.server_logs: ~0 rows (aproximadamente)

-- Volcando estructura para tabla five-race.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Unique player identifier (e.g., license, steam, etc.)',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Player''s display name',
  `group` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'user' COMMENT 'Permission group',
  `first_seen` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'First time the player connected',
  `last_seen` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last time the player was online',
  `banned` tinyint(1) DEFAULT '0' COMMENT 'Whether the player is banned',
  `ban_reason` text COLLATE utf8mb4_unicode_ci COMMENT 'Reason for ban if applicable',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Last known IP address',
  `discord` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Discord ID if linked',
  `steam` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Steam ID if available',
  `license` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'FiveM license identifier',
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`),
  KEY `group` (`group`),
  KEY `banned` (`banned`),
  KEY `steam` (`steam`),
  KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla five-race.users: ~0 rows (aproximadamente)

-- Volcando estructura para tabla five-race.user_accounts
CREATE TABLE IF NOT EXISTS `user_accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Account type (e.g., bank, money, black_money)',
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_account` (`user_id`,`name`),
  CONSTRAINT `fk_account_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla five-race.user_accounts: ~0 rows (aproximadamente)

-- Volcando estructura para tabla five-race.user_characters
CREATE TABLE IF NOT EXISTS `user_characters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT 'Reference to users table',
  `identifier` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Same as users.identifier for quick lookups',
  `character_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'JSON string with all character customization',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When the character was created',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'When the character was last updated',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Whether this is the active character',
  `deleted` tinyint(1) DEFAULT '0' COMMENT 'Soft delete flag',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `identifier` (`identifier`),
  KEY `is_active` (`is_active`),
  CONSTRAINT `fk_character_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla five-race.user_characters: ~0 rows (aproximadamente)

-- Volcando estructura para tabla five-race.user_identifiers
CREATE TABLE IF NOT EXISTS `user_identifiers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Identifier type (e.g., license, steam, discord)',
  `value` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The actual identifier value',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type_value` (`type`,`value`),
  KEY `user_id` (`user_id`),
  KEY `type` (`type`),
  CONSTRAINT `fk_identifier_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla five-race.user_identifiers: ~0 rows (aproximadamente)

-- Volcando estructura para tabla five-race.user_inventory
CREATE TABLE IF NOT EXISTS `user_inventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `item` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `count` int NOT NULL DEFAULT '1',
  `metadata` longtext COLLATE utf8mb4_unicode_ci COMMENT 'JSON string with item metadata',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `item` (`item`),
  CONSTRAINT `fk_inventory_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla five-race.user_inventory: ~0 rows (aproximadamente)

-- Volcando estructura para tabla five-race.user_vehicles
CREATE TABLE IF NOT EXISTS `user_vehicles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `vehicle` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `plate` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `garage` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'impound' COMMENT 'Current garage location',
  `stored` tinyint(1) DEFAULT '0' COMMENT 'Whether the vehicle is in a garage',
  `mods` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Vehicle modifications',
  `fuel_level` float DEFAULT '100',
  `engine_health` float DEFAULT '1000',
  `body_health` float DEFAULT '1000',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `user_id` (`user_id`),
  KEY `garage` (`garage`),
  KEY `stored` (`stored`),
  CONSTRAINT `fk_vehicle_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla five-race.user_vehicles: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
