CREATE TABLE IF NOT EXISTS `stevid_ikanv2_contracts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE IF NOT EXISTS `stevid_ikanv2_dives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


CREATE TABLE IF NOT EXISTS `stevid_ikanv2_user` (
  `identifier` varchar(50) DEFAULT NULL,
  `fishing_simulator_users` longtext DEFAULT NULL,
  `fishing_simulator_fishes_caught` longtext DEFAULT NULL,
  `equipments` longtext DEFAULT NULL,
  `property` longtext DEFAULT NULL,
  `vehicles` longtext DEFAULT NULL,
  `darkmode` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
