-- phpMyAdmin SQL Dump export form PhpMyAdmin
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 14, 2025 at 10:20 AM
-- Server version: 8.0.27-0ubuntu0.20.04.1
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fradur19sql5`
--

-- --------------------------------------------------------

--
-- Table structure for table `Building`
--

CREATE TABLE `Building` (
  `g_id` int NOT NULL,
  `g_name` varchar(255) DEFAULT NULL,
  `floor_nr` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Building`
--

INSERT INTO `Building` (`g_id`, `g_name`, `floor_nr`) VALUES
(1, 'A', 3),
(2, 'C', 2),
(3, 'Sporthalle', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `open_problem_count_per_room`
-- (See below for the actual view)
--
CREATE TABLE `open_problem_count_per_room` (
`open_problem_count` bigint
,`room_name` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `Problem`
--

CREATE TABLE `Problem` (
  `p_id` int NOT NULL,
  `r_id` int DEFAULT NULL,
  `s_id` int DEFAULT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Problem`
--

INSERT INTO `Problem` (`p_id`, `r_id`, `s_id`, `description`) VALUES
(1, 2, 1, 'Luft'),
(2, 1, 1, 'Flecken im Wand'),
(3, 4, 2, 'Kein funktionierende Komputer'),
(4, 6, 3, 'Flecken im Wand'),
(5, 5, 1, 'Projektor'),
(6, 7, 1, 'Nicht sauber'),
(7, 7, 1, 'Keine Toilettenpapier'),
(8, 3, 1, 'Schimmel');

-- --------------------------------------------------------

--
-- Table structure for table `Room`
--

CREATE TABLE `Room` (
  `r_id` int NOT NULL,
  `g_id` int DEFAULT NULL,
  `room_name` varchar(255) DEFAULT NULL,
  `room_type` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Room`
--

INSERT INTO `Room` (`r_id`, `g_id`, `room_name`, `room_type`) VALUES
(1, 1, 'K27', 'Classroom'),
(2, 1, 'MLAB', 'ComputerRoom'),
(3, 1, 'Laborator', 'ScienceRoom'),
(4, 2, 'HLAB', 'ComputerRoom'),
(5, 2, 'PR1', 'ComputerRoom'),
(6, 2, 'CLAB', 'ComputerRoom'),
(7, 3, 'GirlsRoom', 'ChangingRoom'),
(8, 3, 'BoysRoom', 'ChangingRoom'),
(9, 3, 'TeachersRoom', 'ChangingRoom');

-- --------------------------------------------------------

--
-- Stand-in structure for view `room_problem_summary`
-- (See below for the actual view)
--
CREATE TABLE `room_problem_summary` (
`problem_count` bigint
,`room_name` varchar(255)
,`room_type` varchar(255)
,`status_name` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `Status`
--

CREATE TABLE `Status` (
  `s_id` int NOT NULL,
  `status_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Status`
--

INSERT INTO `Status` (`s_id`, `status_name`) VALUES
(1, 'Open'),
(2, 'Working'),
(3, 'Finished');

-- --------------------------------------------------------

--
-- Stand-in structure for view `wall_problem_count_by_building`
-- (See below for the actual view)
--
CREATE TABLE `wall_problem_count_by_building` (
`g_name` varchar(255)
,`wall_problem_count` bigint
);

-- --------------------------------------------------------

--
-- Structure for view `open_problem_count_per_room`
--
DROP TABLE IF EXISTS `open_problem_count_per_room`;

CREATE ALGORITHM=UNDEFINED DEFINER=`fradur19sql5`@`localhost` SQL SECURITY DEFINER VIEW `open_problem_count_per_room`  AS  select `r`.`room_name` AS `room_name`,count(`p`.`p_id`) AS `open_problem_count` from ((`Problem` `p` join `Room` `r` on((`p`.`r_id` = `r`.`r_id`))) join `Status` `s` on((`p`.`s_id` = `s`.`s_id`))) where (`s`.`status_name` = 'Open') group by `r`.`room_name` ;

-- --------------------------------------------------------

--
-- Structure for view `room_problem_summary`
--
DROP TABLE IF EXISTS `room_problem_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`fradur19sql5`@`localhost` SQL SECURITY DEFINER VIEW `room_problem_summary`  AS  select `r`.`room_name` AS `room_name`,`r`.`room_type` AS `room_type`,`s`.`status_name` AS `status_name`,count(`p`.`p_id`) AS `problem_count` from ((`Room` `r` join `Problem` `p` on((`r`.`r_id` = `p`.`r_id`))) join `Status` `s` on((`p`.`s_id` = `s`.`s_id`))) group by `r`.`room_name`,`r`.`room_type`,`s`.`status_name` ;

-- --------------------------------------------------------

--
-- Structure for view `wall_problem_count_by_building`
--
DROP TABLE IF EXISTS `wall_problem_count_by_building`;

CREATE ALGORITHM=UNDEFINED DEFINER=`fradur19sql5`@`localhost` SQL SECURITY DEFINER VIEW `wall_problem_count_by_building`  AS  select `b`.`g_name` AS `g_name`,count(0) AS `wall_problem_count` from (((`Building` `b` join `Room` `r` on((`b`.`g_id` = `r`.`g_id`))) join `Problem` `p` on((`r`.`r_id` = `p`.`r_id`))) join `Status` `s` on((`p`.`s_id` = `s`.`s_id`))) where ((`p`.`description` = 'Flecken im Wand') and (`s`.`status_name` = 'Open')) group by `b`.`g_name` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Building`
--
ALTER TABLE `Building`
  ADD PRIMARY KEY (`g_id`);

--
-- Indexes for table `Problem`
--
ALTER TABLE `Problem`
  ADD PRIMARY KEY (`p_id`),
  ADD KEY `r_id` (`r_id`),
  ADD KEY `s_id` (`s_id`);

--
-- Indexes for table `Room`
--
ALTER TABLE `Room`
  ADD PRIMARY KEY (`r_id`),
  ADD KEY `g_id` (`g_id`);

--
-- Indexes for table `Status`
--
ALTER TABLE `Status`
  ADD PRIMARY KEY (`s_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Building`
--
ALTER TABLE `Building`
  MODIFY `g_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Problem`
--
ALTER TABLE `Problem`
  MODIFY `p_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Room`
--
ALTER TABLE `Room`
  MODIFY `r_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `Status`
--
ALTER TABLE `Status`
  MODIFY `s_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Problem`
--
ALTER TABLE `Problem`
  ADD CONSTRAINT `Problem_ibfk_1` FOREIGN KEY (`r_id`) REFERENCES `Room` (`r_id`),
  ADD CONSTRAINT `Problem_ibfk_2` FOREIGN KEY (`s_id`) REFERENCES `Status` (`s_id`);

--
-- Constraints for table `Room`
--
ALTER TABLE `Room`
  ADD CONSTRAINT `Room_ibfk_1` FOREIGN KEY (`g_id`) REFERENCES `Building` (`g_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
