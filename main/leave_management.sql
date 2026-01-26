-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 20, 2025 at 07:16 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `leave_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `general_applications`
--

CREATE TABLE `general_applications` (
  `id` int(11) NOT NULL,
  `reg_no` varchar(255) NOT NULL,
  `place_of_visit` varchar(255) NOT NULL,
  `purpose_of_visit` varchar(255) NOT NULL,
  `from_date` date NOT NULL,
  `from_time` time NOT NULL,
  `to_date` date NOT NULL,
  `to_time` time NOT NULL,
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `general_applications`
--

INSERT INTO `general_applications` (`id`, `reg_no`, `place_of_visit`, `purpose_of_visit`, `from_date`, `from_time`, `to_date`, `to_time`, `status`) VALUES
(1, '22BCE9029', 'Mandsaur', 'Vacation', '2024-11-30', '08:30:00', '2024-11-30', '09:30:00', 'WApproved'),
(2, '22BCE9029', 'Mandsaur', 'Holidays', '2024-11-30', '08:30:00', '2024-12-06', '09:30:00', 'WApproved'),
(3, '22BCE9029', 'Mandsaur', 'Holidays', '2024-11-30', '13:30:00', '2024-12-07', '10:30:00', 'MRejected'),
(4, '22BCE9029', 'Mandsaue', 'Vacation', '2024-11-30', '10:45:00', '2024-12-07', '10:30:00', 'WApproved'),
(5, '22BCE9029', 'Mandsaur', 'Vacation', '2024-11-30', '15:00:00', '2024-11-30', '18:00:00', 'WApproved'),
(6, '22BCE9029', 'MDS', 'Holidays', '2024-12-27', '00:00:00', '2024-12-27', '04:00:00', 'WApproved'),
(7, '22BCE9029', 'Rajasthan', 'Holidays', '2025-03-25', '15:00:00', '2025-04-05', '16:00:00', 'WApproved'),
(8, '22BCE9029', 'Manipal', 'Urgent Hospital', '2025-03-31', '01:00:00', '2025-03-31', '00:00:00', 'WApproved'),
(9, '22BCE9029', 'HELOO', 'HELOO', '2025-11-20', '02:22:11', '2025-11-20', '11:00:00', 'WApproved');

-- --------------------------------------------------------

--
-- Table structure for table `mentors`
--

CREATE TABLE `mentors` (
  `emp_id` varchar(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `contact` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mentors`
--

INSERT INTO `mentors` (`emp_id`, `name`, `department`, `contact`) VALUES
('175478', 'Dr. Ramkumar D', 'SCOPE', '2147483647'),
('175479', 'Dr. Sibi', 'SCOPE', '9521011212');

-- --------------------------------------------------------

--
-- Table structure for table `mentor_mentees`
--

CREATE TABLE `mentor_mentees` (
  `id` int(11) NOT NULL,
  `mentor_id` varchar(255) NOT NULL,
  `reg_no` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mentor_mentees`
--

INSERT INTO `mentor_mentees` (`id`, `mentor_id`, `reg_no`) VALUES
(1, '175478', '22BCE9029');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `reg_no` varchar(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `branch` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  `contact` varchar(15) NOT NULL,
  `parent_contact` varchar(15) DEFAULT NULL,
  `application_number` varchar(15) DEFAULT NULL,
  `gender` char(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`reg_no`, `name`, `branch`, `batch`, `contact`, `parent_contact`, `application_number`, `gender`) VALUES
('22BCE9029', 'Harsh Carpenter', 'BCE', 2022, '9179970908', '9893609945', '2022175479', 'Male');

-- --------------------------------------------------------

--
-- Table structure for table `student_hostel`
--

CREATE TABLE `student_hostel` (
  `reg_no` varchar(255) NOT NULL,
  `hostel_block` char(5) NOT NULL,
  `room_number` char(5) NOT NULL,
  `room_type` varchar(255) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_hostel`
--

INSERT INTO `student_hostel` (`reg_no`, `hostel_block`, `room_number`, `room_type`, `id`) VALUES
('22BCE9029', 'MH-3', '216', '4 Bed Non-AC', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `reg_no` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `privilege` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`reg_no`, `password`, `name`, `email`, `privilege`) VALUES
('175478', 'faculty@111', 'Dr Ramkumar D', 'mentor@vitap.ac.in', 'mentor'),
('175479', 'faculty@112', 'Dr. Sibi', 'sibi@vitap.ac.in', 'mentor'),
('2', 'warden@mh3', 'Srinivas', 'mh3.warden@vitap.ac.in', 'warden'),
('22BCE9029', 'admin@2004', 'Harsh Carpenter', 'harsh@vitap.ac.in', 'student');

-- --------------------------------------------------------

--
-- Table structure for table `wardens`
--

CREATE TABLE `wardens` (
  `warden_id` int(11) NOT NULL,
  `warden_name` varchar(255) NOT NULL,
  `block` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wardens`
--

INSERT INTO `wardens` (`warden_id`, `warden_name`, `block`) VALUES
(2, 'Srinivas', 'MH-3');

-- --------------------------------------------------------

--
-- Table structure for table `weekend_applications`
--

CREATE TABLE `weekend_applications` (
  `id` int(11) NOT NULL,
  `reg_no` varchar(255) NOT NULL,
  `place_of_visit` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `purpose_of_visit` varchar(255) DEFAULT NULL,
  `time_slot` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `mentor_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weekend_applications`
--

INSERT INTO `weekend_applications` (`id`, `reg_no`, `place_of_visit`, `date`, `purpose_of_visit`, `time_slot`, `status`, `mentor_id`) VALUES
(9, '22BCE9029', 'Vijayawada', '2024-10-27', 'Health', 'slot1', 'WApproved', 175478),
(10, '22BCE9029', 'Vijayawada', '2024-11-17', 'Shopping', 'slot1', 'WApproved', 175478),
(11, '22BCE9029', 'Vijayawada', '2024-12-15', 'Dance', 'slot3', 'WApproved', 175478),
(12, '22BCE9029', 'Vijayawada', '2024-12-29', 'Shopping', 'slot1', 'WApproved', 175478),
(13, '22BCE9029', 'Mandsaur', '2024-12-29', 'Shopping', 'slot1', 'WApproved', 175478),
(14, '22BCE9029', 'Vijayawadad', '2025-01-12', 'Leave', 'slot1', 'MRejected', 175478),
(15, '22BCE9029', 'Hyderabad', '2025-01-13', 'Shop', 'slot2', 'WApproved', 175478),
(16, '22BCE9029', 'Vijaya', '2025-01-19', 'shiop', 'slot2', 'MRejected', 175478),
(17, '22BCE9029', 'Guntur', '2025-03-16', 'DANCE', 'slot1', 'WApproved', 175478),
(18, '22BCE9029', 'Vijayawada', '2025-11-23', 'Going for hospital visit', 'slot1', 'Applied', 175478);

-- --------------------------------------------------------

--
-- Table structure for table `weekend_outing`
--

CREATE TABLE `weekend_outing` (
  `id` int(11) NOT NULL,
  `reg_no` int(11) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `time_slot` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weekend_slots`
--

CREATE TABLE `weekend_slots` (
  `id` int(11) NOT NULL,
  `slot` varchar(255) NOT NULL,
  `time_from` time NOT NULL,
  `time_to` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weekend_slots`
--

INSERT INTO `weekend_slots` (`id`, `slot`, `time_from`, `time_to`) VALUES
(1, 'slot1', '09:30:00', '15:30:00'),
(2, 'slot2', '10:30:00', '16:30:00'),
(3, 'slot3', '11:30:00', '17:30:00'),
(4, 'slot4', '12:30:00', '18:30:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `general_applications`
--
ALTER TABLE `general_applications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mentors`
--
ALTER TABLE `mentors`
  ADD PRIMARY KEY (`emp_id`);

--
-- Indexes for table `mentor_mentees`
--
ALTER TABLE `mentor_mentees`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`reg_no`);

--
-- Indexes for table `student_hostel`
--
ALTER TABLE `student_hostel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`reg_no`);

--
-- Indexes for table `wardens`
--
ALTER TABLE `wardens`
  ADD PRIMARY KEY (`warden_id`);

--
-- Indexes for table `weekend_applications`
--
ALTER TABLE `weekend_applications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weekend_outing`
--
ALTER TABLE `weekend_outing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weekend_slots`
--
ALTER TABLE `weekend_slots`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `general_applications`
--
ALTER TABLE `general_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `mentor_mentees`
--
ALTER TABLE `mentor_mentees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `student_hostel`
--
ALTER TABLE `student_hostel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `wardens`
--
ALTER TABLE `wardens`
  MODIFY `warden_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `weekend_applications`
--
ALTER TABLE `weekend_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `weekend_outing`
--
ALTER TABLE `weekend_outing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `weekend_slots`
--
ALTER TABLE `weekend_slots`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
