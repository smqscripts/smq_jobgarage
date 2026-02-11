CREATE TABLE IF NOT EXISTS `job_garages` (
  `plate` varchar(12) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `job` varchar(50) DEFAULT NULL,
  `vehicle` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `state` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;